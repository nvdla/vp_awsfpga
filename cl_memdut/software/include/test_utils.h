// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: test_utils.h

#ifndef TEST_UTILS_H
#define TEST_UTILS_H

#include <stdint.h>

// Registers in CL_MEMDUT
typedef enum {WONLY_64_BYTES, RONLY_64_BYTES, WR_VERIFY_64_BYTES, RONLY_VERIFY_64_BYTES} ATG_CMD_MODE;
typedef enum {BURST_FIXED, BURST_INCR, BURST_WRAP} ATG_CMD_ABURST;
typedef enum {SIZE_1, SIZE_2, SIZE_4, SIZE_8, SIZE_16, SIZE_32, SIZE_64, SIZE_128} ATG_CMD_ASIZE;
typedef enum {ALL_0, ALL_1, NUM_16_BIT, NUM_16_BIT_REVERSE, FIX_55AAAA55, FIX_33CCCC33} ATG_DATA_MODE;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        ATG_CMD_MODE    cmd_mode            : 3;
        ATG_CMD_ABURST  cmd_aburst          : 2;
        ATG_CMD_ASIZE   cmd_asize           : 3;
        uint32_t    fix_id              : 1;
        uint32_t    fix_addr            : 1;
        uint32_t    dual_cmd_mode       : 1;
        uint32_t    axprot              : 3;
        uint32_t    rsv                 : 2;
        uint32_t    axidly1             : 8;
        uint32_t    axidly2             : 8;
    }__attribute__((packed)) field;
} atg_cmd_ctrl_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    arid_preset         : 14;
        uint32_t    rsv0                : 2;
        uint32_t    awid_preset         : 14;
        uint32_t    rsv1                : 2;
    }__attribute__((packed)) field;
} atg_axi_id_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    addr_base           : 32;
    }__attribute__((packed)) field;
} atg_addr_base_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    araddr_preset       : 16;
        uint32_t    awaddr_preset       : 16;
    }__attribute__((packed)) field;
} atg_addr_low_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    data_length         : 12;
        ATG_DATA_MODE   data_mode           : 3;
        uint32_t    wstrb_change        : 1;
        uint32_t    rsv                 : 16;
    }__attribute__((packed)) field;
} atg_data_ctrl_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    wstrb_preset        : 32;
    }__attribute__((packed)) field;
} atg_wstrb_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    reset               : 1;
        uint32_t    run                 : 1;
        uint32_t    repeat              : 1;
        uint32_t    atg_en               : 1;
        uint32_t    cmd_line_end        : 12;
        uint32_t    cmd_pend_num        : 9;
        uint32_t    rdata_check_en      : 1;
        uint32_t    rdata_sel           : 1;
        uint32_t    rsv                 : 5;
    }__attribute__((packed)) field;
} test_ctrl_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_req_num_total   : 32;
    }__attribute__((packed)) field;
} num_req_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    arcmd_pend_cnt      : 10;
        uint32_t    awcmd_pend_cnt      : 10;
        uint32_t    rsv                 : 12;
    }__attribute__((packed)) field;
} outstand_status_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    wdata_corrupt       : 1;
        uint32_t    bresp               : 2;
        uint32_t    bresp_code          : 1;
        uint32_t    bresp_id            : 1;
        uint32_t    rdata_corrupt       : 1;
        uint32_t    rresp               : 2;
        uint32_t    rresp_code          : 1;
        uint32_t    rresp_phase_less    : 1;
        uint32_t    rresp_phase_more    : 1;
        uint32_t    rresp_id            : 1;
        uint32_t    protocol_error      : 1;
        uint32_t    wstrb_line_mismatch : 1;
        uint32_t    cmd_line_mismatch   : 1;
        uint32_t    rsv                 : 16;
        uint32_t    test_finish         : 1;
    }__attribute__((packed)) field;
} test_status_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_cmd_error_loc   : 24;
        uint32_t    rsv                 : 8;
    }__attribute__((packed)) field;
} test_err_loc_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_resp_cnt_total  : 24;
        uint32_t    rsv                 : 8;
    }__attribute__((packed)) field;
} resp_cnt_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_rresp_cnt_total : 24;
        uint32_t    rsv                 : 8;
    }__attribute__((packed)) field;
} rresp_cnt_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_rdata_cnt_total : 32;
    }__attribute__((packed)) field;
} rdata_cnt_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_req_cnt         : 24;
        uint32_t    rsv                 : 8;
    }__attribute__((packed)) field;
} req_cnt_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_req_wr_cnt      : 24;
        uint32_t    rsv                 : 8;
    }__attribute__((packed)) field;
} req_wr_cnt_reg;

typedef union {
    uint32_t    value;
    uint8_t     bytes[4];
    struct {
        uint32_t    axi_req_wd_cnt      : 32;
    }__attribute__((packed)) field;
} req_wd_cnt_reg;

typedef struct
{
    atg_cmd_ctrl_reg             atg_cmd_ctrl;
    atg_axi_id_reg               atg_axi_id;
    atg_addr_base_reg            atg_addr_base;
    atg_addr_low_reg             atg_addr_low;
    atg_data_ctrl_reg            atg_data_ctrl;
    atg_wstrb_reg                atg_wstrb;
} memdut_atg_ctrl;

typedef struct
{
    resp_cnt_reg                resp_cnt;
    rresp_cnt_reg               rresp_cnt;
    rdata_cnt_reg               rdata_cnt;
    req_cnt_reg                 req_cnt;
    req_wr_cnt_reg              req_wr_cnt;
    req_wd_cnt_reg              req_wd_cnt;
} memdut_test_cnt;

// Util functions
void apb_write_test_reg(uint32_t reg_n, uint32_t data);
void apb_read_test_reg(uint32_t reg_n, uint32_t *data);
void apb_write_cmd_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata);
void apb_read_cmd_ram(uint32_t inst, uint32_t offset, uint32_t* rdata);
void apb_write_we_ram(uint32_t inst, uint32_t offset, uint32_t wdata);
void apb_read_we_ram(uint32_t inst, uint32_t offset, uint32_t* rdata);
void apb_write_wdata_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata);
void apb_read_wdata_ram(uint32_t inst, uint32_t offset, uint32_t* rdata);
void apb_write_rdata_ram(uint32_t inst, uint32_t offset, const uint32_t* wdata);
void apb_read_rdata_ram(uint32_t inst, uint32_t offset, uint32_t* rdata);
void memdut_set_atg_ctrl(const memdut_atg_ctrl *atg_ctrl, uint32_t inst);
void memdut_set_num_req(const num_req_reg num_req, uint32_t inst);
void memdut_set_test_ctrl(const test_ctrl_reg ctrl, uint32_t inst);
void memdut_get_test_ctrl(test_ctrl_reg *ctrl, uint32_t inst);
void memdut_get_test_cnt(memdut_test_cnt *cnt, uint32_t inst);
void memdut_get_test_status(test_status_reg *status, uint32_t inst);

#endif
