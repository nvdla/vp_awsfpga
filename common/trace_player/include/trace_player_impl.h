// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_impl.h

#ifndef TRACE_PLAYER_IMPL_H
#define TRACE_PLAYER_IMPL_H

#include <stdint.h>

extern void reg_write(uint64_t offset, uint32_t val);
extern void reg_read(uint64_t offset, uint32_t *val);
extern void mem_write64(const char *mem_type, uint64_t offset, uint64_t val);
extern void mem_write32(const char *mem_type, uint64_t offset, uint32_t val);
extern void mem_write16(const char *mem_type, uint64_t offset, uint16_t val);
extern void mem_write8(const char *mem_type, uint64_t offset, uint8_t val);
extern void mem_read64(const char *mem_type, uint64_t offset, uint64_t *val);
extern void mem_read32(const char *mem_type, uint64_t offset, uint32_t *val);
extern void mem_read16(const char *mem_type, uint64_t offset, uint16_t *val);
extern void mem_read8(const char *mem_type, uint64_t offset, uint8_t *val);
extern void trace_player_wait(int num);
extern uint32_t trace_player_check_and_clear_pending_intr(void);

#endif
