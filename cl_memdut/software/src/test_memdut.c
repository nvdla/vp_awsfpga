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

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#include "cl_common_utils.h"
#include "test_utils.h"
#include "memdut_regs.h"

#define CFG_INT_STATUS_ADDR UINT64_C(0x0)
#define DDR_C_BASE_ADDR     UINT64_C(0x00000000)
#ifdef SV_TEST
#define NUM_AXI_PORTS       2
#define NUM_LOOP            1
#else
#define NUM_AXI_PORTS       1
#define NUM_LOOP            10
#endif

typedef enum { INT_INIT, INT_ASSERT, INT_DEASSERT } IRQ_STATE_t;

static IRQ_STATE_t irq_state[NUM_AXI_PORTS];

/*
 * pci_vendor_id and pci_device_id values below are Amazon's and avaliable to use for a given FPGA slot. 
 * Users may replace these with their own if allocated to them by PCI SIG
 */
static uint16_t pci_vendor_id = 0x1D0F; /* Amazon PCI Vendor ID */
static uint16_t pci_device_id = 0xF001; /* PCI Device ID preassigned by Amazon for F1 applications */
static uint32_t int_mask = 0x1;

int apb_test(void);
int ram_test(void);
int ddr_c_test(void);
int axi_test(void);

#ifdef SV_TEST
void test_main(uint32_t *exit_code) 
#else
int main(int argc, char **argv)
#endif
{
    int rc = 0;

    if (cl_common_init(pci_vendor_id, pci_device_id, int_mask)) {
        log_printf("Errors on initialization!\n");
        assert(0);
    }

    /* APB test */
    if (apb_test()) {
        rc = 1;
    }

    /* RAM test */
    if (ram_test()) {
        rc = 1;
    }

    /* DDR_C test */
    if (ddr_c_test()) {
        rc = 1;
    }

    /* AXI test */
    if (axi_test()) {
        rc = 1;
    }

    /* cleanup */
    if (cl_common_cleanup()) {
        rc = 1;
    }

    if (!rc) {
        log_printf("Test PASSED\n");
    } else {
        log_printf("Test FAILED\n");
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
    
    assert(int_num < NUM_AXI_PORTS);

    uint32_t status;
    static uint32_t last_status = 0;

    cfg_read(CFG_INT_STATUS_ADDR, &status);
    
    log_printf("CL_INT_HANDLER: int_status=0x%x, last_status=0x%x\n", status, last_status);

    assert(status != last_status);

    if (status & (0x1<<int_num)) {
        log_printf("CL_INT_HANDLER: clear memdut interrupt\n");
        apb_write(MEMDUT_INTR_TEST_CLEAR, 0xFFFFFFFF);
        irq_state[int_num] = INT_ASSERT;
    } else if (irq_state[int_num] == INT_ASSERT) {
        irq_state[int_num] = INT_DEASSERT;
    } else {
        log_printf("CL_INT_HANDLER: ERROR! entering the int handler without interrupt asserted\n");
        assert(0);
    }

    last_status = status;
      
    log_printf("CL_INT_HANDLER: ack interrupt\n");
    cfg_write(CFG_INT_STATUS_ADDR, (0x1<<int_num));
}

// APB test
int apb_test()
{
    uint32_t wdata_32;
    uint32_t rdata_32;
    int rc = 0;
    int i;

    for (i=0; i<2; i++) {
        wdata_32 = 0x12345678+i;
        log_printf("APB_TEST: Writing 0x%x to test_reg_%d\n", wdata_32, i);
        apb_write_test_reg(i, wdata_32);
        apb_read_test_reg(i, &rdata_32);

        log_printf("APB_TEST: Reading 0x%x from test_reg_%d\n", rdata_32, i);
        if (rdata_32 != wdata_32) {
          log_printf("APB_TEST: ERROR!\n");
          rc = 1;
        }
    }

    return rc;
}

// ram test
int ram_test()
{
    uint32_t wdata_32[8];
    uint32_t rdata_32[8];
    int rc = 0;
    int i, j, k;

    // cmd_ram test
    for (i=0; i<NUM_AXI_PORTS; i++) {
        for (j=0; j<4; j++) {
            for (k=0; k<4; k++) {
                wdata_32[k] = 0xabcde000+(i<<8)+(j<<4)+k;
            }
            log_printf("RAM_TEST: Writing 0x%x %x %x %x to CMD_RAM addr: %d\n", wdata_32[0], wdata_32[1], wdata_32[2], wdata_32[3], j);
            apb_write_cmd_ram(i, j, wdata_32);
            apb_read_cmd_ram(i, j, rdata_32);
            log_printf("RAM_TEST: Reading 0x%x %x %x %x from CMD_RAM addr: %d\n", rdata_32[0], rdata_32[1], rdata_32[2], rdata_32[3], j);
            for (k=0; k<4; k++) {
                if (wdata_32[k] != rdata_32[k]) {
                    log_printf("RAM_TEST: ERROR!\n");
                    rc = 1;
                }
            }
        }
    }

    // we_ram test
    for (i=0; i<NUM_AXI_PORTS; i++) {
        for (j=0; j<4; j++) {
            wdata_32[0] = 0x12345600+(i<<4)+j;
            log_printf("RAM_TEST: Writing 0x%x to WE_RAM addr: %d\n", wdata_32[0], j);
            apb_write_we_ram(i, j, wdata_32[0]);
            apb_read_we_ram(i, j, rdata_32);
            log_printf("RAM_TEST: Reading 0x%x from WE_RAM addr: %d\n", rdata_32[0], j);
            if (wdata_32[0] != rdata_32[0]) {
                log_printf("RAM_TEST: ERROR!\n");
                rc = 1;
            }
        }
    }

    // wdata_ram test
    for (i=0; i<NUM_AXI_PORTS; i++) {
        for (j=0; j<4; j++) {
            for (k=0; k<8; k++) {
                wdata_32[k] = 0x23456000+(i<<8)+(j<<4)+k;
            }
            log_printf("RAM_TEST: Writing 0x%x %x %x %x %x %x %x %x to WDATA_RAM addr: %d\n", wdata_32[0], wdata_32[1], wdata_32[2], wdata_32[3], wdata_32[4], wdata_32[5], wdata_32[6], wdata_32[7], j);
            apb_write_wdata_ram(i, j, wdata_32);
            apb_read_wdata_ram(i, j, rdata_32);
            log_printf("RAM_TEST: Reading 0x%x %x %x %x %x %x %x %x from WDATA_RAM addr: %d\n", rdata_32[0], rdata_32[1], rdata_32[2], rdata_32[3], rdata_32[4], rdata_32[5], rdata_32[6], rdata_32[7], j);
            for (k=0; k<8; k++) {
                if (wdata_32[k] != rdata_32[k]) {
                    log_printf("RAM_TEST: ERROR!\n");
                    rc = 1;
                }
            }
        }
    }
    
    // rdata_ram test
    for (i=0; i<NUM_AXI_PORTS; i++) {
        for (j=0; j<4; j++) {
            for (k=0; k<4; k++) {
                rdata_32[k] = 0x34567000+(i<<8)+(j<<4)+k;
            }
            log_printf("RAM_TEST: Writing 0x%x %x %x %x %x %x %x %x to RDATA_RAM addr: %d\n", wdata_32[0], wdata_32[1], wdata_32[2], wdata_32[3], wdata_32[4], wdata_32[5], wdata_32[6], wdata_32[7], j);
            apb_write_rdata_ram(i, j, wdata_32);
            apb_read_rdata_ram(i, j, rdata_32);
            log_printf("RAM_TEST: Reading 0x%x %x %x %x %x %x %x %x from RDATA_RAM addr: %d\n", rdata_32[0], rdata_32[1], rdata_32[2], rdata_32[3], rdata_32[4], rdata_32[5], rdata_32[6], rdata_32[7], j);
            for (k=0; k<8; k++) {
                if (wdata_32[k] != rdata_32[k]) {
                    log_printf("RAM_TEST: ERROR!\n");
                    rc = 1;
                }
            }
        }
    }

    return rc;
}
  
// DDR_C test
int ddr_c_test()
{
    uint64_t addr;
    uint64_t wdata_64;
    uint64_t rdata_64;
    uint32_t i;
    int rc = 0;

    for (i=0; i<4; i++) {
        addr = DDR_C_BASE_ADDR + i*0x10;
        wdata_64 = 0x12345678abcdef01 + i;
        log_printf("DDR_C_TEST: Writing 0x%lx to address 0x%lx\n", wdata_64, addr);
        ddr_write(addr, wdata_64, SIZE_UINT64);
        ddr_read(addr, &rdata_64, SIZE_UINT64);

        log_printf("DDR_C_TEST: Reading 0x%lx from address 0x%lx\n", rdata_64, addr);
        if (rdata_64 != wdata_64) {
            log_printf("DDR_C_TEST: ERROR!");
            rc = 1;
        }
    }

    return rc;
}
  
// AXI test
int axi_test()
{
    uint32_t i, j;
    int rc = 0;

    memdut_atg_ctrl   atg_ctrl[NUM_AXI_PORTS];
    num_req_reg       num_req[NUM_AXI_PORTS];
    test_ctrl_reg     test_ctrl[4];
    memdut_test_cnt   test_cnt[4];
    test_status_reg   test_status[4];

    apb_write(MEMDUT_INTR_TEST_EN, 0xFFFFFFFF); // enable interrupt
    
    for (j=0; j<NUM_LOOP; j++) {
        for (i=0; i<NUM_AXI_PORTS; i++) {
            log_printf("AXI_TEST: testing port %d\n", i);
            irq_state[i] = INT_INIT;

            memset(&atg_ctrl[i], 0, sizeof(memdut_atg_ctrl));
            num_req[i].value = 0;
            test_ctrl[i].value = 0;
            atg_ctrl[i].atg_cmd_ctrl.field.cmd_mode         = WR_VERIFY_64_BYTES;
            atg_ctrl[i].atg_cmd_ctrl.field.cmd_aburst       = BURST_INCR;
            atg_ctrl[i].atg_cmd_ctrl.field.cmd_asize        = SIZE_32;
            atg_ctrl[i].atg_cmd_ctrl.field.axprot           = 0x2;
            atg_ctrl[i].atg_addr_base.field.addr_base       = 0x00100000+0x00100000*i;
            atg_ctrl[i].atg_data_ctrl.field.data_length     = 0x40;
            atg_ctrl[i].atg_data_ctrl.field.data_mode       = NUM_16_BIT;
            atg_ctrl[i].atg_wstrb.field.wstrb_preset        = 0xFFFFFFFF;
            num_req[i].field.axi_req_num_total              = 0x40;
            test_ctrl[i].field.rdata_check_en               = 0x1;
            test_ctrl[i].field.atg_en                       = 0x1;
            test_ctrl[i].field.run                          = 0x1;

            memdut_set_atg_ctrl(&atg_ctrl[i], i);
            memdut_set_num_req(num_req[i], i);
            memdut_set_test_ctrl(test_ctrl[i], i);
            
            memdut_get_test_status(&test_status[i], i);
        
            // wait for interrupt
#ifndef VP_TEST
            uint32_t poll_timeout = 1000;
#endif
            uint32_t poll_limit = 1000;
            while (1) {
#ifdef VP_TEST
                memdut_get_test_status(&test_status[i], i);
                if (test_status[i].field.test_finish == 1 || --poll_limit == 0) {
                    break;
                }
#else
#ifdef SV_TEST
                sv_pause(1);
#else
                int rd = cl_msi_poll(poll_timeout);
                if (rd == -1) {
                    printf("Error when polling event, errno=%d\n", errno);
                    assert(0);
                } else if (rd > 0) {
                    if (cl_msi_is_active(i)) {
                        cl_int_handler(i);
                    } else {
                        printf("Error! interrupt %d is not active\n", i);
                        assert(0);
                    }
                }
#endif // #ifdef SV_TEST
                if (irq_state[i] == INT_DEASSERT || --poll_limit == 0) {
                    break;
                }
#endif // #ifdef VP_TEST
            }
            
            if (poll_limit == 0) {
                log_printf("ERROR! Polling timeout\n");
                return 1;
            }

            memdut_get_test_status(&test_status[i], i);
            if (!(test_status[i].field.test_finish == 1)) {
                log_printf("ERROR! test_finish != 1\n");
                return 1;
            }
            
            memdut_get_test_cnt(&test_cnt[i], i);
            log_printf("AXI_TEST: Total responses received: %d\n", test_cnt[i].resp_cnt.value);
            log_printf("AXI_TEST: Total read responses received: %d\n", test_cnt[i].rresp_cnt.value);
            log_printf("AXI_TEST: Total read data phases received: %d\n", test_cnt[i].rdata_cnt.value); 
            log_printf("AXI_TEST: Total requests issued: %d\n", test_cnt[i].req_cnt.value);
            log_printf("AXI_TEST: Total write requests issued: %d\n", test_cnt[i].req_wr_cnt.value); 
            log_printf("AXI_TEST: Total write data phases issued: %d\n", test_cnt[i].req_wd_cnt.value); 
            if (!(test_status[i].value & 0xefff)) {
                log_printf("AXI_TEST: test passed for axi port %d\n", i);
            } else {
                log_printf("AXI_TEST: test failed for axi port %d\n with error status=0x%x", i, test_status[i].value);
                rc = 1;
            } 

            memdut_get_test_ctrl(&test_ctrl[i], i);
            log_printf("AXI_TEST: Clear the run bit: 0x%08x\n", test_ctrl[i].value);
            test_ctrl[i].value = 0;
            memdut_set_test_ctrl(test_ctrl[i], i);
            memdut_get_test_status(&test_status[i], i);
            log_printf("AXI_TEST: Check MEMDUT_N_TEST_STATUS: %d\n", test_status[i].value);
        }
    }

    return rc;
}
