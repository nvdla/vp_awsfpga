// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_intr.h

#ifndef TRACE_PLAYER_INTR_H
#define TRACE_PLAYER_INTR_H

#include <stdint.h>

typedef struct {
    uint32_t intr_id;
    char *sync_id;
} trace_player_intr_t;

typedef struct trace_player_intr_node {
    trace_player_intr_t intr;
    struct trace_player_intr_node *next;
} trace_player_intr_node_t;

void trace_player_push_expect_intr(uint32_t intr_id, const char* sync_id);
int trace_player_intr_check(uint32_t intr_id);

#endif
