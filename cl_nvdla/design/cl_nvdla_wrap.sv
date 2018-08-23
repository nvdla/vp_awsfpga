// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cl_nvdla_wrap.sv
`include "cl_nvdla_defines.vh"

module cl_nvdla_wrap
(
    input clk,
    input rstn,
    
    output dla_intr,
    input  [63:0]  base_addr0,
`ifdef NVDLA_CVSRAM_PRESENT
    input  [63:0]  base_addr1,
`endif

    axi_bus_t.slave cl_dut_axi_0,
`ifdef NVDLA_CVSRAM_PRESENT
    axi_bus_t.slave cl_dut_axi_1,
`endif

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

wire        m_csb2nvdla_valid;   
wire        m_csb2nvdla_ready; 
wire [15:0] m_csb2nvdla_addr;
wire [31:0] m_csb2nvdla_wdat;
wire        m_csb2nvdla_write;
wire        m_csb2nvdla_nposted;
wire        m_nvdla2csb_valid; 
wire [31:0] m_nvdla2csb_data;

wire    [63:0]  axi_0_awaddr;
wire    [63:0]  axi_1_awaddr;
wire    [63:0]  axi_0_araddr;
wire    [63:0]  axi_1_araddr;

assign cl_dut_axi_0.awaddr = axi_0_awaddr - base_addr0;
assign cl_dut_axi_0.araddr = axi_0_araddr - base_addr0;
`ifdef NVDLA_CVSRAM_PRESENT
assign cl_dut_axi_1.awaddr = axi_1_awaddr - base_addr1;
assign cl_dut_axi_1.araddr = axi_1_araddr - base_addr1;
`endif

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
assign m_apb_pslverr = 1'b0;


NV_NVDLA_apb2csb apb2csb (
   .pclk                  (clk)
  ,.prstn                 (rstn)
  ,.csb2nvdla_ready       (m_csb2nvdla_ready)
  ,.nvdla2csb_data        (m_nvdla2csb_data)
  ,.nvdla2csb_valid       (m_nvdla2csb_valid)
  ,.paddr                 (m_apb_paddr)
  ,.penable               (m_apb_penable)
  ,.psel                  (m_apb_psel)
  ,.pwdata                (m_apb_pwdata)
  ,.pwrite                (m_apb_pwrite)
  ,.csb2nvdla_addr        (m_csb2nvdla_addr)
  ,.csb2nvdla_nposted     (m_csb2nvdla_nposted)
  ,.csb2nvdla_valid       (m_csb2nvdla_valid)
  ,.csb2nvdla_wdat        (m_csb2nvdla_wdat)
  ,.csb2nvdla_write       (m_csb2nvdla_write)
  ,.prdata                (m_apb_prdata)
  ,.pready                (m_apb_pready)
);


NV_nvdla nvdla_top (
   .dla_core_clk                    (clk)
  ,.dla_csb_clk                     (clk)
  ,.global_clk_ovr_on               (1'b0)
  ,.tmc2slcg_disable_clock_gating   (1'b0)
  ,.dla_reset_rstn                  (rstn)
  ,.direct_reset_                   (rstn)
  ,.test_mode                       (1'b0)
  ,.csb2nvdla_valid                 (m_csb2nvdla_valid)
  ,.csb2nvdla_ready                 (m_csb2nvdla_ready)
  ,.csb2nvdla_addr                  (m_csb2nvdla_addr)
  ,.csb2nvdla_wdat                  (m_csb2nvdla_wdat)
  ,.csb2nvdla_write                 (m_csb2nvdla_write)
  ,.csb2nvdla_nposted               (m_csb2nvdla_nposted)
  ,.nvdla2csb_valid                 (m_nvdla2csb_valid)
  ,.nvdla2csb_data                  (m_nvdla2csb_data)
  ,.nvdla2csb_wr_complete           () //FIXME: no such port in apb2csb
  ,.nvdla_core2dbb_aw_awvalid       (cl_dut_axi_0.awvalid)
  ,.nvdla_core2dbb_aw_awready       (cl_dut_axi_0.awready)
  ,.nvdla_core2dbb_aw_awaddr        (axi_0_awaddr)
  ,.nvdla_core2dbb_aw_awid          (cl_dut_axi_0.awid)
  ,.nvdla_core2dbb_aw_awlen         (cl_dut_axi_0.awlen)
  ,.nvdla_core2dbb_w_wvalid         (cl_dut_axi_0.wvalid)
  ,.nvdla_core2dbb_w_wready         (cl_dut_axi_0.wready)
  ,.nvdla_core2dbb_w_wdata          (cl_dut_axi_0.wdata)
  ,.nvdla_core2dbb_w_wstrb          (cl_dut_axi_0.wstrb)
  ,.nvdla_core2dbb_w_wlast          (cl_dut_axi_0.wlast)
  ,.nvdla_core2dbb_b_bvalid         (cl_dut_axi_0.bvalid)
  ,.nvdla_core2dbb_b_bready         (cl_dut_axi_0.bready)
  ,.nvdla_core2dbb_b_bid            (cl_dut_axi_0.bid)
  ,.nvdla_core2dbb_ar_arvalid       (cl_dut_axi_0.arvalid)
  ,.nvdla_core2dbb_ar_arready       (cl_dut_axi_0.arready)
  ,.nvdla_core2dbb_ar_araddr        (axi_0_araddr)
  ,.nvdla_core2dbb_ar_arid          (cl_dut_axi_0.arid)
  ,.nvdla_core2dbb_ar_arlen         (cl_dut_axi_0.arlen)
  ,.nvdla_core2dbb_r_rvalid         (cl_dut_axi_0.rvalid)
  ,.nvdla_core2dbb_r_rready         (cl_dut_axi_0.rready)
  ,.nvdla_core2dbb_r_rid            (cl_dut_axi_0.rid)
  ,.nvdla_core2dbb_r_rlast          (cl_dut_axi_0.rlast)
  ,.nvdla_core2dbb_r_rdata          (cl_dut_axi_0.rdata)
`ifdef NVDLA_CVSRAM_PRESENT
  ,.nvdla_core2cvsram_aw_awvalid    (cl_dut_axi_1.awvalid)
  ,.nvdla_core2cvsram_aw_awready    (cl_dut_axi_1.awready)
  ,.nvdla_core2cvsram_aw_awaddr     (axi_1_awaddr)
  ,.nvdla_core2cvsram_aw_awid       (cl_dut_axi_1.awid)
  ,.nvdla_core2cvsram_aw_awlen      (cl_dut_axi_1.awlen)
  ,.nvdla_core2cvsram_w_wvalid      (cl_dut_axi_1.wvalid)
  ,.nvdla_core2cvsram_w_wready      (cl_dut_axi_1.wready)
  ,.nvdla_core2cvsram_w_wdata       (cl_dut_axi_1.wdata)
  ,.nvdla_core2cvsram_w_wstrb       (cl_dut_axi_1.wstrb)
  ,.nvdla_core2cvsram_w_wlast       (cl_dut_axi_1.wlast)
  ,.nvdla_core2cvsram_b_bvalid      (cl_dut_axi_1.bvalid)
  ,.nvdla_core2cvsram_b_bready      (cl_dut_axi_1.bready)
  ,.nvdla_core2cvsram_b_bid         (cl_dut_axi_1.bid)
  ,.nvdla_core2cvsram_ar_arvalid    (cl_dut_axi_1.arvalid)
  ,.nvdla_core2cvsram_ar_arready    (cl_dut_axi_1.arready)
  ,.nvdla_core2cvsram_ar_araddr     (axi_1_araddr)
  ,.nvdla_core2cvsram_ar_arid       (cl_dut_axi_1.arid)
  ,.nvdla_core2cvsram_ar_arlen      (cl_dut_axi_1.arlen)
  ,.nvdla_core2cvsram_r_rvalid      (cl_dut_axi_1.rvalid)
  ,.nvdla_core2cvsram_r_rready      (cl_dut_axi_1.rready)
  ,.nvdla_core2cvsram_r_rid         (cl_dut_axi_1.rid)
  ,.nvdla_core2cvsram_r_rlast       (cl_dut_axi_1.rlast)
  ,.nvdla_core2cvsram_r_rdata       (cl_dut_axi_1.rdata)
`endif
  ,.dla_intr                        (dla_intr)
  ,.nvdla_pwrbus_ram_c_pd           (32'b0)
  ,.nvdla_pwrbus_ram_ma_pd          (32'b0)
  ,.nvdla_pwrbus_ram_mb_pd          (32'b0)
  ,.nvdla_pwrbus_ram_p_pd           (32'b0)
  ,.nvdla_pwrbus_ram_o_pd           (32'b0)
  ,.nvdla_pwrbus_ram_a_pd           (32'b0)
); // nvdla_top

`ifdef NVDLA_AXI_WIDTH_256
	assign cl_dut_axi_0.awsize = 3'b101;
	assign cl_dut_axi_0.arsize = 3'b101;
`elsif NVDLA_AXI_WIDTH_128
	assign cl_dut_axi_0.awsize = 3'b100;
	assign cl_dut_axi_0.arsize = 3'b100;
`else
	assign cl_dut_axi_0.awsize = 3'b011;
	assign cl_dut_axi_0.arsize = 3'b011;
`endif 

`ifdef NVDLA_CVSRAM_PRESENT
	`ifdef NVDLA_AXI_WIDTH_256
		assign cl_dut_axi_1.awsize = 3'b101;
		assign cl_dut_axi_1.arsize = 3'b101;
	`else 
		assign cl_dut_axi_1.awsize = 3'b011;
		assign cl_dut_axi_1.arsize = 3'b011;
	`endif
`endif


endmodule
