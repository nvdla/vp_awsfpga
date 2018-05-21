// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_sync.c

#include <string.h>
#include <stdlib.h>
#include "trace_player_utils.h"
#include "trace_player_sync.h"

static trace_player_sync_node_t *head = NULL;

static trace_player_sync_node_t* trace_player_sync_find_or_create_node(const char *sync_id)
{
    trace_player_sync_node_t *node = head;
    trace_player_sync_node_t *prev = NULL;

    while (node != NULL) {
        if (strcmp(sync_id, node->sync.sync_id) == 0) {
            break;
        }
        prev = node;
        node = node->next;
    }
    
    if (node == NULL) {
        node = malloc(sizeof(trace_player_sync_node_t));
        node->sync.sync_id = strdup(sync_id);
        node->sync.notified = 0;
        node->next = NULL;
        if (prev != NULL) {
            prev->next = node;
        }
        if (head == NULL) {
            head = node;
        }
    }

    return node;
}

void trace_player_sync_notify(const char *sync_id)
{
    trace_player_sync_node_t* node = trace_player_sync_find_or_create_node(sync_id);
    node->sync.notified = 1;
}

int trace_player_sync_is_notified(const char *sync_id)
{
    trace_player_sync_node_t* node = trace_player_sync_find_or_create_node(sync_id);
    return node->sync.notified;
}
