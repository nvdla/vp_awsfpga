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


#ifndef CL_COMMON_UTILS_H
#define CL_COMMON_UTILS_H

#include <stdint.h>
#include <sys/types.h>

#ifdef VP_TEST
#define log_printf printf
#define SIZE_UINT32 2
#define SIZE_UINT64 3
#else // #ifdef VP_TEST
#ifdef SV_TEST
// Vivado does not support svGetScopeFromName
#ifndef VIVADO_SIM
#include "svdpi.h"
#endif
#include "sh_dpi_tasks.h"
#else
#include <fpga_pci.h>
#include <fpga_mgmt.h>
#define log_printf printf
#endif
#endif // #ifdef VP_TEST

#ifndef VP_TEST
#ifndef SV_TEST
extern pci_bar_handle_t pci_bar_handle_ocl;
extern pci_bar_handle_t pci_bar_handle_bar1;
extern pci_bar_handle_t pci_bar_handle_pcis;

#define SIZE_UINT32 2
#define SIZE_UINT64 3

#define CFG_RESET_ADDR      (0x14)

#define cl_poke_ocl(addr, data) do { \
        if (pci_bar_handle_ocl == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_ocl!\n"); \
            assert(0); \
        } else { \
            fpga_pci_poke(pci_bar_handle_ocl, addr, data); \
        } \
    } \
    while (0)

#define cl_peek_ocl(addr, data) do { \
        if (pci_bar_handle_ocl == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_ocl!\n"); \
            assert(0); \
        } else { \
            fpga_pci_peek(pci_bar_handle_ocl, addr, data); \
        } \
    } \
    while (0)

#define cl_poke_bar1(addr, data) do { \
        if (pci_bar_handle_bar1 == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_bar1!\n"); \
            assert(0); \
        } else { \
            fpga_pci_poke(pci_bar_handle_bar1, addr, data); \
        } \
    } \
    while (0)

#define cl_peek_bar1(addr, data) do { \
        if (pci_bar_handle_bar1 == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_bar1!\n"); \
            assert(0); \
        } else { \
            fpga_pci_peek(pci_bar_handle_bar1, addr, data); \
        } \
    } \
    while (0)

#define cl_poke_pcis(addr, data, size) do { \
        if (pci_bar_handle_pcis == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_pcis!\n"); \
            assert(0); \
        } else { \
            if (size == SIZE_UINT32) { \
                fpga_pci_poke(pci_bar_handle_pcis, addr, data); \
            } else if (size == SIZE_UINT64) { \
                fpga_pci_poke64(pci_bar_handle_pcis, addr, data); \
            } else { \
                log_printf("Unsupported size: %d, only support %d and %d!\n", size, SIZE_UINT32, SIZE_UINT64); \
                assert(0); \
            } \
        } \
    } \
    while (0)

#define cl_peek_pcis(addr, data, size) do { \
        if (pci_bar_handle_pcis == PCI_BAR_HANDLE_INIT) { \
            log_printf("Uninitialized pci_bar_handle_pcis!\n"); \
            assert(0); \
        } else { \
            if (size == SIZE_UINT32) { \
                fpga_pci_peek(pci_bar_handle_pcis, addr, (uint32_t*)data); \
            } else if (size == SIZE_UINT64) { \
                fpga_pci_peek64(pci_bar_handle_pcis, addr, data); \
            } else { \
                log_printf("Unsupported size: %d, only support %d and %d!\n", size, SIZE_UINT32, SIZE_UINT64); \
                assert(0); \
            } \
        } \
    } \
    while (0)

#endif
#endif

// Util functions
void apb_write(uint64_t addr, uint32_t data);
void apb_read(uint64_t addr, uint32_t *data);
void ddr_write(uint64_t addr, uint64_t data, uint32_t size);
void ddr_read(uint64_t addr, uint64_t *data, uint32_t size);
void cfg_write(uint64_t addr, uint32_t data);
void cfg_read(uint64_t addr, uint32_t *data);

#ifndef SV_TEST
/* check if the corresponding AFI is loaded */
int check_afi_ready(int slot_id, uint16_t pci_vendor_id, uint16_t pci_device_id);
#endif

int cl_common_init(uint16_t pci_vendor_id, uint16_t pci_device_id, uint32_t pci_int_mask);
int cl_common_cleanup(void);
void cl_common_reset();

#ifndef VP_TEST
#ifndef SV_TEST
int cl_msi_poll(int timeout);
short cl_msi_is_active(uint32_t interrupt_number);
#endif
#endif

#ifdef VP_TEST
void* mmap_device(off_t offset, size_t size);
#endif

#endif
