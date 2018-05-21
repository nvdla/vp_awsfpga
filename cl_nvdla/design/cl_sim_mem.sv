// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cl_sim_mem.sv

module cl_sim_mem (
    input clk,
    input rstn,
input             mem_axi_awvalid,
output             mem_axi_awready,
input     [63:0]  mem_axi_awaddr,

input             mem_axi_wvalid,
output reg             mem_axi_wready,
input     [63:0]  mem_axi_wdata,
input     [7:0]   mem_axi_wstrb,

output reg             mem_axi_bvalid,
input             mem_axi_bready,
output reg     [1:0]   mem_axi_bresp,

input             mem_axi_arvalid,
output reg             mem_axi_arready,
input     [63:0]  mem_axi_araddr,

output reg             mem_axi_rvalid,
input             mem_axi_rready,
output reg     [1:0]   mem_axi_rresp,
output reg     [63:0]  mem_axi_rdata
);


// internal signals
wire    [63:0]  mem_axi_awaddr_t;
reg     [63:0]  mem_axi_awaddr_reg;
reg             mem_axi_write_pend;
reg             mem_axi_write_pend_reg;

wire    [63:0]  mem_axi_araddr_t;
reg     [63:0]  mem_axi_araddr_reg;
reg             mem_axi_read_pend;
   
// write channel

assign mem_axi_awaddr_t = (mem_axi_awvalid & mem_axi_awready) ? mem_axi_awaddr : mem_axi_awaddr_reg;
always @ (posedge clk or negedge rstn)
    if(!rstn)
        mem_axi_awaddr_reg <= 64'b0;
    else if(mem_axi_awvalid & mem_axi_awready)
        mem_axi_awaddr_reg <= mem_axi_awaddr;

always @ (posedge clk or negedge rstn)
    if(!rstn)
        mem_axi_write_pend <= 1'b0;
    else if(mem_axi_awvalid & mem_axi_awready)
        mem_axi_write_pend <= 1'b1;
    else if(mem_axi_bvalid & mem_axi_bready)
        mem_axi_write_pend <= 1'b0;
assign mem_axi_awready = !mem_axi_write_pend;

always @ (posedge clk or negedge rstn)
    if(!rstn)
        mem_axi_write_pend_reg <= 1'b0;
    else
        mem_axi_write_pend_reg <= mem_axi_write_pend;

always @ (posedge clk or negedge rstn)
    if(!rstn)
        mem_axi_wready <= 1'b0;
    else if(mem_axi_wvalid & mem_axi_wready)
        mem_axi_wready <= 1'b0;
    else if(mem_axi_write_pend & !mem_axi_write_pend_reg)
        mem_axi_wready <= 1'b1;

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        mem_axi_bvalid <= 1'b0;
    else if(mem_axi_bvalid & mem_axi_bready)
        mem_axi_bvalid <= 1'b0;
    else if(mem_axi_wvalid & mem_axi_wready) 
        mem_axi_bvalid <= 1'b1;


always @ (posedge clk or negedge rstn)
    if(!rstn) begin
        mem_axi_bresp <= 2'b0;
    end
    else begin 
        if(mem_axi_wvalid & mem_axi_wready) begin 
            tb.backdoor_mem_write({mem_axi_awaddr_t[63:3],3'b0}, mem_axi_wdata, 8, mem_axi_wstrb);
        end
    end

// read channel

assign mem_axi_araddr_t = (mem_axi_arvalid & mem_axi_arready) ? mem_axi_araddr : mem_axi_araddr_reg;
always @ (posedge clk or negedge rstn)
    if(!rstn) 
        mem_axi_araddr_reg  <= 32'b0;
    else if(mem_axi_arvalid & mem_axi_arready) 
        mem_axi_araddr_reg  <= mem_axi_araddr;

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        mem_axi_read_pend   <= 1'b0;
    else if(mem_axi_arvalid & mem_axi_arready) 
        mem_axi_read_pend   <= 1'b1;
    else if(mem_axi_rvalid & mem_axi_rready) 
        mem_axi_read_pend   <= 1'b0;
assign mem_axi_arready = !mem_axi_read_pend;

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        mem_axi_rvalid <= 1'b0;
    else if(mem_axi_rvalid & mem_axi_rready)
        mem_axi_rvalid <= 1'b0;
    else if(mem_axi_arvalid & mem_axi_arready)
        mem_axi_rvalid <= 1'b1;

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        mem_axi_rresp <= 2'b00;
    else if(mem_axi_arvalid & mem_axi_arready) begin
        mem_axi_rdata <= tb.backdoor_mem_read({mem_axi_araddr[63:3],3'b0}, 8);
    end

endmodule
