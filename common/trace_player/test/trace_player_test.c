// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_test.c

#include "trace_player_utils.h"
#include "trace_player.h"

int main()
{
    int rc = 0;
    DEBUG_PRINT(("TEST: START\n"));
    rc = trace_player_run("./libtrace_parser_command.so");
    DEBUG_PRINT(("TEST: END, rc=%d\n", rc));

    return rc;
}
