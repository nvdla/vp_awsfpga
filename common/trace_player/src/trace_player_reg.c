// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_reg.c

#include "trace_player_reg.h"
#include "trace_player_utils.h"
#include "trace_player_impl.h"

int trace_player_reg_read_check(uint64_t offset, uint32_t golden_val)
{
    int rc = 0;
    uint32_t val;
    reg_read(offset, &val);
    if (val != golden_val) {
        DEBUG_PRINT(("TRACE_PLAYER_REG_READ_CHECK: ERROR! addr=0x%lx, exp=0x%x, act=0x%x\n", offset, golden_val, val));
        rc = 1;
    }
    return rc;
}

int trace_player_reg_poll_reg_equal(uint64_t offset, uint32_t expect_val)
{
    int rc = 0;
    uint32_t val;
    reg_read(offset, &val);
    if (val != expect_val) {
        rc = 1;
    }
    return rc;
}
