// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player.h

#ifndef TRACE_PLAYER_H
#define TRACE_PLAYER_H

void trace_player_set_stop_on_error(int val);
void trace_player_set_wait_interval(int val);
void trace_player_set_skip_mem_init(int val);
void trace_player_set_dump_mem_enable(int val);
int trace_player_run(const char *parser_output_lib);

#endif
