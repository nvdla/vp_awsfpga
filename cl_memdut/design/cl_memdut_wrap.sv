// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cl_memdut_wrap.sv

module cl_memdut_wrap
(
    input clk,
    input rstn,
    output [31:0]   irq_upstream,
    input   [63:0]  base_addr0,
    input   [63:0]  base_addr1,

    axi_bus_t.slave cl_dut_axi_0,
    axi_bus_t.slave cl_dut_axi_1,

    axi_bus_t.master cl_dut_axi_cfg
);

wire [23:0] m_apb_paddr;
wire        m_apb_penable;
wire        m_apb_pns = 1'b0;      // FIXME
wire        m_apb_psel;
wire [12:0] m_apb_puser = 13'b0;    // FIXME
wire [31:0] m_apb_pwdata;
wire        m_apb_pwrite;
wire  [3:0] m_apb_pwstrb = 4'b1111;   // FIXME
wire [31:0] m_apb_prdata;
wire        m_apb_pready;
wire        m_apb_pslverr;

axi_apb_bridge_0 axi2apb (
 .s_axi_aclk            (clk)
,.s_axi_aresetn         (rstn)
,.s_axi_awaddr          (cl_dut_axi_cfg.awaddr[31:0])
,.s_axi_awvalid         (cl_dut_axi_cfg.awvalid)
,.s_axi_awready         (cl_dut_axi_cfg.awready)
,.s_axi_wdata           (cl_dut_axi_cfg.wdata[31:0])
,.s_axi_wvalid          (cl_dut_axi_cfg.wvalid)
,.s_axi_wready          (cl_dut_axi_cfg.wready)
,.s_axi_bresp           (cl_dut_axi_cfg.bresp)
,.s_axi_bvalid          (cl_dut_axi_cfg.bvalid)
,.s_axi_bready          (cl_dut_axi_cfg.bready)
,.s_axi_araddr          (cl_dut_axi_cfg.araddr)
,.s_axi_arvalid         (cl_dut_axi_cfg.arvalid)
,.s_axi_arready         (cl_dut_axi_cfg.arready)
,.s_axi_rdata           (cl_dut_axi_cfg.rdata)
,.s_axi_rresp           (cl_dut_axi_cfg.rresp)
,.s_axi_rvalid          (cl_dut_axi_cfg.rvalid)
,.s_axi_rready          (cl_dut_axi_cfg.rready)
,.m_apb_paddr           (m_apb_paddr)
,.m_apb_psel            (m_apb_psel)
,.m_apb_penable         (m_apb_penable)
,.m_apb_pwrite          (m_apb_pwrite)
,.m_apb_pwdata          (m_apb_pwdata)
,.m_apb_pready          (m_apb_pready)
,.m_apb_prdata          (m_apb_prdata)
,.m_apb_pslverr         (m_apb_pslverr)
);

wire    [63:0]  axi_0_awaddr;
wire    [63:0]  axi_1_awaddr;
wire    [63:0]  axi_0_araddr;
wire    [63:0]  axi_1_araddr;

assign cl_dut_axi_0.awaddr = axi_0_awaddr - base_addr0[39:0];
assign cl_dut_axi_0.araddr = axi_0_araddr - base_addr0[39:0];
assign cl_dut_axi_1.awaddr = axi_1_awaddr - base_addr1[39:0];
assign cl_dut_axi_1.araddr = axi_1_araddr - base_addr1[39:0];

NV_FPGA_unit_checkbox_mem_dut simple_dut (
  // inputs
   .apb_clk        (clk)
  ,.apb_paddr      (m_apb_paddr)
  ,.apb_paddr_1    (24'b0)
  ,.apb_penable    (m_apb_penable)
  ,.apb_penable_1  (1'b0)
  ,.apb_pns        (m_apb_pns)
  ,.apb_pns_1      (1'b0)
  ,.apb_psel       (m_apb_psel)
  ,.apb_psel_1     (1'b0)
  ,.apb_puser      (m_apb_puser)
  ,.apb_puser_1    (13'b0)
  ,.apb_pwdata     (m_apb_pwdata)
  ,.apb_pwdata_1   (32'b0)
  ,.apb_pwrite     (m_apb_pwrite)
  ,.apb_pwrite_1   (1'b0)
  ,.apb_pwstrb     (m_apb_pwstrb)
  ,.apb_pwstrb_1   (4'b0)
  ,.apb_rstn       (rstn)
  ,.axi_0_arready  (cl_dut_axi_0.arready)
  ,.axi_0_awready  (cl_dut_axi_0.awready)
  ,.axi_0_bid      ({6'b0, cl_dut_axi_0.bid})  // 14 bits
  ,.axi_0_bresp    (cl_dut_axi_0.bresp)        // 2 bits
  ,.axi_0_bvalid   (cl_dut_axi_0.bvalid)
  ,.axi_0_rdata    (cl_dut_axi_0.rdata)        // 256 bits
  ,.axi_0_rid      ({6'b0, cl_dut_axi_0.rid})  // 14 bits
  ,.axi_0_rlast    (cl_dut_axi_0.rlast)
  ,.axi_0_rresp    (cl_dut_axi_0.rresp)        // 2 bits
  ,.axi_0_rvalid   (cl_dut_axi_0.rvalid)
  ,.axi_0_wready   (cl_dut_axi_0.wready)
  ,.axi_1_arready  (cl_dut_axi_1.arready)
  ,.axi_1_awready  (cl_dut_axi_1.awready)
  ,.axi_1_bid      ({6'b0, cl_dut_axi_1.bid})
  ,.axi_1_bresp    (cl_dut_axi_1.bresp)
  ,.axi_1_bvalid   (cl_dut_axi_1.bvalid)
  ,.axi_1_rdata    (cl_dut_axi_1.rdata)
  ,.axi_1_rid      ({6'b0, cl_dut_axi_1.rid})
  ,.axi_1_rlast    (cl_dut_axi_1.rlast)
  ,.axi_1_rresp    (cl_dut_axi_1.rresp)
  ,.axi_1_rvalid   (cl_dut_axi_1.rvalid)
  ,.axi_1_wready   (cl_dut_axi_1.wready)
  ,.axi_2_arready  (1'b1)
  ,.axi_2_awready  (1'b1)
  ,.axi_2_bid      (14'b0)
  ,.axi_2_bresp    (2'b0)
  ,.axi_2_bvalid   (1'b0)
  ,.axi_2_rdata    (256'b0)
  ,.axi_2_rid      (14'b0)
  ,.axi_2_rlast    (1'b0)
  ,.axi_2_rresp    (2'b0)
  ,.axi_2_rvalid   (1'b0)
  ,.axi_2_wready   (1'b1)
  ,.axi_3_arready  (1'b1)
  ,.axi_3_awready  (1'b1)
  ,.axi_3_bid      (14'b0)
  ,.axi_3_bresp    (2'b0)
  ,.axi_3_bvalid   (1'b0)
  ,.axi_3_rdata    (256'b0)
  ,.axi_3_rid      (14'b0)
  ,.axi_3_rlast    (1'b0)
  ,.axi_3_rresp    (2'b0)
  ,.axi_3_rvalid   (1'b0)
  ,.axi_3_wready   (1'b1)
  ,.intr_in        (32'b0)
  // outputs
  ,.apb_prdata     (m_apb_prdata)
  ,.apb_prdata_1   ()
  ,.apb_pready     (m_apb_pready)
  ,.apb_pready_1   ()
  ,.apb_pslverr    (m_apb_pslverr)
  ,.apb_pslverr_1  ()
  ,.axi_0_araddr   (axi_0_araddr)
  ,.axi_0_arburst  ()
  ,.axi_0_arcache  ()
  ,.axi_0_arid     (cl_dut_axi_0.arid)
  ,.axi_0_arlen    (cl_dut_axi_0.arlen)
  ,.axi_0_arlock   ()
  ,.axi_0_arprot   ()
  ,.axi_0_arqos    ()
  ,.axi_0_arregion ()
  ,.axi_0_arsize   (cl_dut_axi_0.arsize)
  ,.axi_0_aruser   ()
  ,.axi_0_arvalid  (cl_dut_axi_0.arvalid)
  ,.axi_0_awaddr   (axi_0_awaddr)
  ,.axi_0_awburst  ()
  ,.axi_0_awcache  ()
  ,.axi_0_awid     (cl_dut_axi_0.awid)
  ,.axi_0_awlen    (cl_dut_axi_0.awlen)
  ,.axi_0_awlock   ()
  ,.axi_0_awprot   ()
  ,.axi_0_awqos    ()
  ,.axi_0_awregion ()
  ,.axi_0_awsize   (cl_dut_axi_0.awsize)
  ,.axi_0_awuser   ()
  ,.axi_0_awvalid  (cl_dut_axi_0.awvalid)
  ,.axi_0_bready   (cl_dut_axi_0.bready)
  ,.axi_0_rready   (cl_dut_axi_0.rready)
  ,.axi_0_wdata    (cl_dut_axi_0.wdata)
  ,.axi_0_wlast    (cl_dut_axi_0.wlast)
  ,.axi_0_wstrb    (cl_dut_axi_0.wstrb)
  ,.axi_0_wvalid   (cl_dut_axi_0.wvalid)
  ,.axi_1_araddr   (axi_1_araddr)
  ,.axi_1_arburst  ()
  ,.axi_1_arcache  ()
  ,.axi_1_arid     (cl_dut_axi_1.arid)
  ,.axi_1_arlen    (cl_dut_axi_1.arlen)
  ,.axi_1_arlock   ()
  ,.axi_1_arprot   ()
  ,.axi_1_arqos    ()
  ,.axi_1_arregion ()
  ,.axi_1_arsize   (cl_dut_axi_1.arsize)
  ,.axi_1_aruser   ()
  ,.axi_1_arvalid  (cl_dut_axi_1.arvalid)
  ,.axi_1_awaddr   (axi_1_awaddr)
  ,.axi_1_awburst  ()
  ,.axi_1_awcache  ()
  ,.axi_1_awid     (cl_dut_axi_1.awid)
  ,.axi_1_awlen    (cl_dut_axi_1.awlen)
  ,.axi_1_awlock   ()
  ,.axi_1_awprot   ()
  ,.axi_1_awqos    ()
  ,.axi_1_awregion ()
  ,.axi_1_awsize   (cl_dut_axi_1.awsize)
  ,.axi_1_awuser   ()
  ,.axi_1_awvalid  (cl_dut_axi_1.awvalid)
  ,.axi_1_bready   (cl_dut_axi_1.bready)
  ,.axi_1_rready   (cl_dut_axi_1.rready)
  ,.axi_1_wdata    (cl_dut_axi_1.wdata)
  ,.axi_1_wlast    (cl_dut_axi_1.wlast)
  ,.axi_1_wstrb    (cl_dut_axi_1.wstrb)
  ,.axi_1_wvalid   (cl_dut_axi_1.wvalid)
  ,.axi_2_araddr   ()
  ,.axi_2_arburst  ()
  ,.axi_2_arcache  ()
  ,.axi_2_arid     ()
  ,.axi_2_arlen    ()
  ,.axi_2_arlock   ()
  ,.axi_2_arprot   ()
  ,.axi_2_arqos    ()
  ,.axi_2_arregion ()
  ,.axi_2_arsize   ()
  ,.axi_2_aruser   ()
  ,.axi_2_arvalid  ()
  ,.axi_2_awaddr   ()
  ,.axi_2_awburst  ()
  ,.axi_2_awcache  ()
  ,.axi_2_awid     ()
  ,.axi_2_awlen    ()
  ,.axi_2_awlock   ()
  ,.axi_2_awprot   ()
  ,.axi_2_awqos    ()
  ,.axi_2_awregion ()
  ,.axi_2_awsize   ()
  ,.axi_2_awuser   ()
  ,.axi_2_awvalid  ()
  ,.axi_2_bready   ()
  ,.axi_2_rready   ()
  ,.axi_2_wdata    ()
  ,.axi_2_wlast    ()
  ,.axi_2_wstrb    ()
  ,.axi_2_wvalid   ()
  ,.axi_3_araddr   ()
  ,.axi_3_arburst  ()
  ,.axi_3_arcache  ()
  ,.axi_3_arid     ()
  ,.axi_3_arlen    ()
  ,.axi_3_arlock   ()
  ,.axi_3_arprot   ()
  ,.axi_3_arqos    ()
  ,.axi_3_arregion ()
  ,.axi_3_arsize   ()
  ,.axi_3_aruser   ()
  ,.axi_3_arvalid  ()
  ,.axi_3_awaddr   ()
  ,.axi_3_awburst  ()
  ,.axi_3_awcache  ()
  ,.axi_3_awid     ()
  ,.axi_3_awlen    ()
  ,.axi_3_awlock   ()
  ,.axi_3_awprot   ()
  ,.axi_3_awqos    ()
  ,.axi_3_awregion ()
  ,.axi_3_awsize   ()
  ,.axi_3_awuser   ()
  ,.axi_3_awvalid  ()
  ,.axi_3_bready   ()
  ,.axi_3_rready   ()
  ,.axi_3_wdata    ()
  ,.axi_3_wlast    ()
  ,.axi_3_wstrb    ()
  ,.axi_3_wvalid   ()
  ,.intr_out       (irq_upstream[31:0])   // FIXME. need connect to interrupt transactor
  );

endmodule
