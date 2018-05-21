// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut_axi_256_256.v

`timescale 1ns/10ps
module NV_FPGA_unit_checkbox_mem_dut_axi_256_256 (
   apb_clk           //|< i
  ,apb_rstn          //|< i
  ,apb_wr_op         //|< i
  ,axi_arready       //|< i
  ,axi_awready       //|< i
  ,axi_bid           //|< i
  ,axi_bresp         //|< i
  ,axi_bvalid        //|< i
  ,axi_cmd_ram_sel   //|< i
  ,axi_paddr         //|< i
  ,axi_pwdata        //|< i
  ,axi_rdata         //|< i
  ,axi_rdata_ram_sel //|< i
  ,axi_reg_sel       //|< i
  ,axi_rid           //|< i
  ,axi_rlast         //|< i
  ,axi_rresp         //|< i
  ,axi_rvalid        //|< i
  ,axi_wdata_ram_sel //|< i
  ,axi_wready        //|< i
  ,axi_wstrb_ram_sel //|< i
  ,axi_araddr        //|> o
  ,axi_arburst       //|> o
  ,axi_arcache       //|> o
  ,axi_arid          //|> o
  ,axi_arlen         //|> o
  ,axi_arlock        //|> o
  ,axi_arprot        //|> o
  ,axi_arqos         //|> o
  ,axi_arregion      //|> o
  ,axi_arsize        //|> o
  ,axi_aruser        //|> o
  ,axi_arvalid       //|> o
  ,axi_awaddr        //|> o
  ,axi_awburst       //|> o
  ,axi_awcache       //|> o
  ,axi_awid          //|> o
  ,axi_awlen         //|> o
  ,axi_awlock        //|> o
  ,axi_awprot        //|> o
  ,axi_awqos         //|> o
  ,axi_awregion      //|> o
  ,axi_awsize        //|> o
  ,axi_awuser        //|> o
  ,axi_awvalid       //|> o
  ,axi_bready        //|> o
  ,axi_prdata        //|> o
  ,axi_rready        //|> o
  ,axi_wdata         //|> o
  ,axi_wlast         //|> o
  ,axi_wstrb         //|> o
  ,axi_wvalid        //|> o
  ,test_complete     //|> o
  );

parameter NV_FPGA_UNIT_MEM_DUT_AXI_CMD_PADDR_SHIFT = 4;
parameter NV_FPGA_UNIT_MEM_DUT_AXI_WE_PADDR_SHIFT = 2;
parameter NV_FPGA_UNIT_MEM_DUT_AXI_DATA_PADDR_SHIFT = 5;

input          apb_clk;
input          apb_rstn;
input          apb_wr_op;
input          axi_arready;
input          axi_awready;
input   [13:0] axi_bid;
input    [1:0] axi_bresp;
input          axi_bvalid;
input          axi_cmd_ram_sel;
input   [19:0] axi_paddr;
input   [31:0] axi_pwdata;
input  [255:0] axi_rdata;
input          axi_rdata_ram_sel;
input          axi_reg_sel;
input   [13:0] axi_rid;
input          axi_rlast;
input    [1:0] axi_rresp;
input          axi_rvalid;
input          axi_wdata_ram_sel;
input          axi_wready;
input          axi_wstrb_ram_sel;
output  [39:0] axi_araddr;
output   [1:0] axi_arburst;
output   [3:0] axi_arcache;
output  [13:0] axi_arid;
output   [7:0] axi_arlen;
output   [1:0] axi_arlock;
output   [2:0] axi_arprot;
output   [3:0] axi_arqos;
output   [3:0] axi_arregion;
output   [2:0] axi_arsize;
output  [25:0] axi_aruser;
output         axi_arvalid;
output  [39:0] axi_awaddr;
output   [1:0] axi_awburst;
output   [3:0] axi_awcache;
output  [13:0] axi_awid;
output   [7:0] axi_awlen;
output   [1:0] axi_awlock;
output   [2:0] axi_awprot;
output   [3:0] axi_awqos;
output   [3:0] axi_awregion;
output   [2:0] axi_awsize;
output  [25:0] axi_awuser;
output         axi_awvalid;
output         axi_bready;
output  [31:0] axi_prdata;
output         axi_rready;
output [255:0] axi_wdata;
output         axi_wlast;
output  [31:0] axi_wstrb;
output         axi_wvalid;
output         test_complete;
reg      [7:0] axi_arcmd_line_end;
reg      [7:0] axi_arcmd_line_reg;
reg      [7:0] axi_awcmd_line_end;
reg      [7:0] axi_awcmd_line_reg;
reg    [127:0] axi_cmd_ram_di;
reg      [7:0] axi_cmd_ram_ra_reg;
reg      [7:0] axi_cmd_ram_wa;
reg            axi_cmd_ram_we;
reg     [31:0] axi_prdata;
reg            axi_rd_req_wait_reg;
reg      [8:0] axi_rdata_line_end;
reg      [8:0] axi_rdata_line_reg;
reg    [255:0] axi_rdata_ram_di_i;
reg      [8:0] axi_rdata_ram_wa_i;
reg            axi_rdata_ram_we_i;
reg     [31:0] axi_reg_prdata;
reg      [8:0] axi_wdata_line_end;
reg    [255:0] axi_wdata_ram_di;
reg      [8:0] axi_wdata_ram_ra_reg;
reg      [8:0] axi_wdata_ram_wa;
reg            axi_wdata_ram_we;
reg      [8:0] axi_wstrb_line_end;
reg     [31:0] axi_wstrb_ram_di;
reg      [8:0] axi_wstrb_ram_wa;
reg            axi_wstrb_ram_we;
reg     [23:0] reg_cmd_line_ctrl;
reg     [23:0] reg_cmd_num_total;
reg     [31:0] reg_cmd_pend_num;
reg     [31:0] reg_pg_addr_base;
reg     [31:0] reg_pg_addr_low;
reg     [31:0] reg_pg_cmd_ctrl;
reg     [15:0] reg_pg_data_ctrl;
reg     [31:0] reg_pg_wstrb_preset;
reg     [31:0] reg_rdata_line_ctrl;
reg     [26:1] reg_test_ctrl;
reg     [23:0] reg_wcmd_line_ctrl;
reg     [31:0] reg_wdata_line_ctrl;
reg            test_complete;
reg            test_finish_1t;
reg            test_reset_reg;
reg            test_run;
reg     [31:0] test_timer;
reg [31:0] reg_resp_delay_ctrl; // spyglass disable W498
reg [29:0] reg_pg_axi_id; // spyglass disable W498

wire           arcmd_info_update;
wire           awcmd_info_update;
wire    [26:0] axi_arcmd_info;
wire    [26:0] axi_arcmd_info_ram_di;
wire    [26:0] axi_arcmd_info_ram_dout;
wire     [7:0] axi_arcmd_info_ram_ra;
wire           axi_arcmd_info_ram_re;
wire     [7:0] axi_arcmd_info_ram_wa;
wire           axi_arcmd_info_ram_we;
wire     [7:0] axi_arcmd_line;
wire     [7:0] axi_arcmd_line_repeat_end;
wire     [7:0] axi_arcmd_line_start;
wire     [8:0] axi_arcmd_pend_cnt;
wire    [26:0] axi_awcmd_info;
wire    [26:0] axi_awcmd_info_ram_di;
wire    [26:0] axi_awcmd_info_ram_dout;
wire     [7:0] axi_awcmd_info_ram_ra;
wire           axi_awcmd_info_ram_re;
wire     [7:0] axi_awcmd_info_ram_wa;
wire           axi_awcmd_info_ram_we;
wire     [7:0] axi_awcmd_line;
wire     [7:0] axi_awcmd_line_repeat_end;
wire     [7:0] axi_awcmd_line_start;
wire     [8:0] axi_awcmd_pend_cnt;
wire           axi_clk;
wire    [23:0] axi_cmd_error_loc;
wire    [11:0] axi_cmd_line_end;
wire           axi_cmd_line_mismatch;
wire    [11:0] axi_cmd_line_repeat_end;
wire    [11:0] axi_cmd_line_start;
wire     [7:0] axi_cmd_pend_num_max;
wire     [7:0] axi_cmd_pend_num_min;
wire   [127:0] axi_cmd_ram_dout;
wire     [7:0] axi_cmd_ram_ra;
wire           axi_cmd_ram_re;
wire           axi_i_clk;
wire           axi_i_rstn;
wire           axi_rd_req_wait;
wire           axi_rdata_check_en;
wire    [31:0] axi_rdata_cnt_total;
wire   [255:0] axi_rdata_gold;
wire     [8:0] axi_rdata_line;
wire    [15:0] axi_rdata_line_repeat_end;
wire    [15:0] axi_rdata_line_start;
wire   [255:0] axi_rdata_ram_di;
wire   [255:0] axi_rdata_ram_dout;
wire     [8:0] axi_rdata_ram_ra;
wire           axi_rdata_ram_re;
wire           axi_rdata_ram_re_apb;
wire     [8:0] axi_rdata_ram_wa;
wire           axi_rdata_ram_we;
wire           axi_rdata_ram_we_apb;
wire           axi_rdata_sel;
wire           axi_rdata_update;
wire   [127:0] axi_req_cmd;
wire    [23:0] axi_req_cnt;
wire    [26:0] axi_req_info;
wire    [23:0] axi_req_num_total;
wire    [23:0] axi_req_rd_cnt;
wire           axi_req_rd_wr;
wire           axi_req_update;
wire    [31:0] axi_req_wd_cnt;
wire           axi_req_wd_update;
wire   [255:0] axi_req_wdata;
wire    [23:0] axi_req_wr_cnt;
wire    [31:0] axi_req_wstrb;
wire    [23:0] axi_resp_cnt_total;
wire   [255:0] axi_resp_rdata_di;
wire           axi_resp_rdata_we;
wire    [23:0] axi_rresp_cnt_total;
wire           axi_rstn;
wire    [63:0] axi_rstrb_gold;
wire    [63:0] axi_rstrb_ram_dout;
wire    [15:0] axi_wdata_line_repeat_end;
wire    [15:0] axi_wdata_line_start;
wire     [8:0] axi_wdata_phase_cnt_reg;
wire   [255:0] axi_wdata_ram_dout;
wire     [8:0] axi_wdata_ram_ra;
wire           axi_wdata_ram_re;
wire           axi_wstrb_line_mismatch;
wire    [31:0] axi_wstrb_ram_dout;
wire     [8:0] axi_wstrb_ram_ra;
wire           axi_wstrb_ram_re;
wire           last_cmd_issued;
wire    [26:0] pg_axi_arcmd_info;
wire    [26:0] pg_axi_awcmd_info;
wire   [127:0] pg_axi_cmd;
wire   [255:0] pg_axi_rdata;
wire    [63:0] pg_axi_rstrb;
wire   [255:0] pg_axi_wdata;
wire    [31:0] pg_axi_wstrb;
wire           pg_clk;
wire           pg_en;
wire           pg_rstn;
wire           pg_wr_and_rd_back_mode;
wire    [31:0] reg_cmd_line_ctrl_i;
wire    [31:0] reg_cmd_num_total_i;
wire    [31:0] reg_cmd_pend_num_i;
wire    [31:0] reg_outstand_status_i;
wire    [31:0] reg_pg_addr_base_i;
wire    [31:0] reg_pg_addr_low_i;
wire    [31:0] reg_pg_axi_id_i;
wire    [31:0] reg_pg_cmd_ctrl_i;
wire    [31:0] reg_pg_data_ctrl_i;
wire    [31:0] reg_pg_wstrb_preset_i;
wire    [31:0] reg_rdata_cnt_i;
wire    [31:0] reg_rdata_line_ctrl_i;
wire    [31:0] reg_req_cnt_i;
wire    [31:0] reg_req_wd_cnt_i;
wire    [31:0] reg_req_wr_cnt_i;
wire    [31:0] reg_resp_cnt_i;
wire    [31:0] reg_resp_delay_ctrl_i;
wire    [31:0] reg_rresp_cnt_i;
wire    [31:0] reg_test_ctrl_i;
wire    [31:0] reg_test_err_loc_i;
wire    [31:0] reg_test_status_i;
wire    [31:0] reg_wcmd_line_ctrl_i;
wire    [31:0] reg_wdata_line_ctrl_i;
wire           repeat_mode;
wire           rstn;
wire           status_clear;
wire           test_cmd_issuing;
wire    [12:0] test_error_out;
wire           test_finish;
wire           test_reset;
wire           test_run_i;



// Power Controls can be tied off to 0

// delay test_run by 1 cycle, in case the test mode and test_run are set at the same time
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    test_run <= 1'b0;
  end else begin
    test_run <= test_run_i;
  end
end
assign status_clear = (~test_run & test_run_i) | (test_run & ~test_run_i); // 1T high pulse to clear all test status, but not clear test configuration. 

/////////////////////////////////////////////////////////////////////////
// axi_cmd_ram
/////////////////////////////////////////////////////////////////////////

// write data concentration
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_cmd_ram_di[31:0] <= {32{1'b0}};
    axi_cmd_ram_di[63:32] <= {32{1'b0}};
    axi_cmd_ram_di[95:64] <= {32{1'b0}};
    axi_cmd_ram_di[127:96] <= {32{1'b0}};
  end else begin
    if(apb_wr_op & axi_cmd_ram_sel)
      case (axi_paddr[3:2])     // spyglass disable W71
      2'b00: axi_cmd_ram_di[31:0]   <= axi_pwdata;
      2'b01: axi_cmd_ram_di[63:32]  <= axi_pwdata;
      2'b10: axi_cmd_ram_di[95:64]  <= axi_pwdata;
      2'b11: axi_cmd_ram_di[127:96] <= axi_pwdata;
      endcase
  end
end

// write control
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_cmd_ram_wa <= {8{1'b0}};
    axi_cmd_ram_we <= 1'b0;
  end else begin
    axi_cmd_ram_wa <= axi_paddr>>NV_FPGA_UNIT_MEM_DUT_AXI_CMD_PADDR_SHIFT; // spyglass disable W164a W486
    if(apb_wr_op & axi_cmd_ram_sel & (axi_paddr[3:2] == 2'b11)) 
      axi_cmd_ram_we <= 1'b1;
    else 
      axi_cmd_ram_we <= 1'b0;
  end
end

// read control
assign axi_cmd_ram_re = 1'b1; 
assign axi_cmd_ram_ra = ~test_run_i ? (axi_paddr>>NV_FPGA_UNIT_MEM_DUT_AXI_CMD_PADDR_SHIFT) // spyglass disable W164a W362 W486
                                    : ~test_run ? axi_cmd_line_start
                                                : ~axi_req_update ? axi_cmd_ram_ra_reg
                                                                  : ~repeat_mode ? ((axi_cmd_ram_ra_reg > axi_cmd_line_end) ? 0 : (axi_cmd_ram_ra_reg+1'b1))
                                                                                 : ((axi_cmd_ram_ra_reg > axi_cmd_line_repeat_end) ? axi_cmd_line_start : (axi_cmd_ram_ra_reg+1'b1));

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_cmd_ram_ra_reg <= {8{1'b0}};
  end else begin
    axi_cmd_ram_ra_reg <= axi_cmd_ram_ra;
  end
end

nv_ram_rws_256x128 axi_cmd_ram (
   .clk                     (axi_i_clk)                     //|< w
  ,.ra                      (axi_cmd_ram_ra[7:0])           //|< w
  ,.re                      (axi_cmd_ram_re)                //|< w
  ,.dout                    (axi_cmd_ram_dout[127:0])       //|> w
  ,.wa                      (axi_cmd_ram_wa[7:0])           //|< r
  ,.we                      (axi_cmd_ram_we)                //|< r
  ,.di                      (axi_cmd_ram_di[127:0])         //|< r
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

/////////////////////////////////////////////////////////////////////////
// axi_cmd_info_ram used for response check
/////////////////////////////////////////////////////////////////////////

//signal    info_ram    cmd_ram
//axi_id    [13:0]      [13:0]
//axi_len   [21:14]     [79:72]
//axi_burst [23:22]     [107:106]
//axi_size  [26:24]     [110:108]

assign axi_req_rd_wr = axi_cmd_ram_di[15];
assign axi_req_info = {axi_cmd_ram_di[110:108], axi_cmd_ram_di[107:106], axi_cmd_ram_di[79:72], axi_cmd_ram_di[13:0]};

// arcmd_info_ram

assign axi_arcmd_info_ram_di = axi_req_rd_wr ? axi_req_info : 0;
assign axi_arcmd_info_ram_wa = axi_req_rd_wr ? axi_cmd_ram_wa : 0;
assign axi_arcmd_info_ram_we = axi_req_rd_wr & axi_cmd_ram_we; 
assign axi_arcmd_info_ram_re = 1'b1;
assign axi_arcmd_info_ram_ra = axi_arcmd_line;
assign axi_arcmd_line = ~test_run ? axi_arcmd_line_start
                                  : ~arcmd_info_update ? axi_arcmd_line_reg
                                                      : ~repeat_mode ? ((axi_arcmd_line_reg > axi_arcmd_line_end) ? 0 : (axi_arcmd_line_reg+1'b1))
                                                                     : ((axi_arcmd_line_reg > axi_arcmd_line_repeat_end) ? axi_arcmd_line_start : (axi_arcmd_line_reg+1'b1));

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_arcmd_line_reg <= {8{1'b0}};
    axi_arcmd_line_end <= {8{1'b0}};
  end else begin
    axi_arcmd_line_reg <= axi_arcmd_line;
    if(axi_arcmd_info_ram_wa > axi_arcmd_line_end)
      axi_arcmd_line_end <= axi_arcmd_info_ram_wa;
  end
end

nv_ram_rws_256x27 axi_arcmd_info_ram (
   .clk                     (axi_i_clk)                     //|< w
  ,.ra                      (axi_arcmd_info_ram_ra[7:0])    //|< w
  ,.re                      (axi_arcmd_info_ram_re)         //|< w
  ,.dout                    (axi_arcmd_info_ram_dout[26:0]) //|> w
  ,.wa                      (axi_arcmd_info_ram_wa[7:0])    //|< w
  ,.we                      (axi_arcmd_info_ram_we)         //|< w
  ,.di                      (axi_arcmd_info_ram_di[26:0])   //|< w
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

// awcmd_info_ram

assign axi_awcmd_info_ram_di = ~axi_req_rd_wr ? axi_req_info : 0;
assign axi_awcmd_info_ram_wa = ~axi_req_rd_wr ? axi_cmd_ram_wa : 0;
assign axi_awcmd_info_ram_we = ~axi_req_rd_wr & axi_cmd_ram_we; 
assign axi_awcmd_info_ram_re = 1'b1;
assign axi_awcmd_info_ram_ra = axi_awcmd_line;
assign axi_awcmd_line = ~test_run ? axi_awcmd_line_start
                                  : ~awcmd_info_update ? axi_awcmd_line_reg
                                                      : ~repeat_mode ? ((axi_awcmd_line_reg > axi_awcmd_line_end) ? 0 : (axi_awcmd_line_reg+1'b1))
                                                                     : ((axi_awcmd_line_reg > axi_awcmd_line_repeat_end) ? axi_awcmd_line_start : (axi_awcmd_line_reg+1'b1));

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_awcmd_line_reg <= {8{1'b0}};
    axi_awcmd_line_end <= {8{1'b0}};
  end else begin
    axi_awcmd_line_reg <= axi_arcmd_line;
    if(axi_awcmd_info_ram_wa > axi_awcmd_line_end)
      axi_awcmd_line_end <= axi_awcmd_info_ram_wa;
  end
end

nv_ram_rws_256x27 axi_awcmd_info_ram (
   .clk                     (axi_i_clk)                     //|< w
  ,.ra                      (axi_awcmd_info_ram_ra[7:0])    //|< w
  ,.re                      (axi_awcmd_info_ram_re)         //|< w
  ,.dout                    (axi_awcmd_info_ram_dout[26:0]) //|> w
  ,.wa                      (axi_awcmd_info_ram_wa[7:0])    //|< w
  ,.we                      (axi_awcmd_info_ram_we)         //|< w
  ,.di                      (axi_awcmd_info_ram_di[26:0])   //|< w
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

/////////////////////////////////////////////////////////////////////////
// axi_wdata_ram
/////////////////////////////////////////////////////////////////////////

// data concentration
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wdata_ram_di[31:0] <= {32{1'b0}};
    axi_wdata_ram_di[63:32] <= {32{1'b0}};
    axi_wdata_ram_di[95:64] <= {32{1'b0}};
    axi_wdata_ram_di[127:96] <= {32{1'b0}};
    axi_wdata_ram_di[159:128] <= {32{1'b0}};
    axi_wdata_ram_di[191:160] <= {32{1'b0}};
    axi_wdata_ram_di[223:192] <= {32{1'b0}};
    axi_wdata_ram_di[255:224] <= {32{1'b0}};
  end else begin
    if(apb_wr_op & axi_wdata_ram_sel)
      case (axi_paddr[4:2])  // spyglass disable W71
      0: axi_wdata_ram_di[31:0] <= axi_pwdata;
      1: axi_wdata_ram_di[63:32] <= axi_pwdata;
      2: axi_wdata_ram_di[95:64] <= axi_pwdata;
      3: axi_wdata_ram_di[127:96] <= axi_pwdata;
      4: axi_wdata_ram_di[159:128] <= axi_pwdata;
      5: axi_wdata_ram_di[191:160] <= axi_pwdata;
      6: axi_wdata_ram_di[223:192] <= axi_pwdata;
      7: axi_wdata_ram_di[255:224] <= axi_pwdata;
      endcase
  end
end

// write control
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wdata_ram_wa <= {9{1'b0}};
    axi_wdata_ram_we <= 1'b0;
  end else begin
    axi_wdata_ram_wa <= axi_paddr[19:5]; // spyglass disable W164a
    if(apb_wr_op & axi_wdata_ram_sel & (axi_paddr[4:2] == 7)) 
      axi_wdata_ram_we <= 1'b1;
    else 
      axi_wdata_ram_we <= 1'b0;
  end
end

// read control
assign axi_wdata_ram_re = 1'b1;
assign axi_wdata_ram_ra = ~test_run_i ? (axi_paddr>>NV_FPGA_UNIT_MEM_DUT_AXI_DATA_PADDR_SHIFT) // spyglass disable W164a W362 W486
                                      : ~test_run ? axi_wdata_line_start
                                                  : ~axi_req_wd_update ? axi_wdata_ram_ra_reg
                                                                       : ~repeat_mode ? ((axi_wdata_ram_ra_reg > axi_wdata_line_end) ? 0 : (axi_wdata_ram_ra_reg+1'b1))
                                                                                      : ((axi_wdata_ram_ra_reg > axi_wdata_line_repeat_end) ? axi_wdata_line_start : (axi_wdata_ram_ra_reg+1'b1));

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wdata_ram_ra_reg <= {9{1'b0}};
    axi_wdata_line_end <= {9{1'b0}};
  end else begin
    axi_wdata_ram_ra_reg <= axi_wdata_ram_ra;
    if(axi_wdata_line_end < axi_wdata_ram_wa)
      axi_wdata_line_end <= axi_wdata_ram_wa;
  end
end

nv_ram_rws_512x256 axi_wdata_ram (
   .clk                     (axi_i_clk)                     //|< w
  ,.ra                      (axi_wdata_ram_ra[8:0])         //|< w
  ,.re                      (axi_wdata_ram_re)              //|< w
  ,.dout                    (axi_wdata_ram_dout[255:0])     //|> w
  ,.wa                      (axi_wdata_ram_wa[8:0])         //|< r
  ,.we                      (axi_wdata_ram_we)              //|< r
  ,.di                      (axi_wdata_ram_di[255:0])       //|< r
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

/////////////////////////////////////////////////////////////////////////
// axi_wstrb_ram 
/////////////////////////////////////////////////////////////////////////

// data concentration
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wstrb_ram_di[31:0] <= {32{1'b0}};
  end else begin
    if(apb_wr_op & axi_wstrb_ram_sel)
      axi_wstrb_ram_di[31:0]   <= axi_pwdata; // spyglass disable W164a
  end
end

// write control
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wstrb_ram_wa <= {9{1'b0}};
    axi_wstrb_ram_we <= 1'b0;
  end else begin
    axi_wstrb_ram_wa <= axi_paddr[19:2]; // spyglass disable W164a
    if(apb_wr_op & axi_wstrb_ram_sel) 
      axi_wstrb_ram_we <= 1'b1;
    else 
      axi_wstrb_ram_we <= 1'b0;
  end
end

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_wstrb_line_end <= {9{1'b0}};
  end else begin
    if(axi_wstrb_ram_wa > axi_wstrb_line_end)
      axi_wstrb_line_end <= axi_wstrb_ram_wa;
  end
end

// read control
assign axi_wstrb_ram_re = 1'b1;
assign axi_wstrb_ram_ra = ~test_run_i ? (axi_paddr>>NV_FPGA_UNIT_MEM_DUT_AXI_WE_PADDR_SHIFT) : axi_wdata_ram_ra; // spyglass disable W164a W486

nv_ram_rws_512x32 axi_wstrb_ram (
   .clk                     (axi_i_clk)                     //|< w
  ,.ra                      (axi_wstrb_ram_ra[8:0])         //|< w
  ,.re                      (axi_wstrb_ram_re)              //|< w
  ,.dout                    (axi_wstrb_ram_dout[31:0])      //|> w
  ,.wa                      (axi_wstrb_ram_wa[8:0])         //|< r
  ,.we                      (axi_wstrb_ram_we)              //|< r
  ,.di                      (axi_wstrb_ram_di[31:0])        //|< r
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

/////////////////////////////////////////////////////////////////////////
// axi_rdata_ram
/////////////////////////////////////////////////////////////////////////

// data concentration
always @(posedge axi_i_clk or negedge axi_i_rstn) begin
  if (!axi_i_rstn) begin
    axi_rdata_ram_di_i[31:0] <= {32{1'b0}};
    axi_rdata_ram_di_i[63:32] <= {32{1'b0}};
    axi_rdata_ram_di_i[95:64] <= {32{1'b0}};
    axi_rdata_ram_di_i[127:96] <= {32{1'b0}};
    axi_rdata_ram_di_i[159:128] <= {32{1'b0}};
    axi_rdata_ram_di_i[191:160] <= {32{1'b0}};
    axi_rdata_ram_di_i[223:192] <= {32{1'b0}};
    axi_rdata_ram_di_i[255:224] <= {32{1'b0}};
  end else begin
  if(apb_wr_op & axi_rdata_ram_sel)
      case (axi_paddr[4:2])  // spyglass disable W71
      0: axi_rdata_ram_di_i[31:0] <= axi_pwdata;
      1: axi_rdata_ram_di_i[63:32] <= axi_pwdata;
      2: axi_rdata_ram_di_i[95:64] <= axi_pwdata;
      3: axi_rdata_ram_di_i[127:96] <= axi_pwdata;
      4: axi_rdata_ram_di_i[159:128] <= axi_pwdata;
      5: axi_rdata_ram_di_i[191:160] <= axi_pwdata;
      6: axi_rdata_ram_di_i[223:192] <= axi_pwdata;
      7: axi_rdata_ram_di_i[255:224] <= axi_pwdata;
    endcase
  end
end

// write control
always @(posedge axi_i_clk or negedge axi_i_rstn) begin
  if (!axi_i_rstn) begin
    axi_rdata_ram_wa_i <= {9{1'b0}};
    axi_rdata_ram_we_i <= 1'b0;
  end else begin
    axi_rdata_ram_wa_i <= axi_paddr[19:5]; // spyglass disable W164a
    if(apb_wr_op & axi_rdata_ram_sel & (axi_paddr[4:2] == 7)) 
      axi_rdata_ram_we_i <= 1'b1;
    else 
      axi_rdata_ram_we_i <= 1'b0;
  end
end

// write source select
assign axi_rdata_ram_we_apb = (~test_run_i | test_finish | axi_rdata_check_en); // 1) not start issue cmd; 2) received all response; 3) rdata self check mode.
assign axi_rdata_ram_we = axi_rdata_ram_we_apb ? axi_rdata_ram_we_i : axi_resp_rdata_we;
assign axi_rdata_ram_di = axi_rdata_ram_we_apb ? axi_rdata_ram_di_i : axi_resp_rdata_di;
assign axi_rdata_ram_wa = axi_rdata_ram_we_apb ? axi_rdata_ram_wa_i : axi_rdata_line;
assign axi_rdata_line = ~test_run ? axi_rdata_line_start // spyglass disable W164a W362
                                   : ~axi_rdata_update ? axi_rdata_line_reg
                                                       : ~repeat_mode ? ((axi_rdata_line_reg > axi_rdata_line_end) ? 0 : (axi_rdata_line_reg+1'b1))
                                                                      : ((axi_rdata_line_reg > axi_rdata_line_repeat_end) ? axi_rdata_line_start : (axi_rdata_line_reg+1'b1));

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    axi_rdata_line_reg <= {9{1'b0}};
    axi_rdata_line_end <= {9{1'b0}};
  end else begin
    axi_rdata_line_reg <= axi_rdata_line;
    if(axi_rdata_ram_wa > axi_rdata_line_end)
      axi_rdata_line_end <= axi_rdata_ram_wa;
  end
end

// read control
assign axi_rdata_ram_re_apb = (~test_run_i | test_finish | ~axi_rdata_check_en);
assign axi_rdata_ram_ra = axi_rdata_ram_re_apb ? axi_paddr>>NV_FPGA_UNIT_MEM_DUT_AXI_DATA_PADDR_SHIFT : axi_rdata_line; // spyglass disable W164a W486
assign axi_rdata_ram_re = 1'b1;

nv_ram_rws_512x256 axi_rdata_ram (
   .clk                     (apb_clk)                       //|< i
  ,.ra                      (axi_rdata_ram_ra[8:0])         //|< w
  ,.re                      (axi_rdata_ram_re)              //|< w
  ,.dout                    (axi_rdata_ram_dout[255:0])     //|> w
  ,.wa                      (axi_rdata_ram_wa[8:0])         //|< w
  ,.we                      (axi_rdata_ram_we)              //|< w
  ,.di                      (axi_rdata_ram_di[255:0])       //|< w
  ,.pwrbus_ram_pd           ({32{1'b0}})                    //|< ?
  );

/////////////////////////////////////////////////////////////////////////
// read ram data through APB bus
/////////////////////////////////////////////////////////////////////////

always @(
  axi_reg_sel
  or axi_reg_prdata
  or axi_cmd_ram_sel
  or axi_paddr
  or axi_cmd_ram_dout
  or axi_wstrb_ram_sel
  or axi_wstrb_ram_dout
  or axi_wdata_ram_sel
  or axi_wdata_ram_dout
  or axi_rdata_ram_sel
  or axi_rdata_ram_dout
  ) begin
    if(axi_reg_sel)
      axi_prdata = axi_reg_prdata;
    else if(axi_cmd_ram_sel)
      case (axi_paddr[3:2]) 
      2'b00: axi_prdata = axi_cmd_ram_dout[31:0]   ;
      2'b01: axi_prdata = axi_cmd_ram_dout[63:32]  ;
      2'b10: axi_prdata = axi_cmd_ram_dout[95:64]  ;
      2'b11: axi_prdata = axi_cmd_ram_dout[127:96] ;
      default: axi_prdata = 32'b0;
      endcase
    else if(axi_wstrb_ram_sel)
      axi_prdata   = axi_wstrb_ram_dout; // spyglass disable W164b
    else if(axi_wdata_ram_sel)
      case (axi_paddr[4:2])
      0: axi_prdata = axi_wdata_ram_dout[31:0]; // spyglass disable W164b
      1: axi_prdata = axi_wdata_ram_dout[63:32]; // spyglass disable W164b
      2: axi_prdata = axi_wdata_ram_dout[95:64]; // spyglass disable W164b
      3: axi_prdata = axi_wdata_ram_dout[127:96]; // spyglass disable W164b
      4: axi_prdata = axi_wdata_ram_dout[159:128]; // spyglass disable W164b
      5: axi_prdata = axi_wdata_ram_dout[191:160]; // spyglass disable W164b
      6: axi_prdata = axi_wdata_ram_dout[223:192]; // spyglass disable W164b
      7: axi_prdata = axi_wdata_ram_dout[255:224]; // spyglass disable W164b
      default: axi_prdata = 32'b0;
      endcase
    else if(axi_rdata_ram_sel)
      case (axi_paddr[4:2])
      0: axi_prdata = axi_rdata_ram_dout[31:0];
      1: axi_prdata = axi_rdata_ram_dout[63:32];
      2: axi_prdata = axi_rdata_ram_dout[95:64];
      3: axi_prdata = axi_rdata_ram_dout[127:96];
      4: axi_prdata = axi_rdata_ram_dout[159:128];
      5: axi_prdata = axi_rdata_ram_dout[191:160];
      6: axi_prdata = axi_rdata_ram_dout[223:192];
      7: axi_prdata = axi_rdata_ram_dout[255:224];
      default: axi_prdata = 32'b0;
      endcase
    else
      axi_prdata = 32'b0;
end

//&Always;
//  case(1'b1)
//  axi_reg_sel       : axi_prdata = axi_reg_prdata;
//  axi_cmd_ram_sel   : axi_prdata = axi_cmd_ram_prdata;
//  axi_wstrb_ram_sel    : axi_prdata = axi_wstrb_ram_prdata;
//  axi_wdata_ram_sel : axi_prdata = axi_wdata_ram_prdata;
//  axi_rdata_ram_sel : axi_prdata = axi_rdata_ram_prdata;
//  default: axi_prdata = 0;
//  endcase
//&End;
//

/////////////////////////////////////////////////////////////////////////////
// sub module instances and port connection
/////////////////////////////////////////////////////////////////////////////

NV_FPGA_unit_checkbox_mem_dut_axi_req_256 axi_req (
   .axi_clk                 (axi_clk)                       //|< w
  ,.axi_rstn                (axi_rstn)                      //|< w
  ,.axi_arcmd_pend_cnt      (axi_arcmd_pend_cnt[8:0])       //|< w
  ,.axi_arready             (axi_arready)                   //|< i
  ,.axi_awcmd_pend_cnt      (axi_awcmd_pend_cnt[8:0])       //|< w
  ,.axi_awready             (axi_awready)                   //|< i
  ,.axi_cmd_pend_num_max    (axi_cmd_pend_num_max[7:0])     //|< w
  ,.axi_rd_req_wait         (axi_rd_req_wait)               //|< w
  ,.axi_req_cmd             (axi_req_cmd[127:0])            //|< w
  ,.axi_req_wdata           (axi_req_wdata[255:0])          //|< w
  ,.axi_req_wstrb           (axi_req_wstrb[31:0])           //|< w
  ,.axi_wready              (axi_wready)                    //|< i
  ,.status_clear            (status_clear)                  //|< w
  ,.test_cmd_issuing        (test_cmd_issuing)              //|< w
  ,.axi_araddr              (axi_araddr[39:0])              //|> o
  ,.axi_arburst             (axi_arburst[1:0])              //|> o
  ,.axi_arcache             (axi_arcache[3:0])              //|> o
  ,.axi_arid                (axi_arid[13:0])                //|> o
  ,.axi_arlen               (axi_arlen[7:0])                //|> o
  ,.axi_arlock              (axi_arlock[1:0])               //|> o
  ,.axi_arprot              (axi_arprot[2:0])               //|> o
  ,.axi_arqos               (axi_arqos[3:0])                //|> o
  ,.axi_arregion            (axi_arregion[3:0])             //|> o
  ,.axi_arsize              (axi_arsize[2:0])               //|> o
  ,.axi_aruser              (axi_aruser[25:0])              //|> o
  ,.axi_arvalid             (axi_arvalid)                   //|> o
  ,.axi_awaddr              (axi_awaddr[39:0])              //|> o
  ,.axi_awburst             (axi_awburst[1:0])              //|> o
  ,.axi_awcache             (axi_awcache[3:0])              //|> o
  ,.axi_awid                (axi_awid[13:0])                //|> o
  ,.axi_awlen               (axi_awlen[7:0])                //|> o
  ,.axi_awlock              (axi_awlock[1:0])               //|> o
  ,.axi_awprot              (axi_awprot[2:0])               //|> o
  ,.axi_awqos               (axi_awqos[3:0])                //|> o
  ,.axi_awregion            (axi_awregion[3:0])             //|> o
  ,.axi_awsize              (axi_awsize[2:0])               //|> o
  ,.axi_awuser              (axi_awuser[25:0])              //|> o
  ,.axi_awvalid             (axi_awvalid)                   //|> o
  ,.axi_req_cnt             (axi_req_cnt[23:0])             //|> w
  ,.axi_req_rd_cnt          (axi_req_rd_cnt[23:0])          //|> w
  ,.axi_req_update          (axi_req_update)                //|> w
  ,.axi_req_wd_cnt          (axi_req_wd_cnt[31:0])          //|> w
  ,.axi_req_wd_update       (axi_req_wd_update)             //|> w
  ,.axi_req_wr_cnt          (axi_req_wr_cnt[23:0])          //|> w
  ,.axi_wdata               (axi_wdata[255:0])              //|> o
  ,.axi_wdata_phase_cnt_reg (axi_wdata_phase_cnt_reg[8:0])  //|> w
  ,.axi_wlast               (axi_wlast)                     //|> o
  ,.axi_wstrb               (axi_wstrb[31:0])               //|> o
  ,.axi_wvalid              (axi_wvalid)                    //|> o
  );
NV_FPGA_unit_checkbox_mem_dut_axi_req_gen_256 axi_req_gen (
   .pg_clk                  (pg_clk)                        //|< w
  ,.pg_rstn                 (pg_rstn)                       //|< w
  ,.arcmd_info_update       (arcmd_info_update)             //|< w
  ,.awcmd_info_update       (awcmd_info_update)             //|< w
  ,.axi_rdata_cnt_total     (axi_rdata_cnt_total[31:0])     //|< w
  ,.axi_req_update          (axi_req_update)                //|< w
  ,.axi_req_wd_cnt          (axi_req_wd_cnt[15:0])          //|< w
  ,.axi_wdata_phase_cnt_reg (axi_wdata_phase_cnt_reg[8:0])  //|< w
  ,.reg_pg_addr_base        (reg_pg_addr_base[31:0])        //|< r
  ,.reg_pg_addr_low         (reg_pg_addr_low[31:0])         //|< r
  ,.reg_pg_axi_id           (reg_pg_axi_id[29:0])           //|< r
  ,.reg_pg_cmd_ctrl         (reg_pg_cmd_ctrl[31:0])         //|< r
  ,.reg_pg_data_ctrl        (reg_pg_data_ctrl[15:0])        //|< r
  ,.reg_pg_wstrb_preset     (reg_pg_wstrb_preset[31:0])     //|< r
  ,.status_clear            (status_clear)                  //|< w
  ,.pg_axi_arcmd_info       (pg_axi_arcmd_info[26:0])       //|> w
  ,.pg_axi_awcmd_info       (pg_axi_awcmd_info[26:0])       //|> w
  ,.pg_axi_cmd              (pg_axi_cmd[127:0])             //|> w
  ,.pg_axi_rdata            (pg_axi_rdata[255:0])           //|> w
  ,.pg_axi_rstrb            (pg_axi_rstrb[63:0])            //|> w
  ,.pg_axi_wdata            (pg_axi_wdata[255:0])           //|> w
  ,.pg_axi_wstrb            (pg_axi_wstrb[31:0])            //|> w
  ,.pg_wr_and_rd_back_mode  (pg_wr_and_rd_back_mode)        //|> w
  ,.reg_pg_addr_base_i      (reg_pg_addr_base_i[31:0])      //|> w
  ,.reg_pg_addr_low_i       (reg_pg_addr_low_i[31:0])       //|> w
  ,.reg_pg_axi_id_i         (reg_pg_axi_id_i[31:0])         //|> w
  ,.reg_pg_cmd_ctrl_i       (reg_pg_cmd_ctrl_i[31:0])       //|> w
  ,.reg_pg_data_ctrl_i      (reg_pg_data_ctrl_i[31:0])      //|> w
  ,.reg_pg_wstrb_preset_i   (reg_pg_wstrb_preset_i[31:0])   //|> w
  );
NV_FPGA_unit_checkbox_mem_dut_axi_resp_256 axi_resp (
   .axi_clk                 (axi_clk)                       //|< w
  ,.axi_rstn                (axi_rstn)                      //|< w
  ,.axi_arcmd_info          (axi_arcmd_info[26:0])          //|< w
  ,.axi_awcmd_info          (axi_awcmd_info[13:0])          //|< w
  ,.axi_bid                 (axi_bid[13:0])                 //|< i
  ,.axi_bresp               (axi_bresp[1:0])                //|< i
  ,.axi_bvalid              (axi_bvalid)                    //|< i
  ,.axi_cmd_pend_num_min    (axi_cmd_pend_num_min[7:0])     //|< w
  ,.axi_rdata               (axi_rdata[255:0])              //|< i
  ,.axi_rdata_check_en      (axi_rdata_check_en)            //|< w
  ,.axi_rdata_gold          (axi_rdata_gold[255:0])         //|< w
  ,.axi_req_rd_cnt          (axi_req_rd_cnt[23:0])          //|< w
  ,.axi_req_wr_cnt          (axi_req_wr_cnt[23:0])          //|< w
  ,.axi_rid                 (axi_rid[13:0])                 //|< i
  ,.axi_rlast               (axi_rlast)                     //|< i
  ,.axi_rresp               (axi_rresp[1:0])                //|< i
  ,.axi_rstrb_gold          (axi_rstrb_gold[31:0])          //|< w
  ,.axi_rvalid              (axi_rvalid)                    //|< i
  ,.reg_resp_delay_ctrl     (reg_resp_delay_ctrl[25:0])     //|< r
  ,.status_clear            (status_clear)                  //|< w
  ,.arcmd_info_update       (arcmd_info_update)             //|> w
  ,.awcmd_info_update       (awcmd_info_update)             //|> w
  ,.axi_arcmd_pend_cnt      (axi_arcmd_pend_cnt[8:0])       //|> w
  ,.axi_awcmd_pend_cnt      (axi_awcmd_pend_cnt[8:0])       //|> w
  ,.axi_bready              (axi_bready)                    //|> o
  ,.axi_cmd_error_loc       (axi_cmd_error_loc[23:0])       //|> w
  ,.axi_rdata_cnt_total     (axi_rdata_cnt_total[31:0])     //|> w
  ,.axi_rdata_update        (axi_rdata_update)              //|> w
  ,.axi_resp_cnt_total      (axi_resp_cnt_total[23:0])      //|> w
  ,.axi_resp_rdata_di       (axi_resp_rdata_di[255:0])      //|> w
  ,.axi_resp_rdata_we       (axi_resp_rdata_we)             //|> w
  ,.axi_rready              (axi_rready)                    //|> o
  ,.axi_rresp_cnt_total     (axi_rresp_cnt_total[23:0])     //|> w
  ,.reg_resp_delay_ctrl_i   (reg_resp_delay_ctrl_i[31:0])   //|> w
  ,.test_error_out          (test_error_out[12:0])          //|> w
  );

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    test_reset_reg <= 1'b0;
  end else begin
  test_reset_reg <= test_reset;
  end
end

assign rstn = apb_rstn & ~test_reset_reg;

assign axi_i_clk = apb_clk;
assign axi_i_rstn = rstn;

assign axi_clk = apb_clk;
assign axi_rstn = rstn;

assign pg_clk = apb_clk;
assign pg_rstn = rstn;

// select axi request from pattern gen or ram output
assign axi_req_cmd   = pg_en ? pg_axi_cmd   : axi_cmd_ram_dout;
assign axi_req_wdata = pg_en ? pg_axi_wdata : axi_wdata_ram_dout;
assign axi_req_wstrb = pg_en ? pg_axi_wstrb : axi_wstrb_ram_dout;

// select axi response rdata golden from pg or axi_rdata_ram.
assign axi_rdata_gold = axi_rdata_sel ? axi_rdata_ram_dout : pg_axi_rdata;
assign axi_rstrb_gold = axi_rdata_sel ? axi_rstrb_ram_dout : pg_axi_rstrb;
assign axi_rstrb_ram_dout = {2{32'hFFFF_FFFF}};

// select axi request info from pattern gen or info ram output. those info are used for response check.
assign axi_arcmd_info = pg_en ? pg_axi_arcmd_info : axi_arcmd_info_ram_dout;
assign axi_awcmd_info = pg_en ? pg_axi_awcmd_info : axi_awcmd_info_ram_dout;

assign last_cmd_issued = (axi_req_cnt == axi_req_num_total);
assign test_cmd_issuing = test_run & !last_cmd_issued;

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_rd_req_wait_reg <= 1'b0;
  end else begin
  axi_rd_req_wait_reg <= axi_rd_req_wait;
  end
end

assign axi_rd_req_wait = ~(pg_en & pg_wr_and_rd_back_mode) ? 1'b0 
                                                           : axi_awvalid & axi_awready ? 1'b1
                                                                                       : axi_bvalid & axi_bready ? 1'b0 : axi_rd_req_wait_reg;

// test status
assign test_finish = (axi_req_num_total == axi_resp_cnt_total);
assign axi_cmd_line_mismatch = test_run & ~pg_en & (axi_cmd_line_end != (axi_arcmd_line_end + axi_awcmd_line_end + 1)); // spyglass disable W362
assign axi_wstrb_line_mismatch = test_run & ~pg_en & (axi_wstrb_line_end != axi_wdata_line_end);

//// axi outstanding control
//&Vector 10 axi_arcmd_pend_cnt;
//&Vector 10 axi_awcmd_pend_cnt;
//&Always posedge;
//  if((axi_arvalid & axi_arready) & ~(axi_rvalid & axi_rready & axi_rlast))
//    axi_arcmd_pend_cnt <0= axi_arcmd_pend_cnt + 1'b1;
//  else if(~(axi_arvalid & axi_arready) & (axi_rvalid & axi_rready & axi_rlast))
//    axi_arcmd_pend_cnt <= axi_arcmd_pend_cnt - 1'b1;
//&End;
//
//&Always posedge;
//  if((axi_awvalid & axi_awready) & ~(axi_bvalid & axi_bready))
//    axi_awcmd_pend_cnt <0= axi_awcmd_pend_cnt + 1'b1;
//  else if(~(axi_awvalid & axi_awready) & (axi_bvalid & axi_bready))
//    axi_awcmd_pend_cnt <= axi_awcmd_pend_cnt - 1'b1;
//&End;

// test timer
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    test_timer <= {32{1'b0}};
  end else begin
    if(status_clear)
      test_timer <= 32'b0;
    else if(~test_finish)
      test_timer <= test_timer + 1;
  end
end
  
// finish interrupt
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    test_finish_1t <= 1'b0;
    test_complete <= 1'b0;
  end else begin
    test_finish_1t <= test_finish;
    if(test_finish & ~test_finish_1t & (|axi_resp_cnt_total))
      test_complete <= 1'b1;
    if(test_complete)
      test_complete <= 1'b0;
  end
end

/////////////////////////////////////////////////////////////////////////////
// apb registers 
/////////////////////////////////////////////////////////////////////////////

`define NV_FPGA_UNIT_MEM_DUT_REG_TEST_CTRL           16'h0000
`define NV_FPGA_UNIT_MEM_DUT_REG_CMD_NUM_TOTAL       16'h0004
`define NV_FPGA_UNIT_MEM_DUT_REG_CMD_LINE_CTRL       16'h0008
`define NV_FPGA_UNIT_MEM_DUT_REG_WDATA_LINE_CTRL     16'h000C
`define NV_FPGA_UNIT_MEM_DUT_REG_WCMD_LINE_CTRL      16'h0010
`define NV_FPGA_UNIT_MEM_DUT_REG_RDATA_LINE_CTRL     16'h0014
`define NV_FPGA_UNIT_MEM_DUT_REG_RESP_DELAY_CTRL     16'h0018
`define NV_FPGA_UNIT_MEM_DUT_REG_CMD_PEND_NUM        16'h001C

`define NV_FPGA_UNIT_MEM_DUT_REG_PG_CMD_CTRL         16'h0020
`define NV_FPGA_UNIT_MEM_DUT_REG_PG_AXI_ID           16'h0024
`define NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_BASE        16'h0028
`define NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_LOW         16'h002C
`define NV_FPGA_UNIT_MEM_DUT_REG_PG_DATA_CTRL        16'h0030
`define NV_FPGA_UNIT_MEM_DUT_REG_PG_WSTRB            16'h0034

`define NV_FPGA_UNIT_MEM_DUT_REG_OUTSTAND_STATUS     16'h0040
`define NV_FPGA_UNIT_MEM_DUT_REG_TEST_STATUS         16'h0044
`define NV_FPGA_UNIT_MEM_DUT_REG_TEST_ERR_LOC        16'h0048
`define NV_FPGA_UNIT_MEM_DUT_REG_RESP_CNT            16'h004C
`define NV_FPGA_UNIT_MEM_DUT_REG_RRESP_CNT           16'h0050
`define NV_FPGA_UNIT_MEM_DUT_REG_RDATA_CNT           16'h0054
`define NV_FPGA_UNIT_MEM_DUT_REG_REQ_CNT             16'h0058
`define NV_FPGA_UNIT_MEM_DUT_REG_REQ_WR_CNT          16'h005C
`define NV_FPGA_UNIT_MEM_DUT_REG_REQ_WD_CNT          16'h0060
`define NV_FPGA_UNIT_MEM_DUT_REG_TEST_TIMER          16'h0064

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    reg_test_ctrl[26:1] <= {26{1'b0}};
    reg_cmd_num_total <= {24{1'b0}};
    reg_cmd_line_ctrl <= {24{1'b0}};
    reg_wdata_line_ctrl <= {32{1'b0}};
    reg_wcmd_line_ctrl <= {24{1'b0}};
    reg_rdata_line_ctrl <= {32{1'b0}};
    reg_resp_delay_ctrl <= {32{1'b0}};
    reg_cmd_pend_num <= 32'h80;
    reg_pg_cmd_ctrl <= {32{1'b0}};
    reg_pg_axi_id <= {30{1'b0}};
    reg_pg_addr_base <= {32{1'b0}};
    reg_pg_addr_low <= {32{1'b0}};
    reg_pg_data_ctrl <= {16{1'b0}};
    reg_pg_wstrb_preset <= {32{1'b0}};
  end else begin
    if(axi_reg_sel & apb_wr_op) begin
      case(axi_paddr[15:0]) // spyglass disable W71
      `NV_FPGA_UNIT_MEM_DUT_REG_TEST_CTRL          : reg_test_ctrl[26:1]   <= axi_pwdata[26:1]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_CMD_NUM_TOTAL      : reg_cmd_num_total     <= axi_pwdata[23:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_CMD_LINE_CTRL      : reg_cmd_line_ctrl     <= axi_pwdata[23:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_WDATA_LINE_CTRL    : reg_wdata_line_ctrl   <= axi_pwdata[31:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_WCMD_LINE_CTRL     : reg_wcmd_line_ctrl    <= axi_pwdata[23:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_RDATA_LINE_CTRL    : reg_rdata_line_ctrl   <= axi_pwdata[31:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_RESP_DELAY_CTRL    : reg_resp_delay_ctrl   <= axi_pwdata[31:0];
      `NV_FPGA_UNIT_MEM_DUT_REG_CMD_PEND_NUM       : reg_cmd_pend_num      <= axi_pwdata[31:0];
      
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_CMD_CTRL        : reg_pg_cmd_ctrl       <= axi_pwdata[31:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_AXI_ID          : reg_pg_axi_id         <= axi_pwdata[29:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_BASE       : reg_pg_addr_base      <= axi_pwdata[31:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_LOW        : reg_pg_addr_low       <= axi_pwdata[31:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_DATA_CTRL       : reg_pg_data_ctrl      <= axi_pwdata[15:0]; 
      `NV_FPGA_UNIT_MEM_DUT_REG_PG_WSTRB           : reg_pg_wstrb_preset   <= axi_pwdata[31:0]; 

//   below register are not writable
//      `NV_FPGA_UNIT_MEM_DUT_REG_OUTSTAND_STATUS    : reg_outstand_status   <0= axi_pwdata[19:0];
//      `NV_FPGA_UNIT_MEM_DUT_REG_TEST_STATUS        : reg_test_status       <0= axi_pwdata[31:0]; 
//      `NV_FPGA_UNIT_MEM_DUT_REG_TEST_ERR_LOC       : reg_test_err_loc      <0= axi_pwdata[23:0]; 
//      `NV_FPGA_UNIT_MEM_DUT_REG_RESP_CNT           : reg_resp_cnt          <0= axi_pwdata[23:0]; 
//      `NV_FPGA_UNIT_MEM_DUT_REG_RRESP_CNT          : reg_rresp_cnt         <0= axi_pwdata[23:0]; 
//      `NV_FPGA_UNIT_MEM_DUT_REG_RDATA_CNT          : reg_rdata_cnt         <0= axi_pwdata[31:0]; 
      endcase
    end
  end
end

always @(
  axi_reg_sel
  or axi_paddr
  or reg_test_ctrl_i
  or reg_cmd_num_total_i
  or reg_cmd_line_ctrl_i
  or reg_wdata_line_ctrl_i
  or reg_wcmd_line_ctrl_i
  or reg_rdata_line_ctrl_i
  or reg_resp_delay_ctrl_i
  or reg_cmd_pend_num_i
  or reg_pg_cmd_ctrl_i
  or reg_pg_axi_id_i
  or reg_pg_addr_base_i
  or reg_pg_addr_low_i
  or reg_pg_data_ctrl_i
  or reg_pg_wstrb_preset_i
  or reg_outstand_status_i
  or reg_test_status_i
  or reg_test_err_loc_i
  or reg_resp_cnt_i
  or reg_rresp_cnt_i
  or reg_rdata_cnt_i
  or reg_req_cnt_i
  or reg_req_wr_cnt_i
  or reg_req_wd_cnt_i
  or test_timer
  ) begin
  if(axi_reg_sel) begin
    case(axi_paddr[15:0])
    `NV_FPGA_UNIT_MEM_DUT_REG_TEST_CTRL          : axi_reg_prdata = reg_test_ctrl_i          ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_CMD_NUM_TOTAL      : axi_reg_prdata = reg_cmd_num_total_i      ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_CMD_LINE_CTRL      : axi_reg_prdata = reg_cmd_line_ctrl_i      ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_WDATA_LINE_CTRL    : axi_reg_prdata = reg_wdata_line_ctrl_i    ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_WCMD_LINE_CTRL     : axi_reg_prdata = reg_wcmd_line_ctrl_i     ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_RDATA_LINE_CTRL    : axi_reg_prdata = reg_rdata_line_ctrl_i    ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_RESP_DELAY_CTRL    : axi_reg_prdata = reg_resp_delay_ctrl_i    ; // spyglass disable W164b
    `NV_FPGA_UNIT_MEM_DUT_REG_CMD_PEND_NUM       : axi_reg_prdata = reg_cmd_pend_num_i       ; 
    
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_CMD_CTRL        : axi_reg_prdata = reg_pg_cmd_ctrl_i        ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_AXI_ID          : axi_reg_prdata = reg_pg_axi_id_i          ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_BASE       : axi_reg_prdata = reg_pg_addr_base_i       ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_ADDR_LOW        : axi_reg_prdata = reg_pg_addr_low_i        ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_DATA_CTRL       : axi_reg_prdata = reg_pg_data_ctrl_i       ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_PG_WSTRB           : axi_reg_prdata = reg_pg_wstrb_preset_i    ; 

    `NV_FPGA_UNIT_MEM_DUT_REG_OUTSTAND_STATUS    : axi_reg_prdata = reg_outstand_status_i    ; // spyglass disable W164b 
    `NV_FPGA_UNIT_MEM_DUT_REG_TEST_STATUS        : axi_reg_prdata = reg_test_status_i        ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_TEST_ERR_LOC       : axi_reg_prdata = reg_test_err_loc_i       ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_RESP_CNT           : axi_reg_prdata = reg_resp_cnt_i           ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_RRESP_CNT          : axi_reg_prdata = reg_rresp_cnt_i          ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_RDATA_CNT          : axi_reg_prdata = reg_rdata_cnt_i          ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_REQ_CNT            : axi_reg_prdata = reg_req_cnt_i            ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_REQ_WR_CNT         : axi_reg_prdata = reg_req_wr_cnt_i         ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_REQ_WD_CNT         : axi_reg_prdata = reg_req_wd_cnt_i         ; 
    `NV_FPGA_UNIT_MEM_DUT_REG_TEST_TIMER         : axi_reg_prdata = test_timer               ; 
    default: axi_reg_prdata = 32'b0;
    endcase
  end
  else
    axi_reg_prdata = 32'b0;
end

// TEST_CTRL_REG
assign axi_rdata_sel        = reg_test_ctrl[26];    // rdata golden source select. 0-pg, 1-axi_rdata_ram
assign axi_rdata_check_en   = reg_test_ctrl[25];    // enable rdata checking.
//assign axi_cmd_pend_num     = reg_test_ctrl[24:16]; // set the outstanding requests on AXI bus.
assign axi_cmd_line_end     = reg_test_ctrl[15:4];  // set the last valid axi cmd location in AXI_CMD_RAM
assign pg_en                = reg_test_ctrl[3];     // enable pattern gen function.
assign repeat_mode          = reg_test_ctrl[2];     // enable repeat mode to repeat a paragraph from axi_cmd_line_start to axi_cmd_line_repeat_end in AXI_CMD_RAM.
assign test_run_i           = reg_test_ctrl[1];     // begin to issue axi cmd until axi_req_num_total reached.
assign test_reset           = axi_reg_sel & apb_wr_op & (axi_paddr[15:0] == `NV_FPGA_UNIT_MEM_DUT_REG_TEST_CTRL) & axi_pwdata[0];
assign reg_test_ctrl_i          = {5'b0, reg_test_ctrl[26:25], 9'b0, reg_test_ctrl[15:1], 1'b0};

// CMD_NUM_TOTAL_REG
assign axi_req_num_total    = reg_cmd_num_total[23:0]; // indicate how many axi requests will be issued.
assign reg_cmd_num_total_i      = {8'b0, axi_req_num_total};

// CMD_LINE_CTRL_REG
assign axi_cmd_line_repeat_end  = reg_cmd_line_ctrl[23:12];
assign axi_cmd_line_start       = reg_cmd_line_ctrl[11:0];
assign reg_cmd_line_ctrl_i      = {8'b0, reg_cmd_line_ctrl[23:0]};

// WDATA_LINE_CTRL_REG
assign axi_wdata_line_repeat_end = reg_wdata_line_ctrl[31:16];
assign axi_wdata_line_start = reg_wdata_line_ctrl[15:0];
assign reg_wdata_line_ctrl_i    = reg_wdata_line_ctrl;

// WCMD_LINE_CTRL_REG
assign axi_awcmd_line_repeat_end = reg_wcmd_line_ctrl[23:12]; // spyglass disable W164a
assign axi_awcmd_line_start      = reg_wcmd_line_ctrl[11:0]; // spyglass disable W164a
assign reg_wcmd_line_ctrl_i     = {8'b0, reg_wcmd_line_ctrl[23:0]};

//  the ar info ram can be caculated by (axi_cmd_line_start - axi_awcmd_line_start)
assign axi_arcmd_line_start = axi_cmd_line_start - axi_awcmd_line_start - 1'b1; // spyglass disable W164a
assign axi_arcmd_line_repeat_end = axi_cmd_line_repeat_end - axi_awcmd_line_repeat_end - 1'b1; // spyglass disable W164a

// RDATA_LINE_NUM_REG
assign axi_rdata_line_repeat_end = reg_rdata_line_ctrl[31:16];
assign axi_rdata_line_start = reg_rdata_line_ctrl[15:0];
assign reg_rdata_line_ctrl_i    = reg_rdata_line_ctrl;

// CMD_PEND_NUM_REG, define in axi_resp module
assign axi_cmd_pend_num_min     = reg_cmd_pend_num[15:8];
assign axi_cmd_pend_num_max     = reg_cmd_pend_num[7:0];
assign reg_cmd_pend_num_i   = {16'b0, reg_cmd_pend_num[15:0]};

// below register are defined in axi_req_gen module
// PG_CMD_CTRL_REG 
// PG_AID_REG
// PG_ADDR_BASE_REG
// PG_ADDR_LOW_REG
// PG_DATA_CTRL_REG
// PG_WSTRB_REG

// below are status registers

// OUTSTAND_STATUS_REG
assign reg_outstand_status_i    = {14'b0, axi_awcmd_pend_cnt, axi_arcmd_pend_cnt};

// TEST_STATUS_REG, test_error_out is defined in axi_resp module
assign reg_test_status_i        = {test_finish, 16'b0, axi_cmd_line_mismatch, axi_wstrb_line_mismatch, test_error_out[12:0]};

// TEST_ERR_LOC_REG
assign reg_test_err_loc_i       = {8'b0, axi_cmd_error_loc};

// RESP_CNT_REG
assign reg_resp_cnt_i           = {8'b0, axi_resp_cnt_total};

// RRESP_CNT_REG
assign reg_rresp_cnt_i          = {8'b0, axi_rresp_cnt_total};

// RDATA_CNT_REG
assign reg_rdata_cnt_i          = axi_rdata_cnt_total;

// REQ_CNT_REG
assign reg_req_cnt_i = {8'b0, axi_req_cnt[23:0]};

// REQ_WR_CNT_REG
assign reg_req_wr_cnt_i = {8'b0, axi_req_wr_cnt[23:0]};

// REQ_WDATA_CNT_REG
assign reg_req_wd_cnt_i = axi_req_wd_cnt;

endmodule // NV_FPGA_unit_checkbox_mem_dut_axi_256_256


