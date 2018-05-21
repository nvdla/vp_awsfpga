// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_FPGA_unit_checkbox_mem_dut.v

`timescale 1ns/10ps
module NV_FPGA_unit_checkbox_mem_dut (
   apb_clk        //|< i
  ,apb_paddr      //|< i
  ,apb_paddr_1    //|< i
  ,apb_penable    //|< i
  ,apb_penable_1  //|< i
  ,apb_pns        //|< i
  ,apb_pns_1      //|< i
  ,apb_psel       //|< i
  ,apb_psel_1     //|< i
  ,apb_puser      //|< i
  ,apb_puser_1    //|< i
  ,apb_pwdata     //|< i
  ,apb_pwdata_1   //|< i
  ,apb_pwrite     //|< i
  ,apb_pwrite_1   //|< i
  ,apb_pwstrb     //|< i
  ,apb_pwstrb_1   //|< i
  ,apb_rstn       //|< i
  ,axi_0_arready  //|< i
  ,axi_0_awready  //|< i
  ,axi_0_bid      //|< i
  ,axi_0_bresp    //|< i
  ,axi_0_bvalid   //|< i
  ,axi_0_rdata    //|< i
  ,axi_0_rid      //|< i
  ,axi_0_rlast    //|< i
  ,axi_0_rresp    //|< i
  ,axi_0_rvalid   //|< i
  ,axi_0_wready   //|< i
  ,axi_1_arready  //|< i
  ,axi_1_awready  //|< i
  ,axi_1_bid      //|< i
  ,axi_1_bresp    //|< i
  ,axi_1_bvalid   //|< i
  ,axi_1_rdata    //|< i
  ,axi_1_rid      //|< i
  ,axi_1_rlast    //|< i
  ,axi_1_rresp    //|< i
  ,axi_1_rvalid   //|< i
  ,axi_1_wready   //|< i
  ,axi_2_arready  //|< i
  ,axi_2_awready  //|< i
  ,axi_2_bid      //|< i
  ,axi_2_bresp    //|< i
  ,axi_2_bvalid   //|< i
  ,axi_2_rdata    //|< i
  ,axi_2_rid      //|< i
  ,axi_2_rlast    //|< i
  ,axi_2_rresp    //|< i
  ,axi_2_rvalid   //|< i
  ,axi_2_wready   //|< i
  ,axi_3_arready  //|< i
  ,axi_3_awready  //|< i
  ,axi_3_bid      //|< i
  ,axi_3_bresp    //|< i
  ,axi_3_bvalid   //|< i
  ,axi_3_rdata    //|< i
  ,axi_3_rid      //|< i
  ,axi_3_rlast    //|< i
  ,axi_3_rresp    //|< i
  ,axi_3_rvalid   //|< i
  ,axi_3_wready   //|< i
  ,intr_in        //|< i
  ,apb_prdata     //|> o
  ,apb_prdata_1   //|> o
  ,apb_pready     //|> o
  ,apb_pready_1   //|> o
  ,apb_pslverr    //|> o
  ,apb_pslverr_1  //|> o
  ,axi_0_araddr   //|> o
  ,axi_0_arburst  //|> o
  ,axi_0_arcache  //|> o
  ,axi_0_arid     //|> o
  ,axi_0_arlen    //|> o
  ,axi_0_arlock   //|> o
  ,axi_0_arprot   //|> o
  ,axi_0_arqos    //|> o
  ,axi_0_arregion //|> o
  ,axi_0_arsize   //|> o
  ,axi_0_aruser   //|> o
  ,axi_0_arvalid  //|> o
  ,axi_0_awaddr   //|> o
  ,axi_0_awburst  //|> o
  ,axi_0_awcache  //|> o
  ,axi_0_awid     //|> o
  ,axi_0_awlen    //|> o
  ,axi_0_awlock   //|> o
  ,axi_0_awprot   //|> o
  ,axi_0_awqos    //|> o
  ,axi_0_awregion //|> o
  ,axi_0_awsize   //|> o
  ,axi_0_awuser   //|> o
  ,axi_0_awvalid  //|> o
  ,axi_0_bready   //|> o
  ,axi_0_rready   //|> o
  ,axi_0_wdata    //|> o
  ,axi_0_wlast    //|> o
  ,axi_0_wstrb    //|> o
  ,axi_0_wvalid   //|> o
  ,axi_1_araddr   //|> o
  ,axi_1_arburst  //|> o
  ,axi_1_arcache  //|> o
  ,axi_1_arid     //|> o
  ,axi_1_arlen    //|> o
  ,axi_1_arlock   //|> o
  ,axi_1_arprot   //|> o
  ,axi_1_arqos    //|> o
  ,axi_1_arregion //|> o
  ,axi_1_arsize   //|> o
  ,axi_1_aruser   //|> o
  ,axi_1_arvalid  //|> o
  ,axi_1_awaddr   //|> o
  ,axi_1_awburst  //|> o
  ,axi_1_awcache  //|> o
  ,axi_1_awid     //|> o
  ,axi_1_awlen    //|> o
  ,axi_1_awlock   //|> o
  ,axi_1_awprot   //|> o
  ,axi_1_awqos    //|> o
  ,axi_1_awregion //|> o
  ,axi_1_awsize   //|> o
  ,axi_1_awuser   //|> o
  ,axi_1_awvalid  //|> o
  ,axi_1_bready   //|> o
  ,axi_1_rready   //|> o
  ,axi_1_wdata    //|> o
  ,axi_1_wlast    //|> o
  ,axi_1_wstrb    //|> o
  ,axi_1_wvalid   //|> o
  ,axi_2_araddr   //|> o
  ,axi_2_arburst  //|> o
  ,axi_2_arcache  //|> o
  ,axi_2_arid     //|> o
  ,axi_2_arlen    //|> o
  ,axi_2_arlock   //|> o
  ,axi_2_arprot   //|> o
  ,axi_2_arqos    //|> o
  ,axi_2_arregion //|> o
  ,axi_2_arsize   //|> o
  ,axi_2_aruser   //|> o
  ,axi_2_arvalid  //|> o
  ,axi_2_awaddr   //|> o
  ,axi_2_awburst  //|> o
  ,axi_2_awcache  //|> o
  ,axi_2_awid     //|> o
  ,axi_2_awlen    //|> o
  ,axi_2_awlock   //|> o
  ,axi_2_awprot   //|> o
  ,axi_2_awqos    //|> o
  ,axi_2_awregion //|> o
  ,axi_2_awsize   //|> o
  ,axi_2_awuser   //|> o
  ,axi_2_awvalid  //|> o
  ,axi_2_bready   //|> o
  ,axi_2_rready   //|> o
  ,axi_2_wdata    //|> o
  ,axi_2_wlast    //|> o
  ,axi_2_wstrb    //|> o
  ,axi_2_wvalid   //|> o
  ,axi_3_araddr   //|> o
  ,axi_3_arburst  //|> o
  ,axi_3_arcache  //|> o
  ,axi_3_arid     //|> o
  ,axi_3_arlen    //|> o
  ,axi_3_arlock   //|> o
  ,axi_3_arprot   //|> o
  ,axi_3_arqos    //|> o
  ,axi_3_arregion //|> o
  ,axi_3_arsize   //|> o
  ,axi_3_aruser   //|> o
  ,axi_3_arvalid  //|> o
  ,axi_3_awaddr   //|> o
  ,axi_3_awburst  //|> o
  ,axi_3_awcache  //|> o
  ,axi_3_awid     //|> o
  ,axi_3_awlen    //|> o
  ,axi_3_awlock   //|> o
  ,axi_3_awprot   //|> o
  ,axi_3_awqos    //|> o
  ,axi_3_awregion //|> o
  ,axi_3_awsize   //|> o
  ,axi_3_awuser   //|> o
  ,axi_3_awvalid  //|> o
  ,axi_3_bready   //|> o
  ,axi_3_rready   //|> o
  ,axi_3_wdata    //|> o
  ,axi_3_wlast    //|> o
  ,axi_3_wstrb    //|> o
  ,axi_3_wvalid   //|> o
  ,intr_out       //|> o
  );
input          apb_clk;
input   [23:0] apb_paddr;
input   [23:0] apb_paddr_1;
input          apb_penable;
input          apb_penable_1;
input          apb_pns;
input          apb_pns_1;
input          apb_psel;
input          apb_psel_1;
input   [12:0] apb_puser;
input   [12:0] apb_puser_1;
input   [31:0] apb_pwdata;
input   [31:0] apb_pwdata_1;
input          apb_pwrite;
input          apb_pwrite_1;
input    [3:0] apb_pwstrb;
input    [3:0] apb_pwstrb_1;
input          apb_rstn;
input          axi_0_arready;
input          axi_0_awready;
input   [13:0] axi_0_bid;
input    [1:0] axi_0_bresp;
input          axi_0_bvalid;
input  [255:0] axi_0_rdata;
input   [13:0] axi_0_rid;
input          axi_0_rlast;
input    [1:0] axi_0_rresp;
input          axi_0_rvalid;
input          axi_0_wready;
input          axi_1_arready;
input          axi_1_awready;
input   [13:0] axi_1_bid;
input    [1:0] axi_1_bresp;
input          axi_1_bvalid;
input  [255:0] axi_1_rdata;
input   [13:0] axi_1_rid;
input          axi_1_rlast;
input    [1:0] axi_1_rresp;
input          axi_1_rvalid;
input          axi_1_wready;
input          axi_2_arready;
input          axi_2_awready;
input   [13:0] axi_2_bid;
input    [1:0] axi_2_bresp;
input          axi_2_bvalid;
input  [255:0] axi_2_rdata;
input   [13:0] axi_2_rid;
input          axi_2_rlast;
input    [1:0] axi_2_rresp;
input          axi_2_rvalid;
input          axi_2_wready;
input          axi_3_arready;
input          axi_3_awready;
input   [13:0] axi_3_bid;
input    [1:0] axi_3_bresp;
input          axi_3_bvalid;
input  [255:0] axi_3_rdata;
input   [13:0] axi_3_rid;
input          axi_3_rlast;
input    [1:0] axi_3_rresp;
input          axi_3_rvalid;
input          axi_3_wready;
input   [31:0] intr_in;
output  [31:0] apb_prdata;
output  [31:0] apb_prdata_1;
output         apb_pready;
output         apb_pready_1;
output         apb_pslverr;
output         apb_pslverr_1;
output  [39:0] axi_0_araddr;
output   [1:0] axi_0_arburst;
output   [3:0] axi_0_arcache;
output  [13:0] axi_0_arid;
output   [7:0] axi_0_arlen;
output   [1:0] axi_0_arlock;
output   [2:0] axi_0_arprot;
output   [3:0] axi_0_arqos;
output   [3:0] axi_0_arregion;
output   [2:0] axi_0_arsize;
output  [25:0] axi_0_aruser;
output         axi_0_arvalid;
output  [39:0] axi_0_awaddr;
output   [1:0] axi_0_awburst;
output   [3:0] axi_0_awcache;
output  [13:0] axi_0_awid;
output   [7:0] axi_0_awlen;
output   [1:0] axi_0_awlock;
output   [2:0] axi_0_awprot;
output   [3:0] axi_0_awqos;
output   [3:0] axi_0_awregion;
output   [2:0] axi_0_awsize;
output  [25:0] axi_0_awuser;
output         axi_0_awvalid;
output         axi_0_bready;
output         axi_0_rready;
output [255:0] axi_0_wdata;
output         axi_0_wlast;
output  [31:0] axi_0_wstrb;
output         axi_0_wvalid;
output  [39:0] axi_1_araddr;
output   [1:0] axi_1_arburst;
output   [3:0] axi_1_arcache;
output  [13:0] axi_1_arid;
output   [7:0] axi_1_arlen;
output   [1:0] axi_1_arlock;
output   [2:0] axi_1_arprot;
output   [3:0] axi_1_arqos;
output   [3:0] axi_1_arregion;
output   [2:0] axi_1_arsize;
output  [25:0] axi_1_aruser;
output         axi_1_arvalid;
output  [39:0] axi_1_awaddr;
output   [1:0] axi_1_awburst;
output   [3:0] axi_1_awcache;
output  [13:0] axi_1_awid;
output   [7:0] axi_1_awlen;
output   [1:0] axi_1_awlock;
output   [2:0] axi_1_awprot;
output   [3:0] axi_1_awqos;
output   [3:0] axi_1_awregion;
output   [2:0] axi_1_awsize;
output  [25:0] axi_1_awuser;
output         axi_1_awvalid;
output         axi_1_bready;
output         axi_1_rready;
output [255:0] axi_1_wdata;
output         axi_1_wlast;
output  [31:0] axi_1_wstrb;
output         axi_1_wvalid;
output  [39:0] axi_2_araddr;
output   [1:0] axi_2_arburst;
output   [3:0] axi_2_arcache;
output  [13:0] axi_2_arid;
output   [7:0] axi_2_arlen;
output   [1:0] axi_2_arlock;
output   [2:0] axi_2_arprot;
output   [3:0] axi_2_arqos;
output   [3:0] axi_2_arregion;
output   [2:0] axi_2_arsize;
output  [25:0] axi_2_aruser;
output         axi_2_arvalid;
output  [39:0] axi_2_awaddr;
output   [1:0] axi_2_awburst;
output   [3:0] axi_2_awcache;
output  [13:0] axi_2_awid;
output   [7:0] axi_2_awlen;
output   [1:0] axi_2_awlock;
output   [2:0] axi_2_awprot;
output   [3:0] axi_2_awqos;
output   [3:0] axi_2_awregion;
output   [2:0] axi_2_awsize;
output  [25:0] axi_2_awuser;
output         axi_2_awvalid;
output         axi_2_bready;
output         axi_2_rready;
output [255:0] axi_2_wdata;
output         axi_2_wlast;
output  [31:0] axi_2_wstrb;
output         axi_2_wvalid;
output  [39:0] axi_3_araddr;
output   [1:0] axi_3_arburst;
output   [3:0] axi_3_arcache;
output  [13:0] axi_3_arid;
output   [7:0] axi_3_arlen;
output   [1:0] axi_3_arlock;
output   [2:0] axi_3_arprot;
output   [3:0] axi_3_arqos;
output   [3:0] axi_3_arregion;
output   [2:0] axi_3_arsize;
output  [25:0] axi_3_aruser;
output         axi_3_arvalid;
output  [39:0] axi_3_awaddr;
output   [1:0] axi_3_awburst;
output   [3:0] axi_3_awcache;
output  [13:0] axi_3_awid;
output   [7:0] axi_3_awlen;
output   [1:0] axi_3_awlock;
output   [2:0] axi_3_awprot;
output   [3:0] axi_3_awqos;
output   [3:0] axi_3_awregion;
output   [2:0] axi_3_awsize;
output  [25:0] axi_3_awuser;
output         axi_3_awvalid;
output         axi_3_bready;
output         axi_3_rready;
output [255:0] axi_3_wdata;
output         axi_3_wlast;
output  [31:0] axi_3_wstrb;
output         axi_3_wvalid;
output  [31:0] intr_out;
wire           apb_wr_op;
wire           axi_0_cmd_ram_sel;
wire    [23:0] axi_0_paddr;
wire    [31:0] axi_0_prdata;
wire           axi_0_rdata_ram_sel;
wire           axi_0_reg_sel;
wire           axi_0_wdata_ram_sel;
wire           axi_0_wstrb_ram_sel;
wire           axi_1_cmd_ram_sel;
wire    [23:0] axi_1_paddr;
wire    [31:0] axi_1_prdata;
wire           axi_1_rdata_ram_sel;
wire           axi_1_reg_sel;
wire           axi_1_wdata_ram_sel;
wire           axi_1_wstrb_ram_sel;
wire           axi_2_cmd_ram_sel;
wire    [23:0] axi_2_paddr;
wire    [31:0] axi_2_prdata;
wire           axi_2_rdata_ram_sel;
wire           axi_2_reg_sel;
wire           axi_2_wdata_ram_sel;
wire           axi_2_wstrb_ram_sel;
wire           axi_3_cmd_ram_sel;
wire    [23:0] axi_3_paddr;
wire    [31:0] axi_3_prdata;
wire           axi_3_rdata_ram_sel;
wire           axi_3_reg_sel;
wire           axi_3_wdata_ram_sel;
wire           axi_3_wstrb_ram_sel;
wire           test_complete_0;
wire           test_complete_1;
wire           test_complete_2;
wire           test_complete_3;

parameter APB_TRAN_BASE_ADDR     = 24'h000000;
parameter MEM_DUT_AXI_PORT_SPACE = 24'h100000;

parameter APB_TRAN_BASE_ADDR_1   = 24'hB00000;

NV_FPGA_unit_checkbox_mem_dut_apb_slave #( .APB_BASE_ADDR(APB_TRAN_BASE_ADDR), .AXI_PORT_SPACE(MEM_DUT_AXI_PORT_SPACE)) u_apb_slave (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_paddr           (apb_paddr[23:0])     //|< i
  ,.apb_penable         (apb_penable)         //|< i
  ,.apb_pns             (apb_pns)             //|< i
  ,.apb_psel            (apb_psel)            //|< i
  ,.apb_puser           (apb_puser[12:0])     //|< i
  ,.apb_pwdata          (apb_pwdata[31:0])    //|< i
  ,.apb_pwrite          (apb_pwrite)          //|< i
  ,.apb_pwstrb          (apb_pwstrb[3:0])     //|< i
  ,.axi_0_prdata        (axi_0_prdata[31:0])  //|< w
  ,.axi_1_prdata        (axi_1_prdata[31:0])  //|< w
  ,.axi_2_prdata        (axi_2_prdata[31:0])  //|< w
  ,.axi_3_prdata        (axi_3_prdata[31:0])  //|< w
  ,.intr_in             (intr_in[31:0])       //|< i
  ,.test_complete_0     (test_complete_0)     //|< w
  ,.test_complete_1     (test_complete_1)     //|< w
  ,.test_complete_2     (test_complete_2)     //|< w
  ,.test_complete_3     (test_complete_3)     //|< w
  ,.apb_prdata          (apb_prdata[31:0])    //|> o
  ,.apb_pready          (apb_pready)          //|> o
  ,.apb_pslverr         (apb_pslverr)         //|> o
  ,.apb_wr_op           (apb_wr_op)           //|> w
  ,.axi_0_cmd_ram_sel   (axi_0_cmd_ram_sel)   //|> w
  ,.axi_0_paddr         (axi_0_paddr[23:0])   //|> w
  ,.axi_0_rdata_ram_sel (axi_0_rdata_ram_sel) //|> w
  ,.axi_0_reg_sel       (axi_0_reg_sel)       //|> w
  ,.axi_0_wdata_ram_sel (axi_0_wdata_ram_sel) //|> w
  ,.axi_0_wstrb_ram_sel (axi_0_wstrb_ram_sel) //|> w
  ,.axi_1_cmd_ram_sel   (axi_1_cmd_ram_sel)   //|> w
  ,.axi_1_paddr         (axi_1_paddr[23:0])   //|> w
  ,.axi_1_rdata_ram_sel (axi_1_rdata_ram_sel) //|> w
  ,.axi_1_reg_sel       (axi_1_reg_sel)       //|> w
  ,.axi_1_wdata_ram_sel (axi_1_wdata_ram_sel) //|> w
  ,.axi_1_wstrb_ram_sel (axi_1_wstrb_ram_sel) //|> w
  ,.axi_2_cmd_ram_sel   (axi_2_cmd_ram_sel)   //|> w
  ,.axi_2_paddr         (axi_2_paddr[23:0])   //|> w
  ,.axi_2_rdata_ram_sel (axi_2_rdata_ram_sel) //|> w
  ,.axi_2_reg_sel       (axi_2_reg_sel)       //|> w
  ,.axi_2_wdata_ram_sel (axi_2_wdata_ram_sel) //|> w
  ,.axi_2_wstrb_ram_sel (axi_2_wstrb_ram_sel) //|> w
  ,.axi_3_cmd_ram_sel   (axi_3_cmd_ram_sel)   //|> w
  ,.axi_3_paddr         (axi_3_paddr[23:0])   //|> w
  ,.axi_3_rdata_ram_sel (axi_3_rdata_ram_sel) //|> w
  ,.axi_3_reg_sel       (axi_3_reg_sel)       //|> w
  ,.axi_3_wdata_ram_sel (axi_3_wdata_ram_sel) //|> w
  ,.axi_3_wstrb_ram_sel (axi_3_wstrb_ram_sel) //|> w
  ,.intr_out            (intr_out[31:0])      //|> o
  );

NV_FPGA_unit_checkbox_mem_dut_apb_slave #( .APB_BASE_ADDR(APB_TRAN_BASE_ADDR_1), .AXI_PORT_SPACE(MEM_DUT_AXI_PORT_SPACE)) u_apb_slave_1 (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_paddr           (apb_paddr_1[23:0])   //|< i
  ,.apb_penable         (apb_penable_1)       //|< i
  ,.apb_pns             (apb_pns_1)           //|< i
  ,.apb_psel            (apb_psel_1)          //|< i
  ,.apb_puser           (apb_puser_1[12:0])   //|< i
  ,.apb_pwdata          (apb_pwdata_1[31:0])  //|< i
  ,.apb_pwrite          (apb_pwrite_1)        //|< i
  ,.apb_pwstrb          (apb_pwstrb_1[3:0])   //|< i
  ,.axi_0_prdata        ({32{1'b0}})          //|< ?
  ,.axi_1_prdata        ({32{1'b0}})          //|< ?
  ,.axi_2_prdata        ({32{1'b0}})          //|< ?
  ,.axi_3_prdata        ({32{1'b0}})          //|< ?
  ,.intr_in             ({32{1'b0}})          //|< ?
  ,.test_complete_0     ({1{1'b0}})           //|< ?
  ,.test_complete_1     ({1{1'b0}})           //|< ?
  ,.test_complete_2     ({1{1'b0}})           //|< ?
  ,.test_complete_3     ({1{1'b0}})           //|< ?
  ,.apb_prdata          (apb_prdata_1[31:0])  //|> o
  ,.apb_pready          (apb_pready_1)        //|> o
  ,.apb_pslverr         (apb_pslverr_1)       //|> o
  ,.apb_wr_op           ()                    //|> ?
  ,.axi_0_cmd_ram_sel   ()                    //|> ?
  ,.axi_0_paddr         ()                    //|> ?
  ,.axi_0_rdata_ram_sel ()                    //|> ?
  ,.axi_0_reg_sel       ()                    //|> ?
  ,.axi_0_wdata_ram_sel ()                    //|> ?
  ,.axi_0_wstrb_ram_sel ()                    //|> ?
  ,.axi_1_cmd_ram_sel   ()                    //|> ?
  ,.axi_1_paddr         ()                    //|> ?
  ,.axi_1_rdata_ram_sel ()                    //|> ?
  ,.axi_1_reg_sel       ()                    //|> ?
  ,.axi_1_wdata_ram_sel ()                    //|> ?
  ,.axi_1_wstrb_ram_sel ()                    //|> ?
  ,.axi_2_cmd_ram_sel   ()                    //|> ?
  ,.axi_2_paddr         ()                    //|> ?
  ,.axi_2_rdata_ram_sel ()                    //|> ?
  ,.axi_2_reg_sel       ()                    //|> ?
  ,.axi_2_wdata_ram_sel ()                    //|> ?
  ,.axi_2_wstrb_ram_sel ()                    //|> ?
  ,.axi_3_cmd_ram_sel   ()                    //|> ?
  ,.axi_3_paddr         ()                    //|> ?
  ,.axi_3_rdata_ram_sel ()                    //|> ?
  ,.axi_3_reg_sel       ()                    //|> ?
  ,.axi_3_wdata_ram_sel ()                    //|> ?
  ,.axi_3_wstrb_ram_sel ()                    //|> ?
  ,.intr_out            ()                    //|> ?
  );

//Instance AXI Master PORT 0
NV_FPGA_unit_checkbox_mem_dut_axi_256_256 axi_master_0 (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_wr_op           (apb_wr_op)           //|< w
  ,.axi_arready         (axi_0_arready)       //|< i
  ,.axi_awready         (axi_0_awready)       //|< i
  ,.axi_bid             (axi_0_bid[13:0])     //|< i
  ,.axi_bresp           (axi_0_bresp[1:0])    //|< i
  ,.axi_bvalid          (axi_0_bvalid)        //|< i
  ,.axi_cmd_ram_sel     (axi_0_cmd_ram_sel)   //|< w
  ,.axi_paddr           (axi_0_paddr[19:0])   //|< w
  ,.axi_pwdata          (apb_pwdata[31:0])    //|< i
  ,.axi_rdata           (axi_0_rdata[255:0])  //|< i
  ,.axi_rdata_ram_sel   (axi_0_rdata_ram_sel) //|< w
  ,.axi_reg_sel         (axi_0_reg_sel)       //|< w
  ,.axi_rid             (axi_0_rid[13:0])     //|< i
  ,.axi_rlast           (axi_0_rlast)         //|< i
  ,.axi_rresp           (axi_0_rresp[1:0])    //|< i
  ,.axi_rvalid          (axi_0_rvalid)        //|< i
  ,.axi_wdata_ram_sel   (axi_0_wdata_ram_sel) //|< w
  ,.axi_wready          (axi_0_wready)        //|< i
  ,.axi_wstrb_ram_sel   (axi_0_wstrb_ram_sel) //|< w
  ,.axi_araddr          (axi_0_araddr[39:0])  //|> o
  ,.axi_arburst         (axi_0_arburst[1:0])  //|> o
  ,.axi_arcache         (axi_0_arcache[3:0])  //|> o
  ,.axi_arid            (axi_0_arid[13:0])    //|> o
  ,.axi_arlen           (axi_0_arlen[7:0])    //|> o
  ,.axi_arlock          (axi_0_arlock[1:0])   //|> o
  ,.axi_arprot          (axi_0_arprot[2:0])   //|> o
  ,.axi_arqos           (axi_0_arqos[3:0])    //|> o
  ,.axi_arregion        (axi_0_arregion[3:0]) //|> o
  ,.axi_arsize          (axi_0_arsize[2:0])   //|> o
  ,.axi_aruser          (axi_0_aruser[25:0])  //|> o
  ,.axi_arvalid         (axi_0_arvalid)       //|> o
  ,.axi_awaddr          (axi_0_awaddr[39:0])  //|> o
  ,.axi_awburst         (axi_0_awburst[1:0])  //|> o
  ,.axi_awcache         (axi_0_awcache[3:0])  //|> o
  ,.axi_awid            (axi_0_awid[13:0])    //|> o
  ,.axi_awlen           (axi_0_awlen[7:0])    //|> o
  ,.axi_awlock          (axi_0_awlock[1:0])   //|> o
  ,.axi_awprot          (axi_0_awprot[2:0])   //|> o
  ,.axi_awqos           (axi_0_awqos[3:0])    //|> o
  ,.axi_awregion        (axi_0_awregion[3:0]) //|> o
  ,.axi_awsize          (axi_0_awsize[2:0])   //|> o
  ,.axi_awuser          (axi_0_awuser[25:0])  //|> o
  ,.axi_awvalid         (axi_0_awvalid)       //|> o
  ,.axi_bready          (axi_0_bready)        //|> o
  ,.axi_prdata          (axi_0_prdata[31:0])  //|> w
  ,.axi_rready          (axi_0_rready)        //|> o
  ,.axi_wdata           (axi_0_wdata[255:0])  //|> o
  ,.axi_wlast           (axi_0_wlast)         //|> o
  ,.axi_wstrb           (axi_0_wstrb[31:0])   //|> o
  ,.axi_wvalid          (axi_0_wvalid)        //|> o
  ,.test_complete       (test_complete_0)     //|> w
  );
//Instance AXI Master PORT 1
NV_FPGA_unit_checkbox_mem_dut_axi_256_256 axi_master_1 (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_wr_op           (apb_wr_op)           //|< w
  ,.axi_arready         (axi_1_arready)       //|< i
  ,.axi_awready         (axi_1_awready)       //|< i
  ,.axi_bid             (axi_1_bid[13:0])     //|< i
  ,.axi_bresp           (axi_1_bresp[1:0])    //|< i
  ,.axi_bvalid          (axi_1_bvalid)        //|< i
  ,.axi_cmd_ram_sel     (axi_1_cmd_ram_sel)   //|< w
  ,.axi_paddr           (axi_1_paddr[19:0])   //|< w
  ,.axi_pwdata          (apb_pwdata[31:0])    //|< i
  ,.axi_rdata           (axi_1_rdata[255:0])  //|< i
  ,.axi_rdata_ram_sel   (axi_1_rdata_ram_sel) //|< w
  ,.axi_reg_sel         (axi_1_reg_sel)       //|< w
  ,.axi_rid             (axi_1_rid[13:0])     //|< i
  ,.axi_rlast           (axi_1_rlast)         //|< i
  ,.axi_rresp           (axi_1_rresp[1:0])    //|< i
  ,.axi_rvalid          (axi_1_rvalid)        //|< i
  ,.axi_wdata_ram_sel   (axi_1_wdata_ram_sel) //|< w
  ,.axi_wready          (axi_1_wready)        //|< i
  ,.axi_wstrb_ram_sel   (axi_1_wstrb_ram_sel) //|< w
  ,.axi_araddr          (axi_1_araddr[39:0])  //|> o
  ,.axi_arburst         (axi_1_arburst[1:0])  //|> o
  ,.axi_arcache         (axi_1_arcache[3:0])  //|> o
  ,.axi_arid            (axi_1_arid[13:0])    //|> o
  ,.axi_arlen           (axi_1_arlen[7:0])    //|> o
  ,.axi_arlock          (axi_1_arlock[1:0])   //|> o
  ,.axi_arprot          (axi_1_arprot[2:0])   //|> o
  ,.axi_arqos           (axi_1_arqos[3:0])    //|> o
  ,.axi_arregion        (axi_1_arregion[3:0]) //|> o
  ,.axi_arsize          (axi_1_arsize[2:0])   //|> o
  ,.axi_aruser          (axi_1_aruser[25:0])  //|> o
  ,.axi_arvalid         (axi_1_arvalid)       //|> o
  ,.axi_awaddr          (axi_1_awaddr[39:0])  //|> o
  ,.axi_awburst         (axi_1_awburst[1:0])  //|> o
  ,.axi_awcache         (axi_1_awcache[3:0])  //|> o
  ,.axi_awid            (axi_1_awid[13:0])    //|> o
  ,.axi_awlen           (axi_1_awlen[7:0])    //|> o
  ,.axi_awlock          (axi_1_awlock[1:0])   //|> o
  ,.axi_awprot          (axi_1_awprot[2:0])   //|> o
  ,.axi_awqos           (axi_1_awqos[3:0])    //|> o
  ,.axi_awregion        (axi_1_awregion[3:0]) //|> o
  ,.axi_awsize          (axi_1_awsize[2:0])   //|> o
  ,.axi_awuser          (axi_1_awuser[25:0])  //|> o
  ,.axi_awvalid         (axi_1_awvalid)       //|> o
  ,.axi_bready          (axi_1_bready)        //|> o
  ,.axi_prdata          (axi_1_prdata[31:0])  //|> w
  ,.axi_rready          (axi_1_rready)        //|> o
  ,.axi_wdata           (axi_1_wdata[255:0])  //|> o
  ,.axi_wlast           (axi_1_wlast)         //|> o
  ,.axi_wstrb           (axi_1_wstrb[31:0])   //|> o
  ,.axi_wvalid          (axi_1_wvalid)        //|> o
  ,.test_complete       (test_complete_1)     //|> w
  );
//Instance AXI Master PORT 2
NV_FPGA_unit_checkbox_mem_dut_axi_256_256 axi_master_2 (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_wr_op           (apb_wr_op)           //|< w
  ,.axi_arready         (axi_2_arready)       //|< i
  ,.axi_awready         (axi_2_awready)       //|< i
  ,.axi_bid             (axi_2_bid[13:0])     //|< i
  ,.axi_bresp           (axi_2_bresp[1:0])    //|< i
  ,.axi_bvalid          (axi_2_bvalid)        //|< i
  ,.axi_cmd_ram_sel     (axi_2_cmd_ram_sel)   //|< w
  ,.axi_paddr           (axi_2_paddr[19:0])   //|< w
  ,.axi_pwdata          (apb_pwdata[31:0])    //|< i
  ,.axi_rdata           (axi_2_rdata[255:0])  //|< i
  ,.axi_rdata_ram_sel   (axi_2_rdata_ram_sel) //|< w
  ,.axi_reg_sel         (axi_2_reg_sel)       //|< w
  ,.axi_rid             (axi_2_rid[13:0])     //|< i
  ,.axi_rlast           (axi_2_rlast)         //|< i
  ,.axi_rresp           (axi_2_rresp[1:0])    //|< i
  ,.axi_rvalid          (axi_2_rvalid)        //|< i
  ,.axi_wdata_ram_sel   (axi_2_wdata_ram_sel) //|< w
  ,.axi_wready          (axi_2_wready)        //|< i
  ,.axi_wstrb_ram_sel   (axi_2_wstrb_ram_sel) //|< w
  ,.axi_araddr          (axi_2_araddr[39:0])  //|> o
  ,.axi_arburst         (axi_2_arburst[1:0])  //|> o
  ,.axi_arcache         (axi_2_arcache[3:0])  //|> o
  ,.axi_arid            (axi_2_arid[13:0])    //|> o
  ,.axi_arlen           (axi_2_arlen[7:0])    //|> o
  ,.axi_arlock          (axi_2_arlock[1:0])   //|> o
  ,.axi_arprot          (axi_2_arprot[2:0])   //|> o
  ,.axi_arqos           (axi_2_arqos[3:0])    //|> o
  ,.axi_arregion        (axi_2_arregion[3:0]) //|> o
  ,.axi_arsize          (axi_2_arsize[2:0])   //|> o
  ,.axi_aruser          (axi_2_aruser[25:0])  //|> o
  ,.axi_arvalid         (axi_2_arvalid)       //|> o
  ,.axi_awaddr          (axi_2_awaddr[39:0])  //|> o
  ,.axi_awburst         (axi_2_awburst[1:0])  //|> o
  ,.axi_awcache         (axi_2_awcache[3:0])  //|> o
  ,.axi_awid            (axi_2_awid[13:0])    //|> o
  ,.axi_awlen           (axi_2_awlen[7:0])    //|> o
  ,.axi_awlock          (axi_2_awlock[1:0])   //|> o
  ,.axi_awprot          (axi_2_awprot[2:0])   //|> o
  ,.axi_awqos           (axi_2_awqos[3:0])    //|> o
  ,.axi_awregion        (axi_2_awregion[3:0]) //|> o
  ,.axi_awsize          (axi_2_awsize[2:0])   //|> o
  ,.axi_awuser          (axi_2_awuser[25:0])  //|> o
  ,.axi_awvalid         (axi_2_awvalid)       //|> o
  ,.axi_bready          (axi_2_bready)        //|> o
  ,.axi_prdata          (axi_2_prdata[31:0])  //|> w
  ,.axi_rready          (axi_2_rready)        //|> o
  ,.axi_wdata           (axi_2_wdata[255:0])  //|> o
  ,.axi_wlast           (axi_2_wlast)         //|> o
  ,.axi_wstrb           (axi_2_wstrb[31:0])   //|> o
  ,.axi_wvalid          (axi_2_wvalid)        //|> o
  ,.test_complete       (test_complete_2)     //|> w
  );
//Instance AXI Master PORT 3
NV_FPGA_unit_checkbox_mem_dut_axi_256_256 axi_master_3 (
   .apb_clk             (apb_clk)             //|< i
  ,.apb_rstn            (apb_rstn)            //|< i
  ,.apb_wr_op           (apb_wr_op)           //|< w
  ,.axi_arready         (axi_3_arready)       //|< i
  ,.axi_awready         (axi_3_awready)       //|< i
  ,.axi_bid             (axi_3_bid[13:0])     //|< i
  ,.axi_bresp           (axi_3_bresp[1:0])    //|< i
  ,.axi_bvalid          (axi_3_bvalid)        //|< i
  ,.axi_cmd_ram_sel     (axi_3_cmd_ram_sel)   //|< w
  ,.axi_paddr           (axi_3_paddr[19:0])   //|< w
  ,.axi_pwdata          (apb_pwdata[31:0])    //|< i
  ,.axi_rdata           (axi_3_rdata[255:0])  //|< i
  ,.axi_rdata_ram_sel   (axi_3_rdata_ram_sel) //|< w
  ,.axi_reg_sel         (axi_3_reg_sel)       //|< w
  ,.axi_rid             (axi_3_rid[13:0])     //|< i
  ,.axi_rlast           (axi_3_rlast)         //|< i
  ,.axi_rresp           (axi_3_rresp[1:0])    //|< i
  ,.axi_rvalid          (axi_3_rvalid)        //|< i
  ,.axi_wdata_ram_sel   (axi_3_wdata_ram_sel) //|< w
  ,.axi_wready          (axi_3_wready)        //|< i
  ,.axi_wstrb_ram_sel   (axi_3_wstrb_ram_sel) //|< w
  ,.axi_araddr          (axi_3_araddr[39:0])  //|> o
  ,.axi_arburst         (axi_3_arburst[1:0])  //|> o
  ,.axi_arcache         (axi_3_arcache[3:0])  //|> o
  ,.axi_arid            (axi_3_arid[13:0])    //|> o
  ,.axi_arlen           (axi_3_arlen[7:0])    //|> o
  ,.axi_arlock          (axi_3_arlock[1:0])   //|> o
  ,.axi_arprot          (axi_3_arprot[2:0])   //|> o
  ,.axi_arqos           (axi_3_arqos[3:0])    //|> o
  ,.axi_arregion        (axi_3_arregion[3:0]) //|> o
  ,.axi_arsize          (axi_3_arsize[2:0])   //|> o
  ,.axi_aruser          (axi_3_aruser[25:0])  //|> o
  ,.axi_arvalid         (axi_3_arvalid)       //|> o
  ,.axi_awaddr          (axi_3_awaddr[39:0])  //|> o
  ,.axi_awburst         (axi_3_awburst[1:0])  //|> o
  ,.axi_awcache         (axi_3_awcache[3:0])  //|> o
  ,.axi_awid            (axi_3_awid[13:0])    //|> o
  ,.axi_awlen           (axi_3_awlen[7:0])    //|> o
  ,.axi_awlock          (axi_3_awlock[1:0])   //|> o
  ,.axi_awprot          (axi_3_awprot[2:0])   //|> o
  ,.axi_awqos           (axi_3_awqos[3:0])    //|> o
  ,.axi_awregion        (axi_3_awregion[3:0]) //|> o
  ,.axi_awsize          (axi_3_awsize[2:0])   //|> o
  ,.axi_awuser          (axi_3_awuser[25:0])  //|> o
  ,.axi_awvalid         (axi_3_awvalid)       //|> o
  ,.axi_bready          (axi_3_bready)        //|> o
  ,.axi_prdata          (axi_3_prdata[31:0])  //|> w
  ,.axi_rready          (axi_3_rready)        //|> o
  ,.axi_wdata           (axi_3_wdata[255:0])  //|> o
  ,.axi_wlast           (axi_3_wlast)         //|> o
  ,.axi_wstrb           (axi_3_wstrb[31:0])   //|> o
  ,.axi_wvalid          (axi_3_wvalid)        //|> o
  ,.test_complete       (test_complete_3)     //|> w
  );

endmodule // NV_FPGA_unit_checkbox_mem_dut


