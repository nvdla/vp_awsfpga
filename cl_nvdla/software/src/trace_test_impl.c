// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_test_impl.c

#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#include "cl_common_utils.h"

#define CHAR2UINT64(array, index) \
    (((uint64_t)(array[index])) \
     | (((uint64_t)(array[index+1]))<<8) \
     | (((uint64_t)(array[index+2]))<<16) \
     | (((uint64_t)(array[index+3]))<<24) \
     | (((uint64_t)(array[index+4]))<<32) \
     | (((uint64_t)(array[index+5]))<<40) \
     | (((uint64_t)(array[index+6]))<<48) \
     | (((uint64_t)(array[index+7]))<<56))
#define CHAR2UINT32(array, index) \
    (((uint32_t)(array[index])) \
     | (((uint32_t)(array[index+1]))<<8) \
     | (((uint32_t)(array[index+2]))<<16) \
     | (((uint32_t)(array[index+3]))<<24))
#define CHAR2UINT16(array, index) \
    (((uint16_t)(array[index])) \
     | (((uint16_t)(array[index+1]))<<8))

#define DDR_C_BASE_ADDR 0xC0000000

static int enable_sim_mem = 0;
void set_enable_sim_mem(int val)
{
    enable_sim_mem = val;
}

void reg_write(uint64_t offset, uint32_t val)
{
    apb_write(offset, val);
}

void reg_read(uint64_t offset, uint32_t *val)
{
    apb_read(offset, val);
}

void mem_write64(const char *mem_type, uint64_t offset, uint64_t val)
{
    if (enable_sim_mem) {
#ifdef SV_TEST
        backdoor_mem_write(offset, val, 8, 0xFF);
#endif
    } else {
#ifdef VP_TEST
        ddr_write(offset-DDR_C_BASE_ADDR, val, 3);
#else
        ddr_write(offset, val, 3);
#endif
    }
}

void mem_write32(const char *mem_type, uint64_t offset, uint32_t val)
{
    if (enable_sim_mem) {
#ifdef SV_TEST
        backdoor_mem_write(offset, val, 4, 0xF);
#endif
    } else {
#ifdef VP_TEST
        ddr_write(offset-DDR_C_BASE_ADDR, val, 2);
#else
        ddr_write(offset, val, 2);
#endif
    }
}

void mem_write16(const char *mem_type, uint64_t offset, uint16_t val)
{
    if (enable_sim_mem) {
#ifdef SV_TEST
        backdoor_mem_write(offset, val, 2, 0x3);
#endif
    } else {
#ifdef VP_TEST
        ddr_write(offset-DDR_C_BASE_ADDR, val, 1);
#else
        ddr_write(offset, val, 1);
#endif
    }
}

void mem_write8(const char *mem_type, uint64_t offset, uint8_t val)
{
    if (enable_sim_mem) {
#ifdef SV_TEST
        backdoor_mem_write(offset, val, 1, 0x1);
#endif
    } else {
#ifdef VP_TEST
        ddr_write(offset-DDR_C_BASE_ADDR, val, 0);
#else
        ddr_write(offset, val, 0);
#endif
    }
}

void mem_read64(const char *mem_type, uint64_t offset, uint64_t *val)
{
    if (enable_sim_mem) {
#ifdef SV_TEST
        *val = backdoor_mem_read(offset, 8);
#endif
    } else {
#ifdef VP_TEST
        ddr_read(offset-DDR_C_BASE_ADDR, val, 3);
#else
        ddr_read(offset, val, 3);
#endif
    }
}

void mem_read32(const char *mem_type, uint64_t offset, uint32_t *val)
{
    uint64_t rdata;
    if (enable_sim_mem) {
#ifdef SV_TEST
        rdata = backdoor_mem_read(offset, 4);
#endif
    } else {
#ifdef VP_TEST
        ddr_read(offset-DDR_C_BASE_ADDR, &rdata, 2);
#else
        ddr_read(offset, &rdata, 2);
#endif
    }
    *val = rdata;
}

void mem_read16(const char *mem_type, uint64_t offset, uint16_t *val)
{
    uint64_t rdata;
    if (enable_sim_mem) {
#ifdef SV_TEST
        rdata = backdoor_mem_read(offset, 2);
#endif
    } else {
#ifdef VP_TEST
        ddr_read(offset-DDR_C_BASE_ADDR, &rdata, 1);
#else
        ddr_read(offset, &rdata, 1);
#endif
    }
    *val = rdata;
}

void mem_read8(const char *mem_type, uint64_t offset, uint8_t *val)
{
    uint64_t rdata;
    if (enable_sim_mem) {
#ifdef SV_TEST
        rdata = backdoor_mem_read(offset, 1);
#endif
    } else {
        ddr_read(offset, &rdata, 0);
#ifdef VP_TEST
        ddr_read(offset-DDR_C_BASE_ADDR, &rdata, 0);
#else
        ddr_read(offset, &rdata, 0);
#endif
    }
    *val = rdata;
}

void trace_player_wait(uint32_t num)
{
#ifdef SV_TEST
    sv_pause(num);
#endif
}

#ifndef SV_TEST
extern void cl_check_and_clear_intr(void);
#endif

uint32_t trace_player_check_and_clear_pending_intr(void)
{
#ifndef SV_TEST
    cl_check_and_clear_intr();
#endif
    extern uint32_t trace_player_pending_intr;
    uint32_t rc = trace_player_pending_intr;
    /* clear pending intr */
    trace_player_pending_intr = 0;
    return rc;
}
