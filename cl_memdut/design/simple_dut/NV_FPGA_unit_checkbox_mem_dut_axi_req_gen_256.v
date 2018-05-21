// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut_axi_req_gen_256.v

module NV_FPGA_unit_checkbox_mem_dut_axi_req_gen_256 (
   pg_clk
  ,pg_rstn
  ,arcmd_info_update
  ,awcmd_info_update
  ,axi_rdata_cnt_total
  ,axi_req_update
  ,axi_req_wd_cnt
  ,axi_wdata_phase_cnt_reg
  ,reg_pg_addr_base
  ,reg_pg_addr_low
  ,reg_pg_axi_id
  ,reg_pg_cmd_ctrl
  ,reg_pg_data_ctrl
  ,reg_pg_wstrb_preset
  ,status_clear
  ,pg_axi_arcmd_info
  ,pg_axi_awcmd_info
  ,pg_axi_cmd
  ,pg_axi_rdata
  ,pg_axi_rstrb
  ,pg_axi_wdata
  ,pg_axi_wstrb
  ,pg_wr_and_rd_back_mode
  ,reg_pg_addr_base_i
  ,reg_pg_addr_low_i
  ,reg_pg_axi_id_i
  ,reg_pg_cmd_ctrl_i
  ,reg_pg_data_ctrl_i
  ,reg_pg_wstrb_preset_i
  );
input          pg_clk;
input          pg_rstn;
input          arcmd_info_update;
input          awcmd_info_update;
input   [31:0] axi_rdata_cnt_total;
input          axi_req_update;
input   [15:0] axi_req_wd_cnt;
input    [8:0] axi_wdata_phase_cnt_reg;
input   [31:0] reg_pg_addr_base;
input   [31:0] reg_pg_addr_low;
input   [29:0] reg_pg_axi_id;
input   [31:0] reg_pg_cmd_ctrl;
input   [15:0] reg_pg_data_ctrl;
input   [31:0] reg_pg_wstrb_preset;
input          status_clear;
output  [26:0] pg_axi_arcmd_info;
output  [26:0] pg_axi_awcmd_info;
output [127:0] pg_axi_cmd;
output [255:0] pg_axi_rdata;
output  [63:0] pg_axi_rstrb;
output [255:0] pg_axi_wdata;
output  [31:0] pg_axi_wstrb;
output         pg_wr_and_rd_back_mode;
output  [31:0] reg_pg_addr_base_i;
output  [31:0] reg_pg_addr_low_i;
output  [31:0] reg_pg_axi_id_i;
output  [31:0] reg_pg_cmd_ctrl_i;
output  [31:0] reg_pg_data_ctrl_i;
output  [31:0] reg_pg_wstrb_preset_i;
reg      [7:0] arcmd_info_arid;
reg      [7:0] awcmd_info_awid;
reg     [39:0] axi_araddr;
reg      [7:0] axi_arid;
reg     [39:0] axi_awaddr;
reg      [7:0] axi_awid;
reg      [0:0] axi_axrw;
reg    [255:0] pg_axi_rdata;
reg    [255:0] pg_axi_wdata;
wire    [39:0] axi_axaddr;
wire     [1:0] axi_axburst;
wire     [3:0] axi_axcache;
wire     [7:0] axi_axdly1;
wire     [7:0] axi_axdly2;
wire    [13:0] axi_axid;
wire     [7:0] axi_axlen;
wire     [1:0] axi_axlock;
wire     [2:0] axi_axprot;
wire     [3:0] axi_axqos;
wire     [2:0] axi_axsize;
wire    [25:0] axi_axuser;
wire     [0:0] axi_dual_cmd_mode;
wire    [39:0] pg_addr_base;
wire    [15:0] pg_araddr_preset;
wire    [13:0] pg_arid_preset;
wire    [15:0] pg_awaddr_preset;
wire    [13:0] pg_awid_preset;
wire     [7:0] pg_axdly1;
wire     [7:0] pg_axdly2;
wire     [5:0] pg_axi_wstrb_shift;
wire    [63:0] pg_axi_wstrb_tmp;
wire     [2:0] pg_axprot;
wire     [1:0] pg_cmd_aburst;
wire     [2:0] pg_cmd_asize;
wire    [11:0] pg_cmd_data_length;
wire     [2:0] pg_cmd_mode;
wire     [2:0] pg_data_mode;
wire           pg_dual_cmd_mode;
wire           pg_fix_addr;
wire           pg_fix_id;
wire           pg_wstrb_change;
wire    [31:0] pg_wstrb_preset;



/////////////////////////////////////////////////////////////////////////
// generate aw/ar cmd output for request issue
/////////////////////////////////////////////////////////////////////////



assign pg_axi_cmd = {
    4'b0,
    axi_axqos,
    axi_axlock,
    axi_axprot,
    axi_axcache,
    axi_axsize,
    axi_axburst,
    axi_axuser,
    axi_axlen,
    axi_axaddr,
    axi_axdly2,
    axi_axdly1,
    axi_axrw,
    axi_dual_cmd_mode,
    axi_axid};

assign axi_dual_cmd_mode    = pg_dual_cmd_mode;
assign axi_axdly1           = pg_axdly1;
assign axi_axdly2           = pg_axdly2;

assign axi_axcache          = 4'b0;
assign axi_axprot           = pg_axprot;
assign axi_axlock           = 2'b0;
assign axi_axqos            = 4'b0;

// burst/size/length are set in registers
assign axi_axburst = pg_cmd_aburst;
assign axi_axsize = pg_cmd_asize;
assign axi_axlen = (pg_cmd_data_length >> pg_cmd_asize) - 1'b1; // spyglass disable W164a

assign axi_axuser = 26'b0;

// read/write assign
always @(posedge pg_clk or negedge pg_rstn) begin
  if (!pg_rstn) begin
    axi_axrw <= 1'b0;
  end else begin
    case(pg_cmd_mode)
    3'b000: axi_axrw <= 1'b0;
    3'b001: axi_axrw <= 1'b1;
    3'b010: axi_axrw <= axi_req_update ? ~axi_axrw : axi_axrw;
    3'b011: axi_axrw <= 1'b1;
    default: axi_axrw <= 1'b0;
    endcase
  end
end

assign pg_wr_and_rd_back_mode = (pg_cmd_mode == 3'b010);

// arid/awid and addr generator
always @(posedge pg_clk or negedge pg_rstn) begin
  if (!pg_rstn) begin
    axi_arid <= {8{1'b0}};
    axi_awid <= {8{1'b0}};
    axi_araddr <= {40{1'b0}};
    axi_awaddr <= {40{1'b0}};
  end else begin
  if(status_clear) begin
    axi_arid   <= pg_arid_preset[7:0];
    axi_awid   <= pg_awid_preset[7:0];
    axi_araddr <= pg_addr_base + pg_araddr_preset; // spyglass disable W484
    axi_awaddr <= pg_addr_base + pg_awaddr_preset; // spyglass disable W484
  end
  else if(axi_req_update) begin
    if(axi_axrw) begin
      axi_arid   <= pg_fix_id ? axi_arid : (axi_arid + 1'b1);
      axi_araddr <= pg_fix_addr ? axi_araddr: (axi_araddr + pg_cmd_data_length); // spyglass disable W484
    end
    else begin
      axi_awid   <= pg_fix_id ? axi_awid : (axi_awid + 1'b1);
      axi_awaddr <= pg_fix_addr ? axi_awaddr: (axi_awaddr + pg_cmd_data_length); // spyglass disable W484
    end
  end
  end
end

assign axi_axid = axi_axrw ? {pg_arid_preset[13:8], axi_arid} : {pg_awid_preset[13:8], axi_awid};
assign axi_axaddr = axi_axrw ? axi_araddr : axi_awaddr;

// wdata assignment.
always @(
  pg_data_mode
  or axi_req_wd_cnt
  ) begin
  //if(pg_en) begin
    case(pg_data_mode)
    3'b000: pg_axi_wdata = 0;
    3'b001: pg_axi_wdata = {8{32'hFFFF_FFFF}};
    3'b010: pg_axi_wdata = {16{axi_req_wd_cnt[15:0]}}; // spyglass disable W164a
    3'b011: pg_axi_wdata = {16{~axi_req_wd_cnt[15:0]}}; // spyglass disable W164a
    3'b100: pg_axi_wdata = {8{32'h55AA_AA55}};
    3'b101: pg_axi_wdata = {8{32'h33CC_CC33}};
    default: pg_axi_wdata = 0;
    endcase
  //end
end

assign pg_axi_wstrb_tmp = ~pg_wstrb_change ? {2{pg_wstrb_preset}}
                                           : (axi_req_wd_cnt[1:0] == 2'b11) ? {2{32'hFFFFFFFF}}
                                           : (axi_req_wd_cnt[1:0] == 2'b10) ? {2{32'h00FFFFFF}}
                                           : (axi_req_wd_cnt[1:0] == 2'b01) ? {2{32'h0000FFFF}} : {2{32'h000000FF}};
assign pg_axi_wstrb_shift = (axi_wdata_phase_cnt_reg<<axi_axsize)%32; // spyglass disable W164a
assign pg_axi_wstrb = pg_axi_wstrb_tmp&(((1<<(1<<axi_axsize))-1)<<(pg_axi_wstrb_shift)); // spyglass disable W164a

/////////////////////////////////////////////////////////////////////////
// generate aw/ar info output for response check
/////////////////////////////////////////////////////////////////////////

// info contents
//signal    info_ram    cmd_ram
//axi_id    [13:0]      [13:0]
//axi_len   [21:14]     [79:72]
//axi_burst [23:22]     [107:106]
//axi_size  [26:24]     [110:108]

// aw info output generation
always @(posedge pg_clk or negedge pg_rstn) begin
  if (!pg_rstn) begin
    awcmd_info_awid <= {8{1'b0}};
  end else begin
  if(status_clear) 
    awcmd_info_awid   <= pg_awid_preset[7:0];
  else if(awcmd_info_update) 
    awcmd_info_awid   <= pg_fix_id ? awcmd_info_awid : (awcmd_info_awid + 1'b1);
  end
end
assign pg_axi_awcmd_info = {axi_axsize, axi_axburst, axi_axlen, pg_awid_preset[13:8], awcmd_info_awid};

// ar info output generation 
always @(posedge pg_clk or negedge pg_rstn) begin
  if (!pg_rstn) begin
    arcmd_info_arid <= {8{1'b0}};
  end else begin
  if(status_clear) 
    arcmd_info_arid   <= pg_arid_preset[7:0];
  else if(arcmd_info_update) 
    arcmd_info_arid   <= pg_fix_id ? arcmd_info_arid : (arcmd_info_arid + 1'b1);
  end
end
assign pg_axi_arcmd_info = {axi_axsize, axi_axburst, axi_axlen, pg_arid_preset[13:8], arcmd_info_arid};

// rdata golden
always @(
  pg_data_mode
  or axi_rdata_cnt_total
  ) begin
  case(pg_data_mode)
  3'b000: pg_axi_rdata = 0;
  3'b001: pg_axi_rdata = {16{32'hFFFF_FFFF}};   // spyglass disable W164a
  3'b010: pg_axi_rdata = {31{axi_rdata_cnt_total[15:0]}}; // spyglass disable W164a
  3'b011: pg_axi_rdata = {31{~axi_rdata_cnt_total[15:0]}}; // spyglass disable W164a
  3'b100: pg_axi_rdata = {16{32'h55AA_AA55}};   // spyglass disable W164a
  3'b101: pg_axi_rdata = {16{32'h33CC_CC33}};   // spyglass disable W164a
  default: pg_axi_rdata = 0;
  endcase
end

assign pg_axi_rstrb = ~pg_wstrb_change ? {2{pg_wstrb_preset}}
                                       : (axi_rdata_cnt_total[1:0] == 2'b11) ? {2{32'hFFFFFFFF}}
                                       : (axi_rdata_cnt_total[1:0] == 2'b10) ? {2{32'h00FFFFFF}}
                                       : (axi_rdata_cnt_total[1:0] == 2'b01) ? {2{32'h0000FFFF}} : {2{32'h000000FF}};

/////////////////////////////////////////////////////////////////////////
// register connection
/////////////////////////////////////////////////////////////////////////

// PG_CMD_CTRL_REG
assign pg_axdly2            = reg_pg_cmd_ctrl[31:24];
assign pg_axdly1            = reg_pg_cmd_ctrl[23:16];
// rsv reg_pg_cmd_ctrl[15:14];
assign pg_axprot[2:0]       = reg_pg_cmd_ctrl[13:11];
assign pg_dual_cmd_mode     = reg_pg_cmd_ctrl[10];
assign pg_fix_addr          = reg_pg_cmd_ctrl[9];
assign pg_fix_id            = reg_pg_cmd_ctrl[8];
assign pg_cmd_asize[2:0]    = reg_pg_cmd_ctrl[7:5];
assign pg_cmd_aburst[1:0]   = reg_pg_cmd_ctrl[4:3];
assign pg_cmd_mode[2:0]     = reg_pg_cmd_ctrl[2:0];
assign reg_pg_cmd_ctrl_i        = {reg_pg_cmd_ctrl[31:16], 2'b0, reg_pg_cmd_ctrl[13:0]};

// PG_AXI_ID_REG
assign pg_awid_preset[13:0] = reg_pg_axi_id[29:16];
assign pg_arid_preset[13:0] = reg_pg_axi_id[13:0];
assign reg_pg_axi_id_i             = {2'b0, pg_awid_preset, 2'b0, pg_arid_preset};

// PG_ADDR_BASE_REG (axaddr[39:8])
assign pg_addr_base[39:0]   = {reg_pg_addr_base[31:0], 8'b0};
assign reg_pg_addr_base_i       = reg_pg_addr_base[31:0];

// PG_AXADDR_LOW_REG (axaddr[7:0])
assign pg_awaddr_preset[15:0]   = reg_pg_addr_low[31:16];
assign pg_araddr_preset[15:0]   = reg_pg_addr_low[15:0];
assign reg_pg_addr_low_i        = reg_pg_addr_low;

// PG_DATA_CTRL_REG
assign pg_wstrb_change          = reg_pg_data_ctrl[15];
assign pg_data_mode[2:0]        = reg_pg_data_ctrl[14:12];
assign pg_cmd_data_length[11:0] = reg_pg_data_ctrl[11:0];
assign reg_pg_data_ctrl_i       = {16'b0, reg_pg_data_ctrl[15:0]};

// PG_WSTRB_REG
assign pg_wstrb_preset[31:0]    = reg_pg_wstrb_preset[31:0];
assign reg_pg_wstrb_preset_i    = reg_pg_wstrb_preset;

endmodule // NV_FPGA_unit_checkbox_mem_dut_axi_req_gen_256

