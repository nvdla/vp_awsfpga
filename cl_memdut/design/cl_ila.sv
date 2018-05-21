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

module cl_ila (

   input aclk,

   input drck,
   input shift,
   input tdi,
   input update,
   input sel,
   output logic tdo,
   input tms,
   input tck,
   input runtest,
   input reset,
   input capture,
   input bscanid_en,

   axi_bus_t sh_cl_dma_pcis_q,
   axi_bus_t cl_sh_ddr_bus

);

//---------------------------- 
// Debug bridge
//---------------------------- 
 cl_debug_bridge CL_DEBUG_BRIDGE (
      .clk(aclk),
      .S_BSCAN_drck(drck),
      .S_BSCAN_shift(shift),
      .S_BSCAN_tdi(tdi),
      .S_BSCAN_update(update),
      .S_BSCAN_sel(sel),
      .S_BSCAN_tdo(tdo),
      .S_BSCAN_tms(tms),
      .S_BSCAN_tck(tck),
      .S_BSCAN_runtest(runtest),
      .S_BSCAN_reset(reset),
      .S_BSCAN_capture(capture),
      .S_BSCAN_bscanid_en(bscanid_en)
   );


//---------------------------- 
// Debug Core ILA for dmm pcis AXI4 interface 
//---------------------------- 
   ila_1 CL_DMA_ILA_0 (
                   .clk    (aclk),
                   .probe0 (sh_cl_dma_pcis_q.awvalid),
                   .probe1 (sh_cl_dma_pcis_q.awaddr),
                   .probe2 (2'b0),
                   .probe3 (sh_cl_dma_pcis_q.awready),
                   .probe4 (sh_cl_dma_pcis_q.wvalid),
                   .probe5 (sh_cl_dma_pcis_q.wstrb),
                   .probe6 (sh_cl_dma_pcis_q.wlast),
                   .probe7 (sh_cl_dma_pcis_q.wready),
                   .probe8 (1'b0),
                   .probe9 (1'b0),
                   .probe10 (sh_cl_dma_pcis_q.wdata),
                   .probe11 (1'b0),
                   .probe12 (sh_cl_dma_pcis_q.arready),
                   .probe13 (2'b0),
                   .probe14 (sh_cl_dma_pcis_q.rdata),
                   .probe15 (sh_cl_dma_pcis_q.araddr),
                   .probe16 (sh_cl_dma_pcis_q.arvalid),
                   .probe17 (3'b0),
                   .probe18 (3'b0),
                   .probe19 (sh_cl_dma_pcis_q.awid),
                   .probe20 (sh_cl_dma_pcis_q.arid),
                   .probe21 (sh_cl_dma_pcis_q.awlen),
                   .probe22 (sh_cl_dma_pcis_q.rlast),
                   .probe23 (3'b0), 
                   .probe24 (sh_cl_dma_pcis_q.rresp),
                   .probe25 (sh_cl_dma_pcis_q.rid),
                   .probe26 (sh_cl_dma_pcis_q.rvalid),
                   .probe27 (sh_cl_dma_pcis_q.arlen),
                   .probe28 (3'b0),
                   .probe29 (sh_cl_dma_pcis_q.bresp),
                   .probe30 (sh_cl_dma_pcis_q.rready),
                   .probe31 (4'b0),
                   .probe32 (4'b0),
                   .probe33 (4'b0),
                   .probe34 (4'b0),
                   .probe35 (sh_cl_dma_pcis_q.bvalid),
                   .probe36 (4'b0),
                   .probe37 (4'b0),
                   .probe38 (sh_cl_dma_pcis_q.bid),
                   .probe39 (sh_cl_dma_pcis_q.bready),
                   .probe40 (1'b0),
                   .probe41 (1'b0),
                   .probe42 (1'b0),
                   .probe43 (1'b0)
                   );
//---------------------------- 
// Debug Core ILA for DDRA AXI4 interface monitoring 
//---------------------------- 
      ila_1 CL_DDRA_ILA_0 (
                   .clk    (aclk),
                   .probe0 (cl_sh_ddr_bus.awvalid),
                   .probe1 (cl_sh_ddr_bus.awaddr),
                   .probe2 (2'b0),
                   .probe3 (cl_sh_ddr_bus.awready),
                   .probe4 (cl_sh_ddr_bus.wvalid),
                   .probe5 (cl_sh_ddr_bus.wstrb),
                   .probe6 (cl_sh_ddr_bus.wlast),
                   .probe7 (cl_sh_ddr_bus.wready),
                   .probe8 (1'b0),
                   .probe9 (1'b0),
                   .probe10 (cl_sh_ddr_bus.wdata),
                   .probe11 (1'b0),
                   .probe12 (cl_sh_ddr_bus.arready),
                   .probe13 (2'b0),
                   .probe14 (cl_sh_ddr_bus.rdata),
                   .probe15 (cl_sh_ddr_bus.araddr),
                   .probe16 (cl_sh_ddr_bus.arvalid),
                   .probe17 (3'b0),
                   .probe18 (3'b0),
                   .probe19 (cl_sh_ddr_bus.awid[4:0]),
                   .probe20 (cl_sh_ddr_bus.arid[4:0]),
                   .probe21 (cl_sh_ddr_bus.awlen),
                   .probe22 (cl_sh_ddr_bus.rlast),
                   .probe23 (3'b0), 
                   .probe24 (cl_sh_ddr_bus.rresp),
                   .probe25 (cl_sh_ddr_bus.rid[4:0]),
                   .probe26 (cl_sh_ddr_bus.rvalid),
                   .probe27 (cl_sh_ddr_bus.arlen),
                   .probe28 (3'b0),
                   .probe29 (cl_sh_ddr_bus.bresp),
                   .probe30 (cl_sh_ddr_bus.rready),
                   .probe31 (4'b0),
                   .probe32 (4'b0),
                   .probe33 (4'b0),
                   .probe34 (4'b0),
                   .probe35 (cl_sh_ddr_bus.bvalid),
                   .probe36 (4'b0),
                   .probe37 (4'b0),
                   .probe38 (cl_sh_ddr_bus.bid[4:0]),
                   .probe39 (cl_sh_ddr_bus.bready),
                   .probe40 (1'b0),
                   .probe41 (1'b0),
                   .probe42 (1'b0),
                   .probe43 (1'b0)
                   );


endmodule

