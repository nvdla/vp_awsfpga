// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player.c

#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <dlfcn.h>
#include <sys/time.h>
#include "trace_player.h"
#include "trace_player_utils.h"
#include "trace_player_cmd.h"
#include "trace_player_thread.h"
#include "trace_player_mem.h"
#include "trace_player_intr.h"
#include "trace_player_impl.h"

typedef void (*PREPARE_CMD_FUNC)(void);

#define TRACE_TEST_TIMEOUT_SEC 120

static int stop_on_error = 1;
static int wait_interval = 1;

void trace_player_set_stop_on_error(int val)
{
    stop_on_error = val;
}

void trace_player_set_wait_interval(int val)
{
    wait_interval = val;
}

void trace_player_set_skip_mem_init(int val)
{
    trace_player_mem_set_skip_mem_init(val);
}

void trace_player_set_dump_mem_enable(int val)
{
    trace_player_mem_set_dump_mem_enable(val);
}

static uint64_t sys_sec = 0;
int trace_player_run(const char *parser_output_lib)
{
    int rc = 0;

    struct timeval tv;
    gettimeofday(&tv, NULL);

    sys_sec = tv.tv_sec;
    
    /* open parser output library */
    DEBUG_PRINT(("TRACE_PLAYER_RUN: open library %s\n", parser_output_lib));
    void *handle = dlopen(parser_output_lib, RTLD_LAZY);
    if (!handle) {
        DEBUG_PRINT(("TRACE_PLAYER_RUN: ERROR! unable to open library %s\n", parser_output_lib));
        exit(EXIT_FAILURE);
    }
    
    /* get prepare commands function from  parser output library */
    char *error;
    PREPARE_CMD_FUNC prepare_cmd_func = NULL;
    dlerror();
    *(void **)(&prepare_cmd_func) = dlsym(handle, "trace_parser_prepare_commands");
    if ((error = dlerror()) != NULL) {
        DEBUG_PRINT(("TRACE_PLAYER_RUN: ERROR! %s\n", error));
        exit(EXIT_FAILURE);
    }

    /* prepare commands */
    DEBUG_PRINT(("TRACE_PLAYER_RUN: prepare commands\n"));
    prepare_cmd_func();
    
    /* run */
    DEBUG_PRINT(("TRACE_PLAYER_RUN: run start, stop_on_error=%d, wait_interval=%d\n", stop_on_error, wait_interval));

    trace_player_thread_node_t **p_head = trace_player_thread_list_get_head();

    /* set interrupt sync id before run the trace test */
    trace_player_thread_node_t *p_int_cfg_thread = *p_head;

    /* update thread list head */
    p_head = &(p_int_cfg_thread->next);

    while (1)
    {
        if (trace_player_thread_run(&(p_int_cfg_thread->thread)) == TRACE_PLAYER_CMD_RESULT_NORUN)
        {
            DEBUG_PRINT(("Sync ID for interrupt configure DONE!\n"));
            break;
        }
    }


    while (1) {
        int all_blocked = 1;
        if (*p_head == NULL) {
            DEBUG_PRINT(("TRACE_PLAYER_RUN: empty thread list!\n"));
            break;
        } else {
            /* check and handle interrupt */
            uint32_t pending_intr = trace_player_check_and_clear_pending_intr();
            if (0 != trace_player_intr_check(pending_intr)) {
                if (stop_on_error != 0) {
                    rc = 1;
                    goto out;
                }
            }
            /* iterate the thread list */
            trace_player_thread_node_t *node = *p_head;
            while (node != NULL) {
                trace_player_thread_node_t *tmp;
                switch (trace_player_thread_run(&(node->thread))) {
                    case TRACE_PLAYER_CMD_RESULT_NORUN:
                        tmp = node->next;
                        trace_player_thread_list_remove_node(node);
                        node = tmp;
                        all_blocked = 0;
                        break;
                    case TRACE_PLAYER_CMD_RESULT_DONE:
                        node = node->next;
                        all_blocked = 0;
                        break;
                    case TRACE_PLAYER_CMD_RESULT_BLOCKED:
                        node = node->next;
                        break;
                    case TRACE_PLAYER_CMD_RESULT_ERROR:
                        all_blocked = 0;
                        if (stop_on_error != 0) {
                            rc = 1;
                            goto out;
                        } else {
                            node = node->next;
                        }
                        break;
                    default:
                        assert(0);
                }
            }
        }
        if (all_blocked) {
            trace_player_wait(wait_interval);
        }

        uint64_t cur_sec = 0;
        uint64_t det_sec = 0;
        gettimeofday(&tv, NULL);
        cur_sec = tv.tv_sec;
        det_sec = cur_sec - sys_sec;
        if (det_sec >= TRACE_TEST_TIMEOUT_SEC)
        {
            rc = 2;
            goto out;
        }
    }

out:
    DEBUG_PRINT(("TRACE_PLAYER_RUN: run end, rc=%d\n", rc));
    return rc;
}
