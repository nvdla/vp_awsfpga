// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_intr.c

#include <string.h>
#include <stdlib.h>
#include "trace_player_utils.h"
#include "trace_player_intr.h"
#include "trace_player_sync.h"

static trace_player_intr_node_t *head = NULL;

void trace_player_push_expect_intr(uint32_t intr_id, const char* sync_id)
{
    DEBUG_PRINT(("TRACE_PLAYER_INTR: push expect intr, id=0x%x, sync_id=%s\n", intr_id, sync_id));
    trace_player_intr_node_t *new_node;
    new_node = malloc(sizeof(trace_player_intr_node_t));
    new_node->intr.intr_id = intr_id;
    new_node->intr.sync_id = strdup(sync_id);
    new_node->next = NULL;

    if (head == NULL) {
        head = new_node;
    } else {
        trace_player_intr_node_t *current = head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
        
}

int trace_player_intr_check(uint32_t intr_id)
{
    int rc = 0;

    if (intr_id != 0 && head != NULL) {
        while ((intr_id & head->intr.intr_id) == head->intr.intr_id) {
            DEBUG_PRINT(("TRACE_PLAYER_INTR: get expected intr id=0x%x\n", head->intr.intr_id));
            /* notify sync_id */
            trace_player_sync_notify(head->intr.sync_id);
            /* clear head intr */
            intr_id = intr_id & (~(head->intr.intr_id));
            /* pop intr list */
            trace_player_intr_node_t *next_node = head->next;
            free(head->intr.sync_id);
            free(head);
            head = next_node;
            if (head == NULL)
                break;
        }
    }
    if (intr_id != 0 && head != NULL) {
        trace_player_intr_node_t *p1 = head;
        trace_player_intr_node_t *p2 = p1->next;
        while (p2 != NULL) {
            if ((intr_id & p2->intr.intr_id) == p2->intr.intr_id) {
                DEBUG_PRINT(("TRACE_PLAYER_INTR: get expected intr id=0x%x\n", p2->intr.intr_id));
                /* notify sync_id */
                trace_player_sync_notify(p2->intr.sync_id);
                /* clear p2 intr */
                intr_id = intr_id & (~(p2->intr.intr_id));

                p1->next = p2->next;

                free(p2->intr.sync_id);
                free(p2);
            } else {
                p1 = p1->next;
            }
            p2 = p1->next;
        }
    }

    if (intr_id != 0) {
        DEBUG_PRINT(("TRACE_PLAYER_INTR: WARNING! unexpect intr_id=0x%x\n", intr_id));
        //rc = 1;
    }

    return rc;
}
