// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_sync.h

#ifndef TRACE_PLAYER_SYNC_H
#define TRACE_PLAYER_SYNC_H

typedef struct {
    char *sync_id;
    int notified;
} trace_player_sync_t;

typedef struct trace_player_sync_node {
    trace_player_sync_t sync;
    struct trace_player_sync_node *next;
} trace_player_sync_node_t;

void trace_player_sync_notify(const char *sync_id);
int trace_player_sync_is_notified(const char *sync_id);

#endif
