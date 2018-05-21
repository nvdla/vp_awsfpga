// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_cmd.c

#include <stdlib.h>
#include <string.h>
#include "trace_player_utils.h"
#include "trace_player_cmd.h"
#include "trace_player_impl.h"
#include "trace_player_reg.h"
#include "trace_player_mem.h"
#include "trace_player_sync.h"
#include "trace_player_intr.h"

static void trace_player_cmd_free(trace_player_cmd_node_t **p_head)
{
    if (*p_head != NULL) {
        switch ((*p_head)->cmd.type) {
            case TRACE_PLAYER_CMD_READ:
                free((*p_head)->cmd.reg_read_cmd.sync_id);
                break;
            case TRACE_PLAYER_CMD_MEM_LOAD:
                free((*p_head)->cmd.mem_load_cmd.mem_type);
                free((*p_head)->cmd.mem_load_cmd.file_path);
                break;
            case TRACE_PLAYER_CMD_MEM_INIT_PATTERN:
                free((*p_head)->cmd.mem_init_pattern_cmd.mem_type);
                free((*p_head)->cmd.mem_init_pattern_cmd.pattern);
                break;
            case TRACE_PLAYER_CMD_MEM_INIT_FILE:
                free((*p_head)->cmd.mem_init_file_cmd.mem_type);
                free((*p_head)->cmd.mem_init_file_cmd.file_path);
                break;
            case TRACE_PLAYER_CMD_INTR_NOTIFY:
                free((*p_head)->cmd.intr_notify_cmd.sync_id);
                break;
            case TRACE_PLAYER_CMD_SYNC_WAIT:
                free((*p_head)->cmd.sync_wait_cmd.sync_id);
                break;
            case TRACE_PLAYER_CMD_SYNC_NOTIFY:
                free((*p_head)->cmd.sync_notify_cmd.sync_id);
                break;
            case TRACE_PLAYER_CMD_CHECK_CRC:
                free((*p_head)->cmd.check_crc_cmd.sync_id);
                free((*p_head)->cmd.check_crc_cmd.mem_type);
                break;
            case TRACE_PLAYER_CMD_CHECK_FILE:
                free((*p_head)->cmd.check_file_cmd.sync_id);
                free((*p_head)->cmd.check_file_cmd.mem_type);
                free((*p_head)->cmd.check_file_cmd.file_path);
                break;
            case TRACE_PLAYER_CMD_CHECK_NOTHING:
                free((*p_head)->cmd.check_nothing_cmd.sync_id);
                break;
            default:
                break;
        }
        free(*p_head);
    }
}

static void trace_player_cmd_list_push(trace_player_cmd_node_t **p_head, trace_player_cmd_node_t *node)
{
    if (*p_head == NULL) {
        *p_head = node;
    } else {
        trace_player_cmd_node_t *tmp = (*p_head);
        while (tmp->next != NULL) {
            tmp = tmp->next;
        }
        tmp->next = node;
    }
    node->next = NULL;
}

trace_player_cmd_result_t trace_player_cmd_run(const trace_player_cmd_t *cmd)
{
    trace_player_cmd_result_t rc = TRACE_PLAYER_CMD_RESULT_DONE;
    uint32_t val;

    switch (cmd->type) {
        case TRACE_PLAYER_CMD_WRITE:
            reg_write(cmd->reg_write_cmd.offset, cmd->reg_write_cmd.value);
            break;
        case TRACE_PLAYER_CMD_READ:
            reg_read(cmd->reg_read_cmd.offset, &val);
            trace_player_sync_notify(cmd->reg_read_cmd.sync_id);
            break;
        case TRACE_PLAYER_CMD_READ_CHECK:
            if (0 != trace_player_reg_read_check(cmd->reg_read_check_cmd.offset, cmd->reg_read_check_cmd.golden_val)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_POLL_REG_EQUAL:
            if (0 != trace_player_reg_poll_reg_equal(cmd->poll_reg_equal_cmd.offset, cmd->poll_reg_equal_cmd.expect_val)) {
                rc = TRACE_PLAYER_CMD_RESULT_BLOCKED;
            }
            break;
        case TRACE_PLAYER_CMD_MEM_LOAD:
            if (0 != trace_player_mem_load(cmd->mem_load_cmd.mem_type, cmd->mem_load_cmd.base, cmd->mem_load_cmd.file_path)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_MEM_INIT_PATTERN:
            if (0 != trace_player_mem_init_pattern(cmd->mem_init_pattern_cmd.mem_type, cmd->mem_init_pattern_cmd.base, cmd->mem_init_pattern_cmd.size, cmd->mem_init_pattern_cmd.pattern)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_MEM_INIT_FILE:
            if (0 != trace_player_mem_init_file(cmd->mem_init_file_cmd.mem_type, cmd->mem_init_file_cmd.base, cmd->mem_init_file_cmd.file_path)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_INTR_NOTIFY:
            trace_player_push_expect_intr(cmd->intr_notify_cmd.intr_id, cmd->intr_notify_cmd.sync_id);
            break;
        case TRACE_PLAYER_CMD_SYNC_WAIT:
            if (trace_player_sync_is_notified(cmd->sync_wait_cmd.sync_id) == 0) {
                rc = TRACE_PLAYER_CMD_RESULT_BLOCKED;
            }
            break;
        case TRACE_PLAYER_CMD_SYNC_NOTIFY:
            trace_player_sync_notify(cmd->sync_notify_cmd.sync_id);
            break;
        case TRACE_PLAYER_CMD_CHECK_CRC:
            if (trace_player_sync_is_notified(cmd->check_crc_cmd.sync_id) == 0) {
                rc = TRACE_PLAYER_CMD_RESULT_BLOCKED;
            } else if (0 != trace_player_mem_check_crc(cmd->check_crc_cmd.mem_type, cmd->check_crc_cmd.base, cmd->check_crc_cmd.size, cmd->check_crc_cmd.golden_crc)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_CHECK_FILE:
            if (trace_player_sync_is_notified(cmd->check_file_cmd.sync_id) == 0) {
                rc = TRACE_PLAYER_CMD_RESULT_BLOCKED;
            } else if (0 != trace_player_mem_check_file(cmd->check_file_cmd.mem_type, cmd->check_file_cmd.base, cmd->check_file_cmd.size, cmd->check_file_cmd.file_path)) {
                rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            }
            break;
        case TRACE_PLAYER_CMD_CHECK_NOTHING:
            if (trace_player_sync_is_notified(cmd->check_nothing_cmd.sync_id) == 0) {
                rc = TRACE_PLAYER_CMD_RESULT_BLOCKED;
            }
            break;
        default:
            rc = TRACE_PLAYER_CMD_RESULT_ERROR;
            break;
    }

    DEBUG_PRINT(("TRACE_PLAYER_CMD: run cmd type=%d, rc=%d\n", cmd->type, rc));

    return rc;
}

void trace_player_cmd_list_pop(trace_player_cmd_node_t **p_head)
{
    if (*p_head != NULL) {
        trace_player_cmd_node_t *tmp = (*p_head)->next;
        trace_player_cmd_free(p_head);
        *p_head = tmp;
    }
}

void trace_player_cmd_list_push_cmd_reg_write(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t value)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_WRITE;
    node->cmd.reg_write_cmd.offset = offset;
    node->cmd.reg_write_cmd.value = value;
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_reg_read(trace_player_cmd_node_t **p_head, uint64_t offset, const char *sync_id)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_READ;
    node->cmd.reg_read_cmd.offset = offset;
    node->cmd.reg_read_cmd.sync_id = strdup(sync_id);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_reg_read_check(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t golden_val)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_READ_CHECK;
    node->cmd.reg_read_check_cmd.offset = offset;
    node->cmd.reg_read_check_cmd.golden_val = golden_val;
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_poll_reg_equal(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t expect_val)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_POLL_REG_EQUAL;
    node->cmd.poll_reg_equal_cmd.offset = offset;
    node->cmd.poll_reg_equal_cmd.expect_val = expect_val;
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_mem_load(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, const char *file_path)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_MEM_LOAD;
    node->cmd.mem_load_cmd.mem_type = strdup(mem_type);
    node->cmd.mem_load_cmd.base = base;
    node->cmd.mem_load_cmd.file_path = strdup(file_path);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_mem_init_pattern(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, uint32_t size, const char *pattern)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_MEM_INIT_PATTERN;
    node->cmd.mem_init_pattern_cmd.mem_type = strdup(mem_type);
    node->cmd.mem_init_pattern_cmd.base = base;
    node->cmd.mem_init_pattern_cmd.size = size;
    node->cmd.mem_init_pattern_cmd.pattern = strdup(pattern);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_mem_init_file(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, const char *file_path)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_MEM_INIT_FILE;
    node->cmd.mem_init_file_cmd.mem_type = strdup(mem_type);
    node->cmd.mem_init_file_cmd.base = base;
    node->cmd.mem_init_file_cmd.file_path = strdup(file_path);
    trace_player_cmd_list_push(p_head, node);
}


void trace_player_cmd_list_push_cmd_intr_notify(trace_player_cmd_node_t **p_head, uint32_t intr_id, const char *sync_id)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_INTR_NOTIFY;
    node->cmd.intr_notify_cmd.intr_id = intr_id;
    node->cmd.intr_notify_cmd.sync_id = strdup(sync_id);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_sync_wait(trace_player_cmd_node_t **p_head, const char *sync_id)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_SYNC_WAIT;
    node->cmd.sync_wait_cmd.sync_id = strdup(sync_id);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_sync_notify(trace_player_cmd_node_t **p_head, const char *sync_id)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_SYNC_NOTIFY;
    node->cmd.sync_notify_cmd.sync_id = strdup(sync_id);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_check_crc(trace_player_cmd_node_t **p_head, const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, uint32_t golden_crc)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_CHECK_CRC;
    node->cmd.check_crc_cmd.sync_id = strdup(sync_id);
    node->cmd.check_crc_cmd.mem_type = strdup(mem_type);
    node->cmd.check_crc_cmd.base = base;
    node->cmd.check_crc_cmd.size = size;
    node->cmd.check_crc_cmd.golden_crc = golden_crc;
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_check_file(trace_player_cmd_node_t **p_head, const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, const char *file_path)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_CHECK_FILE;
    node->cmd.check_file_cmd.sync_id = strdup(sync_id);
    node->cmd.check_file_cmd.mem_type = strdup(mem_type);
    node->cmd.check_file_cmd.base = base;
    node->cmd.check_file_cmd.size = size;
    node->cmd.check_file_cmd.file_path = strdup(file_path);
    trace_player_cmd_list_push(p_head, node);
}

void trace_player_cmd_list_push_cmd_check_nothing(trace_player_cmd_node_t **p_head, const char *sync_id)
{
    trace_player_cmd_node_t *node = malloc(sizeof(trace_player_cmd_node_t));
    node->cmd.type = TRACE_PLAYER_CMD_CHECK_NOTHING;
    node->cmd.check_nothing_cmd.sync_id = strdup(sync_id);
    trace_player_cmd_list_push(p_head, node);
}
