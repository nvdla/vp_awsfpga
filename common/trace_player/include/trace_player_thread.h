// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_thread.h

#ifndef TRACE_PLAYER_THREAD_H
#define TRACE_PLAYER_THREAD_H

#include "trace_player_cmd.h"

typedef struct {
    char *name;
    trace_player_cmd_node_t *cmd_head;
} trace_player_thread_t;

typedef struct trace_player_thread_node {
    trace_player_thread_t thread;
    struct trace_player_thread_node *next;
} trace_player_thread_node_t;

trace_player_thread_node_t** trace_player_thread_list_get_head(void);
trace_player_cmd_result_t trace_player_thread_run(trace_player_thread_t *thread);
void trace_player_thread_list_remove_node(trace_player_thread_node_t *rnode);
void trace_player_thread_push_cmd_reg_write(const char* thread_name, uint64_t offset, uint32_t value);
void trace_player_thread_push_cmd_reg_read(const char* thread_name, uint64_t offset, const char *sync_id);
void trace_player_thread_push_cmd_reg_read_check(const char* thread_name, uint64_t offset, uint32_t golden_val);
void trace_player_thread_push_cmd_poll_reg_equal(const char* thread_name, uint64_t offset, uint32_t expect_val);
void trace_player_thread_push_cmd_mem_load(const char* mem_type, uint64_t base, const char *file_path);
void trace_player_thread_push_cmd_mem_init_pattern(const char* mem_type, uint64_t base, uint32_t size, const char *pattern);
void trace_player_thread_push_cmd_mem_init_file(const char* mem_type, uint64_t base, const char *file_path);
void trace_player_thread_push_cmd_intr_notify(uint32_t intr_id, const char *sync_id);
void trace_player_thread_push_cmd_sync_wait(const char* thread_name, const char *sync_id);
void trace_player_thread_push_cmd_sync_notify(const char* thread_name, const char *sync_id);
void trace_player_thread_push_cmd_check_crc(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, uint32_t golden_crc);
void trace_player_thread_push_cmd_check_file(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, const char *file_path);
void trace_player_thread_push_cmd_check_nothing(const char *sync_id);

#endif
