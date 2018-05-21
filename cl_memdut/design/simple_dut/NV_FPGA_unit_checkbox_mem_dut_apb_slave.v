// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut_apb_slave.v

module NV_FPGA_unit_checkbox_mem_dut_apb_slave (
   apb_clk
  ,apb_rstn
  ,apb_paddr
  ,apb_penable
  ,apb_pns
  ,apb_psel
  ,apb_puser
  ,apb_pwdata
  ,apb_pwrite
  ,apb_pwstrb
  ,axi_0_prdata
  ,axi_1_prdata
  ,axi_2_prdata
  ,axi_3_prdata
  ,intr_in
  ,test_complete_0
  ,test_complete_1
  ,test_complete_2
  ,test_complete_3
  ,apb_prdata
  ,apb_pready
  ,apb_pslverr
  ,apb_wr_op
  ,axi_0_cmd_ram_sel
  ,axi_0_paddr
  ,axi_0_rdata_ram_sel
  ,axi_0_reg_sel
  ,axi_0_wdata_ram_sel
  ,axi_0_wstrb_ram_sel
  ,axi_1_cmd_ram_sel
  ,axi_1_paddr
  ,axi_1_rdata_ram_sel
  ,axi_1_reg_sel
  ,axi_1_wdata_ram_sel
  ,axi_1_wstrb_ram_sel
  ,axi_2_cmd_ram_sel
  ,axi_2_paddr
  ,axi_2_rdata_ram_sel
  ,axi_2_reg_sel
  ,axi_2_wdata_ram_sel
  ,axi_2_wstrb_ram_sel
  ,axi_3_cmd_ram_sel
  ,axi_3_paddr
  ,axi_3_rdata_ram_sel
  ,axi_3_reg_sel
  ,axi_3_wdata_ram_sel
  ,axi_3_wstrb_ram_sel
  ,intr_out
  );
input         apb_clk;
input         apb_rstn;
input  [23:0] apb_paddr;
input         apb_penable;
input         apb_pns;
input         apb_psel;
input  [12:0] apb_puser;
input  [31:0] apb_pwdata;
input         apb_pwrite;
input   [3:0] apb_pwstrb;
input  [31:0] axi_0_prdata;
input  [31:0] axi_1_prdata;
input  [31:0] axi_2_prdata;
input  [31:0] axi_3_prdata;
input  [31:0] intr_in;
input         test_complete_0;
input         test_complete_1;
input         test_complete_2;
input         test_complete_3;
output [31:0] apb_prdata;
output        apb_pready;
output        apb_pslverr;
output        apb_wr_op;
output        axi_0_cmd_ram_sel;
output [23:0] axi_0_paddr;
output        axi_0_rdata_ram_sel;
output        axi_0_reg_sel;
output        axi_0_wdata_ram_sel;
output        axi_0_wstrb_ram_sel;
output        axi_1_cmd_ram_sel;
output [23:0] axi_1_paddr;
output        axi_1_rdata_ram_sel;
output        axi_1_reg_sel;
output        axi_1_wdata_ram_sel;
output        axi_1_wstrb_ram_sel;
output        axi_2_cmd_ram_sel;
output [23:0] axi_2_paddr;
output        axi_2_rdata_ram_sel;
output        axi_2_reg_sel;
output        axi_2_wdata_ram_sel;
output        axi_2_wstrb_ram_sel;
output        axi_3_cmd_ram_sel;
output [23:0] axi_3_paddr;
output        axi_3_rdata_ram_sel;
output        axi_3_reg_sel;
output        axi_3_wdata_ram_sel;
output        axi_3_wstrb_ram_sel;
output [31:0] intr_out;
reg    [31:0] apb_delay_reg;
reg    [31:0] apb_prdata;
reg     [7:0] apb_rd_cnt_reg;
reg    [31:0] apb_test_reg1;
reg    [31:0] apb_test_reg2;
reg    [31:0] apb_test_reg_prdata;
reg     [7:0] apb_wr_cnt_reg;
reg    [31:0] intr_reg;
reg    [31:0] reg_apb_timer;
reg    [31:0] reg_intr_test_clear;
reg    [31:0] reg_intr_test_clear_1t;
reg    [31:0] reg_intr_test_en;
reg    [31:0] reg_intr_test_mode1;
reg    [31:0] reg_intr_test_mode2;
reg    [31:0] reg_intr_test_set;
wire          apb_delay_done;
wire          apb_delay_reg_sel;
wire    [7:0] apb_rd_cnt;
wire          apb_rd_op;
wire    [7:0] apb_rd_random_delay;
wire          apb_test_reg1_sel;
wire          apb_test_reg2_sel;
wire          apb_test_reg3_sel;
wire          apb_test_reg4_sel;
wire          apb_test_reg_sel;
wire          apb_timer_reg_sel;
wire    [7:0] apb_wr_cnt;
wire    [7:0] apb_wr_random_delay;
wire    [3:0] axi_0_base_addr;
wire          axi_0_sel;
wire    [3:0] axi_1_base_addr;
wire          axi_1_sel;
wire    [3:0] axi_2_base_addr;
wire          axi_2_sel;
wire    [3:0] axi_3_base_addr;
wire          axi_3_sel;
wire          intr_test_reg_sel;
wire   [31:0] reg_intr_test_downstream;


//input          apb_psel;
//input          apb_penable;
//input          apb_pwrite;
//input          apb_pns;
//input [3:0]    apb_pwstrb;
//input [23:0]   apb_paddr;
//input [31:0]   apb_pwdata;
//output           apb_pslverr;
//output           apb_pready;
//output  [31:0]   apb_prdata;




/////////////////////////////////////////////////////////////////////////////////
// address decode
/////////////////////////////////////////////////////////////////////////////////

parameter APB_BASE_ADDR  = 24'h000000;
parameter AXI_PORT_SPACE = 24'h100000;

// use APB_REG1 to define APB_WR_RAMDOM_DELAY and APB_RD_RANDOM_DELAY.
parameter APB_DELAY_REG_OFFSET = 16'h0080;
parameter APB_TIMER_REG_OFFSET = 16'h0084;
parameter APB_TEST_REG1_OFFSET = 16'h0100;
parameter APB_TEST_REG2_OFFSET = 16'h0104;
parameter APB_TEST_REG3_OFFSET = 16'h0108;
parameter APB_TEST_REG4_OFFSET = 16'h010C;

parameter INTR_TEST_REG_BASE = 16'h2000;
parameter INTR_TEST_SET_REG = 8'h00;    // write 1 to set interrupt bits
parameter INTR_TEST_CLEAR_REG = 8'h04;  // write 1 to clear interrupt bits
parameter INTR_TEST_MODE1_REG = 8'h08;  // set interrupt type: level or pulse
parameter INTR_TEST_MODE2_REG = 8'h0C;  // set 1 to enable assert interrupt imediately after clear that bit.
parameter INTR_TEST_EN_REG    = 8'h10;  // enable interrupt bits.

parameter INTR_TEST_DOWNSTREAM_REG = 8'h20;

// bit [19:16]
`define NV_FPGA_UNIT_MEM_DUT_AXI_REG_BASE        4'h0
`define NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE    4'h1
`define NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE     4'h3
`define NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE  4'h4
`define NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE  4'hA

assign axi_0_base_addr = (APB_BASE_ADDR[23:20] + (AXI_PORT_SPACE[23:20]*0));
assign axi_0_paddr = (apb_paddr - {axi_0_base_addr, 20'b0}); // spyglass disable W484
assign axi_0_sel = apb_psel & (apb_paddr[23:20] == axi_0_base_addr);
assign axi_0_reg_sel        = axi_0_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_REG_BASE      ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  );
assign axi_0_cmd_ram_sel    = axi_0_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   );
assign axi_0_wstrb_ram_sel  = axi_0_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE);
assign axi_0_wdata_ram_sel  = axi_0_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE);
assign axi_0_rdata_ram_sel  = axi_0_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE) & (apb_paddr[19:16] < AXI_PORT_SPACE[23:16]);

assign axi_1_base_addr = (APB_BASE_ADDR[23:20] + (AXI_PORT_SPACE[23:20]*1));
assign axi_1_paddr = (apb_paddr - {axi_1_base_addr, 20'b0}); // spyglass disable W484
assign axi_1_sel = apb_psel & (apb_paddr[23:20] == axi_1_base_addr);
assign axi_1_reg_sel        = axi_1_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_REG_BASE      ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  );
assign axi_1_cmd_ram_sel    = axi_1_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   );
assign axi_1_wstrb_ram_sel  = axi_1_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE);
assign axi_1_wdata_ram_sel  = axi_1_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE);
assign axi_1_rdata_ram_sel  = axi_1_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE) & (apb_paddr[19:16] < AXI_PORT_SPACE[23:16]);

assign axi_2_base_addr = (APB_BASE_ADDR[23:20] + (AXI_PORT_SPACE[23:20]*2));
assign axi_2_paddr = (apb_paddr - {axi_2_base_addr, 20'b0}); // spyglass disable W484
assign axi_2_sel = apb_psel & (apb_paddr[23:20] == axi_2_base_addr);
assign axi_2_reg_sel        = axi_2_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_REG_BASE      ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  );
assign axi_2_cmd_ram_sel    = axi_2_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   );
assign axi_2_wstrb_ram_sel  = axi_2_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE);
assign axi_2_wdata_ram_sel  = axi_2_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE);
assign axi_2_rdata_ram_sel  = axi_2_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE) & (apb_paddr[19:16] < AXI_PORT_SPACE[23:16]);

assign axi_3_base_addr = (APB_BASE_ADDR[23:20] + (AXI_PORT_SPACE[23:20]*3));
assign axi_3_paddr = (apb_paddr - {axi_3_base_addr, 20'b0}); // spyglass disable W484
assign axi_3_sel = apb_psel & (apb_paddr[23:20] == axi_3_base_addr);
assign axi_3_reg_sel        = axi_3_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_REG_BASE      ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  );
assign axi_3_cmd_ram_sel    = axi_3_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_CMD_RAM_BASE  ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   );
assign axi_3_wstrb_ram_sel  = axi_3_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WE_RAM_BASE   ) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE);
assign axi_3_wdata_ram_sel  = axi_3_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_WDATA_RAM_BASE) & (apb_paddr[19:16] < `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE);
assign axi_3_rdata_ram_sel  = axi_3_sel & (apb_paddr[19:16] >= `NV_FPGA_UNIT_MEM_DUT_AXI_RDATA_RAM_BASE) & (apb_paddr[19:16] < AXI_PORT_SPACE[23:16]);


assign apb_test_reg1_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_TEST_REG1_OFFSET[15:2]);
assign apb_test_reg2_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_TEST_REG2_OFFSET[15:2]);
assign apb_test_reg3_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_TEST_REG3_OFFSET[15:2]);
assign apb_test_reg4_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_TEST_REG4_OFFSET[15:2]);
assign apb_delay_reg_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_DELAY_REG_OFFSET[15:2]);
assign intr_test_reg_sel = axi_0_reg_sel & (apb_paddr[15:8] == INTR_TEST_REG_BASE[15:8]);
assign apb_timer_reg_sel = axi_0_reg_sel & (apb_paddr[15:2] == APB_TIMER_REG_OFFSET[15:2]);

assign apb_test_reg_sel = apb_test_reg1_sel | apb_test_reg2_sel | apb_test_reg3_sel | apb_test_reg4_sel | apb_delay_reg_sel | intr_test_reg_sel;

/////////////////////////////////////////////////////////////////////////////////
// data path connect
/////////////////////////////////////////////////////////////////////////////////

always @(
  axi_0_sel
  or apb_test_reg_sel
  or apb_test_reg_prdata
  or axi_0_prdata
  or axi_1_sel
  or axi_1_prdata
  or axi_2_sel
  or axi_2_prdata
  or axi_3_sel
  or axi_3_prdata
  ) begin
  case(1'b1) // spyglass disable W226
  axi_0_sel: apb_prdata = apb_test_reg_sel ? apb_test_reg_prdata : axi_0_prdata; // spyglass disable W171
  axi_1_sel: apb_prdata = axi_1_prdata; // spyglass disable W171
  axi_2_sel: apb_prdata = axi_2_prdata; // spyglass disable W171
  axi_3_sel: apb_prdata = axi_3_prdata; // spyglass disable W171
  default: apb_prdata = 0;
  endcase
end

always @(
  apb_test_reg1_sel
  or apb_test_reg1
  or apb_test_reg2_sel
  or apb_test_reg2
  or apb_test_reg3_sel
  or apb_test_reg4_sel
  or apb_puser
  or apb_delay_reg_sel
  or apb_delay_reg
  or intr_test_reg_sel
  or apb_paddr
  or reg_intr_test_set
  or reg_intr_test_clear
  or reg_intr_test_mode1
  or reg_intr_test_mode2
  or reg_intr_test_en
  or reg_intr_test_downstream
  ) begin
  if(apb_test_reg1_sel)
    apb_test_reg_prdata = apb_test_reg1;
  else if(apb_test_reg2_sel)
    apb_test_reg_prdata = apb_test_reg2;
  else if(apb_test_reg3_sel)
    apb_test_reg_prdata = 32'b0;
  else if(apb_test_reg4_sel)
    apb_test_reg_prdata = {19'b0, apb_puser};
  else if(apb_delay_reg_sel)
    apb_test_reg_prdata = apb_delay_reg;
  else if(intr_test_reg_sel)
    case(apb_paddr[7:0])
    INTR_TEST_SET_REG   : apb_test_reg_prdata = reg_intr_test_set;
    INTR_TEST_CLEAR_REG : apb_test_reg_prdata = reg_intr_test_clear;
    INTR_TEST_MODE1_REG : apb_test_reg_prdata = reg_intr_test_mode1;
    INTR_TEST_MODE2_REG : apb_test_reg_prdata = reg_intr_test_mode2;
    INTR_TEST_EN_REG    : apb_test_reg_prdata = reg_intr_test_en;   
    INTR_TEST_DOWNSTREAM_REG : apb_test_reg_prdata = reg_intr_test_downstream;
    default: apb_test_reg_prdata = 0;
    endcase
  else
    apb_test_reg_prdata = 0;
end

//&PerlBeg;
//  foreach my $axi_port_num (0..(AXI_MASTER_NUM-1)) {
//    vprintl
//"assign axi_0_pwdata = axi_${axi_port_num}_sel ? apb_pwdata : 0;";
//  }
//&PerlEnd;
//
//assign apb_test_reg_pwdata = apb_pwdata;

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    reg_intr_test_set <= {32{1'b0}};
    reg_intr_test_clear <= {32{1'b0}};
    reg_intr_test_clear_1t <= {32{1'b0}};
    apb_test_reg1[7:0] <= {8{1'b0}};
    apb_test_reg1[15:8] <= {8{1'b0}};
    apb_test_reg1[23:16] <= {8{1'b0}};
    apb_test_reg1[31:24] <= {8{1'b0}};
    apb_test_reg2[7:0] <= {8{1'b0}};
    apb_test_reg2[15:8] <= {8{1'b0}};
    apb_test_reg2[23:16] <= {8{1'b0}};
    apb_test_reg2[31:24] <= {8{1'b0}};
    apb_delay_reg[31:0] <= {32{1'b0}};
    reg_intr_test_mode1 <= {32{1'b0}};
    reg_intr_test_mode2 <= {32{1'b0}};
    reg_intr_test_en <= {32{1'b0}};
  end else begin
  reg_intr_test_set   <= 0;
  reg_intr_test_clear <= 0;
  reg_intr_test_clear_1t <= reg_intr_test_clear;
  if (apb_wr_op == 1'b1) begin
    if(apb_test_reg1_sel) begin
      apb_test_reg1[7:0]   <= apb_pwstrb[0] ? apb_pwdata[7:0]   : apb_test_reg1[7:0]; // spyglass disable W171
      apb_test_reg1[15:8]  <= apb_pwstrb[1] ? apb_pwdata[15:8]  : apb_test_reg1[15:8]; // spyglass disable W171
      apb_test_reg1[23:16] <= apb_pwstrb[2] ? apb_pwdata[23:16] : apb_test_reg1[23:16]; // spyglass disable W171
      apb_test_reg1[31:24] <= apb_pwstrb[3] ? apb_pwdata[31:24] : apb_test_reg1[31:24]; // spyglass disable W171
    end
    else if(apb_test_reg2_sel) begin
      apb_test_reg2[7:0]   <= apb_pwstrb[0] ? apb_pwdata[7:0]   : apb_test_reg2[7:0]; // spyglass disable W171
      apb_test_reg2[15:8]  <= apb_pwstrb[1] ? apb_pwdata[15:8]  : apb_test_reg2[15:8]; // spyglass disable W171
      apb_test_reg2[23:16] <= apb_pwstrb[2] ? apb_pwdata[23:16] : apb_test_reg2[23:16]; // spyglass disable W171
      apb_test_reg2[31:24] <= apb_pwstrb[3] ? apb_pwdata[31:24] : apb_test_reg2[31:24]; // spyglass disable W171
    end
    else if(apb_delay_reg_sel)
      apb_delay_reg[31:0] <= apb_pwdata[31:0]; // spyglass disable W171
    else if(intr_test_reg_sel)
      case(apb_paddr[7:0]) //spyglass disable W71
      INTR_TEST_SET_REG   : reg_intr_test_set   <= apb_pwdata;
      INTR_TEST_CLEAR_REG : reg_intr_test_clear <= apb_pwdata;
      INTR_TEST_MODE1_REG : reg_intr_test_mode1 <= apb_pwdata | 32'h0000_000F;
      INTR_TEST_MODE2_REG : reg_intr_test_mode2 <= apb_pwdata & 32'hFFFF_FFF0;
      INTR_TEST_EN_REG    : reg_intr_test_en    <= apb_pwdata;
      endcase
  end
  end
end

assign apb_wr_random_delay = apb_delay_reg[7:0];
assign apb_rd_random_delay = apb_delay_reg[15:8];

/////////////////////////////////////////////////////////////////////////////////
// apb interface flow control 
/////////////////////////////////////////////////////////////////////////////////

assign apb_pslverr =  apb_test_reg3_sel;
assign apb_pready = apb_penable & apb_delay_done;

assign apb_delay_done = apb_pwrite ? (apb_wr_cnt > apb_wr_random_delay) : (apb_rd_cnt > apb_rd_random_delay);

assign apb_wr_cnt = (apb_psel & apb_pwrite & ~apb_penable) ? 0 : (apb_wr_cnt_reg + 1'b1);
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    apb_wr_cnt_reg <= {8{1'b0}};
  end else begin
  apb_wr_cnt_reg <= apb_wr_cnt;
  end
end

assign apb_rd_cnt = (apb_psel & ~apb_pwrite & ~apb_penable) ? 0 : (apb_rd_cnt_reg + 1'b1);
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    apb_rd_cnt_reg <= {8{1'b0}};
  end else begin
  apb_rd_cnt_reg <= apb_rd_cnt;
  end
end

assign apb_wr_op = apb_psel & apb_pwrite & apb_penable;
assign apb_rd_op = apb_psel & ~apb_pwrite & apb_penable;

/////////////////////////////////////////////////////////////////////////////////
// interrupt generation for testing
/////////////////////////////////////////////////////////////////////////////////

// upstream interrupt
// bit 0: assert if test_complete assertd; de-assert if (clear it or in pulse intr mode)
// bit 1-31: assert if (set it or clear it in back-to-back intr mode); de-assert if (clear it or in pulse intr mode)
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[0] <= 1'b0;
  end else begin
    if(test_complete_0)
      intr_reg[0] <= 1'b1;
    else if(intr_reg[0] & (reg_intr_test_clear[0] | reg_intr_test_mode1[0]))
      intr_reg[0] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[1] <= 1'b0;
  end else begin
    if(test_complete_1)
      intr_reg[1] <= 1'b1;
    else if(intr_reg[1] & (reg_intr_test_clear[1] | reg_intr_test_mode1[1]))
      intr_reg[1] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[2] <= 1'b0;
  end else begin
    if(test_complete_2)
      intr_reg[2] <= 1'b1;
    else if(intr_reg[2] & (reg_intr_test_clear[2] | reg_intr_test_mode1[2]))
      intr_reg[2] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[3] <= 1'b0;
  end else begin
    if(test_complete_3)
      intr_reg[3] <= 1'b1;
    else if(intr_reg[3] & (reg_intr_test_clear[3] | reg_intr_test_mode1[3]))
      intr_reg[3] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[4] <= 1'b0;
  end else begin
    if(~intr_reg[4] & (reg_intr_test_set[4] | (reg_intr_test_clear_1t[4] & reg_intr_test_mode2[4])))
      intr_reg[4] <= 1'b1;
    else if(intr_reg[4] & (reg_intr_test_clear[4] | reg_intr_test_mode1[4]))
      intr_reg[4] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[5] <= 1'b0;
  end else begin
    if(~intr_reg[5] & (reg_intr_test_set[5] | (reg_intr_test_clear_1t[5] & reg_intr_test_mode2[5])))
      intr_reg[5] <= 1'b1;
    else if(intr_reg[5] & (reg_intr_test_clear[5] | reg_intr_test_mode1[5]))
      intr_reg[5] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[6] <= 1'b0;
  end else begin
    if(~intr_reg[6] & (reg_intr_test_set[6] | (reg_intr_test_clear_1t[6] & reg_intr_test_mode2[6])))
      intr_reg[6] <= 1'b1;
    else if(intr_reg[6] & (reg_intr_test_clear[6] | reg_intr_test_mode1[6]))
      intr_reg[6] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[7] <= 1'b0;
  end else begin
    if(~intr_reg[7] & (reg_intr_test_set[7] | (reg_intr_test_clear_1t[7] & reg_intr_test_mode2[7])))
      intr_reg[7] <= 1'b1;
    else if(intr_reg[7] & (reg_intr_test_clear[7] | reg_intr_test_mode1[7]))
      intr_reg[7] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[8] <= 1'b0;
  end else begin
    if(~intr_reg[8] & (reg_intr_test_set[8] | (reg_intr_test_clear_1t[8] & reg_intr_test_mode2[8])))
      intr_reg[8] <= 1'b1;
    else if(intr_reg[8] & (reg_intr_test_clear[8] | reg_intr_test_mode1[8]))
      intr_reg[8] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[9] <= 1'b0;
  end else begin
    if(~intr_reg[9] & (reg_intr_test_set[9] | (reg_intr_test_clear_1t[9] & reg_intr_test_mode2[9])))
      intr_reg[9] <= 1'b1;
    else if(intr_reg[9] & (reg_intr_test_clear[9] | reg_intr_test_mode1[9]))
      intr_reg[9] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[10] <= 1'b0;
  end else begin
    if(~intr_reg[10] & (reg_intr_test_set[10] | (reg_intr_test_clear_1t[10] & reg_intr_test_mode2[10])))
      intr_reg[10] <= 1'b1;
    else if(intr_reg[10] & (reg_intr_test_clear[10] | reg_intr_test_mode1[10]))
      intr_reg[10] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[11] <= 1'b0;
  end else begin
    if(~intr_reg[11] & (reg_intr_test_set[11] | (reg_intr_test_clear_1t[11] & reg_intr_test_mode2[11])))
      intr_reg[11] <= 1'b1;
    else if(intr_reg[11] & (reg_intr_test_clear[11] | reg_intr_test_mode1[11]))
      intr_reg[11] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[12] <= 1'b0;
  end else begin
    if(~intr_reg[12] & (reg_intr_test_set[12] | (reg_intr_test_clear_1t[12] & reg_intr_test_mode2[12])))
      intr_reg[12] <= 1'b1;
    else if(intr_reg[12] & (reg_intr_test_clear[12] | reg_intr_test_mode1[12]))
      intr_reg[12] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[13] <= 1'b0;
  end else begin
    if(~intr_reg[13] & (reg_intr_test_set[13] | (reg_intr_test_clear_1t[13] & reg_intr_test_mode2[13])))
      intr_reg[13] <= 1'b1;
    else if(intr_reg[13] & (reg_intr_test_clear[13] | reg_intr_test_mode1[13]))
      intr_reg[13] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[14] <= 1'b0;
  end else begin
    if(~intr_reg[14] & (reg_intr_test_set[14] | (reg_intr_test_clear_1t[14] & reg_intr_test_mode2[14])))
      intr_reg[14] <= 1'b1;
    else if(intr_reg[14] & (reg_intr_test_clear[14] | reg_intr_test_mode1[14]))
      intr_reg[14] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[15] <= 1'b0;
  end else begin
    if(~intr_reg[15] & (reg_intr_test_set[15] | (reg_intr_test_clear_1t[15] & reg_intr_test_mode2[15])))
      intr_reg[15] <= 1'b1;
    else if(intr_reg[15] & (reg_intr_test_clear[15] | reg_intr_test_mode1[15]))
      intr_reg[15] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[16] <= 1'b0;
  end else begin
    if(~intr_reg[16] & (reg_intr_test_set[16] | (reg_intr_test_clear_1t[16] & reg_intr_test_mode2[16])))
      intr_reg[16] <= 1'b1;
    else if(intr_reg[16] & (reg_intr_test_clear[16] | reg_intr_test_mode1[16]))
      intr_reg[16] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[17] <= 1'b0;
  end else begin
    if(~intr_reg[17] & (reg_intr_test_set[17] | (reg_intr_test_clear_1t[17] & reg_intr_test_mode2[17])))
      intr_reg[17] <= 1'b1;
    else if(intr_reg[17] & (reg_intr_test_clear[17] | reg_intr_test_mode1[17]))
      intr_reg[17] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[18] <= 1'b0;
  end else begin
    if(~intr_reg[18] & (reg_intr_test_set[18] | (reg_intr_test_clear_1t[18] & reg_intr_test_mode2[18])))
      intr_reg[18] <= 1'b1;
    else if(intr_reg[18] & (reg_intr_test_clear[18] | reg_intr_test_mode1[18]))
      intr_reg[18] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[19] <= 1'b0;
  end else begin
    if(~intr_reg[19] & (reg_intr_test_set[19] | (reg_intr_test_clear_1t[19] & reg_intr_test_mode2[19])))
      intr_reg[19] <= 1'b1;
    else if(intr_reg[19] & (reg_intr_test_clear[19] | reg_intr_test_mode1[19]))
      intr_reg[19] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[20] <= 1'b0;
  end else begin
    if(~intr_reg[20] & (reg_intr_test_set[20] | (reg_intr_test_clear_1t[20] & reg_intr_test_mode2[20])))
      intr_reg[20] <= 1'b1;
    else if(intr_reg[20] & (reg_intr_test_clear[20] | reg_intr_test_mode1[20]))
      intr_reg[20] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[21] <= 1'b0;
  end else begin
    if(~intr_reg[21] & (reg_intr_test_set[21] | (reg_intr_test_clear_1t[21] & reg_intr_test_mode2[21])))
      intr_reg[21] <= 1'b1;
    else if(intr_reg[21] & (reg_intr_test_clear[21] | reg_intr_test_mode1[21]))
      intr_reg[21] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[22] <= 1'b0;
  end else begin
    if(~intr_reg[22] & (reg_intr_test_set[22] | (reg_intr_test_clear_1t[22] & reg_intr_test_mode2[22])))
      intr_reg[22] <= 1'b1;
    else if(intr_reg[22] & (reg_intr_test_clear[22] | reg_intr_test_mode1[22]))
      intr_reg[22] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[23] <= 1'b0;
  end else begin
    if(~intr_reg[23] & (reg_intr_test_set[23] | (reg_intr_test_clear_1t[23] & reg_intr_test_mode2[23])))
      intr_reg[23] <= 1'b1;
    else if(intr_reg[23] & (reg_intr_test_clear[23] | reg_intr_test_mode1[23]))
      intr_reg[23] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[24] <= 1'b0;
  end else begin
    if(~intr_reg[24] & (reg_intr_test_set[24] | (reg_intr_test_clear_1t[24] & reg_intr_test_mode2[24])))
      intr_reg[24] <= 1'b1;
    else if(intr_reg[24] & (reg_intr_test_clear[24] | reg_intr_test_mode1[24]))
      intr_reg[24] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[25] <= 1'b0;
  end else begin
    if(~intr_reg[25] & (reg_intr_test_set[25] | (reg_intr_test_clear_1t[25] & reg_intr_test_mode2[25])))
      intr_reg[25] <= 1'b1;
    else if(intr_reg[25] & (reg_intr_test_clear[25] | reg_intr_test_mode1[25]))
      intr_reg[25] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[26] <= 1'b0;
  end else begin
    if(~intr_reg[26] & (reg_intr_test_set[26] | (reg_intr_test_clear_1t[26] & reg_intr_test_mode2[26])))
      intr_reg[26] <= 1'b1;
    else if(intr_reg[26] & (reg_intr_test_clear[26] | reg_intr_test_mode1[26]))
      intr_reg[26] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[27] <= 1'b0;
  end else begin
    if(~intr_reg[27] & (reg_intr_test_set[27] | (reg_intr_test_clear_1t[27] & reg_intr_test_mode2[27])))
      intr_reg[27] <= 1'b1;
    else if(intr_reg[27] & (reg_intr_test_clear[27] | reg_intr_test_mode1[27]))
      intr_reg[27] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[28] <= 1'b0;
  end else begin
    if(~intr_reg[28] & (reg_intr_test_set[28] | (reg_intr_test_clear_1t[28] & reg_intr_test_mode2[28])))
      intr_reg[28] <= 1'b1;
    else if(intr_reg[28] & (reg_intr_test_clear[28] | reg_intr_test_mode1[28]))
      intr_reg[28] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[29] <= 1'b0;
  end else begin
    if(~intr_reg[29] & (reg_intr_test_set[29] | (reg_intr_test_clear_1t[29] & reg_intr_test_mode2[29])))
      intr_reg[29] <= 1'b1;
    else if(intr_reg[29] & (reg_intr_test_clear[29] | reg_intr_test_mode1[29]))
      intr_reg[29] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[30] <= 1'b0;
  end else begin
    if(~intr_reg[30] & (reg_intr_test_set[30] | (reg_intr_test_clear_1t[30] & reg_intr_test_mode2[30])))
      intr_reg[30] <= 1'b1;
    else if(intr_reg[30] & (reg_intr_test_clear[30] | reg_intr_test_mode1[30]))
      intr_reg[30] <= 1'b0;
  end
end
always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    intr_reg[31] <= 1'b0;
  end else begin
    if(~intr_reg[31] & (reg_intr_test_set[31] | (reg_intr_test_clear_1t[31] & reg_intr_test_mode2[31])))
      intr_reg[31] <= 1'b1;
    else if(intr_reg[31] & (reg_intr_test_clear[31] | reg_intr_test_mode1[31]))
      intr_reg[31] <= 1'b0;
  end
end

assign intr_out = reg_intr_test_en & intr_reg;

// downstream interrupt
//assign reg_intr_test_downstream_wr = apb_wr_op & intr_test_reg_sel & (apb_paddr[7:0] == INTR_TEST_DOWNSTREAM_REG);
//
//&PerlBeg;
//foreach my $i (0..31) {
//  vprintl
//"&Always posedge;",
//"    if(intr_in[$i])",
//"      reg_intr_test_downstream[$i] <0= 1'b1;",
//"    else if(reg_intr_test_downstream_wr & apb_pwdata[$i])",
//"      reg_intr_test_downstream[$i] <0= 1'b0;",
//"&End;";
//}
//&PerlEnd;
assign reg_intr_test_downstream[31:0] = intr_in[31:0];

/////////////////////////////////////////////////////////////////////////////////
// general timer for debug use
/////////////////////////////////////////////////////////////////////////////////

always @(posedge apb_clk or negedge apb_rstn) begin
  if (!apb_rstn) begin
    reg_apb_timer <= {32{1'b0}};
  end else begin
    if(apb_wr_op & apb_timer_reg_sel)
      reg_apb_timer <= apb_pwdata;
    else
      reg_apb_timer <= reg_apb_timer + 1;
  end
end

endmodule // NV_FPGA_unit_checkbox_mem_dut_apb_slave

