// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_reg.h

#ifndef TRACE_PLAYER_REG_H_
#define TRACE_PLAYER_REG_H_

#include <stdint.h>

int trace_player_reg_read_check(uint64_t offset, uint32_t golden_val);
int trace_player_reg_poll_reg_equal(uint64_t offset, uint32_t expect_val);

#endif
