// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_test_impl.c

#include <stdio.h>
#include <stdint.h>

void reg_write(uint64_t offset, uint32_t val)
{
    printf("REG_WRITE: offset=0x%lx, val=0x%x\n", offset, val);
}

void reg_read(uint64_t offset, uint32_t *val)
{
    printf("REG_READ: offset=0x%lx, val=0x%x\n", offset, 0);
}

void mem_write64(const char *mem_type, uint64_t offset, uint64_t val)
{
    printf("MEM_WRITE64: mem_type=%s, offset=0x%lx, val=0x%lx\n", mem_type, offset, val);
}

void mem_write32(const char *mem_type, uint64_t offset, uint32_t val)
{
    printf("MEM_WRITE32: mem_type=%s, offset=0x%lx, val=0x%x\n", mem_type, offset, val);
}

void mem_write16(const char *mem_type, uint64_t offset, uint16_t val)
{
    printf("MEM_WRITE16: mem_type=%s, offset=0x%lx, val=0x%x\n", mem_type, offset, val);
}

void mem_write8(const char *mem_type, uint64_t offset, uint8_t val)
{
    printf("MEM_WRITE8: mem_type=%s, offset=0x%lx, val=0x%x\n", mem_type, offset, val);
}

void mem_read64(const char *mem_type, uint64_t offset, uint64_t *val)
{
    printf("MEM_read64: mem_type=%s, offset=0x%lx\n", mem_type, offset);
    *val = 0;
}

void mem_read32(const char *mem_type, uint64_t offset, uint32_t *val)
{
    printf("MEM_read32: mem_type=%s, offset=0x%lx\n", mem_type, offset);
    *val = 0;
}

void mem_read16(const char *mem_type, uint64_t offset, uint16_t *val)
{
    printf("MEM_read16: mem_type=%s, offset=0x%lx\n", mem_type, offset);
    *val = 0;
}

void mem_read8(const char *mem_type, uint64_t offset, uint8_t *val)
{
    printf("MEM_read8: mem_type=%s, offset=0x%lx\n", mem_type, offset);
    *val = 0;
}

void trace_player_wait(uint32_t num)
{
    printf("WAIT: %d\n", num);
}

/* fake interrupt generate and handle */
uint32_t trace_player_check_and_clear_pending_intr(void)
{
    uint32_t rc = 0;
    static int i = 0;

    if (i++ == 1000) {
        i = 0;
        rc = 0x1<<6;
        printf("NOTIFY_INTR: 0x%x\n", rc);
    }

    return rc;
}
