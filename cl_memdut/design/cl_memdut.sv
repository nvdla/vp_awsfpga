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

module cl_memdut #(parameter NUM_DDR=4) 

(
   `include "cl_ports.vh"

);

//`include "cl_common_defines.vh"      // CL Defines for all examples
`include "cl_id_defines.vh"          // Defines for ID0 and ID1 (PCI ID's)
`include "cl_memdut_defines.vh"

// TIE OFF ALL UNUSED INTERFACES
// Including all the unused interface to tie off
// This list is put in the top of the fie to remind
// developers to remve the specific interfaces
// that the CL will use

`include "unused_ddr_a_b_d_template.inc"
`include "unused_pcim_template.inc"
`include "unused_cl_sda_template.inc"

// Define the addition pipeline stag
// needed to close timing for the various
// place where ATG (Automatic Test Generator)
// is defined
   
   localparam NUM_CFG_STGS_CL_DDR_ATG = 8;
   localparam NUM_CFG_STGS_SH_DDR_ATG = 4;
   localparam NUM_CFG_STGS_PCIE_ATG = 4;

// To reduce RTL simulation time, only 8KiB of
// each external DRAM is scrubbed in simulations

`ifdef SIM
   localparam DDR_SCRB_MAX_ADDR = 64'h1FFF;
`else   
   localparam DDR_SCRB_MAX_ADDR = 64'h3FFFFFFFF; //16GB 
`endif
   localparam DDR_SCRB_BURST_LEN_MINUS1 = 15;

`ifdef NO_CL_TST_SCRUBBER
   localparam NO_SCRB_INST = 1;
`else
   localparam NO_SCRB_INST = 0;
`endif   

//---------------------------- 
// Internal signals
//---------------------------- 
axi_bus_t sh_cl_dma_pcis_bus();
axi_bus_t sh_cl_dma_pcis_q();
// keep below memdut_axi_0/1 i/f same as nvdla configuration. Note: nvdla, axi_data_width=512,axi_len_width=4 
axi_bus_t #(.AWS_FPGA_AXI_BUS_DATA_WIDTH(256), .AWS_FPGA_AXI_BUS_ID_WIDTH(8), .AWS_FPGA_AXI_BUS_ADDR_WIDTH(40), .AWS_FPGA_AXI_BUS_LEN_WIDTH(4)) nvdla_dbb_axi_bus();
axi_bus_t #(.AWS_FPGA_AXI_BUS_DATA_WIDTH(256), .AWS_FPGA_AXI_BUS_ID_WIDTH(8), .AWS_FPGA_AXI_BUS_ADDR_WIDTH(40), .AWS_FPGA_AXI_BUS_LEN_WIDTH(4)) nvdla_cvsram_axi_bus();

axi_bus_t cl_sh_ddr_bus();

axi_bus_t #(.AWS_FPGA_AXI_BUS_DATA_WIDTH(32), .AWS_FPGA_AXI_BUS_ID_WIDTH(1), .AWS_FPGA_AXI_BUS_ADDR_WIDTH(32), .AWS_FPGA_AXI_BUS_LEN_WIDTH(1)) sh_ocl_bus();

axi_bus_t #(.AWS_FPGA_AXI_BUS_DATA_WIDTH(32), .AWS_FPGA_AXI_BUS_ID_WIDTH(1), .AWS_FPGA_AXI_BUS_ADDR_WIDTH(32), .AWS_FPGA_AXI_BUS_LEN_WIDTH(1)) sh_bar1_bus();

logic clk;
(* dont_touch = "true" *) logic pipe_rst_n;
logic pre_sync_rst_n;
(* dont_touch = "true" *) logic sync_rst_n;
logic sh_cl_flr_assert_q;

//---------------------------- 
// End Internal signals
//----------------------------

assign clk = clk_main_a0;

//reset synchronizer
lib_pipe #(.WIDTH(1), .STAGES(4)) PIPE_RST_N (.clk(clk), .rst_n(1'b1), .in_bus(rst_main_n), .out_bus(pipe_rst_n));
   
always_ff @(negedge pipe_rst_n or posedge clk)
   if (!pipe_rst_n)
   begin
      pre_sync_rst_n <= 0;
      sync_rst_n <= 0;
   end
   else
   begin
      pre_sync_rst_n <= 1;
      sync_rst_n <= pre_sync_rst_n;
   end

//FLR response 
always_ff @(negedge sync_rst_n or posedge clk)
   if (!sync_rst_n)
   begin
      sh_cl_flr_assert_q <= 0;
      cl_sh_flr_done <= 0;
   end
   else
   begin
      sh_cl_flr_assert_q <= sh_cl_flr_assert;
      cl_sh_flr_done <= sh_cl_flr_assert_q && !cl_sh_flr_done;
   end

//-------------------------------------------
// Tie-Off Global Signals
//-------------------------------------------
`ifndef CL_VERSION
   `define CL_VERSION 32'hee_ee_ee_00
`endif


  assign cl_sh_status0[31:0] =  32'h0000_0FF0;
  assign cl_sh_status1[31:0] = `CL_VERSION;

//-------------------------------------------------
// ID Values
//-------------------------------------------------
  assign cl_sh_id0[31:0] = `CL_SH_ID0;
  assign cl_sh_id1[31:0] = `CL_SH_ID1;


///////////////////////////////////////////////////////////////////////
///////////////// DMA PCIS SLAVE module ///////////////////////////////
///////////////////////////////////////////////////////////////////////
 
assign sh_cl_dma_pcis_bus.awvalid = sh_cl_dma_pcis_awvalid;
assign sh_cl_dma_pcis_bus.awaddr = sh_cl_dma_pcis_awaddr;
assign sh_cl_dma_pcis_bus.awid[5:0] = sh_cl_dma_pcis_awid;
assign sh_cl_dma_pcis_bus.awlen = sh_cl_dma_pcis_awlen;
assign sh_cl_dma_pcis_bus.awsize = sh_cl_dma_pcis_awsize;
assign cl_sh_dma_pcis_awready = sh_cl_dma_pcis_bus.awready;
assign sh_cl_dma_pcis_bus.wvalid = sh_cl_dma_pcis_wvalid;
assign sh_cl_dma_pcis_bus.wdata = sh_cl_dma_pcis_wdata;
assign sh_cl_dma_pcis_bus.wstrb = sh_cl_dma_pcis_wstrb;
assign sh_cl_dma_pcis_bus.wlast = sh_cl_dma_pcis_wlast;
assign cl_sh_dma_pcis_wready = sh_cl_dma_pcis_bus.wready;
assign cl_sh_dma_pcis_bvalid = sh_cl_dma_pcis_bus.bvalid;
assign cl_sh_dma_pcis_bresp = sh_cl_dma_pcis_bus.bresp;
assign sh_cl_dma_pcis_bus.bready = sh_cl_dma_pcis_bready;
assign cl_sh_dma_pcis_bid = sh_cl_dma_pcis_bus.bid[5:0];
assign sh_cl_dma_pcis_bus.arvalid = sh_cl_dma_pcis_arvalid;
assign sh_cl_dma_pcis_bus.araddr = sh_cl_dma_pcis_araddr;
assign sh_cl_dma_pcis_bus.arid[5:0] = sh_cl_dma_pcis_arid;
assign sh_cl_dma_pcis_bus.arlen = sh_cl_dma_pcis_arlen;
assign sh_cl_dma_pcis_bus.arsize = sh_cl_dma_pcis_arsize;
assign cl_sh_dma_pcis_arready = sh_cl_dma_pcis_bus.arready;
assign cl_sh_dma_pcis_rvalid = sh_cl_dma_pcis_bus.rvalid;
assign cl_sh_dma_pcis_rid = sh_cl_dma_pcis_bus.rid[5:0];
assign cl_sh_dma_pcis_rlast = sh_cl_dma_pcis_bus.rlast;
assign cl_sh_dma_pcis_rresp = sh_cl_dma_pcis_bus.rresp;
assign cl_sh_dma_pcis_rdata = sh_cl_dma_pcis_bus.rdata;
assign sh_cl_dma_pcis_bus.rready = sh_cl_dma_pcis_rready;

assign cl_sh_ddr_awid = cl_sh_ddr_bus.awid;
assign cl_sh_ddr_awaddr = cl_sh_ddr_bus.awaddr;
assign cl_sh_ddr_awlen = cl_sh_ddr_bus.awlen;
assign cl_sh_ddr_awsize = cl_sh_ddr_bus.awsize;
assign cl_sh_ddr_awvalid = cl_sh_ddr_bus.awvalid;
assign cl_sh_ddr_bus.awready = sh_cl_ddr_awready;
assign cl_sh_ddr_wid = 16'b0;
assign cl_sh_ddr_wdata = cl_sh_ddr_bus.wdata;
assign cl_sh_ddr_wstrb = cl_sh_ddr_bus.wstrb;
assign cl_sh_ddr_wlast = cl_sh_ddr_bus.wlast;
assign cl_sh_ddr_wvalid = cl_sh_ddr_bus.wvalid;
assign cl_sh_ddr_bus.wready = sh_cl_ddr_wready;
assign cl_sh_ddr_bus.bid = sh_cl_ddr_bid;
assign cl_sh_ddr_bus.bresp = sh_cl_ddr_bresp;
assign cl_sh_ddr_bus.bvalid = sh_cl_ddr_bvalid;
assign cl_sh_ddr_bready = cl_sh_ddr_bus.bready;
assign cl_sh_ddr_arid = cl_sh_ddr_bus.arid;
assign cl_sh_ddr_araddr = cl_sh_ddr_bus.araddr;
assign cl_sh_ddr_arlen = cl_sh_ddr_bus.arlen;
assign cl_sh_ddr_arsize = cl_sh_ddr_bus.arsize;
assign cl_sh_ddr_arvalid = cl_sh_ddr_bus.arvalid;
assign cl_sh_ddr_bus.arready = sh_cl_ddr_arready;
assign cl_sh_ddr_bus.rid = sh_cl_ddr_rid;
assign cl_sh_ddr_bus.rresp = sh_cl_ddr_rresp;
assign cl_sh_ddr_bus.rvalid = sh_cl_ddr_rvalid;
assign cl_sh_ddr_bus.rdata = sh_cl_ddr_rdata;
assign cl_sh_ddr_bus.rlast = sh_cl_ddr_rlast;
assign cl_sh_ddr_rready = cl_sh_ddr_bus.rready;

(* dont_touch = "true" *) logic dma_pcis_slv_sync_rst_n;
lib_pipe #(.WIDTH(1), .STAGES(4)) DMA_PCIS_SLV_SLC_RST_N (.clk(clk), .rst_n(1'b1), .in_bus(sync_rst_n), .out_bus(dma_pcis_slv_sync_rst_n));
cl_dma_pcis_slv #(.SCRB_BURST_LEN_MINUS1(DDR_SCRB_BURST_LEN_MINUS1),
                    .SCRB_MAX_ADDR(DDR_SCRB_MAX_ADDR),
                    .NO_SCRB_INST(NO_SCRB_INST)) CL_DMA_PCIS_SLV (
    .aclk(clk),
    .aresetn(dma_pcis_slv_sync_rst_n),

    .sh_cl_dma_pcis_bus(sh_cl_dma_pcis_bus),
    .nvdla_dbb_axi_bus(nvdla_dbb_axi_bus),
    .nvdla_cvsram_axi_bus(nvdla_cvsram_axi_bus),

    .sh_cl_dma_pcis_q(sh_cl_dma_pcis_q),

    .cl_sh_ddr_bus     (cl_sh_ddr_bus)
  );

///////////////////////////////////////////////////////////////////////
///////////////// DMA PCIS SLAVE module ///////////////////////////////
///////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////
///////////////// OCL SLAVE module ////////////////////////////////////
///////////////////////////////////////////////////////////////////////

assign sh_ocl_bus.awvalid = sh_ocl_awvalid;
assign sh_ocl_bus.awaddr[31:0] = sh_ocl_awaddr;
assign ocl_sh_awready = sh_ocl_bus.awready;
assign sh_ocl_bus.wvalid = sh_ocl_wvalid;
assign sh_ocl_bus.wdata[31:0] = sh_ocl_wdata;
assign sh_ocl_bus.wstrb[3:0] = sh_ocl_wstrb;
assign ocl_sh_wready = sh_ocl_bus.wready;
assign ocl_sh_bvalid = sh_ocl_bus.bvalid;
assign ocl_sh_bresp = sh_ocl_bus.bresp;
assign sh_ocl_bus.bready = sh_ocl_bready;
assign sh_ocl_bus.arvalid = sh_ocl_arvalid;
assign sh_ocl_bus.araddr[31:0] = sh_ocl_araddr;
assign ocl_sh_arready = sh_ocl_bus.arready;
assign ocl_sh_rvalid = sh_ocl_bus.rvalid;
assign ocl_sh_rresp = sh_ocl_bus.rresp;
assign ocl_sh_rdata = sh_ocl_bus.rdata[31:0];
assign sh_ocl_bus.rready = sh_ocl_rready;

(* dont_touch = "true" *) logic ocl_slv_sync_rst_n;
lib_pipe #(.WIDTH(1), .STAGES(4)) OCL_SLV_SLC_RST_N (.clk(clk), .rst_n(1'b1), .in_bus(sync_rst_n), .out_bus(ocl_slv_sync_rst_n));

///////////////////////////////////////////////////////////////////////
///////////////// OCL SLAVE module ////////////////////////////////////
///////////////////////////////////////////////////////////////////////


//----------------------------------------- 
// Interrrupt example  
//-----------------------------------------

(* dont_touch = "true" *) logic int_slv_sync_rst_n;
lib_pipe #(.WIDTH(1), .STAGES(4)) INT_SLV_SLC_RST_N (.clk(clk), .rst_n(1'b1), .in_bus(sync_rst_n), .out_bus(int_slv_sync_rst_n));

//----------------------------------------- 
// Interrrupt example  
//-----------------------------------------

//----------------------------------------- 
// BAR1 SLAVE module 
//-----------------------------------------

assign sh_bar1_bus.awvalid = sh_bar1_awvalid;
assign sh_bar1_bus.awaddr[31:0] = sh_bar1_awaddr;
assign bar1_sh_awready = sh_bar1_bus.awready;
assign sh_bar1_bus.wvalid = sh_bar1_wvalid;
assign sh_bar1_bus.wdata[31:0] = sh_bar1_wdata;
assign sh_bar1_bus.wstrb[3:0] = sh_bar1_wstrb;
assign bar1_sh_wready = sh_bar1_bus.wready;
assign bar1_sh_bvalid = sh_bar1_bus.bvalid;
assign bar1_sh_bresp = sh_bar1_bus.bresp;
assign sh_bar1_bus.bready = sh_bar1_bready;
assign sh_bar1_bus.arvalid = sh_bar1_arvalid;
assign sh_bar1_bus.araddr[31:0] = sh_bar1_araddr;
assign bar1_sh_arready = sh_bar1_bus.arready;
assign bar1_sh_rvalid = sh_bar1_bus.rvalid;
assign bar1_sh_rresp = sh_bar1_bus.rresp;
assign bar1_sh_rdata = sh_bar1_bus.rdata[31:0];
assign sh_bar1_bus.rready = sh_bar1_rready;

(* dont_touch = "true" *) logic bar1_slv_sync_rst_n;
lib_pipe #(.WIDTH(1), .STAGES(4)) BAR1_SLV_SLC_RST_N (.clk(clk), .rst_n(1'b1), .in_bus(sync_rst_n), .out_bus(bar1_slv_sync_rst_n));

//----------------------------------------- 
// BAR1 SLAVE module 
//-----------------------------------------

//----------------------------------------- 
// Virtual JTAG ILA Debug core example 
//-----------------------------------------


`ifndef DISABLE_VJTAG_DEBUG

cl_ila CL_ILA (

   .aclk(clk),

   .drck(drck),
   .shift(shift),
   .tdi(tdi),
   .update(update),
   .sel(sel),
   .tdo(tdo),
   .tms(tms),
   .tck(tck),
   .runtest(runtest),
   .reset(reset),
   .capture(capture),
   .bscanid_en(bscanid_en),
 
   .sh_cl_dma_pcis_q(sh_cl_dma_pcis_q),
   .cl_sh_ddr_bus(cl_sh_ddr_bus)

);

cl_vio CL_VIO (

   .clk_extra_a1(clk_extra_a1)

);


`endif //  `ifndef DISABLE_VJTAG_DEBUG

//----------------------------------------- 
// Virtual JATG ILA Debug core example 
//-----------------------------------------

//----------------------------------------- 
// Simple DUT 
//-----------------------------------------
wire    [15:0]  irq_upstream;
wire    [63:0]  base_addr0;
wire    [63:0]  base_addr1;
cl_memdut_wrap CL_MEMDUT_WRAP (
    .clk(clk),
    .rstn(rst_main_n),
    .irq_upstream(irq_upstream),
    .base_addr0(base_addr0[63:0]),
    .base_addr1(base_addr1[63:0]),

    .cl_dut_axi_0(nvdla_dbb_axi_bus),
    .cl_dut_axi_1(nvdla_cvsram_axi_bus),

    .cl_dut_axi_cfg(sh_ocl_bus)
);

//----------------------------------------- 
// Simple DUT 
//-----------------------------------------

//----------------------------------------- 
// interrupt upstream
//-----------------------------------------
wire    [15:0]  irq_status;
wire    [15:0]  irq_pop;

cl_irq_up CL_IRQ_UP(
    .clk        (clk),
    .reset_     (int_slv_sync_rst_n),
    .irq        (irq_upstream[15:0]),
    .irq_status (irq_status[15:0]),
    .irq_pop    (irq_pop[15:0]),
    .irq_req    (cl_sh_apppf_irq_req[15:0]),
    .irq_ack    (sh_cl_apppf_irq_ack[15:0])
);


//----------------------------------------- 
// interrupt upstream
//-----------------------------------------

//----------------------------------------- 
//custom configure registers 
//-----------------------------------------

cl_cfgreg CL_CFGREG (
  .clk(clk),
  .rstn(bar1_slv_sync_rst_n),
  .irq_status(irq_status[15:0]),
  .irq_pop(irq_pop[15:0]),
  .base_addr0(base_addr0[63:0]),
  .base_addr1(base_addr1[63:0]),
  
  .cfg_axi_bus(sh_bar1_bus)

);


endmodule   
