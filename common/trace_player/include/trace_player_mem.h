// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_mem.h

#ifndef TRACE_PLAYER_MEM_H
#define TRACE_PLAYER_MEM_H

#include <stdint.h>

void trace_player_mem_set_skip_mem_init(int val);
void trace_player_mem_set_dump_mem_enable(int val);
int trace_player_mem_load(const char *mem_type, uint64_t base, const char *file_path);
int trace_player_mem_init_pattern(const char *mem_type, uint64_t base, uint32_t size, const char *pattern);
int trace_player_mem_init_file(const char *mem_type, uint64_t base, const char *file_path);
int trace_player_mem_check_crc(const char *mem_type, uint64_t base, uint32_t size, uint32_t golden_crc);
int trace_player_mem_check_file(const char *mem_type, uint64_t base, uint32_t size, const char *file_path);

#endif
