// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_parser.h

#ifndef TRACE_PLAYER_PARSER_H
#define TRACE_PLAYER_PARSER_H

#include <stdint.h>

extern void trace_player_thread_push_cmd_reg_write(const char* thread_name, uint64_t offset, uint32_t value);
extern void trace_player_thread_push_cmd_reg_read(const char* thread_name, uint64_t offset, const char *sync_id);
extern void trace_player_thread_push_cmd_reg_read_check(const char* thread_name, uint64_t offset, uint32_t golden_val);
extern void trace_player_thread_push_cmd_poll_reg_equal(const char* thread_name, uint64_t offset, uint32_t expect_val);
extern void trace_player_thread_push_cmd_mem_load(const char* mem_type, uint64_t base, const char *file_path);
extern void trace_player_thread_push_cmd_mem_init_pattern(const char* mem_type, uint64_t base, uint32_t size, const char *pattern);
extern void trace_player_thread_push_cmd_mem_init_file(const char* mem_type, uint64_t base, const char *file_path);
extern void trace_player_thread_push_cmd_intr_notify(uint32_t intr_id, const char *sync_id);
extern void trace_player_thread_push_cmd_sync_wait(const char* thread_name, const char *sync_id);
extern void trace_player_thread_push_cmd_sync_notify(const char* thread_name, const char *sync_id);
extern void trace_player_thread_push_cmd_check_crc(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, uint32_t golden_crc);
extern void trace_player_thread_push_cmd_check_file(const char *sync_id, const char* mem_type, uint64_t base, uint32_t size, const char *file_path);
extern void trace_player_thread_push_cmd_check_nothing(const char *sync_id);

#endif
