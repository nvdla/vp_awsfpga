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


#include "cl_common_utils.h"
#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>
#include <poll.h>

#ifndef VP_TEST
#ifndef SV_TEST
#include <utils/log.h>
#endif
#endif

#ifdef VP_TEST
#include <stdlib.h>
#include <sys/mman.h>
#define OCL_BASE  0x10200000
#define OCL_SIZE  (0x10220000 - 0x10200000)
#define DDR_BASE 0xc0000000
#define DDR_SIZE 0x40000000
uint32_t *p_reg;
uint64_t *p_mem;
#else
#ifndef SV_TEST
#define MAX_NUM_INT 16
pci_bar_handle_t pci_bar_handle_ocl = PCI_BAR_HANDLE_INIT;
pci_bar_handle_t pci_bar_handle_bar1 = PCI_BAR_HANDLE_INIT;
pci_bar_handle_t pci_bar_handle_pcis = PCI_BAR_HANDLE_INIT;
struct pollfd pci_int_fds[MAX_NUM_INT];
#endif
#endif

// Util functions
void apb_write(uint64_t addr, uint32_t data)
{
#ifdef VP_TEST
    *(p_reg+addr/4) = data;
#else
    cl_poke_ocl(addr, data);
#endif
}

void apb_read(uint64_t addr, uint32_t *data)
{
#ifdef VP_TEST
    *data = *(p_reg+addr/4);
#else
    cl_peek_ocl(addr, data);
#endif
}

void ddr_write(uint64_t addr, uint64_t data, uint32_t size)
{
#ifdef VP_TEST
    switch (size) {
        case 0:
            ((uint8_t *)p_mem)[addr] = data & 0xFF;
            break;
        case 1:
            ((uint16_t *)p_mem)[addr>>1] = data & 0xFFFF;
            break;
        case 2:
            ((uint32_t *)p_mem)[addr>>2] = data & 0xFFFFFFFF;
            break;
        default:
            p_mem[addr>>3] = data;
            break;
    }
#else
    cl_poke_pcis(addr, data, size);
#endif
}

void ddr_read(uint64_t addr, uint64_t *data, uint32_t size)
{
#ifdef VP_TEST
    switch (size) {
        case 0:
            *data = ((uint8_t *)p_mem)[addr];
            break;
        case 1:
            *data = ((uint16_t *)p_mem)[addr>>1];
            break;
        case 2:
            *data = ((uint32_t *)p_mem)[addr>>2];
            break;
        default:
            *data = p_mem[addr>>3];
            break;
    }
#else
    cl_peek_pcis(addr, data, size);
#endif
}

void cfg_write(uint64_t addr, uint32_t data)
{
#ifndef VP_TEST
    cl_poke_bar1(addr, data);
#endif
}

void cfg_read(uint64_t addr, uint32_t *data)
{
#ifndef VP_TEST
    cl_peek_bar1(addr, data);
#endif
}

#ifndef VP_TEST
#ifndef SV_TEST
/* check if the corresponding AFI is loaded */
int check_afi_ready(int slot_id, uint16_t pci_vendor_id, uint16_t pci_device_id) 
{
    struct fpga_mgmt_image_info info = {0}; 
    int rc;

    /* get local image description, contains status, vendor id, and device id. */
    rc = fpga_mgmt_describe_local_image(slot_id, &info,0);
    fail_on(rc, out, "Unable to get AFI information from slot %d. Are you running as root?",slot_id);

    /* check to see if the slot is ready */
    if (info.status != FPGA_STATUS_LOADED) {
        rc = 1;
        fail_on(rc, out, "AFI in Slot %d is not in READY state !", slot_id);
    }

    printf("AFI PCI  Vendor ID: 0x%x, Device ID 0x%x\n",
        info.spec.map[FPGA_APP_PF].vendor_id,
        info.spec.map[FPGA_APP_PF].device_id);

    /* confirm that the AFI that we expect is in fact loaded */
    if (info.spec.map[FPGA_APP_PF].vendor_id != pci_vendor_id ||
        info.spec.map[FPGA_APP_PF].device_id != pci_device_id) {
        printf("AFI does not show expected PCI vendor id and device ID. If the AFI "
               "was just loaded, it might need a rescan. Rescanning now.\n");

        rc = fpga_pci_rescan_slot_app_pfs(slot_id);
        fail_on(rc, out, "Unable to update PF for slot %d",slot_id);
        /* get local image description, contains status, vendor id, and device id. */
        rc = fpga_mgmt_describe_local_image(slot_id, &info,0);
        fail_on(rc, out, "Unable to get AFI information from slot %d",slot_id);

        printf("AFI PCI  Vendor ID: 0x%x, Device ID 0x%x\n",
            info.spec.map[FPGA_APP_PF].vendor_id,
            info.spec.map[FPGA_APP_PF].device_id);

        /* confirm that the AFI that we expect is in fact loaded after rescan */
        if (info.spec.map[FPGA_APP_PF].vendor_id != pci_vendor_id ||
             info.spec.map[FPGA_APP_PF].device_id != pci_device_id) {
            rc = 1;
            fail_on(rc, out, "The PCI vendor id and device of the loaded AFI are not "
                             "the expected values.");
        }
    }

    return (rc != 0 ? 1: 0);
out:
    return 1;
}
#endif
#endif

int cl_common_init(uint16_t pci_vendor_id, uint16_t pci_device_id, uint32_t pci_int_mask) 
{
#ifdef VP_TEST
    void* ocl_mm = mmap_device(OCL_BASE, OCL_SIZE);
    void* ddr_mm = mmap_device(DDR_BASE, DDR_SIZE);
    p_reg = (uint32_t *)ocl_mm;
    p_mem = (uint64_t *)ddr_mm;
    return 0;
#else
    int rc;

#ifdef SV_TEST
// Vivado does not support svGetScopeFromName
//#ifdef INCLUDE_DPI_CALLS
#ifndef VIVADO_SIM
    svScope scope;
    scope = svGetScopeFromName("tb");
    svSetScope(scope);

    rc = 0;
#endif
//#endif
#else
    int slot_id;
    int pf_id;
    int bar_id;

    /* initialize the fpga_pci library so we could have access to FPGA PCIe from this applications */
    rc = fpga_pci_init();
    fail_on(rc, out, "Unable to initialize the fpga_pci library");

    /* This demo works with single FPGA slot, we pick slot #0 as it works for both f1.2xl and f1.16xl */
    slot_id = 0;
    rc = check_afi_ready(slot_id, pci_vendor_id, pci_device_id);
    fail_on(rc, out, "AFI not ready");

    /* initialize the bar handle */
    pf_id = FPGA_APP_PF;
    
    bar_id = APP_PF_BAR0;
    rc = fpga_pci_attach(slot_id, pf_id, bar_id, 0, &pci_bar_handle_ocl);
    fail_on(rc, out, "Unable to attach to the AFI on slot id %d, bar_id %d", slot_id, bar_id);
    bar_id = APP_PF_BAR1;
    rc = fpga_pci_attach(slot_id, pf_id, bar_id, 0, &pci_bar_handle_bar1);
    fail_on(rc, out, "Unable to attach to the AFI on slot id %d, bar_id %d", slot_id, bar_id);
    bar_id = APP_PF_BAR4;
    rc = fpga_pci_attach(slot_id, pf_id, bar_id, 0, &pci_bar_handle_pcis);
    fail_on(rc, out, "Unable to attach to the AFI on slot id %d, bar_id %d", slot_id, bar_id);

    /* initialize the MSI interrupt fd */
    uint32_t i;
    char event_file_name[256];
    int fd;
    for (i=0; i<MAX_NUM_INT; i++) {
        if ((pci_int_mask>>i)&0x1) {
            rc = sprintf(event_file_name, "/dev/fpga%i_event%i", slot_id, i);
            fail_on((rc = (rc < 0)? 1:0), out, "Unable to format event file name.");
            if((fd = open(event_file_name, O_RDONLY)) == -1) {
                printf("Error - invalid device %s\n", event_file_name);
                rc = 1;
                fail_on(rc, out, "Unable to open event device %s", event_file_name);
            }
            pci_int_fds[i].fd = fd;
            pci_int_fds[i].events = POLLIN;
        } else {
            pci_int_fds[i].fd = -1;
        }
    }
       
#endif

    return (rc != 0 ? 1 : 0);
out:
    return 1;
#endif
}

int cl_common_cleanup()
{
#ifdef VP_TEST
    return 0;
#else
    int rc = 0;;
#ifndef SV_TEST
    if (pci_bar_handle_ocl >= 0) {
        if (fpga_pci_detach(pci_bar_handle_ocl) != 0) {
            printf("Failure while detaching bar0 from the fpga.\n");
            rc = 1;
        }
    }
    if (pci_bar_handle_bar1 >= 0) {
        if (fpga_pci_detach(pci_bar_handle_bar1) != 0) {
            printf("Failure while detaching bar1 from the fpga.\n");
            rc = 1;
        }
    }
    if (pci_bar_handle_pcis >= 0) {
        if (fpga_pci_detach(pci_bar_handle_pcis) != 0) {
            printf("Failure while detaching bar4 from the fpga.\n");
            rc = 1;
        }
    }
    uint32_t i;
    for (i=0; i<MAX_NUM_INT; i++) {
        if (pci_int_fds[i].fd != -1) {
            close(pci_int_fds[i].fd);
        }
    }
#endif
    return rc;
#endif
}

void cl_common_reset()
{
#ifndef VP_TEST
#ifdef SV_TEST
// Vivado does not support svGetScopeFromName
//#ifdef INCLUDE_DPI_CALLS
#ifndef VIVADO_SIM
    svScope scope;
    scope = svGetScopeFromName("tb");
    svSetScope(scope);
#endif
//#endif
#endif
    uint32_t reset;

    cfg_read(CFG_RESET_ADDR, &reset);

    reset = reset | (0x1);
    cfg_write(CFG_RESET_ADDR, reset);
#ifndef SV_TEST
    usleep(1000);
#else
    sv_pause(1);
#endif
    reset = reset & (0xFFFFFFFE);
    cfg_write(CFG_RESET_ADDR, reset);
#ifndef SV_TEST
    usleep(1000);
#else
    sv_pause(1);
#endif
#endif
    printf("INFO -- Reset Done\n");
}

#ifndef VP_TEST
#ifndef SV_TEST
int cl_msi_poll(int timeout)
{
    return poll(pci_int_fds, MAX_NUM_INT, timeout);
}

short cl_msi_is_active(uint32_t interrupt_number)
{
    return (pci_int_fds[interrupt_number].revents & POLLIN);
}
#endif
#endif

#ifdef VP_TEST
void* mmap_device(off_t offset, size_t size)
{
    int fd = open("/dev/mem", O_RDWR);
	if (fd < 0) {
		perror("open /dev/mem failed!");
        exit(EXIT_FAILURE);
	}

    void* device_mm = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset);
    if (close(fd) < 0) {
        perror("close failed!");
    }
    if (device_mm == MAP_FAILED) {
        perror("mmap DLA failed!");
        exit(EXIT_FAILURE);
    }
    return device_mm;
}
#endif
