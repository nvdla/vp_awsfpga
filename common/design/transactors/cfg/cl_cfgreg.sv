// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cl_cfgreg.sv

module cl_cfgreg (
    input clk,
    input rstn,
    input   [15:0]  irq_status,
    output  [15:0]  irq_pop,
    output  [63:0]  base_addr0,
    output  [63:0]  base_addr1,
    output  [31:0]  misc_control,
    axi_bus_t.master cfg_axi_bus
);

wire            cfg_axi_awvalid;
wire            cfg_axi_awready;
wire    [31:0]  cfg_axi_awaddr;

wire            cfg_axi_wvalid;
reg             cfg_axi_wready;
wire    [31:0]  cfg_axi_wdata;
wire    [3:0]   cfg_axi_wstrb;

reg             cfg_axi_bvalid;
wire            cfg_axi_bready;
reg     [1:0]   cfg_axi_bresp;

wire            cfg_axi_arvalid;
reg             cfg_axi_arready;
wire    [31:0]  cfg_axi_araddr;

reg             cfg_axi_rvalid;
wire            cfg_axi_rready;
reg     [1:0]   cfg_axi_rresp;
reg     [31:0]  cfg_axi_rdata;

reg     [15:0]  irq_pop;
reg     [31:0]  misc_control;

// internal signals
reg     [2:0]   cfg_axi_wr_state;
reg     [31:0]  cfg_axi_awaddr_reg;
reg     [31:0]  base_addr0_hi;
reg     [31:0]  base_addr0_lo;
reg     [31:0]  base_addr1_hi;
reg     [31:0]  base_addr1_lo;

reg     [1:0]   cfg_axi_rd_state;
reg     [31:0]  cfg_axi_araddr_reg;


assign cfg_axi_awvalid = cfg_axi_bus.awvalid;
assign cfg_axi_awaddr = cfg_axi_bus.awaddr;
assign cfg_axi_bus.awready = cfg_axi_awready;
 
assign cfg_axi_wvalid = cfg_axi_bus.wvalid;
assign cfg_axi_wdata = cfg_axi_bus.wdata;
assign cfg_axi_wstrb = cfg_axi_bus.wstrb;
assign cfg_axi_bus.wready = cfg_axi_wready;

assign cfg_axi_bus.bvalid = cfg_axi_bvalid;
assign cfg_axi_bus.bresp = cfg_axi_bresp;
assign cfg_axi_bready = cfg_axi_bus.bready;

assign cfg_axi_arvalid = cfg_axi_bus.arvalid;
assign cfg_axi_araddr = cfg_axi_bus.araddr;
assign cfg_axi_bus.arready = cfg_axi_arready;

assign cfg_axi_bus.rvalid = cfg_axi_rvalid;
assign cfg_axi_bus.rresp = cfg_axi_rresp;
assign cfg_axi_bus.rdata = cfg_axi_rdata;
assign cfg_axi_rready = cfg_axi_bus.rready;

assign base_addr0 = {base_addr0_hi, base_addr0_lo};
assign base_addr1 = {base_addr1_hi, base_addr1_lo};

///////////////////////////////////////////////////////////
// write channel

// axi write cmd flow control
`define     CFG_AXI_WR_IDLE     0
`define     CFG_AXI_WR_DATA     1
`define     CFG_AXI_WR_RESP     2

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        cfg_axi_wr_state <= 1<<`CFG_AXI_WR_IDLE;
    else 
        case (1) 
        cfg_axi_wr_state[`CFG_AXI_WR_IDLE] : 
            // awready asserted, wait awvalid to jump out
            if(cfg_axi_awvalid) 
                cfg_axi_wr_state <= 1<<`CFG_AXI_WR_DATA;
        cfg_axi_wr_state[`CFG_AXI_WR_DATA] :
            // wready asserted, wait wvalid to jump out. only support 1 beat.
            if(cfg_axi_wvalid) 
                cfg_axi_wr_state <= 1<<`CFG_AXI_WR_RESP;
        cfg_axi_wr_state[`CFG_AXI_WR_RESP] :
            // bvalid asserted, wait bready to jump out.
            if(cfg_axi_bready) 
                cfg_axi_wr_state <= 1<<`CFG_AXI_WR_IDLE;
        endcase

assign cfg_axi_awready = cfg_axi_wr_state[`CFG_AXI_WR_IDLE];
assign cfg_axi_wready = cfg_axi_wr_state[`CFG_AXI_WR_DATA];
assign cfg_axi_bvalid = cfg_axi_wr_state[`CFG_AXI_WR_RESP];

// latch awaddr for address decoding
always @ (posedge clk or negedge rstn)
    if(!rstn)
        cfg_axi_awaddr_reg <= 32'b0;
    else if(cfg_axi_awvalid & cfg_axi_awready)
        cfg_axi_awaddr_reg <= cfg_axi_awaddr;

// write data to registers
`define CFGREG_IRQUP        32'h00000000
`define CFGREG_BASE0_LO     32'h00000004
`define CFGREG_BASE0_HI     32'h00000008
`define CFGREG_BASE1_LO     32'h0000000C
`define CFGREG_BASE1_HI     32'h00000010
`define CFGREG_BASE1_HI     32'h00000010
`define CFGREG_MISC_CTRL    32'h00000014

always @ (posedge clk or negedge rstn)
    if(!rstn) begin
        base_addr0_hi <= 32'b0;
        base_addr0_lo <= 32'b0;
        base_addr1_hi <= 32'b0;
        base_addr1_lo <= 32'b0;
        irq_pop       <= 16'b0;
        cfg_axi_bresp <= 2'b0;
        misc_control  <= 32'b0;
    end
    else begin 
        irq_pop <= 16'b0;
        cfg_axi_bresp[1:0]  <= 2'b0;
        if(cfg_axi_wvalid & cfg_axi_wready) begin 
            case (cfg_axi_awaddr_reg)
            `CFGREG_IRQUP : begin
                irq_pop[7:0]        <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                irq_pop[15:8]       <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
            end
            `CFGREG_BASE0_LO : begin
                base_addr0_lo[7:0]  <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                base_addr0_lo[15:8] <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
                base_addr0_lo[23:16]<= {8{cfg_axi_wstrb[2]}} & cfg_axi_wdata[23:16];
                base_addr0_lo[31:24]<= {8{cfg_axi_wstrb[3]}} & cfg_axi_wdata[31:24];
            end
            `CFGREG_BASE0_HI : begin
                base_addr0_hi[7:0]  <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                base_addr0_hi[15:8] <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
                base_addr0_hi[23:16]<= {8{cfg_axi_wstrb[2]}} & cfg_axi_wdata[23:16];
                base_addr0_hi[31:24]<= {8{cfg_axi_wstrb[3]}} & cfg_axi_wdata[31:24];
            end
            `CFGREG_BASE1_LO : begin
                base_addr1_lo[7:0]  <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                base_addr1_lo[15:8] <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
                base_addr1_lo[23:16]<= {8{cfg_axi_wstrb[2]}} & cfg_axi_wdata[23:16];
                base_addr1_lo[31:24]<= {8{cfg_axi_wstrb[3]}} & cfg_axi_wdata[31:24];
            end
            `CFGREG_BASE1_HI : begin
                base_addr1_hi[7:0]  <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                base_addr1_hi[15:8] <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
                base_addr1_hi[23:16]<= {8{cfg_axi_wstrb[2]}} & cfg_axi_wdata[23:16];
                base_addr1_hi[31:24]<= {8{cfg_axi_wstrb[3]}} & cfg_axi_wdata[31:24];
            end
            `CFGREG_MISC_CTRL : begin
                misc_control[7:0]   <= {8{cfg_axi_wstrb[0]}} & cfg_axi_wdata[7:0];
                misc_control[15:8]  <= {8{cfg_axi_wstrb[1]}} & cfg_axi_wdata[15:8];
                misc_control[23:16] <= {8{cfg_axi_wstrb[2]}} & cfg_axi_wdata[23:16];
                misc_control[31:24] <= {8{cfg_axi_wstrb[3]}} & cfg_axi_wdata[31:24];
            end
            default : begin 
                cfg_axi_bresp[1:0]  <= 2'b11; // return error code for non existing address
            end
            endcase
        end
    end


///////////////////////////////////////////////////////////
// read channel

// axi write cmd flow control
`define     CFG_AXI_RD_IDLE     0
`define     CFG_AXI_RD_DATA     1

always @ (posedge clk or negedge rstn)
    if(!rstn) 
        cfg_axi_rd_state <= 1<<`CFG_AXI_RD_IDLE;
    else 
        case (1) 
        cfg_axi_rd_state[`CFG_AXI_RD_IDLE] : 
            // arready asserted, wait awvalid to jump out
            if(cfg_axi_arvalid) 
                cfg_axi_rd_state <= 1<<`CFG_AXI_RD_DATA;
        cfg_axi_rd_state[`CFG_AXI_RD_DATA] :
            // rvalid asserted, wait bready to jump out. only support 1 beat
            if(cfg_axi_rready) 
                cfg_axi_rd_state <= 1<<`CFG_AXI_RD_IDLE;
        endcase

assign cfg_axi_arready = cfg_axi_rd_state[`CFG_AXI_RD_IDLE];
assign cfg_axi_rvalid = cfg_axi_rd_state[`CFG_AXI_RD_DATA];

// latch araddr for address decoding
always @ (posedge clk or negedge rstn)
    if(!rstn) 
        cfg_axi_araddr_reg  <= 32'b0;
    else if(cfg_axi_arvalid & cfg_axi_arready) 
        cfg_axi_araddr_reg  <= cfg_axi_araddr;

// mux register data out
always @ (*) begin
    cfg_axi_rresp = 2'b00;

    case (cfg_axi_araddr_reg)
    `CFGREG_IRQUP       : cfg_axi_rdata   = {16'b0, irq_status};
    `CFGREG_BASE0_LO    : cfg_axi_rdata   = base_addr0_lo;
    `CFGREG_BASE0_HI    : cfg_axi_rdata   = base_addr0_hi;
    `CFGREG_BASE1_LO    : cfg_axi_rdata   = base_addr1_lo;
    `CFGREG_BASE1_HI    : cfg_axi_rdata   = base_addr1_hi;
    `CFGREG_MISC_CTRL   : cfg_axi_rdata   = misc_control;
    default : begin 
        cfg_axi_rdata[31:0] = 32'b0;
        cfg_axi_rresp[1:0]  = 2'b11; // return error code for non existing address
    end
    endcase
end


endmodule
