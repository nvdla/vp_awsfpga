// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_thread.c

#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "trace_player_utils.h"
#include "trace_player_thread.h"
#include "trace_player_impl.h"

static trace_player_thread_node_t *head = NULL;

static trace_player_thread_node_t* trace_player_thread_list_find_or_create_node(const char* name)
{
    trace_player_thread_node_t *node = head;
    trace_player_thread_node_t *prev = NULL;

    while (node != NULL) {
        if (strcmp(name, node->thread.name) == 0) {
            break;
        }
        prev = node;
        node = node->next;
    }
    
    if (node == NULL) {
        node = malloc(sizeof(trace_player_thread_node_t));
        node->thread.name = strdup(name);
        node->thread.cmd_head = NULL;
        node->next = NULL;
        if (prev != NULL) {
            prev->next = node;
        }
        if (head == NULL) {
            trace_player_thread_node_t *int_cfg_node;
            int_cfg_node = malloc(sizeof(trace_player_thread_node_t));
            int_cfg_node->thread.name = strdup("INT_CFG");
            int_cfg_node->thread.cmd_head = NULL;
            int_cfg_node->next = node;
            head = int_cfg_node;
            DEBUG_PRINT(("TRACE_PLAYER_THREAD: create thread %s\n", "INT_CFG"));
        }
        DEBUG_PRINT(("TRACE_PLAYER_THREAD: create thread %s\n", name));
    }

    return node;
}

static trace_player_thread_node_t* trace_player_thread_get_node(const char* thread_name)
{
    static trace_player_thread_node_t *thread_node_cache = NULL;
    if (thread_node_cache == NULL || strcmp(thread_name, thread_node_cache->thread.name) != 0) {
        thread_node_cache = trace_player_thread_list_find_or_create_node(thread_name);
    }
    return thread_node_cache;
}

trace_player_thread_node_t** trace_player_thread_list_get_head(void)
{
    return &head;
}

trace_player_cmd_result_t trace_player_thread_run(trace_player_thread_t *thread)
{
    trace_player_cmd_result_t rc = TRACE_PLAYER_CMD_RESULT_NORUN;
    if (thread->cmd_head != NULL) {
        rc = trace_player_cmd_run(&(thread->cmd_head->cmd));
        if (rc != TRACE_PLAYER_CMD_RESULT_BLOCKED) {
            trace_player_cmd_list_pop(&(thread->cmd_head));
        }
    }
    DEBUG_PRINT(("TRACE_PLAYER_THREAD: run thread %s, result=%d\n", thread->name, rc));
    return rc;
}

void trace_player_thread_list_remove_node(trace_player_thread_node_t *rnode)
{
    if (rnode == head) {
        head = head->next;
    } else {
        trace_player_thread_node_t *node = head;
        while (node != NULL) {
            if (rnode == node->next) {
                node->next = rnode->next;
                break;
            }
            node = node->next;
        }
    }

    free(rnode->thread.name);
    free(rnode);
}

void trace_player_thread_push_cmd_reg_write(const char* thread_name, uint64_t offset, uint32_t value)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_reg_write(&(node->thread.cmd_head), offset, value);
}

void trace_player_thread_push_cmd_reg_read(const char* thread_name, uint64_t offset, const char *sync_id)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_reg_read(&(node->thread.cmd_head), offset, sync_id);
}

void trace_player_thread_push_cmd_reg_read_check(const char* thread_name, uint64_t offset, uint32_t golden_val)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_reg_read_check(&(node->thread.cmd_head), offset, golden_val);
}

void trace_player_thread_push_cmd_poll_reg_equal(const char* thread_name, uint64_t offset, uint32_t expect_val)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_poll_reg_equal(&(node->thread.cmd_head), offset, expect_val);
}

void trace_player_thread_push_cmd_mem_load(const char* mem_type, uint64_t base, const char *file_path)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_mem_load(&(node->thread.cmd_head), mem_type, base, file_path);
}

void trace_player_thread_push_cmd_mem_init_pattern(const char* mem_type, uint64_t base, uint32_t size, const char *pattern)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_mem_init_pattern(&(node->thread.cmd_head), mem_type, base, size, pattern);
}

void trace_player_thread_push_cmd_mem_init_file(const char* mem_type, uint64_t base, const char *file_path)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_mem_init_file(&(node->thread.cmd_head), mem_type, base, file_path);
}

void trace_player_thread_push_cmd_intr_notify(uint32_t intr_id, const char *sync_id)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("INT_CFG");
    trace_player_cmd_list_push_cmd_intr_notify(&(node->thread.cmd_head), intr_id, sync_id);
}

void trace_player_thread_push_cmd_sync_wait(const char* thread_name, const char *sync_id)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_sync_wait(&(node->thread.cmd_head), sync_id);
}

void trace_player_thread_push_cmd_sync_notify(const char* thread_name, const char *sync_id)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node(thread_name);
    trace_player_cmd_list_push_cmd_sync_notify(&(node->thread.cmd_head), sync_id);
}

void trace_player_thread_push_cmd_check_crc(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, uint32_t golden_crc)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_check_crc(&(node->thread.cmd_head), sync_id, mem_type, base, size, golden_crc);
}

void trace_player_thread_push_cmd_check_file(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, const char *file_path)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_check_file(&(node->thread.cmd_head), sync_id, mem_type, base, size, file_path);
}

void trace_player_thread_push_cmd_check_nothing(const char *sync_id)
{
    trace_player_thread_node_t *node = trace_player_thread_get_node("UTILS");
    trace_player_cmd_list_push_cmd_check_nothing(&(node->thread.cmd_head), sync_id);
}
