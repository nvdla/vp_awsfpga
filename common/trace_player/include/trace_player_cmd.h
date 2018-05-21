// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_cmd.h

#ifndef TRACE_PLAYER_CMD_H
#define TRACE_PLAYER_CMD_H

#include <stdint.h>

typedef enum {
    TRACE_PLAYER_CMD_WRITE, 
    TRACE_PLAYER_CMD_READ, 
    TRACE_PLAYER_CMD_READ_CHECK, 
    TRACE_PLAYER_CMD_POLL_REG_EQUAL, 
    TRACE_PLAYER_CMD_MEM_LOAD, 
    TRACE_PLAYER_CMD_MEM_INIT_PATTERN, 
    TRACE_PLAYER_CMD_MEM_INIT_FILE, 
    TRACE_PLAYER_CMD_INTR_NOTIFY,
    TRACE_PLAYER_CMD_SYNC_WAIT,
    TRACE_PLAYER_CMD_SYNC_NOTIFY,
    TRACE_PLAYER_CMD_CHECK_CRC,
    TRACE_PLAYER_CMD_CHECK_FILE,
    TRACE_PLAYER_CMD_CHECK_NOTHING
} trace_player_cmd_type_t;

typedef enum {
    TRACE_PLAYER_CMD_RESULT_DONE,
    TRACE_PLAYER_CMD_RESULT_NORUN,
    TRACE_PLAYER_CMD_RESULT_BLOCKED,
    TRACE_PLAYER_CMD_RESULT_ERROR
} trace_player_cmd_result_t;

typedef struct {
    uint64_t offset;
    uint32_t value;
} reg_write_cmd_t;

typedef struct {
    uint64_t offset;
    char *sync_id;
} reg_read_cmd_t;

typedef struct {
    uint64_t offset;
    uint32_t golden_val;
} reg_read_check_cmd_t;

typedef struct {
    uint64_t offset;
    uint32_t expect_val;
} poll_reg_equal_cmd_t;

typedef struct {
    char *mem_type;
    uint64_t base;
    char *file_path;
} mem_load_cmd_t;

typedef struct {
    char *mem_type;
    uint64_t base;
    uint32_t size;
    char *pattern;
} mem_init_pattern_cmd_t;

typedef struct {
    char *mem_type;
    uint64_t base;
    char *file_path;
} mem_init_file_cmd_t;

typedef struct {
    uint32_t intr_id;
    char *sync_id;
} intr_notify_cmd_t;

typedef struct {
    char *sync_id;
} sync_wait_cmd_t;

typedef struct {
    char *sync_id;
} sync_notify_cmd_t;

typedef struct {
    char *sync_id;
    char *mem_type;
    uint64_t base;
    uint32_t size;
    uint32_t golden_crc;
} check_crc_cmd_t;

typedef struct {
    char *sync_id;
    char *mem_type;
    uint64_t base;
    uint32_t size;
    char *file_path;
} check_file_cmd_t;

typedef struct {
    char *sync_id;
} check_nothing_cmd_t;

typedef struct {
    trace_player_cmd_type_t type;
    union {
        reg_write_cmd_t reg_write_cmd;
        reg_read_cmd_t reg_read_cmd;
        reg_read_check_cmd_t reg_read_check_cmd;
        poll_reg_equal_cmd_t poll_reg_equal_cmd;
        mem_load_cmd_t mem_load_cmd;
        mem_init_pattern_cmd_t mem_init_pattern_cmd;
        mem_init_file_cmd_t mem_init_file_cmd;
        intr_notify_cmd_t intr_notify_cmd;
        sync_wait_cmd_t sync_wait_cmd;
        sync_notify_cmd_t sync_notify_cmd;
        check_crc_cmd_t check_crc_cmd;
        check_file_cmd_t check_file_cmd;
        check_nothing_cmd_t check_nothing_cmd;
    };
} trace_player_cmd_t;

typedef struct trace_player_cmd_node {
    trace_player_cmd_t cmd;
    struct trace_player_cmd_node *next;
} trace_player_cmd_node_t;

trace_player_cmd_result_t trace_player_cmd_run(const trace_player_cmd_t *cmd);
void trace_player_cmd_list_pop(trace_player_cmd_node_t **p_head);
void trace_player_cmd_list_push_cmd_reg_write(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t value);
void trace_player_cmd_list_push_cmd_reg_read(trace_player_cmd_node_t **p_head, uint64_t offset, const char *sync_id);
void trace_player_cmd_list_push_cmd_reg_read_check(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t golden_val);
void trace_player_cmd_list_push_cmd_poll_reg_equal(trace_player_cmd_node_t **p_head, uint64_t offset, uint32_t expect_val);
void trace_player_cmd_list_push_cmd_mem_load(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, const char *file_path);
void trace_player_cmd_list_push_cmd_mem_init_pattern(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, uint32_t size, const char *pattern);
void trace_player_cmd_list_push_cmd_mem_init_file(trace_player_cmd_node_t **p_head, const char* mem_type, uint64_t base, const char *file_path);
void trace_player_cmd_list_push_cmd_intr_notify(trace_player_cmd_node_t **p_head, uint32_t intr_id, const char *sync_id);
void trace_player_cmd_list_push_cmd_sync_wait(trace_player_cmd_node_t **p_head, const char *sync_id);
void trace_player_cmd_list_push_cmd_sync_notify(trace_player_cmd_node_t **p_head, const char *sync_id);
void trace_player_cmd_list_push_cmd_check_crc(trace_player_cmd_node_t **p_head, const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, uint32_t golden_crc);
void trace_player_cmd_list_push_cmd_check_file(trace_player_cmd_node_t **p_head, const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, const char *file_path);
void trace_player_cmd_list_push_cmd_check_nothing(trace_player_cmd_node_t **p_head, const char *sync_id);

#endif
