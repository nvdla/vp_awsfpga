// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: test_utils.c

#include "test_utils.h"
#include "cl_common_utils.h"
#include "memdut_regs.h"

// Util functions
void apb_write_test_reg(uint32_t reg_n, uint32_t data)
{
    apb_write(MEMDUT_APB_TEST_REG(reg_n), data);
}

void apb_read_test_reg(uint32_t reg_n, uint32_t *data)
{
    apb_read(MEMDUT_APB_TEST_REG(reg_n), data);
}

void apb_write_cmd_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata)
{
    int i;
    for (i=0; i<4; i++) {
        apb_write(MEMDUT_N_CMD_RAM_BASE(inst)+(offset<<4)+(i<<2), wdata[i]);
    }
}

void apb_read_cmd_ram(uint32_t inst, uint32_t offset, uint32_t* rdata)
{
    int i;
    for (i=0; i<4; i++) {
        apb_read(MEMDUT_N_CMD_RAM_BASE(inst)+(offset<<4)+(i<<2), &rdata[i]);
    }
}

void apb_write_we_ram(uint32_t inst, uint32_t offset, uint32_t wdata)
{
    apb_write(MEMDUT_N_WE_RAM_BASE(inst)+(offset<<2), wdata);
}

void apb_read_we_ram(uint32_t inst, uint32_t offset, uint32_t* rdata)
{
    apb_read(MEMDUT_N_WE_RAM_BASE(inst)+(offset<<2), rdata);
}

void apb_write_wdata_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata)
{
    int i;
    for (i=0; i<8; i++) {
        apb_write(MEMDUT_N_WDATA_RAM_BASE(inst)+(offset<<5)+(i<<2), wdata[i]);
    }
}

void apb_read_wdata_ram(uint32_t inst, uint32_t offset, uint32_t* rdata)
{
    int i;
    for (i=0; i<8; i++) {
        apb_read(MEMDUT_N_WDATA_RAM_BASE(inst)+(offset<<5)+(i<<2), &rdata[i]);
    }
}

void apb_write_rdata_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata)
{
    int i;
    for (i=0; i<8; i++) {
        apb_write(MEMDUT_N_RDATA_RAM_BASE(inst)+(offset<<5)+(i<<2), wdata[i]);
    }
}

void apb_read_rdata_ram(uint32_t inst, uint32_t offset, uint32_t* rdata)
{
    int i;
    for (i=0; i<8; i++) {
        apb_read(MEMDUT_N_RDATA_RAM_BASE(inst)+(offset<<5)+(i<<2), &rdata[i]);
    }
}

void memdut_set_atg_ctrl(const memdut_atg_ctrl *atg_ctrl, uint32_t inst)
{
    apb_write(MEMDUT_N_ATG_CMD_CTRL(inst),     atg_ctrl->atg_cmd_ctrl.value);
    apb_write(MEMDUT_N_ATG_AXI_ID(inst),       atg_ctrl->atg_axi_id.value); 
    apb_write(MEMDUT_N_ATG_ADDR_BASE(inst),    atg_ctrl->atg_addr_base.value);
    apb_write(MEMDUT_N_ATG_ADDR_LOW(inst),     atg_ctrl->atg_addr_low.value); 
    apb_write(MEMDUT_N_ATG_DATA_CTRL(inst),    atg_ctrl->atg_data_ctrl.value); 
    apb_write(MEMDUT_N_ATG_WSTRB(inst),        atg_ctrl->atg_wstrb.value); 
}

void memdut_set_num_req(const num_req_reg num_req, uint32_t inst)
{
    apb_write(MEMDUT_N_CMD_NUM_TOTAL(inst),          num_req.value);
}

void memdut_set_test_ctrl(const test_ctrl_reg ctrl, uint32_t inst)
{
    apb_write(MEMDUT_N_TEST_CTRL(inst),        ctrl.value);
}

void memdut_get_test_ctrl(test_ctrl_reg *ctrl, uint32_t inst)
{
    apb_read(MEMDUT_N_TEST_CTRL(inst), &(ctrl->value));
}

void memdut_get_test_cnt(memdut_test_cnt *cnt, uint32_t inst)
{
    apb_read(MEMDUT_N_RESP_CNT(inst), &(cnt->resp_cnt.value));
    apb_read(MEMDUT_N_RRESP_CNT(inst), &(cnt->rresp_cnt.value));
    apb_read(MEMDUT_N_RDATA_CNT(inst), &(cnt->rdata_cnt.value));
    apb_read(MEMDUT_N_REQ_CNT(inst), &(cnt->req_cnt.value));
    apb_read(MEMDUT_N_REQ_WR_CNT(inst), &(cnt->req_wr_cnt.value));
    apb_read(MEMDUT_N_REQ_WD_CNT(inst), &(cnt->req_wd_cnt.value));
}

void memdut_get_test_status(test_status_reg *status, uint32_t inst)
{
    apb_read(MEMDUT_N_TEST_STATUS(inst), &(status->value));
}
