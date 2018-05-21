// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut_axi_resp_256.v

module NV_FPGA_unit_checkbox_mem_dut_axi_resp_256 (
   axi_clk
  ,axi_rstn
  ,axi_arcmd_info
  ,axi_awcmd_info
  ,axi_bid
  ,axi_bresp
  ,axi_bvalid
  ,axi_cmd_pend_num_min
  ,axi_rdata
  ,axi_rdata_check_en
  ,axi_rdata_gold
  ,axi_req_rd_cnt
  ,axi_req_wr_cnt
  ,axi_rid
  ,axi_rlast
  ,axi_rresp
  ,axi_rstrb_gold
  ,axi_rvalid
  ,reg_resp_delay_ctrl
  ,status_clear
  ,arcmd_info_update
  ,awcmd_info_update
  ,axi_arcmd_pend_cnt
  ,axi_awcmd_pend_cnt
  ,axi_bready
  ,axi_cmd_error_loc
  ,axi_rdata_cnt_total
  ,axi_rdata_update
  ,axi_resp_cnt_total
  ,axi_resp_rdata_di
  ,axi_resp_rdata_we
  ,axi_rready
  ,axi_rresp_cnt_total
  ,reg_resp_delay_ctrl_i
  ,test_error_out
  );
input          axi_clk;
input          axi_rstn;
input   [26:0] axi_arcmd_info;
input   [13:0] axi_awcmd_info;
input   [13:0] axi_bid;
input    [1:0] axi_bresp;
input          axi_bvalid;
input    [7:0] axi_cmd_pend_num_min;
input  [255:0] axi_rdata;
input          axi_rdata_check_en;
input  [255:0] axi_rdata_gold;
input   [23:0] axi_req_rd_cnt;
input   [23:0] axi_req_wr_cnt;
input   [13:0] axi_rid;
input          axi_rlast;
input    [1:0] axi_rresp;
input   [31:0] axi_rstrb_gold;
input          axi_rvalid;
input   [25:0] reg_resp_delay_ctrl;
input          status_clear;
output         arcmd_info_update;
output         awcmd_info_update;
output   [8:0] axi_arcmd_pend_cnt;
output   [8:0] axi_awcmd_pend_cnt;
output         axi_bready;
output  [23:0] axi_cmd_error_loc;
output  [31:0] axi_rdata_cnt_total;
output         axi_rdata_update;
output  [23:0] axi_resp_cnt_total;
output [255:0] axi_resp_rdata_di;
output         axi_resp_rdata_we;
output         axi_rready;
output  [23:0] axi_rresp_cnt_total;
output  [31:0] reg_resp_delay_ctrl_i;
output  [12:0] test_error_out;
reg      [8:0] axi_arcmd_pend_cnt;
reg      [8:0] axi_awcmd_pend_cnt;
reg      [7:0] axi_bready_delay_cnt;
reg      [7:0] axi_bready_delay_cycles;
reg     [23:0] axi_bresp_cnt_total;
reg            axi_bresp_error_code;
reg            axi_bresp_error_id;
reg      [1:0] axi_bresp_error_resp;
reg     [23:0] axi_cmd_error_loc;
reg      [8:0] axi_rdata_cnt;
reg     [31:0] axi_rdata_cnt_total_reg;
reg            axi_rdata_match;
reg            axi_rdata_match_reg;
reg      [7:0] axi_rready_delay_cnt;
reg      [7:0] axi_rready_delay_cycles;
reg     [23:0] axi_rresp_cnt_total;
reg            axi_rresp_error_code;
reg            axi_rresp_error_id;
reg            axi_rresp_error_phase_less;
reg            axi_rresp_error_phase_more;
reg      [1:0] axi_rresp_error_resp;
wire     [1:0] axi_arburst_gold;
wire    [13:0] axi_arid_gold;
wire     [7:0] axi_arlen_gold;
wire     [2:0] axi_arsize_gold;
wire    [13:0] axi_awid_gold;
wire     [7:0] axi_bready_delay_cycles_preset;
wire           axi_bready_delay_en;
wire           axi_bready_delay_random;
wire           axi_rdata_corrupt;
wire     [7:0] axi_rready_delay_cycles_preset;
wire           axi_rready_delay_en;
wire           axi_rready_delay_random;
wire           axi_wdata_corrupt;
wire           protocol_error;
wire    [63:0] rdata_match_byte;
wire    [63:0] rdata_match_byte_shift;






//&Force output axi_bresp_cnt_total;




///////////////////////////////////////////////////////////////////
// read response
///////////////////////////////////////////////////////////////////

// get axi arcmd information which are used for read response check
//signal    info_ram    cmd_ram
//axi_id    [13:0]      [13:0]
//axi_len   [21:14]     [79:72]
//axi_burst [23:22]     [107:106]
//axi_size  [26:24]     [110:108]

assign arcmd_info_update = axi_rvalid & axi_rready & axi_rlast;
assign axi_arsize_gold = axi_arcmd_info[26:24];
assign axi_arburst_gold = axi_arcmd_info[23:22];
assign axi_arlen_gold = axi_arcmd_info[21:14];
assign axi_arid_gold = axi_arcmd_info[13:0];

assign axi_rdata_cnt_total = (axi_rvalid & axi_rready) ? (axi_rdata_cnt_total_reg + 1'b1) 
                                                       : status_clear ? 0 : axi_rdata_cnt_total_reg;

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_rdata_cnt_total_reg <= {32{1'b0}};
    axi_rdata_cnt <= {9{1'b0}};
    axi_rresp_cnt_total <= {24{1'b0}};
  end else begin
  axi_rdata_cnt_total_reg <= axi_rdata_cnt_total;
  if(status_clear) begin
    axi_rdata_cnt <= 0;
    axi_rresp_cnt_total <= 0;
  end
  else if(axi_rvalid & axi_rready) begin
    if(axi_rlast) begin
      axi_rdata_cnt <= 0;
      axi_rresp_cnt_total <= axi_rresp_cnt_total + 1'b1;
    end
    else begin
      axi_rdata_cnt <=  axi_rdata_cnt + 1'b1;
      axi_rresp_cnt_total <= axi_rresp_cnt_total;
    end
  end
  end
end

// write to AXI_RDATA_RAM
assign axi_resp_rdata_we = axi_rvalid & axi_rready;
assign axi_resp_rdata_di = axi_rdata;

// axi read resp valid-ready delay cycles control
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_arcmd_pend_cnt <= {9{1'b0}};
  end else begin
  axi_arcmd_pend_cnt <= axi_req_rd_cnt - axi_rresp_cnt_total; // spyglass disable W164a
  end
end
assign axi_rready = (~axi_rready_delay_en | (axi_rready_delay_cnt >= axi_rready_delay_cycles)) & (axi_arcmd_pend_cnt >= axi_cmd_pend_num_min); // spyglass disable W362

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_rready_delay_cnt <= {8{1'b0}};
  end else begin
  if(axi_rvalid) begin
    if(axi_rready)
      axi_rready_delay_cnt <= 0;
    else
      axi_rready_delay_cnt <= axi_rready_delay_cnt + 1'b1;
  end
  end
end

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_rready_delay_cycles <= {8{1'b0}};
  end else begin
  if(axi_rready_delay_en) begin
    if(~axi_rready_delay_random)
      axi_rready_delay_cycles <= axi_rready_delay_cycles_preset;
    else if(axi_rvalid & axi_rready)
      axi_rready_delay_cycles <= (axi_rready_delay_cycles + 1) % 4;
  end
  else
    axi_rready_delay_cycles <= 0;
  end
end

// axi read response error case detect
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_rresp_error_id <= 1'b0;
    axi_rresp_error_phase_more <= 1'b0;
    axi_rresp_error_phase_less <= 1'b0;
    axi_rresp_error_code <= 1'b0;
    axi_rresp_error_resp <= {2{1'b0}};
    axi_rdata_match_reg <= 1'b0;
  end else begin
  if(status_clear) begin
    axi_rresp_error_id          <= 0;
    axi_rresp_error_phase_more  <= 0;
    axi_rresp_error_phase_less  <= 0;
    axi_rresp_error_code        <= 0;
    axi_rresp_error_resp        <= 0;
    axi_rdata_match_reg         <= 1;
  end
  if(axi_rvalid & axi_rready) begin
    axi_rresp_error_id          <= axi_rresp_error_id | (axi_rid != axi_arid_gold);
    axi_rresp_error_phase_more  <= axi_rresp_error_phase_more | (axi_rlast & (axi_rdata_cnt > axi_arlen_gold)); // spyglass disable W362
    axi_rresp_error_phase_less  <= axi_rresp_error_phase_less | (axi_rlast & (axi_rdata_cnt < axi_arlen_gold)); // spyglass disable W362
    axi_rresp_error_code        <= axi_rresp_error_code | (|axi_rresp);
    axi_rresp_error_resp        <= (axi_rresp != 2'b00) ? axi_rresp : axi_rresp_error_resp;
    axi_rdata_match_reg         <= axi_rdata_match_reg & axi_rdata_match;
  end
  end
end

///////////////////////////////////////////////////////////////////
// write response
///////////////////////////////////////////////////////////////////

assign awcmd_info_update = axi_bvalid & axi_bready;
assign axi_awid_gold = axi_awcmd_info[13:0];

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_bresp_cnt_total <= {24{1'b0}};
  end else begin
  if(status_clear)
    axi_bresp_cnt_total <= 0;
  else if(axi_bvalid & axi_bready) begin
    axi_bresp_cnt_total <= axi_bresp_cnt_total + 1'b1;
  end
  end
end

// axi read resp valid-ready delay cycles control
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_awcmd_pend_cnt <= {9{1'b0}};
  end else begin
  axi_awcmd_pend_cnt <= axi_req_wr_cnt - axi_bresp_cnt_total; // spyglass disable W164a
  end
end
assign axi_bready = (~axi_bready_delay_en | (axi_bready_delay_cnt >= axi_bready_delay_cycles)) & (axi_awcmd_pend_cnt >= axi_cmd_pend_num_min); // spyglass disable W362

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_bready_delay_cnt <= {8{1'b0}};
  end else begin
  if(axi_bvalid) begin
    if(axi_bready)
      axi_bready_delay_cnt <= 0;
    else
      axi_bready_delay_cnt <= axi_bready_delay_cnt + 1'b1;
  end
  end
end

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_bready_delay_cycles <= {8{1'b0}};
  end else begin
  if(axi_bready_delay_en) begin
    if(axi_bready_delay_random)
      axi_bready_delay_cycles <= axi_bready_delay_cycles_preset;
    else if(axi_bvalid & axi_bready)
      axi_bready_delay_cycles <= (axi_bready_delay_cycles + 1) % 4;
  end
  else
    axi_bready_delay_cycles <= 0;
  end
end

// axi read response error case detect
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_bresp_error_id <= 1'b0;
    axi_bresp_error_code <= 1'b0;
    axi_bresp_error_resp <= {2{1'b0}};
  end else begin
  if(status_clear) begin
    axi_bresp_error_id   <= 0; 
    axi_bresp_error_code <= 0; 
    axi_bresp_error_resp <= 0; 
  end
  if(axi_bvalid & axi_bready) begin
    axi_bresp_error_id   <= axi_bresp_error_id | (axi_bid != axi_awid_gold);
    axi_bresp_error_code <= axi_bresp_error_code | (axi_bresp != 2'b00);
    axi_bresp_error_resp <= (axi_bresp != 2'b00) ? axi_bresp : axi_bresp_error_resp;
  end
  end
end

////////////////////////////////////////////////////////////////
// axi read data check
////////////////////////////////////////////////////////////////

assign axi_rdata_update = axi_rvalid & axi_rready;

assign rdata_match_byte[0] = !axi_rstrb_gold[0] | (axi_rdata[7:0] == axi_rdata_gold[7:0]);
assign rdata_match_byte[1] = !axi_rstrb_gold[1] | (axi_rdata[15:8] == axi_rdata_gold[15:8]);
assign rdata_match_byte[2] = !axi_rstrb_gold[2] | (axi_rdata[23:16] == axi_rdata_gold[23:16]);
assign rdata_match_byte[3] = !axi_rstrb_gold[3] | (axi_rdata[31:24] == axi_rdata_gold[31:24]);
assign rdata_match_byte[4] = !axi_rstrb_gold[4] | (axi_rdata[39:32] == axi_rdata_gold[39:32]);
assign rdata_match_byte[5] = !axi_rstrb_gold[5] | (axi_rdata[47:40] == axi_rdata_gold[47:40]);
assign rdata_match_byte[6] = !axi_rstrb_gold[6] | (axi_rdata[55:48] == axi_rdata_gold[55:48]);
assign rdata_match_byte[7] = !axi_rstrb_gold[7] | (axi_rdata[63:56] == axi_rdata_gold[63:56]);
assign rdata_match_byte[8] = !axi_rstrb_gold[8] | (axi_rdata[71:64] == axi_rdata_gold[71:64]);
assign rdata_match_byte[9] = !axi_rstrb_gold[9] | (axi_rdata[79:72] == axi_rdata_gold[79:72]);
assign rdata_match_byte[10] = !axi_rstrb_gold[10] | (axi_rdata[87:80] == axi_rdata_gold[87:80]);
assign rdata_match_byte[11] = !axi_rstrb_gold[11] | (axi_rdata[95:88] == axi_rdata_gold[95:88]);
assign rdata_match_byte[12] = !axi_rstrb_gold[12] | (axi_rdata[103:96] == axi_rdata_gold[103:96]);
assign rdata_match_byte[13] = !axi_rstrb_gold[13] | (axi_rdata[111:104] == axi_rdata_gold[111:104]);
assign rdata_match_byte[14] = !axi_rstrb_gold[14] | (axi_rdata[119:112] == axi_rdata_gold[119:112]);
assign rdata_match_byte[15] = !axi_rstrb_gold[15] | (axi_rdata[127:120] == axi_rdata_gold[127:120]);
assign rdata_match_byte[16] = !axi_rstrb_gold[16] | (axi_rdata[135:128] == axi_rdata_gold[135:128]);
assign rdata_match_byte[17] = !axi_rstrb_gold[17] | (axi_rdata[143:136] == axi_rdata_gold[143:136]);
assign rdata_match_byte[18] = !axi_rstrb_gold[18] | (axi_rdata[151:144] == axi_rdata_gold[151:144]);
assign rdata_match_byte[19] = !axi_rstrb_gold[19] | (axi_rdata[159:152] == axi_rdata_gold[159:152]);
assign rdata_match_byte[20] = !axi_rstrb_gold[20] | (axi_rdata[167:160] == axi_rdata_gold[167:160]);
assign rdata_match_byte[21] = !axi_rstrb_gold[21] | (axi_rdata[175:168] == axi_rdata_gold[175:168]);
assign rdata_match_byte[22] = !axi_rstrb_gold[22] | (axi_rdata[183:176] == axi_rdata_gold[183:176]);
assign rdata_match_byte[23] = !axi_rstrb_gold[23] | (axi_rdata[191:184] == axi_rdata_gold[191:184]);
assign rdata_match_byte[24] = !axi_rstrb_gold[24] | (axi_rdata[199:192] == axi_rdata_gold[199:192]);
assign rdata_match_byte[25] = !axi_rstrb_gold[25] | (axi_rdata[207:200] == axi_rdata_gold[207:200]);
assign rdata_match_byte[26] = !axi_rstrb_gold[26] | (axi_rdata[215:208] == axi_rdata_gold[215:208]);
assign rdata_match_byte[27] = !axi_rstrb_gold[27] | (axi_rdata[223:216] == axi_rdata_gold[223:216]);
assign rdata_match_byte[28] = !axi_rstrb_gold[28] | (axi_rdata[231:224] == axi_rdata_gold[231:224]);
assign rdata_match_byte[29] = !axi_rstrb_gold[29] | (axi_rdata[239:232] == axi_rdata_gold[239:232]);
assign rdata_match_byte[30] = !axi_rstrb_gold[30] | (axi_rdata[247:240] == axi_rdata_gold[247:240]);
assign rdata_match_byte[31] = !axi_rstrb_gold[31] | (axi_rdata[255:248] == axi_rdata_gold[255:248]);
assign rdata_match_byte[32] = 1'b1;
assign rdata_match_byte[33] = 1'b1;
assign rdata_match_byte[34] = 1'b1;
assign rdata_match_byte[35] = 1'b1;
assign rdata_match_byte[36] = 1'b1;
assign rdata_match_byte[37] = 1'b1;
assign rdata_match_byte[38] = 1'b1;
assign rdata_match_byte[39] = 1'b1;
assign rdata_match_byte[40] = 1'b1;
assign rdata_match_byte[41] = 1'b1;
assign rdata_match_byte[42] = 1'b1;
assign rdata_match_byte[43] = 1'b1;
assign rdata_match_byte[44] = 1'b1;
assign rdata_match_byte[45] = 1'b1;
assign rdata_match_byte[46] = 1'b1;
assign rdata_match_byte[47] = 1'b1;
assign rdata_match_byte[48] = 1'b1;
assign rdata_match_byte[49] = 1'b1;
assign rdata_match_byte[50] = 1'b1;
assign rdata_match_byte[51] = 1'b1;
assign rdata_match_byte[52] = 1'b1;
assign rdata_match_byte[53] = 1'b1;
assign rdata_match_byte[54] = 1'b1;
assign rdata_match_byte[55] = 1'b1;
assign rdata_match_byte[56] = 1'b1;
assign rdata_match_byte[57] = 1'b1;
assign rdata_match_byte[58] = 1'b1;
assign rdata_match_byte[59] = 1'b1;
assign rdata_match_byte[60] = 1'b1;
assign rdata_match_byte[61] = 1'b1;
assign rdata_match_byte[62] = 1'b1;
assign rdata_match_byte[63] = 1'b1;
assign rdata_match_byte_shift = rdata_match_byte >> ((axi_rdata_cnt<<axi_arsize_gold) % 32);

always @(
  axi_arsize_gold
  or rdata_match_byte_shift
  ) begin
  case(axi_arsize_gold)
  3'b000: axi_rdata_match = &rdata_match_byte_shift[0:0];
  3'b001: axi_rdata_match = &rdata_match_byte_shift[1:0];
  3'b010: axi_rdata_match = &rdata_match_byte_shift[3:0];
  3'b011: axi_rdata_match = &rdata_match_byte_shift[7:0];
  3'b100: axi_rdata_match = &rdata_match_byte_shift[15:0];
  3'b101: axi_rdata_match = &rdata_match_byte_shift[31:0];
  3'b110: axi_rdata_match = &rdata_match_byte_shift[63:0];
  default: axi_rdata_match = 0;
  endcase
end

////////////////////////////////////////////////////////////////
// registers
////////////////////////////////////////////////////////////////

// RESP_DELAY_CTRL_REG, used for delay control register.
assign axi_bready_delay_en              = reg_resp_delay_ctrl[0];
assign axi_bready_delay_random          = reg_resp_delay_ctrl[1];
assign axi_bready_delay_cycles_preset   = reg_resp_delay_ctrl[9:2];
assign axi_rready_delay_en              = reg_resp_delay_ctrl[16];
assign axi_rready_delay_random          = reg_resp_delay_ctrl[17];
assign axi_rready_delay_cycles_preset   = reg_resp_delay_ctrl[25:18];
assign reg_resp_delay_ctrl_i    = {6'b0, axi_rready_delay_cycles_preset, axi_rready_delay_random, axi_rready_delay_en,
                                   6'b0, axi_bready_delay_cycles_preset, axi_bready_delay_random, axi_bready_delay_en};

// for TEST_STATUS_REG
// combine error bits.
assign protocol_error = axi_rresp_error_id | axi_rresp_error_phase_more | axi_rresp_error_phase_less | axi_rresp_error_code | axi_bresp_error_id | axi_bresp_error_code | axi_rdata_corrupt | axi_wdata_corrupt;
assign axi_rdata_corrupt = ~axi_rdata_match_reg & axi_rdata_check_en;
assign axi_wdata_corrupt = 1'b0;

// test_status register. 13 bits
assign test_error_out = {protocol_error, axi_rresp_error_id, axi_rresp_error_phase_more, axi_rresp_error_phase_less, axi_rresp_error_code, 
        axi_rresp_error_resp[1:0], axi_rdata_corrupt, axi_bresp_error_id, axi_bresp_error_code, axi_bresp_error_resp[1:0], axi_wdata_corrupt};

// error cmd location log register
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_cmd_error_loc <= {24{1'b0}};
  end else begin
  if(status_clear)
    axi_cmd_error_loc <= 0;
  else if(((axi_bvalid & axi_bready) | (axi_rvalid & axi_rready)) & ~protocol_error)
    axi_cmd_error_loc <= axi_resp_cnt_total;
  end
end

// response/rdata cnt 
assign axi_resp_cnt_total = axi_rresp_cnt_total + axi_bresp_cnt_total; // spyglass disable W484

endmodule // NV_FPGA_unit_checkbox_mem_dut_axi_resp_256

