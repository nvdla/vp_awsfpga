// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut_axi_req_256.v

module NV_FPGA_unit_checkbox_mem_dut_axi_req_256 (
   axi_clk
  ,axi_rstn
  ,axi_arcmd_pend_cnt
  ,axi_arready
  ,axi_awcmd_pend_cnt
  ,axi_awready
  ,axi_cmd_pend_num_max
  ,axi_rd_req_wait
  ,axi_req_cmd
  ,axi_req_wdata
  ,axi_req_wstrb
  ,axi_wready
  ,status_clear
  ,test_cmd_issuing
  ,axi_araddr
  ,axi_arburst
  ,axi_arcache
  ,axi_arid
  ,axi_arlen
  ,axi_arlock
  ,axi_arprot
  ,axi_arqos
  ,axi_arregion
  ,axi_arsize
  ,axi_aruser
  ,axi_arvalid
  ,axi_awaddr
  ,axi_awburst
  ,axi_awcache
  ,axi_awid
  ,axi_awlen
  ,axi_awlock
  ,axi_awprot
  ,axi_awqos
  ,axi_awregion
  ,axi_awsize
  ,axi_awuser
  ,axi_awvalid
  ,axi_req_cnt
  ,axi_req_rd_cnt
  ,axi_req_update
  ,axi_req_wd_cnt
  ,axi_req_wd_update
  ,axi_req_wr_cnt
  ,axi_wdata
  ,axi_wdata_phase_cnt_reg
  ,axi_wlast
  ,axi_wstrb
  ,axi_wvalid
  );
input          axi_clk;
input          axi_rstn;
input    [8:0] axi_arcmd_pend_cnt;
input          axi_arready;
input    [8:0] axi_awcmd_pend_cnt;
input          axi_awready;
input    [7:0] axi_cmd_pend_num_max;
input          axi_rd_req_wait;
input  [127:0] axi_req_cmd;
input  [255:0] axi_req_wdata;
input   [31:0] axi_req_wstrb;
input          axi_wready;
input          status_clear;
input          test_cmd_issuing;
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
output  [23:0] axi_req_cnt;
output  [23:0] axi_req_rd_cnt;
output         axi_req_update;
output  [31:0] axi_req_wd_cnt;
output         axi_req_wd_update;
output  [23:0] axi_req_wr_cnt;
output [255:0] axi_wdata;
output   [8:0] axi_wdata_phase_cnt_reg;
output         axi_wlast;
output  [31:0] axi_wstrb;
output         axi_wvalid;
reg            axi_arcmd_accept_reg;
reg            axi_arvalid_reg;
reg            axi_awcmd_accept_reg;
reg            axi_awvalid_reg;
reg     [23:0] axi_req_cnt_reg;
reg      [7:0] axi_req_dly1_cnt;
reg      [7:0] axi_req_dly2_cnt;
reg     [23:0] axi_req_rd_cnt_reg;
reg            axi_req_update;
reg     [31:0] axi_req_wd_cnt_reg;
reg     [23:0] axi_req_wr_cnt_reg;
reg            axi_wdata_accept_reg;
reg      [8:0] axi_wdata_phase_cnt_reg;
reg      [3:0] nxt_req_state;
reg      [3:0] req_state;
wire           axi_arcmd_accept;
wire           axi_awcmd_accept;
wire    [39:0] axi_axaddr;
wire    [39:0] axi_axaddr_reg;
wire     [1:0] axi_axburst;
wire     [1:0] axi_axburst_reg;
wire     [3:0] axi_axcache;
wire     [3:0] axi_axcache_reg;
wire     [7:0] axi_axdly1_reg;
wire     [7:0] axi_axdly2_reg;
wire    [13:0] axi_axid;
wire    [13:0] axi_axid_reg;
wire     [7:0] axi_axlen;
wire     [7:0] axi_axlen_reg;
wire     [1:0] axi_axlock;
wire     [1:0] axi_axlock_reg;
wire     [2:0] axi_axprot;
wire     [2:0] axi_axprot_reg;
wire     [3:0] axi_axqos;
wire     [3:0] axi_axqos_reg;
wire     [3:0] axi_axregion;
wire     [3:0] axi_axregion_reg;
wire           axi_axrw;
wire           axi_axrw_reg;
wire     [2:0] axi_axsize;
wire     [2:0] axi_axsize_reg;
wire    [25:0] axi_axuser;
wire    [25:0] axi_axuser_reg;
wire           axi_dual_cmd_mode;
wire           axi_req_dly1_done;
wire           axi_req_dly2_done;
wire           axi_single_rwcmd_accept;
wire           axi_wdata_accept;
wire     [8:0] axi_wdata_phase_cnt;



// AXI request signals declaration



// control singals declaration



// output control singals for other module


reg [127:0] axi_req_cmd_reg; // spyglass disable W498
// latest axi request are present on output of axi_cmd_ram
// axi_reg_cmd_reg store last axi cmd
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_req_cmd_reg <= {128{1'b0}};
  end else begin
  if(axi_req_update) begin
    axi_req_cmd_reg <= axi_req_cmd;
  end
  end
end

// de-concentrate the axi request information
assign axi_axregion[3:0]    = axi_req_cmd[127:124];
assign axi_axqos[3:0]       = axi_req_cmd[123:120];
assign axi_axlock[1:0]      = axi_req_cmd[119:118];
assign axi_axprot[2:0]      = axi_req_cmd[117:115];
assign axi_axcache[3:0]     = axi_req_cmd[114:111];
assign axi_axsize[2:0]      = axi_req_cmd[110:108];
assign axi_axburst[1:0]     = axi_req_cmd[107:106];
assign axi_axuser[25:0]     = axi_req_cmd[105:80];
assign axi_axlen[7:0]       = axi_req_cmd[79:72];
assign axi_axaddr[39:0]     = axi_req_cmd[71:32];
//assign axi_axdly2           = axi_req_cmd[27:24];
//assign axi_axdly1           = axi_req_cmd[19:16];
assign axi_axrw             = axi_req_cmd[15];
assign axi_dual_cmd_mode    = axi_req_cmd[14];
assign axi_axid[13:0]       = axi_req_cmd[13:0];

assign axi_axregion_reg[3:0]= axi_req_cmd_reg[127:124];
assign axi_axqos_reg[3:0]   = axi_req_cmd_reg[123:120];
assign axi_axlock_reg[1:0]  = axi_req_cmd_reg[119:118];
assign axi_axprot_reg[2:0]  = axi_req_cmd_reg[117:115];
assign axi_axcache_reg[3:0] = axi_req_cmd_reg[114:111];
assign axi_axsize_reg[2:0]  = axi_req_cmd_reg[110:108];
assign axi_axburst_reg[1:0] = axi_req_cmd_reg[107:106];
assign axi_axuser_reg[25:0] = axi_req_cmd_reg[105:80];
assign axi_axlen_reg[7:0]   = axi_req_cmd_reg[79:72];
assign axi_axaddr_reg[39:0] = axi_req_cmd_reg[71:32];
assign axi_axdly2_reg[7:0]  = axi_req_cmd_reg[31:24];
assign axi_axdly1_reg[7:0]  = axi_req_cmd_reg[23:16];
assign axi_axrw_reg         = axi_req_cmd_reg[15];
//axi_dual_cmd_mode_reg 
assign axi_axid_reg[13:0]   = axi_req_cmd_reg[13:0];

// count the totol requests and the total wdata phases.
// axi_req_cnt indicate which cmd (1..N) is being accepted. N is the total cmd number
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_req_cnt_reg <= {24{1'b0}};
    axi_req_wd_cnt_reg <= {32{1'b0}};
    axi_req_rd_cnt_reg <= {24{1'b0}};
    axi_req_wr_cnt_reg <= {24{1'b0}};
  end else begin
  if(status_clear) begin
    axi_req_cnt_reg <= 0;
    axi_req_wd_cnt_reg <= 0;
    axi_req_rd_cnt_reg <= 0;
    axi_req_wr_cnt_reg <= 0;
  end
  else begin
    axi_req_cnt_reg <= axi_req_cnt;
    axi_req_wd_cnt_reg <= axi_req_wd_cnt;
    axi_req_rd_cnt_reg <= axi_req_rd_cnt;
    axi_req_wr_cnt_reg <= axi_req_wr_cnt;
  end
  end
end

assign axi_req_cnt = axi_req_update ? (axi_req_cnt_reg + 1'b1) : axi_req_cnt_reg;
assign axi_req_wd_cnt = axi_req_wd_update ? (axi_req_wd_cnt_reg + 1'b1) : axi_req_wd_cnt_reg;

assign axi_req_rd_cnt = (axi_arvalid & axi_arready) ? (axi_req_rd_cnt_reg + 1'b1) : axi_req_rd_cnt_reg;
assign axi_req_wr_cnt = (axi_wvalid & axi_wready & axi_wlast) ? (axi_req_wr_cnt_reg + 1'b1) : axi_req_wr_cnt_reg;

// single read or write cmd(with only 1 data phase) accepted
assign axi_single_rwcmd_accept = axi_axrw ? (axi_arvalid & axi_arready) : (axi_awvalid & axi_awready & axi_wvalid & axi_wready & axi_wlast);

// state machine for axi request channel
// ISSUE:
//  1) if axi_dual_cmd_mode==1, fetch next cmd and jump to ISSUE_DUAL state
//  2) else if arcmd or awcmd/wlast accepted
//      a) if more wdata phase required for a write cmd, jump to WDATA state
//      b) else if it's the last cmd, return to IDLE state
//      c) else fetch next cmd and stay ISSUE state
// ISSUE_DUAL:
//  1) if both r/w cmd accepted
//      a) if more data phase required, jump to WDATA state
//      b) else if it's the last cmd, jump to IDLE state
//      a) else jump to ISSUE state
//  2) else stay ISSUE_DUAL state
// WDATA:
//  1) if it's the last cmd, jump to IDLE state
//  2) else if it's the last wdata phase for curr cmd, jump to ISSUE state
//  3) else stay WDATA state.


//## fsm (1) output

//|	-one_hot_states
//|	-no_assert_state_x
//|	-no_testpoints
//|	REGISTERS
//|	  req_state <= nxt_req_state;
//|	  axi_req_update = 1'b0;
//|	RESET
//|	  IDLE <- ;
//|	ADVANCE
//|	  <- 1;
//|	STATES
//|	IDLE :
//|		ISSUE <- test_cmd_issuing;
//|	ISSUE :
//|		if(axi_dual_cmd_mode | axi_single_rwcmd_accept) 
//|		  axi_req_update=1;
//|		ISSUE_DUAL <- axi_dual_cmd_mode;
//|		WDATA <- (~axi_axrw & axi_awvalid & axi_awready & (~(axi_wvalid & axi_wready) | (|axi_awlen)));
//|		IDLE <- !test_cmd_issuing;
//|	ISSUE_DUAL :
//|		if(axi_arcmd_accept & axi_awcmd_accept & axi_wdata_accept & (axi_wdata_phase_cnt == axi_awlen+1))
//|		  axi_req_update=1;
//|		WDATA <- (axi_arcmd_accept & axi_awcmd_accept & (axi_wdata_phase_cnt < axi_awlen+1));
//|		IDLE  <- (axi_arcmd_accept & axi_awcmd_accept & !test_cmd_issuing);
//|		ISSUE <- (axi_arcmd_accept & axi_awcmd_accept);
//|		if(axi_wdata_phase_cnt == (axi_awlen+1))
//|		  axi_req_update=1;
//|		IDLE <- !test_cmd_issuing;
//|		ISSUE <- (axi_wvalid & axi_wready & (axi_wdata_phase_cnt == axi_awlen+1));
//|)

//## fsm (1) defines

`define IDLE 0
`define ISSUE 1
`define ISSUE_DUAL 2
`define WDATA 3

//## fsm (1) com block

always @(
  req_state
  or test_cmd_issuing
  or axi_dual_cmd_mode
  or axi_single_rwcmd_accept
  or axi_axrw
  or axi_awvalid
  or axi_awready
  or axi_wvalid
  or axi_wready
  or axi_awlen
  or axi_arcmd_accept
  or axi_awcmd_accept
  or axi_wdata_accept
  or axi_wdata_phase_cnt
  ) begin
  nxt_req_state = req_state;
  axi_req_update = 1'b0;
  begin
    casez (1'b1)  // spyglass disable W226
      req_state[`IDLE]: begin // spyglass disable W225 W171
        if (test_cmd_issuing) begin
          nxt_req_state = 4'd1 << `ISSUE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((test_cmd_issuing) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      req_state[`ISSUE]: begin // spyglass disable W225 W171
        if(axi_dual_cmd_mode | axi_single_rwcmd_accept)
        axi_req_update=1;
        if (axi_dual_cmd_mode) begin
          nxt_req_state = 4'd1 << `ISSUE_DUAL; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((axi_dual_cmd_mode) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((~axi_axrw & axi_awvalid & axi_awready & (~(axi_wvalid & axi_wready) | (|axi_awlen)))) begin
          nxt_req_state = 4'd1 << `WDATA; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((~axi_axrw & axi_awvalid & axi_awready & (~(axi_wvalid & axi_wready) | (|axi_awlen)))) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (!test_cmd_issuing) begin
          nxt_req_state = 4'd1 << `IDLE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((!test_cmd_issuing) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      req_state[`ISSUE_DUAL]: begin // spyglass disable W225 W171
        if(axi_arcmd_accept & axi_awcmd_accept & axi_wdata_accept & (axi_wdata_phase_cnt == axi_awlen+1))
        axi_req_update=1;
        if ((axi_arcmd_accept & axi_awcmd_accept & (axi_wdata_phase_cnt < axi_awlen+1))) begin
          nxt_req_state = 4'd1 << `WDATA; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((axi_arcmd_accept & axi_awcmd_accept & (axi_wdata_phase_cnt < axi_awlen+1))) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((axi_arcmd_accept & axi_awcmd_accept & !test_cmd_issuing)) begin
          nxt_req_state = 4'd1 << `IDLE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((axi_arcmd_accept & axi_awcmd_accept & !test_cmd_issuing)) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((axi_arcmd_accept & axi_awcmd_accept)) begin
          nxt_req_state = 4'd1 << `ISSUE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((axi_arcmd_accept & axi_awcmd_accept)) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      req_state[`WDATA]: begin // spyglass disable W225 W171
        if(axi_wdata_phase_cnt == (axi_awlen+1))
        axi_req_update=1;
        if (!test_cmd_issuing) begin
          nxt_req_state = 4'd1 << `IDLE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((!test_cmd_issuing) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((axi_wvalid & axi_wready & (axi_wdata_phase_cnt == axi_awlen+1))) begin
          nxt_req_state = 4'd1 << `ISSUE; // spyglass disable W459
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((axi_wvalid & axi_wready & (axi_wdata_phase_cnt == axi_awlen+1))) === 1'bx) begin
          nxt_req_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      // VCS coverage off
      default: begin
        nxt_req_state = 4'd1 << `IDLE; // spyglass disable W459
        `ifndef SYNTHESIS
        nxt_req_state = {4{1'bx}};
        `endif
      end
      // VCS coverage on
    endcase
  end
end

//## fsm (1) seq block

always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    req_state <= 4'd1 << 0; // spyglass disable W459
  end else begin
  req_state <= nxt_req_state;
  end
end


assign axi_req_wd_update = axi_wvalid & axi_wready;

// judge when to exit from ISSUE_DUAL state.
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_arcmd_accept_reg <= 1'b0;
    axi_awcmd_accept_reg <= 1'b0;
    axi_wdata_accept_reg <= 1'b0;
  end else begin
  if(req_state[`ISSUE_DUAL]) begin
    axi_arcmd_accept_reg <= axi_arcmd_accept;
    axi_awcmd_accept_reg <= axi_awcmd_accept;
    axi_wdata_accept_reg <= axi_wdata_accept;
  end
  else begin
    axi_arcmd_accept_reg <= 0;
    axi_awcmd_accept_reg <= 0;
    axi_wdata_accept_reg <= 0;
  end
  end
end

assign axi_arcmd_accept = req_state[`ISSUE_DUAL] ? (axi_arcmd_accept_reg | axi_arready) : 0;
assign axi_awcmd_accept = req_state[`ISSUE_DUAL] ? (axi_awcmd_accept_reg | axi_awready) : 0;
assign axi_wdata_accept = req_state[`ISSUE_DUAL] ? (axi_wdata_accept_reg | (axi_wvalid & axi_wready)) : 0;

// caculate how many wdata phase finished in one single cmd
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_wdata_phase_cnt_reg <= {9{1'b0}};
  end else begin
  if(status_clear)
    axi_wdata_phase_cnt_reg <= 9'b0;
  else
    axi_wdata_phase_cnt_reg <= axi_wdata_phase_cnt;
  end
end

assign axi_wdata_phase_cnt = (axi_wvalid & axi_wready) ? (axi_awvalid & axi_awready) ? 1 : (axi_wdata_phase_cnt_reg + 1'b1) 
                                                       : (axi_awvalid & axi_awready) ? 0 : axi_wdata_phase_cnt_reg;

// assignment of axi cmd channel
assign axi_arid     = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axid_reg      : axi_axrw ? axi_axid : 0;
assign axi_araddr   = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axaddr_reg    : axi_axrw ? axi_axaddr : 0;
assign axi_arlen    = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axlen_reg     : axi_axrw ? axi_axlen : 0;
assign axi_arburst  = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axburst_reg   : axi_axrw ? axi_axburst : 0;
assign axi_arsize   = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axsize_reg    : axi_axrw ? axi_axsize : 0;
assign axi_aruser   = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axuser_reg    : axi_axrw ? axi_axuser : 0;
assign axi_arcache  = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axcache_reg   : axi_axrw ? axi_axcache : 0;
assign axi_arprot   = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axprot_reg    : axi_axrw ? axi_axprot : 0;
assign axi_arlock   = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axlock_reg    : axi_axrw ? axi_axlock : 0;
assign axi_arqos    = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axqos_reg     : axi_axrw ? axi_axqos : 0;
assign axi_arregion = (req_state[`ISSUE_DUAL] & axi_axrw_reg) ? axi_axregion_reg  : axi_axrw ? axi_axregion : 0;

assign axi_awid     = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axid_reg     : ~axi_axrw ? axi_axid : 0;
assign axi_awaddr   = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axaddr_reg   : ~axi_axrw ? axi_axaddr : 0;
assign axi_awlen    = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axlen_reg    : ~axi_axrw ? axi_axlen : 0;
assign axi_awburst  = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axburst_reg  : ~axi_axrw ? axi_axburst : 0;
assign axi_awsize   = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axsize_reg   : ~axi_axrw ? axi_axsize : 0;
assign axi_awuser   = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axuser_reg   : ~axi_axrw ? axi_axuser : 0;
assign axi_awcache  = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axcache_reg  : ~axi_axrw ? axi_axcache : 0;
assign axi_awprot   = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axprot_reg   : ~axi_axrw ? axi_axprot : 0;
assign axi_awlock   = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axlock_reg   : ~axi_axrw ? axi_axlock : 0;
assign axi_awqos    = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axqos_reg    : ~axi_axrw ? axi_axqos : 0;
assign axi_awregion = (req_state[`ISSUE_DUAL] & ~axi_axrw_reg) ? axi_axregion_reg : ~axi_axrw ? axi_axregion : 0;

// generate axi_arvalid signal
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_arvalid_reg <= 1'b0;
  end else begin
  if(axi_arvalid & axi_arready) //de-assert it when received arready in ISSUE_DUAL state
    axi_arvalid_reg <= 0;
  else if(req_state[`ISSUE] & axi_dual_cmd_mode) // assert it before enter ISSUE_DUAL state
    axi_arvalid_reg <= 1;
  else
    axi_arvalid_reg <= axi_arvalid;
  end
end

assign axi_arvalid = ((req_state[`ISSUE] & axi_axrw & !axi_dual_cmd_mode & axi_req_dly1_done & !axi_rd_req_wait) | (req_state[`ISSUE_DUAL] & axi_arvalid_reg)) & (axi_arcmd_pend_cnt <axi_cmd_pend_num_max); // spyglass disable W362

// generate axi_awvalid signal
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_awvalid_reg <= 1'b0;
  end else begin
  if(axi_awvalid & axi_awready)
    axi_awvalid_reg <= 0;
  else if(req_state[`ISSUE] & axi_dual_cmd_mode) // assert it before enter ISSUE_DUAL state
    axi_awvalid_reg <= 1;
  else
    axi_awvalid_reg <= axi_awvalid;
  end
end

assign axi_awvalid = ((req_state[`ISSUE] & ~axi_axrw & !axi_dual_cmd_mode & axi_req_dly1_done) | (req_state[`ISSUE_DUAL] & axi_awvalid_reg)) & (axi_awcmd_pend_cnt <axi_cmd_pend_num_max); // spyglass disable W362

// generate axi_wvalid_signal. assert if not IDLE state & Write CMD & awready-wvalid delay done.
assign axi_wvalid = (~req_state[`IDLE] & ~axi_axrw & axi_req_dly2_done & axi_req_dly1_done);

// assignment of write data signal
assign axi_wdata = axi_req_wdata;
assign axi_wstrb = axi_req_wstrb;

assign axi_wlast =  (|axi_awlen) ? ~axi_awvalid & axi_wvalid & (axi_wdata_phase_cnt == (axi_awlen + 1)) : axi_wvalid & (axi_wdata_phase_cnt == (axi_awlen + 1));

// delay control for command channel.
// dly1: (axvalid & axready) to next (axvalid) delay cycles.
// dly2: (awvalid & awready) to (wvalid) delay cycles
always @(posedge axi_clk or negedge axi_rstn) begin
  if (!axi_rstn) begin
    axi_req_dly1_cnt <= {8{1'b0}};
    axi_req_dly2_cnt <= {8{1'b0}};
  end else begin
  if(~test_cmd_issuing | axi_req_update) begin
    axi_req_dly1_cnt <= 0;
    axi_req_dly2_cnt <= 0;
  end
  else begin
    axi_req_dly1_cnt <= axi_req_dly1_cnt + 1'b1;
    axi_req_dly2_cnt <= axi_req_dly2_cnt + 1'b1;
  end
  end
end

assign axi_req_dly1_done = (axi_req_dly1_cnt >= axi_axdly1_reg);
assign axi_req_dly2_done = (axi_req_dly2_cnt >= axi_axdly2_reg);

// registers assignment

endmodule // NV_FPGA_unit_checkbox_mem_dut_axi_req_256


