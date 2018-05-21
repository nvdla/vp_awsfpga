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

`ifndef SYNTHESIS

module cl_sim_mem_wrap
(
    input aclk,
    input aresetn,

    axi_bus_t.master mem_bus_in,
    axi_bus_t.slave mem_bus_out
);

logic[15:0] mem_axi_512_bus_awid;
logic[63:0] mem_axi_512_bus_awaddr;
logic[7:0] mem_axi_512_bus_awlen;
logic [2:0] mem_axi_512_bus_awsize;
logic mem_axi_512_bus_awvalid;
logic mem_axi_512_bus_awready;

logic[15:0] mem_axi_512_bus_wid;
logic[511:0] mem_axi_512_bus_wdata;
logic[63:0] mem_axi_512_bus_wstrb;
logic mem_axi_512_bus_wlast;
logic mem_axi_512_bus_wvalid;
logic mem_axi_512_bus_wready;
   
logic[15:0] mem_axi_512_bus_bid;
logic[1:0] mem_axi_512_bus_bresp;
logic mem_axi_512_bus_bvalid;
logic mem_axi_512_bus_bready;
   
logic[15:0] mem_axi_512_bus_arid;
logic[63:0] mem_axi_512_bus_araddr;
logic[7:0] mem_axi_512_bus_arlen;
logic [2:0] mem_axi_512_bus_arsize;
logic mem_axi_512_bus_arvalid;
logic mem_axi_512_bus_arready;
   
logic[15:0] mem_axi_512_bus_rid;
logic[511:0] mem_axi_512_bus_rdata;
logic[1:0] mem_axi_512_bus_rresp;
logic mem_axi_512_bus_rlast;
logic mem_axi_512_bus_rvalid;
logic mem_axi_512_bus_rready;

logic[63:0] mem_axi_64_bus_awaddr;
logic[7:0] mem_axi_64_bus_awlen;
logic [2:0] mem_axi_64_bus_awsize;
logic mem_axi_64_bus_awvalid;
logic mem_axi_64_bus_awready;

logic[63:0] mem_axi_64_bus_wdata;
logic[7:0] mem_axi_64_bus_wstrb;
logic mem_axi_64_bus_wlast;
logic mem_axi_64_bus_wvalid;
logic mem_axi_64_bus_wready;
   
logic[1:0] mem_axi_64_bus_bresp;
logic mem_axi_64_bus_bvalid;
logic mem_axi_64_bus_bready;
   
logic[63:0] mem_axi_64_bus_araddr;
logic[7:0] mem_axi_64_bus_arlen;
logic [2:0] mem_axi_64_bus_arsize;
logic mem_axi_64_bus_arvalid;
logic mem_axi_64_bus_arready;
   
logic[63:0] mem_axi_64_bus_rdata;
logic[1:0] mem_axi_64_bus_rresp;
logic mem_axi_64_bus_rlast;
logic mem_axi_64_bus_rvalid;
logic mem_axi_64_bus_rready;

logic[63:0] mem_axil_64_bus_awaddr;
logic[7:0] mem_axil_64_bus_awlen;
logic [2:0] mem_axil_64_bus_awsize;
logic mem_axil_64_bus_awvalid;
logic mem_axil_64_bus_awready;

logic[63:0] mem_axil_64_bus_wdata;
logic[7:0] mem_axil_64_bus_wstrb;
logic mem_axil_64_bus_wlast;
logic mem_axil_64_bus_wvalid;
logic mem_axil_64_bus_wready;
   
logic[1:0] mem_axil_64_bus_bresp;
logic mem_axil_64_bus_bvalid;
logic mem_axil_64_bus_bready;
   
logic[63:0] mem_axil_64_bus_araddr;
logic[7:0] mem_axil_64_bus_arlen;
logic [2:0] mem_axil_64_bus_arsize;
logic mem_axil_64_bus_arvalid;
logic mem_axil_64_bus_arready;
   
logic[63:0] mem_axil_64_bus_rdata;
logic[1:0] mem_axil_64_bus_rresp;
logic mem_axil_64_bus_rlast;
logic mem_axil_64_bus_rvalid;
logic mem_axil_64_bus_rready;

logic enable_sim_mem;
initial
begin
    if ($test$plusargs("enable_sim_mem"))
    begin
        $display("Enable simulation memory!");
        enable_sim_mem = 1;
    end
    else
    begin
        $display("Disable simulation memory!");
        enable_sim_mem = 0;
    end
end

assign mem_bus_out.awid 	    = enable_sim_mem ? 0 : mem_bus_in.awid;
assign mem_bus_out.awaddr 	    = enable_sim_mem ? 0 : mem_bus_in.awaddr;
assign mem_bus_out.awlen 	    = enable_sim_mem ? 0 : mem_bus_in.awlen;
assign mem_bus_out.awsize 	    = enable_sim_mem ? 0 : mem_bus_in.awsize;
assign mem_bus_out.awvalid 	    = enable_sim_mem ? 0 : mem_bus_in.awvalid;
assign mem_bus_out.wdata 	    = enable_sim_mem ? 0 : mem_bus_in.wdata;
assign mem_bus_out.wstrb 	    = enable_sim_mem ? 0 : mem_bus_in.wstrb;
assign mem_bus_out.wlast 	    = enable_sim_mem ? 0 : mem_bus_in.wlast;
assign mem_bus_out.wvalid 	    = enable_sim_mem ? 0 : mem_bus_in.wvalid;
assign mem_bus_out.bready 	    = enable_sim_mem ? 0 : mem_bus_in.bready;
assign mem_bus_out.arid 	    = enable_sim_mem ? 0 : mem_bus_in.arid;
assign mem_bus_out.araddr 	    = enable_sim_mem ? 0 : mem_bus_in.araddr;
assign mem_bus_out.arlen 	    = enable_sim_mem ? 0 : mem_bus_in.arlen;
assign mem_bus_out.arsize 	    = enable_sim_mem ? 0 : mem_bus_in.arsize;
assign mem_bus_out.arvalid 	    = enable_sim_mem ? 0 : mem_bus_in.arvalid;
assign mem_bus_out.rready 	    = enable_sim_mem ? 0 : mem_bus_in.rready;

assign mem_axi_512_bus_awid 	= enable_sim_mem ? mem_bus_in.awid	    : 0;
assign mem_axi_512_bus_awaddr 	= enable_sim_mem ? mem_bus_in.awaddr	: 0;
assign mem_axi_512_bus_awlen 	= enable_sim_mem ? mem_bus_in.awlen	    : 0;
assign mem_axi_512_bus_awsize 	= enable_sim_mem ? mem_bus_in.awsize	: 0;
assign mem_axi_512_bus_awvalid 	= enable_sim_mem ? mem_bus_in.awvalid	: 0;
assign mem_axi_512_bus_wdata 	= enable_sim_mem ? mem_bus_in.wdata	    : 0;
assign mem_axi_512_bus_wstrb 	= enable_sim_mem ? mem_bus_in.wstrb	    : 0;
assign mem_axi_512_bus_wlast 	= enable_sim_mem ? mem_bus_in.wlast	    : 0;
assign mem_axi_512_bus_wvalid 	= enable_sim_mem ? mem_bus_in.wvalid	: 0;
assign mem_axi_512_bus_bready 	= enable_sim_mem ? mem_bus_in.bready	: 0;
assign mem_axi_512_bus_arid 	= enable_sim_mem ? mem_bus_in.arid	    : 0;
assign mem_axi_512_bus_araddr 	= enable_sim_mem ? mem_bus_in.araddr	: 0;
assign mem_axi_512_bus_arlen 	= enable_sim_mem ? mem_bus_in.arlen	    : 0;
assign mem_axi_512_bus_arsize 	= enable_sim_mem ? mem_bus_in.arsize	: 0;
assign mem_axi_512_bus_arvalid 	= enable_sim_mem ? mem_bus_in.arvalid	: 0;
assign mem_axi_512_bus_rready 	= enable_sim_mem ? mem_bus_in.rready	: 0;

assign mem_bus_in.awready 	    = enable_sim_mem ? mem_axi_512_bus_awready 	: mem_bus_out.awready;
assign mem_bus_in.wready 	    = enable_sim_mem ? mem_axi_512_bus_wready 	: mem_bus_out.wready;
assign mem_bus_in.bid 	        = enable_sim_mem ? mem_axi_512_bus_bid 	    : mem_bus_out.bid;
assign mem_bus_in.bresp 	    = enable_sim_mem ? mem_axi_512_bus_bresp 	: mem_bus_out.bresp;
assign mem_bus_in.bvalid 	    = enable_sim_mem ? mem_axi_512_bus_bvalid 	: mem_bus_out.bvalid;
assign mem_bus_in.arready 	    = enable_sim_mem ? mem_axi_512_bus_arready 	: mem_bus_out.arready;
assign mem_bus_in.rid 	        = enable_sim_mem ? mem_axi_512_bus_rid 	    : mem_bus_out.rid;
assign mem_bus_in.rresp 	    = enable_sim_mem ? mem_axi_512_bus_rresp 	: mem_bus_out.rresp;
assign mem_bus_in.rvalid 	    = enable_sim_mem ? mem_axi_512_bus_rvalid 	: mem_bus_out.rvalid;
assign mem_bus_in.rdata 	    = enable_sim_mem ? mem_axi_512_bus_rdata 	: mem_bus_out.rdata;
assign mem_bus_in.rlast 	    = enable_sim_mem ? mem_axi_512_bus_rlast 	: mem_bus_out.rlast;

axi_dwidth_converter_512b_to_64b AXI_DWIDTH_CONVERTER_512B_TO_64B ( 
    .s_axi_aclk(aclk),
    .s_axi_aresetn(aresetn),
    .s_axi_awid(mem_axi_512_bus_awid),
    .s_axi_awaddr(mem_axi_512_bus_awaddr),
    .s_axi_awlen(mem_axi_512_bus_awlen),
    .s_axi_awsize(mem_axi_512_bus_awsize),
    .s_axi_awburst(2'b01),
    .s_axi_awlock(1'b0),
    .s_axi_awcache(4'b11),
    .s_axi_awprot(3'b010),
    .s_axi_awregion(4'b0),
    .s_axi_awqos(4'b0),
    .s_axi_awvalid(mem_axi_512_bus_awvalid),
    .s_axi_awready(mem_axi_512_bus_awready),
    .s_axi_wdata(mem_axi_512_bus_wdata),
    .s_axi_wstrb(mem_axi_512_bus_wstrb),
    .s_axi_wlast(mem_axi_512_bus_wlast),
    .s_axi_wvalid(mem_axi_512_bus_wvalid),
    .s_axi_wready(mem_axi_512_bus_wready),
    .s_axi_bid(mem_axi_512_bus_bid),
    .s_axi_bresp(mem_axi_512_bus_bresp),
    .s_axi_bvalid(mem_axi_512_bus_bvalid),
    .s_axi_bready(mem_axi_512_bus_bready),
    .s_axi_arid(mem_axi_512_bus_arid),
    .s_axi_araddr(mem_axi_512_bus_araddr),
    .s_axi_arlen(mem_axi_512_bus_arlen),
    .s_axi_arsize(mem_axi_512_bus_arsize),
    .s_axi_arburst(2'b01),
    .s_axi_arlock(1'b0),
    .s_axi_arcache(4'b11),
    .s_axi_arprot(3'b010),
    .s_axi_arregion(4'b0),
    .s_axi_arqos(4'b0),
    .s_axi_arvalid(mem_axi_512_bus_arvalid),
    .s_axi_arready(mem_axi_512_bus_arready),
    .s_axi_rid(mem_axi_512_bus_rid),
    .s_axi_rdata(mem_axi_512_bus_rdata),
    .s_axi_rresp(mem_axi_512_bus_rresp),
    .s_axi_rlast(mem_axi_512_bus_rlast),
    .s_axi_rvalid(mem_axi_512_bus_rvalid),
    .s_axi_rready(mem_axi_512_bus_rready),
    .m_axi_awaddr(mem_axi_64_bus_awaddr),
    .m_axi_awlen(mem_axi_64_bus_awlen),
    .m_axi_awsize(mem_axi_64_bus_awsize),
    .m_axi_awburst(),
    .m_axi_awlock(),
    .m_axi_awcache(),
    .m_axi_awprot(),
    .m_axi_awregion(),
    .m_axi_awqos(),
    .m_axi_awvalid(mem_axi_64_bus_awvalid),
    .m_axi_awready(mem_axi_64_bus_awready),
    .m_axi_wdata(mem_axi_64_bus_wdata),
    .m_axi_wstrb(mem_axi_64_bus_wstrb),
    .m_axi_wlast(mem_axi_64_bus_wlast),
    .m_axi_wvalid(mem_axi_64_bus_wvalid),
    .m_axi_wready(mem_axi_64_bus_wready),
    .m_axi_bresp(mem_axi_64_bus_bresp),
    .m_axi_bvalid(mem_axi_64_bus_bvalid),
    .m_axi_bready(mem_axi_64_bus_bready),
    .m_axi_araddr(mem_axi_64_bus_araddr),
    .m_axi_arlen(mem_axi_64_bus_arlen),
    .m_axi_arsize(mem_axi_64_bus_arsize),
    .m_axi_arburst(),
    .m_axi_arlock(),
    .m_axi_arcache(),
    .m_axi_arprot(),
    .m_axi_arregion(),
    .m_axi_arqos(),
    .m_axi_arvalid(mem_axi_64_bus_arvalid),
    .m_axi_arready(mem_axi_64_bus_arready),
    .m_axi_rdata(mem_axi_64_bus_rdata),
    .m_axi_rresp(mem_axi_64_bus_rresp),
    .m_axi_rlast(mem_axi_64_bus_rlast),
    .m_axi_rvalid(mem_axi_64_bus_rvalid),
    .m_axi_rready(mem_axi_64_bus_rready)
);

axi_protocol_converter_axi_to_axil AXI_PROTOCOL_CONVERTER_AXI_TO_AXIL ( 
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_awaddr(mem_axi_64_bus_awaddr),
    .s_axi_awlen(mem_axi_64_bus_awlen),
    .s_axi_awsize(mem_axi_64_bus_awsize),
    .s_axi_awburst(2'b01),
    .s_axi_awlock(1'b0),
    .s_axi_awcache(4'b11),
    .s_axi_awprot(3'b010),
    .s_axi_awregion(4'b0),
    .s_axi_awqos(4'b0),
    .s_axi_awvalid(mem_axi_64_bus_awvalid),
    .s_axi_awready(mem_axi_64_bus_awready),
    .s_axi_wdata(mem_axi_64_bus_wdata),
    .s_axi_wstrb(mem_axi_64_bus_wstrb),
    .s_axi_wlast(mem_axi_64_bus_wlast),
    .s_axi_wvalid(mem_axi_64_bus_wvalid),
    .s_axi_wready(mem_axi_64_bus_wready),
    .s_axi_bresp(mem_axi_64_bus_bresp),
    .s_axi_bvalid(mem_axi_64_bus_bvalid),
    .s_axi_bready(mem_axi_64_bus_bready),
    .s_axi_araddr(mem_axi_64_bus_araddr),
    .s_axi_arlen(mem_axi_64_bus_arlen),
    .s_axi_arsize(mem_axi_64_bus_arsize),
    .s_axi_arburst(2'b01),
    .s_axi_arlock(1'b0),
    .s_axi_arcache(4'b11),
    .s_axi_arprot(3'b010),
    .s_axi_arregion(4'b0),
    .s_axi_arqos(4'b0),
    .s_axi_arvalid(mem_axi_64_bus_arvalid),
    .s_axi_arready(mem_axi_64_bus_arready),
    .s_axi_rdata(mem_axi_64_bus_rdata),
    .s_axi_rresp(mem_axi_64_bus_rresp),
    .s_axi_rlast(mem_axi_64_bus_rlast),
    .s_axi_rvalid(mem_axi_64_bus_rvalid),
    .s_axi_rready(mem_axi_64_bus_rready),
    .m_axi_awaddr(mem_axil_64_bus_awaddr),
    .m_axi_awprot(),
    .m_axi_awvalid(mem_axil_64_bus_awvalid),
    .m_axi_awready(mem_axil_64_bus_awready),
    .m_axi_wdata(mem_axil_64_bus_wdata),
    .m_axi_wstrb(mem_axil_64_bus_wstrb),
    .m_axi_wvalid(mem_axil_64_bus_wvalid),
    .m_axi_wready(mem_axil_64_bus_wready),
    .m_axi_bresp(mem_axil_64_bus_bresp),
    .m_axi_bvalid(mem_axil_64_bus_bvalid),
    .m_axi_bready(mem_axil_64_bus_bready),
    .m_axi_araddr(mem_axil_64_bus_araddr),
    .m_axi_arprot(),
    .m_axi_arvalid(mem_axil_64_bus_arvalid),
    .m_axi_arready(mem_axil_64_bus_arready),
    .m_axi_rdata(mem_axil_64_bus_rdata),
    .m_axi_rresp(mem_axil_64_bus_rresp),
    .m_axi_rvalid(mem_axil_64_bus_rvalid),
    .m_axi_rready(mem_axil_64_bus_rready)
);

cl_sim_mem CL_SIM_MEM(
   .clk(aclk),
   .rstn(aresetn),

   .mem_axi_awvalid(mem_axil_64_bus_awvalid),                                                                    
   .mem_axi_awaddr(mem_axil_64_bus_awaddr),                                                               
   .mem_axi_awready(mem_axil_64_bus_awready),                                                                           
   
   //Write data                                                                                    
   .mem_axi_wvalid(mem_axil_64_bus_wvalid),                                                                     
   .mem_axi_wdata(mem_axil_64_bus_wdata),                                                                
   .mem_axi_wstrb(mem_axil_64_bus_wstrb),                                                                 
   .mem_axi_wready(mem_axil_64_bus_wready),                                                                            
 
   //Write response                                                                                
   .mem_axi_bvalid(mem_axil_64_bus_bvalid),                                                                            
   .mem_axi_bresp(mem_axil_64_bus_bresp),
   .mem_axi_bready(mem_axil_64_bus_bready),
                                                                                                   
   //Read address
   .mem_axi_arvalid(mem_axil_64_bus_arvalid),                                                                    
   .mem_axi_araddr(mem_axil_64_bus_araddr),                                                               
   .mem_axi_arready(mem_axil_64_bus_arready),
                                                                                                   
   //Read data/response
   .mem_axi_rvalid(mem_axil_64_bus_rvalid),                                                                            
   .mem_axi_rdata(mem_axil_64_bus_rdata),
   .mem_axi_rresp(mem_axil_64_bus_rresp),
                                                                                                   
   .mem_axi_rready(mem_axil_64_bus_rready)
);

endmodule

`endif
