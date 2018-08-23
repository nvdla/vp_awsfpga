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

`include "cl_nvdla_defines.vh"

module cl_dma_pcis_slv #(parameter SCRB_MAX_ADDR = 64'h3FFFFFFFF, parameter SCRB_BURST_LEN_MINUS1 = 15, parameter NO_SCRB_INST = 1)

(
    input aclk,
    input aresetn,

    axi_bus_t.master sh_cl_dma_pcis_bus,
    axi_bus_t.master nvdla_dbb_axi_bus,
`ifdef NVDLA_CVSRAM_PRESENT
    axi_bus_t.master nvdla_cvsram_axi_bus,
`endif

    axi_bus_t sh_cl_dma_pcis_q,

    axi_bus_t.slave cl_sh_ddr_bus

 
);
localparam NUM_CFG_STGS_CL_DDR_ATG = 4;
localparam NUM_CFG_STGS_SH_DDR_ATG = 4;

//---------------------------- 
// Internal signals
//---------------------------- 
axi_bus_t cl_sh_ddr_q();
axi_bus_t cl_sh_ddr_q2();
axi_bus_t sh_cl_pcis();
    
//---------------------------- 
// End Internal signals
//---------------------------- 


//reset synchronizers
(* dont_touch = "true" *) logic slr0_sync_aresetn;
(* dont_touch = "true" *) logic slr1_sync_aresetn;
(* dont_touch = "true" *) logic slr2_sync_aresetn;
lib_pipe #(.WIDTH(1), .STAGES(4)) SLR0_PIPE_RST_N (.clk(aclk), .rst_n(1'b1), .in_bus(aresetn), .out_bus(slr0_sync_aresetn));
lib_pipe #(.WIDTH(1), .STAGES(4)) SLR1_PIPE_RST_N (.clk(aclk), .rst_n(1'b1), .in_bus(aresetn), .out_bus(slr1_sync_aresetn));
lib_pipe #(.WIDTH(1), .STAGES(4)) SLR2_PIPE_RST_N (.clk(aclk), .rst_n(1'b1), .in_bus(aresetn), .out_bus(slr2_sync_aresetn));

//---------------------------- 
// flop the dma_pcis interface input of CL 
//---------------------------- 

   // AXI4 Register Slice for dma_pcis interface
   axi_register_slice PCI_AXL_REG_SLC (
       .aclk          (aclk),
       .aresetn       (slr0_sync_aresetn),
       .s_axi_awid    (sh_cl_dma_pcis_bus.awid),
       .s_axi_awaddr  (sh_cl_dma_pcis_bus.awaddr),
       .s_axi_awlen   (sh_cl_dma_pcis_bus.awlen),                                            
       .s_axi_awvalid (sh_cl_dma_pcis_bus.awvalid),
       .s_axi_awsize  (sh_cl_dma_pcis_bus.awsize),
       .s_axi_awready (sh_cl_dma_pcis_bus.awready),
       .s_axi_wdata   (sh_cl_dma_pcis_bus.wdata),
       .s_axi_wstrb   (sh_cl_dma_pcis_bus.wstrb),
       .s_axi_wlast   (sh_cl_dma_pcis_bus.wlast),
       .s_axi_wvalid  (sh_cl_dma_pcis_bus.wvalid),
       .s_axi_wready  (sh_cl_dma_pcis_bus.wready),
       .s_axi_bid     (sh_cl_dma_pcis_bus.bid),
       .s_axi_bresp   (sh_cl_dma_pcis_bus.bresp),
       .s_axi_bvalid  (sh_cl_dma_pcis_bus.bvalid),
       .s_axi_bready  (sh_cl_dma_pcis_bus.bready),
       .s_axi_arid    (sh_cl_dma_pcis_bus.arid),
       .s_axi_araddr  (sh_cl_dma_pcis_bus.araddr),
       .s_axi_arlen   (sh_cl_dma_pcis_bus.arlen), 
       .s_axi_arvalid (sh_cl_dma_pcis_bus.arvalid),
       .s_axi_arsize  (sh_cl_dma_pcis_bus.arsize),
       .s_axi_arready (sh_cl_dma_pcis_bus.arready),
       .s_axi_rid     (sh_cl_dma_pcis_bus.rid),
       .s_axi_rdata   (sh_cl_dma_pcis_bus.rdata),
       .s_axi_rresp   (sh_cl_dma_pcis_bus.rresp),
       .s_axi_rlast   (sh_cl_dma_pcis_bus.rlast),
       .s_axi_rvalid  (sh_cl_dma_pcis_bus.rvalid),
       .s_axi_rready  (sh_cl_dma_pcis_bus.rready),
 
       .m_axi_awid    (sh_cl_dma_pcis_q.awid),
       .m_axi_awaddr  (sh_cl_dma_pcis_q.awaddr), 
       .m_axi_awlen   (sh_cl_dma_pcis_q.awlen),
       .m_axi_awvalid (sh_cl_dma_pcis_q.awvalid),
       .m_axi_awsize  (sh_cl_dma_pcis_q.awsize),
       .m_axi_awready (sh_cl_dma_pcis_q.awready),
       .m_axi_wdata   (sh_cl_dma_pcis_q.wdata),  
       .m_axi_wstrb   (sh_cl_dma_pcis_q.wstrb),
       .m_axi_wvalid  (sh_cl_dma_pcis_q.wvalid), 
       .m_axi_wlast   (sh_cl_dma_pcis_q.wlast),
       .m_axi_wready  (sh_cl_dma_pcis_q.wready), 
       .m_axi_bresp   (sh_cl_dma_pcis_q.bresp),  
       .m_axi_bvalid  (sh_cl_dma_pcis_q.bvalid), 
       .m_axi_bid     (sh_cl_dma_pcis_q.bid),
       .m_axi_bready  (sh_cl_dma_pcis_q.bready), 
       .m_axi_arid    (sh_cl_dma_pcis_q.arid), 
       .m_axi_araddr  (sh_cl_dma_pcis_q.araddr), 
       .m_axi_arlen   (sh_cl_dma_pcis_q.arlen), 
       .m_axi_arsize  (sh_cl_dma_pcis_q.arsize), 
       .m_axi_arvalid (sh_cl_dma_pcis_q.arvalid),
       .m_axi_arready (sh_cl_dma_pcis_q.arready),
       .m_axi_rid     (sh_cl_dma_pcis_q.rid),  
       .m_axi_rdata   (sh_cl_dma_pcis_q.rdata),  
       .m_axi_rresp   (sh_cl_dma_pcis_q.rresp),  
       .m_axi_rlast   (sh_cl_dma_pcis_q.rlast),  
       .m_axi_rvalid  (sh_cl_dma_pcis_q.rvalid), 
       .m_axi_rready  (sh_cl_dma_pcis_q.rready)
   );


//---------------------------- 
// axi interconnect for DDR address decodes 
//---------------------------- 
`ifdef NVDLA_AXI_WIDTH_256
	(* dont_touch = "true" *) axi_interconnect_nv_large  AXI_INTERCONNECT ( 
`elsif NVDLA_AXI_WIDTH_128
	(* dont_touch = "true" *) axi_interconnect_nvdla_128b AXI_INTERCONNECT ( 
`else 
	`ifdef NVDLA_CVSRAM_PRESENT
		(* dont_touch = "true" *) axi_interconnect_nvdla_64b_cvsram AXI_INTERCONNECT ( 
	`else
		(* dont_touch = "true" *) axi_interconnect_nvdla_64b AXI_INTERCONNECT ( 
	`endif
`endif
     .INTERCONNECT_ACLK     (aclk)
    ,.INTERCONNECT_ARESETN  (slr1_sync_aresetn)
    ,.S00_AXI_ARESET_OUT_N  ()
    ,.S00_AXI_ACLK          (aclk)
    ,.S00_AXI_AWID          ({2'b0, sh_cl_dma_pcis_q.awid[5:0]})
    ,.S00_AXI_AWADDR        ({sh_cl_dma_pcis_q.awaddr[63:37], 1'b0, sh_cl_dma_pcis_q.awaddr[35:0]})
    ,.S00_AXI_AWLEN         (sh_cl_dma_pcis_q.awlen)
    ,.S00_AXI_AWSIZE        (sh_cl_dma_pcis_q.awsize)
    ,.S00_AXI_AWBURST       (2'b01)
    ,.S00_AXI_AWLOCK        (1'b0)
    ,.S00_AXI_AWCACHE       (4'b11)
    ,.S00_AXI_AWPROT        (3'b010)
    ,.S00_AXI_AWQOS         (4'b0)
    ,.S00_AXI_AWVALID       (sh_cl_dma_pcis_q.awvalid)
    ,.S00_AXI_AWREADY       (sh_cl_dma_pcis_q.awready)
    ,.S00_AXI_WDATA         (sh_cl_dma_pcis_q.wdata)
    ,.S00_AXI_WSTRB         (sh_cl_dma_pcis_q.wstrb)
    ,.S00_AXI_WLAST         (sh_cl_dma_pcis_q.wlast)
    ,.S00_AXI_WVALID        (sh_cl_dma_pcis_q.wvalid)
    ,.S00_AXI_WREADY        (sh_cl_dma_pcis_q.wready)
    ,.S00_AXI_BID           (sh_cl_dma_pcis_q.bid[5:0])
    ,.S00_AXI_BRESP         (sh_cl_dma_pcis_q.bresp)
    ,.S00_AXI_BVALID        (sh_cl_dma_pcis_q.bvalid)
    ,.S00_AXI_BREADY        (sh_cl_dma_pcis_q.bready)
    ,.S00_AXI_ARID          ({2'b0, sh_cl_dma_pcis_q.arid[5:0]})
    ,.S00_AXI_ARADDR        (sh_cl_dma_pcis_q.araddr)
    ,.S00_AXI_ARLEN         (sh_cl_dma_pcis_q.arlen)
    ,.S00_AXI_ARSIZE        (sh_cl_dma_pcis_q.arsize)
    ,.S00_AXI_ARBURST       (2'b01)
    ,.S00_AXI_ARLOCK        (1'b0)
    ,.S00_AXI_ARCACHE       (4'b11)
    ,.S00_AXI_ARPROT        (3'b010)
    ,.S00_AXI_ARQOS         (4'b0)
    ,.S00_AXI_ARVALID       (sh_cl_dma_pcis_q.arvalid)
    ,.S00_AXI_ARREADY       (sh_cl_dma_pcis_q.arready)
    ,.S00_AXI_RID           (sh_cl_dma_pcis_q.rid[5:0])
    ,.S00_AXI_RDATA         (sh_cl_dma_pcis_q.rdata)
    ,.S00_AXI_RRESP         (sh_cl_dma_pcis_q.rresp)
    ,.S00_AXI_RLAST         (sh_cl_dma_pcis_q.rlast)
    ,.S00_AXI_RVALID        (sh_cl_dma_pcis_q.rvalid)
    ,.S00_AXI_RREADY        (sh_cl_dma_pcis_q.rready)
    ,.S01_AXI_ARESET_OUT_N  ()
    ,.S01_AXI_ACLK          (aclk)
    ,.S01_AXI_AWID          (nvdla_dbb_axi_bus.awid)
    ,.S01_AXI_AWADDR        (nvdla_dbb_axi_bus.awaddr)
    ,.S01_AXI_AWLEN         ({4'b0, nvdla_dbb_axi_bus.awlen})
    ,.S01_AXI_AWSIZE        (nvdla_dbb_axi_bus.awsize)
    ,.S01_AXI_AWBURST       (2'b01)
    ,.S01_AXI_AWLOCK        (1'b0)
    ,.S01_AXI_AWCACHE       (4'b11)
    ,.S01_AXI_AWPROT        (3'b010)
    ,.S01_AXI_AWQOS         (4'b0)
    ,.S01_AXI_AWVALID       (nvdla_dbb_axi_bus.awvalid)
    ,.S01_AXI_AWREADY       (nvdla_dbb_axi_bus.awready)
    ,.S01_AXI_WDATA         (nvdla_dbb_axi_bus.wdata)
    ,.S01_AXI_WSTRB         (nvdla_dbb_axi_bus.wstrb)
    ,.S01_AXI_WLAST         (nvdla_dbb_axi_bus.wlast)
    ,.S01_AXI_WVALID        (nvdla_dbb_axi_bus.wvalid)
    ,.S01_AXI_WREADY        (nvdla_dbb_axi_bus.wready)
    ,.S01_AXI_BID           (nvdla_dbb_axi_bus.bid)
    ,.S01_AXI_BRESP         (nvdla_dbb_axi_bus.bresp)
    ,.S01_AXI_BVALID        (nvdla_dbb_axi_bus.bvalid)
    ,.S01_AXI_BREADY        (nvdla_dbb_axi_bus.bready)
    ,.S01_AXI_ARID          (nvdla_dbb_axi_bus.arid)
    ,.S01_AXI_ARADDR        (nvdla_dbb_axi_bus.araddr)
    ,.S01_AXI_ARLEN         ({4'b0, nvdla_dbb_axi_bus.arlen})
    ,.S01_AXI_ARSIZE        (nvdla_dbb_axi_bus.arsize)
    ,.S01_AXI_ARBURST       (2'b01)
    ,.S01_AXI_ARLOCK        (1'b0)
    ,.S01_AXI_ARCACHE       (4'b11)
    ,.S01_AXI_ARPROT        (3'b10)
    ,.S01_AXI_ARQOS         (4'b0)
    ,.S01_AXI_ARVALID       (nvdla_dbb_axi_bus.arvalid)
    ,.S01_AXI_ARREADY       (nvdla_dbb_axi_bus.arready)
    ,.S01_AXI_RID           (nvdla_dbb_axi_bus.rid)
    ,.S01_AXI_RDATA         (nvdla_dbb_axi_bus.rdata)
    ,.S01_AXI_RRESP         (nvdla_dbb_axi_bus.rresp)
    ,.S01_AXI_RLAST         (nvdla_dbb_axi_bus.rlast)
    ,.S01_AXI_RVALID        (nvdla_dbb_axi_bus.rvalid)
    ,.S01_AXI_RREADY        (nvdla_dbb_axi_bus.rready)
`ifdef NVDLA_CVSRAM_PRESENT
    ,.S02_AXI_ARESET_OUT_N  ()
    ,.S02_AXI_ACLK          (aclk)
    ,.S02_AXI_AWID          (nvdla_cvsram_axi_bus.awid)
    ,.S02_AXI_AWADDR        (nvdla_cvsram_axi_bus.awaddr)
    ,.S02_AXI_AWLEN         ({4'b0, nvdla_cvsram_axi_bus.awlen})
    ,.S02_AXI_AWSIZE        (nvdla_cvsram_axi_bus.awsize)
    ,.S02_AXI_AWBURST       (2'b01)
    ,.S02_AXI_AWLOCK        (1'b0)
    ,.S02_AXI_AWCACHE       (4'b11)
    ,.S02_AXI_AWPROT        (3'b10)
    ,.S02_AXI_AWQOS         (4'b0)
    ,.S02_AXI_AWVALID       (nvdla_cvsram_axi_bus.awvalid)
    ,.S02_AXI_AWREADY       (nvdla_cvsram_axi_bus.awready)
    ,.S02_AXI_WDATA         (nvdla_cvsram_axi_bus.wdata)
    ,.S02_AXI_WSTRB         (nvdla_cvsram_axi_bus.wstrb)
    ,.S02_AXI_WLAST         (nvdla_cvsram_axi_bus.wlast)
    ,.S02_AXI_WVALID        (nvdla_cvsram_axi_bus.wvalid)
    ,.S02_AXI_WREADY        (nvdla_cvsram_axi_bus.wready)
    ,.S02_AXI_BID           (nvdla_cvsram_axi_bus.bid)
    ,.S02_AXI_BRESP         (nvdla_cvsram_axi_bus.bresp)
    ,.S02_AXI_BVALID        (nvdla_cvsram_axi_bus.bvalid)
    ,.S02_AXI_BREADY        (nvdla_cvsram_axi_bus.bready)
    ,.S02_AXI_ARID          (nvdla_cvsram_axi_bus.arid)
    ,.S02_AXI_ARADDR        (nvdla_cvsram_axi_bus.araddr)
    ,.S02_AXI_ARLEN         ({4'b0, nvdla_cvsram_axi_bus.arlen})
    ,.S02_AXI_ARSIZE        (nvdla_cvsram_axi_bus.arsize)
    ,.S02_AXI_ARBURST       (2'b01)
    ,.S02_AXI_ARLOCK        (1'b0)
    ,.S02_AXI_ARCACHE       (4'b11)
    ,.S02_AXI_ARPROT        (3'b10)
    ,.S02_AXI_ARQOS         (4'b0)
    ,.S02_AXI_ARVALID       (nvdla_cvsram_axi_bus.arvalid)
    ,.S02_AXI_ARREADY       (nvdla_cvsram_axi_bus.arready)
    ,.S02_AXI_RID           (nvdla_cvsram_axi_bus.rid)
    ,.S02_AXI_RDATA         (nvdla_cvsram_axi_bus.rdata)
    ,.S02_AXI_RRESP         (nvdla_cvsram_axi_bus.rresp)
    ,.S02_AXI_RLAST         (nvdla_cvsram_axi_bus.rlast)
    ,.S02_AXI_RVALID        (nvdla_cvsram_axi_bus.rvalid)
    ,.S02_AXI_RREADY        (nvdla_cvsram_axi_bus.rready)
`endif
    ,.M00_AXI_ARESET_OUT_N  ()
    ,.M00_AXI_ACLK          (aclk)
    ,.M00_AXI_AWID          (cl_sh_ddr_q.awid[11:0])
    ,.M00_AXI_AWADDR        (cl_sh_ddr_q.awaddr)
    ,.M00_AXI_AWLEN         (cl_sh_ddr_q.awlen)
    ,.M00_AXI_AWSIZE        (cl_sh_ddr_q.awsize)
    ,.M00_AXI_AWBURST       ()
    ,.M00_AXI_AWLOCK        ()
    ,.M00_AXI_AWCACHE       ()
    ,.M00_AXI_AWPROT        ()
    ,.M00_AXI_AWQOS         ()
    ,.M00_AXI_AWVALID       (cl_sh_ddr_q.awvalid)
    ,.M00_AXI_AWREADY       (cl_sh_ddr_q.awready)
    ,.M00_AXI_WDATA         (cl_sh_ddr_q.wdata)
    ,.M00_AXI_WSTRB         (cl_sh_ddr_q.wstrb)
    ,.M00_AXI_WLAST         (cl_sh_ddr_q.wlast)
    ,.M00_AXI_WVALID        (cl_sh_ddr_q.wvalid)
    ,.M00_AXI_WREADY        (cl_sh_ddr_q.wready)
    ,.M00_AXI_BID           (cl_sh_ddr_q.bid[11:0])
    ,.M00_AXI_BRESP         (cl_sh_ddr_q.bresp)
    ,.M00_AXI_BVALID        (cl_sh_ddr_q.bvalid)
    ,.M00_AXI_BREADY        (cl_sh_ddr_q.bready)
    ,.M00_AXI_ARID          (cl_sh_ddr_q.arid[11:0])
    ,.M00_AXI_ARADDR        (cl_sh_ddr_q.araddr)
    ,.M00_AXI_ARLEN         (cl_sh_ddr_q.arlen)
    ,.M00_AXI_ARSIZE        (cl_sh_ddr_q.arsize)
    ,.M00_AXI_ARBURST       ()
    ,.M00_AXI_ARLOCK        ()
    ,.M00_AXI_ARCACHE       ()
    ,.M00_AXI_ARPROT        ()
    ,.M00_AXI_ARQOS         ()
    ,.M00_AXI_ARVALID       (cl_sh_ddr_q.arvalid)
    ,.M00_AXI_ARREADY       (cl_sh_ddr_q.arready)
    ,.M00_AXI_RID           (cl_sh_ddr_q.rid[11:0])
    ,.M00_AXI_RDATA         (cl_sh_ddr_q.rdata)
    ,.M00_AXI_RRESP         (cl_sh_ddr_q.rresp)
    ,.M00_AXI_RLAST         (cl_sh_ddr_q.rlast)
    ,.M00_AXI_RVALID        (cl_sh_ddr_q.rvalid)
    ,.M00_AXI_RREADY        (cl_sh_ddr_q.rready));

assign cl_sh_ddr_q.arid[15:12] = 4'b0;
assign cl_sh_ddr_q.awid[15:12] = 4'b0;

//---------------------------- 
// flop the output of interconnect for DDRC 
//---------------------------- 
   axi_register_slice DDR_C_TST_AXI4_REG_SLC (
       .aclk           (aclk),
       .aresetn        (slr1_sync_aresetn),
                                                                                                                                  
       .s_axi_awid     (cl_sh_ddr_q.awid),
       .s_axi_awaddr   ({cl_sh_ddr_q.awaddr[63:36], 2'b0, cl_sh_ddr_q.awaddr[33:0]}),
       .s_axi_awlen    (cl_sh_ddr_q.awlen),
       .s_axi_awsize   (cl_sh_ddr_q.awsize),
       .s_axi_awvalid  (cl_sh_ddr_q.awvalid),
       .s_axi_awready  (cl_sh_ddr_q.awready),
       .s_axi_wdata    (cl_sh_ddr_q.wdata),
       .s_axi_wstrb    (cl_sh_ddr_q.wstrb),
       .s_axi_wlast    (cl_sh_ddr_q.wlast),
       .s_axi_wvalid   (cl_sh_ddr_q.wvalid),
       .s_axi_wready   (cl_sh_ddr_q.wready),
       .s_axi_bid      (cl_sh_ddr_q.bid),
       .s_axi_bresp    (cl_sh_ddr_q.bresp),
       .s_axi_bvalid   (cl_sh_ddr_q.bvalid),
       .s_axi_bready   (cl_sh_ddr_q.bready),
       .s_axi_arid     (cl_sh_ddr_q.arid),
       .s_axi_araddr   ({cl_sh_ddr_q.araddr[63:36], 2'b0, cl_sh_ddr_q.araddr[33:0]}),
       .s_axi_arlen    (cl_sh_ddr_q.arlen),
       .s_axi_arsize   (cl_sh_ddr_q.arsize),
       .s_axi_arvalid  (cl_sh_ddr_q.arvalid),
       .s_axi_arready  (cl_sh_ddr_q.arready),
       .s_axi_rid      (cl_sh_ddr_q.rid),
       .s_axi_rdata    (cl_sh_ddr_q.rdata),
       .s_axi_rresp    (cl_sh_ddr_q.rresp),
       .s_axi_rlast    (cl_sh_ddr_q.rlast),
       .s_axi_rvalid   (cl_sh_ddr_q.rvalid),
       .s_axi_rready   (cl_sh_ddr_q.rready),  
       .m_axi_awid     (cl_sh_ddr_q2.awid),   
       .m_axi_awaddr   (cl_sh_ddr_q2.awaddr), 
       .m_axi_awlen    (cl_sh_ddr_q2.awlen),  
       .m_axi_awsize   (cl_sh_ddr_q2.awsize),
       .m_axi_awvalid  (cl_sh_ddr_q2.awvalid),
       .m_axi_awready  (cl_sh_ddr_q2.awready),
       .m_axi_wdata    (cl_sh_ddr_q2.wdata),  
       .m_axi_wstrb    (cl_sh_ddr_q2.wstrb),  
       .m_axi_wlast    (cl_sh_ddr_q2.wlast),  
       .m_axi_wvalid   (cl_sh_ddr_q2.wvalid), 
       .m_axi_wready   (cl_sh_ddr_q2.wready), 
       .m_axi_bid      (cl_sh_ddr_q2.bid),    
       .m_axi_bresp    (cl_sh_ddr_q2.bresp),  
       .m_axi_bvalid   (cl_sh_ddr_q2.bvalid), 
       .m_axi_bready   (cl_sh_ddr_q2.bready), 
       .m_axi_arid     (cl_sh_ddr_q2.arid),   
       .m_axi_araddr   (cl_sh_ddr_q2.araddr), 
       .m_axi_arlen    (cl_sh_ddr_q2.arlen),  
       .m_axi_arsize   (cl_sh_ddr_q2.arsize),
       .m_axi_arvalid  (cl_sh_ddr_q2.arvalid),
       .m_axi_arready  (cl_sh_ddr_q2.arready),
       .m_axi_rid      (cl_sh_ddr_q2.rid),    
       .m_axi_rdata    (cl_sh_ddr_q2.rdata),  
       .m_axi_rresp    (cl_sh_ddr_q2.rresp),  
       .m_axi_rlast    (cl_sh_ddr_q2.rlast),  
       .m_axi_rvalid   (cl_sh_ddr_q2.rvalid), 
       .m_axi_rready   (cl_sh_ddr_q2.rready)
   );


//---------------------------- 
// flop the output of ATG/Scrubber for DDRC 
//---------------------------- 

   axi_register_slice DDR_C_TST_AXI4_REG_SLC_1 (
     .aclk           (aclk),
     .aresetn        (slr1_sync_aresetn),
                                                                                                                                
     .s_axi_awid     (cl_sh_ddr_q2.awid),
     .s_axi_awaddr   ({cl_sh_ddr_q2.awaddr}),
     .s_axi_awlen    (cl_sh_ddr_q2.awlen),
     .s_axi_awsize   (cl_sh_ddr_q2.awsize),
     .s_axi_awvalid  (cl_sh_ddr_q2.awvalid),
     .s_axi_awready  (cl_sh_ddr_q2.awready),
     .s_axi_wdata    (cl_sh_ddr_q2.wdata),
     .s_axi_wstrb    (cl_sh_ddr_q2.wstrb),
     .s_axi_wlast    (cl_sh_ddr_q2.wlast),
     .s_axi_wvalid   (cl_sh_ddr_q2.wvalid),
     .s_axi_wready   (cl_sh_ddr_q2.wready),
     .s_axi_bid      (cl_sh_ddr_q2.bid),
     .s_axi_bresp    (cl_sh_ddr_q2.bresp),
     .s_axi_bvalid   (cl_sh_ddr_q2.bvalid),
     .s_axi_bready   (cl_sh_ddr_q2.bready),
     .s_axi_arid     (cl_sh_ddr_q2.arid),
     .s_axi_araddr   (cl_sh_ddr_q2.araddr),
     .s_axi_arlen    (cl_sh_ddr_q2.arlen),
     .s_axi_arsize   (cl_sh_ddr_q2.arsize),
     .s_axi_arvalid  (cl_sh_ddr_q2.arvalid),
     .s_axi_arready  (cl_sh_ddr_q2.arready),
     .s_axi_rid      (cl_sh_ddr_q2.rid),
     .s_axi_rdata    (cl_sh_ddr_q2.rdata),
     .s_axi_rresp    (cl_sh_ddr_q2.rresp),
     .s_axi_rlast    (cl_sh_ddr_q2.rlast),
     .s_axi_rvalid   (cl_sh_ddr_q2.rvalid),
     .s_axi_rready   (cl_sh_ddr_q2.rready),
  
     .m_axi_awid     (cl_sh_ddr_bus.awid),   
     .m_axi_awaddr   (cl_sh_ddr_bus.awaddr), 
     .m_axi_awlen    (cl_sh_ddr_bus.awlen),  
     .m_axi_awsize   (cl_sh_ddr_bus.awsize),
     .m_axi_awvalid  (cl_sh_ddr_bus.awvalid),
     .m_axi_awready  (cl_sh_ddr_bus.awready),
     .m_axi_wdata    (cl_sh_ddr_bus.wdata),  
     .m_axi_wstrb    (cl_sh_ddr_bus.wstrb),  
     .m_axi_wlast    (cl_sh_ddr_bus.wlast),  
     .m_axi_wvalid   (cl_sh_ddr_bus.wvalid), 
     .m_axi_wready   (cl_sh_ddr_bus.wready), 
     .m_axi_bid      (cl_sh_ddr_bus.bid),    
     .m_axi_bresp    (cl_sh_ddr_bus.bresp),  
     .m_axi_bvalid   (cl_sh_ddr_bus.bvalid), 
     .m_axi_bready   (cl_sh_ddr_bus.bready), 
     .m_axi_arid     (cl_sh_ddr_bus.arid),   
     .m_axi_araddr   (cl_sh_ddr_bus.araddr), 
     .m_axi_arlen    (cl_sh_ddr_bus.arlen),  
     .m_axi_arsize   (cl_sh_ddr_bus.arsize),
     .m_axi_arvalid  (cl_sh_ddr_bus.arvalid),
     .m_axi_arready  (cl_sh_ddr_bus.arready),
     .m_axi_rid      (cl_sh_ddr_bus.rid),    
     .m_axi_rdata    (cl_sh_ddr_bus.rdata),  
     .m_axi_rresp    (cl_sh_ddr_bus.rresp),  
     .m_axi_rlast    (cl_sh_ddr_bus.rlast),  
     .m_axi_rvalid   (cl_sh_ddr_bus.rvalid), 
     .m_axi_rready   (cl_sh_ddr_bus.rready)
   );

endmodule

