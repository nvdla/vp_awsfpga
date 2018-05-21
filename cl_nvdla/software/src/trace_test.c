// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_test.c

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>
#include <unistd.h>

#include "opendla.h"

#include "cl_common_utils.h"

#include "trace_player.h"
#include "trace_player_intr.h"

/*
 * Platform Specific Params
 */
#define CFG_INT_STATUS_ADDR (0x0)

/*
 * pci_vendor_id and pci_device_id values below are Amazon's and avaliable to use for a given FPGA slot. 
 * Users may replace these with their own if allocated to them by PCI SIG
 */
static uint16_t pci_vendor_id = 0x1D0F; /* Amazon PCI Vendor ID */
static uint16_t pci_device_id = 0xF001; /* PCI Device ID preassigned by Amazon for F1 applications */
static uint32_t int_mask = 0x1;

typedef enum { INT_INIT, INT_ASSERT, INT_DEASSERT } IRQ_STATE_t;

static IRQ_STATE_t irq_state = INT_INIT;

uint32_t trace_player_pending_intr = 0;

#ifdef SV_TEST
void set_enable_sim_mem(int val);
#endif

/*
 * Interrupt handler
 */
void cl_int_handler(uint32_t int_num);
void wait_irq_done(void);
void cl_check_and_clear_intr(void);

#ifdef SV_TEST
void trace_test_main(uint32_t *exit_code, const char *trace_file, int enable_sim_mem)
#else
int main(int argc, char **argv)
#endif
{
    int rc = 0;

#ifdef SV_TEST
#else
    assert(argc == 2);
    char *trace_file = argv[1];
#endif

    if (cl_common_init(pci_vendor_id, pci_device_id, int_mask)) {
        log_printf("Errors on initialization!\n");
        assert(0);
    }
#ifndef VP_TEST
    cl_common_reset();
#endif

#ifdef SV_TEST
    set_enable_sim_mem(enable_sim_mem);
#endif
    
    rc = trace_player_run(trace_file);

    /* wait for irq handling done */
    wait_irq_done();

    /* cleanup */
    if (cl_common_cleanup()) {
        rc = 1;
    }

    switch(rc){
        case 0:
            log_printf("Test PASSED\n");
            break;
        case 1:
            log_printf("Test FAILED\n");
            break;
        case 2:
            log_printf("Test TIMEOUT\n");
            break;
    }

#ifdef SV_TEST
    *exit_code = rc;
#else
    return rc;
#endif
}

void cl_int_handler(uint32_t int_num) 
{
    log_printf("CL_INT_HANDLER: enter cl_int_handler, int_num=%d\n", int_num);
 
    if (int_num != 0) {
        log_printf("CL_INT_HANDLER: ERROR! int_num should always be 0!\n");
        return;
    }

    uint32_t status;
    static uint32_t last_status = 0;

    cfg_read(CFG_INT_STATUS_ADDR, &status);
    
    log_printf("CL_INT_HANDLER: int_status=0x%x, last_status=0x%x\n", status, last_status);

    if (status == last_status) {
        log_printf("CL_INT_HANDLER: ERROR! status should never be the same as last_status!\n");
        return;
    }

    if (status & (0x1<<int_num)) {
        uint32_t* nvdla_intr_status_reg = (uint32_t*)(NVDLA_GLB_S_INTR_STATUS_0);
        uint32_t int_status;
        apb_read((uintptr_t)nvdla_intr_status_reg, &int_status);

        if (int_status != 0)
        {
            trace_player_pending_intr |= int_status;
            log_printf("CL_INT_HANDLER: get nvdla interrupt: 0x%x, trace_player_pending_intr=0x%x\n", int_status, trace_player_pending_intr);
            log_printf("CL_INT_HANDLER: clear nvdla interrupt: 0x%x\n", int_status);
            apb_write((uintptr_t)nvdla_intr_status_reg, int_status);
            while(1) {
                apb_read((uintptr_t)nvdla_intr_status_reg, &int_status);
                if (int_status == 0) {
                    log_printf("CL_INT_HANDLER: interrupt cleared\n");
                    break;
                } else {
                    trace_player_pending_intr |= int_status;
                    log_printf("CL_INT_HANDLER: get nvdla interrupt: 0x%x, trace_player_pending_intr=0x%x\n", int_status, trace_player_pending_intr);
                    log_printf("CL_INT_HANDLER: clear nvdla interrupt: 0x%x\n", int_status);
                    apb_write((uintptr_t)nvdla_intr_status_reg, int_status);
                }
            };
        }
        irq_state = INT_ASSERT;
    } else if (irq_state == INT_ASSERT) {
        irq_state = INT_DEASSERT;
    } else {
        log_printf("CL_INT_HANDLER: ERROR! entering the int handler without interrupt asserted\n");
    }

    last_status = status;
      
    log_printf("CL_INT_HANDLER: ack interrupt\n");
    cfg_write(CFG_INT_STATUS_ADDR, (0x1<<int_num));
}

void wait_irq_done()
{
#ifndef SV_TEST
#ifndef VP_TEST
    while (irq_state == INT_ASSERT) {
        log_printf("WAIT_IRQ_DONE: waiting for irq done\n");
        usleep(1000000);
        cl_check_and_clear_intr();
        irq_state = INT_DEASSERT;
    }
#endif
#endif
}

#ifndef SV_TEST
#ifdef VP_TEST
void cl_check_and_clear_intr(void)
{
    uint32_t* nvdla_intr_status_reg = (uint32_t*)(NVDLA_GLB_S_INTR_STATUS_0);
    uint32_t int_status;
    apb_read((uintptr_t)nvdla_intr_status_reg, &int_status);
    trace_player_pending_intr |= int_status;
    if (int_status != 0) {
        log_printf("CL_INT_HANDLER: get nvdla interrupt: 0x%x, trace_player_pending_intr=0x%x\n", int_status, trace_player_pending_intr);
        log_printf("CL_INT_HANDLER: clear nvdla interrupt: 0x%x\n", int_status);
        apb_write((uintptr_t)nvdla_intr_status_reg, int_status);
        irq_state = INT_ASSERT;
        log_printf("CL_INT_HANDLER: ack interrupt transactor\n");
    }
}
#else
void cl_check_and_clear_intr(void)
{
    uint32_t poll_timeout = 10;
    int rd = cl_msi_poll(poll_timeout);
    if (rd == -1) {
        log_printf("Error when polling event, errno=%d\n", errno);
        assert(0);
    } else if (rd > 0) {
        if (cl_msi_is_active(0)) {
            cl_int_handler(0);
        } else {
            log_printf("Error! interrupt %d is not active\n", 0);
            assert(0);
        }
    }
}
#endif
#endif
