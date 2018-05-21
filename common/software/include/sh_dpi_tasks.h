// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

// Copyright (c) 2009-2017, NVIDIA CORPORATION. All rights reserved.
// NVIDIA’s contributions are offered under the Amazon Software License


#ifndef SH_DPI_TASKS
#define SH_DPI_TASKS

#include <stdarg.h>
#include <stdint.h>

#define SIZE_UINT8  0
#define SIZE_UINT16 1
#define SIZE_UINT32 2
#define SIZE_UINT64 3

#define CFG_RESET_ADDR      (0x14)

extern void sv_printf(char *msg);
extern void sv_map_host_memory(uint8_t *memory);

extern void cl_peek_ocl(uint64_t addr, uint32_t *data);
extern void cl_poke_ocl(uint64_t addr, uint32_t  data);
extern void cl_peek_bar1(uint64_t addr, uint32_t *data);
extern void cl_poke_bar1(uint64_t addr, uint32_t  data);
extern void cl_peek_pcis(uint64_t addr, uint64_t *data, uint32_t size);
extern void cl_poke_pcis(uint64_t addr, uint64_t  data, uint32_t size);
extern void sv_int_ack(uint32_t int_num);

extern void sv_pause(uint32_t x);

extern void sv_assert(uint32_t x);

extern void backdoor_mem_write(uint64_t addr, uint64_t data, uint32_t size, uint32_t wstrb);
extern uint64_t backdoor_mem_read(uint64_t addr, uint32_t size);

void test_main(uint32_t *exit_code);
void trace_test_main(uint32_t *exit_code, const char *trace_output_lib, int enable_sim_mem);

void cl_int_handler(uint32_t int_num);

void host_memory_putc(uint64_t addr, uint8_t data);

//void host_memory_getc(uint64_t addr, uint8_t *data)
uint8_t host_memory_getc(uint64_t addr);

void log_printf(const char *format, ...);

void int_handler(uint32_t int_num);

#define LOW_32b(a)  ((uint32_t)((uint64_t)(a) & 0xffffffff))
#define HIGH_32b(a) ((uint32_t)(((uint64_t)(a)) >> 32L))

#endif
