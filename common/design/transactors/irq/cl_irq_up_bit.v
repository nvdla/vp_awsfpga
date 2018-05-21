// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cl_irq_up_bit.v

`timescale 100ps/10ps 
`include "simulate_x_tick.vh"
module cl_irq_up_bit (
   clk        //|< i
  ,reset_     //|< i
  ,irq_ack    //|< i *
  ,irq_in     //|< i
  ,irq_pop    //|< i
  ,irq_req    //|> o
  ,irq_status //|> o
  );

input         clk;
input         reset_;
input  [15:0] irq_ack;
input         irq_in;
input         irq_pop;
output        irq_req;
output        irq_status;
wire          irq_in_change;
wire          rd_data;
wire          rd_req;
wire          wr_busy;
reg           irq_in_d;
reg           irq_req;
reg           irq_status;
reg           rd_busy;

always @(posedge clk) begin
  if (!reset_) begin
    irq_in_d <= 1'b0;
  end else begin
    irq_in_d <= irq_in;
  end
end

assign irq_in_change = irq_in ^ irq_in_d;

irq_upstream_reqfifo u_irq_upstream_reqfifo (
   .clk           (clk)                        //|< i
  ,.reset_        (reset_)                     //|< i
  ,.wr_busy       (wr_busy)                    //|> w
  ,.wr_idle       ()                           //|> ?
  ,.wr_req        ((irq_in_change & !wr_busy)) //|< ?
  ,.wr_data       (irq_in)                     //|< i
  ,.rd_busy       (rd_busy)                    //|< r
  ,.rd_req        (rd_req)                     //|> w
  ,.rd_data       (rd_data)                    //|> w
  ,.pwrbus_ram_pd ({32{1'b0}})                 //|< ?
  );


always @(posedge clk) begin
  if (!reset_) begin
    irq_req <= 1'b0;
    rd_busy <= 1'b0;
    irq_status <= 1'b0;
  end else begin
    if(irq_req) 
        irq_req     <= 1'b0;
    else if(rd_busy)
        rd_busy     <= !irq_pop;
    else if(rd_req) begin
        irq_req     <= 1'b1;
        rd_busy     <= 1'b1;
        irq_status  <= rd_data;
    end
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"error: irq fifo full!")      zzz_assert_never_1x (clk, `ASSERT_RESET, (irq_in_change & wr_busy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

endmodule // cl_irq_up_bit

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/10/24_05_01_31/nvtools/scripts/fifogen
// fifogen -no_make_ram -input_config_yaml /home/ip/shared/inf/fullchip_cfg/nvgpu/falcon6.0/39727485/config_yamls/fifogen/tulit2/fifogen.yml -stdout -m irq_upstream_reqfifo -d 64 -w 1 -ram ra2 -wr_reg -rd_reg -wr_idle [Chosen ram type (forced to -ram auto): ff - fifogen_flops (la2 was allowed but not chosen; ra2 was allowed but not chosen)]
// chip config vars: strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  uses_prand=1  perfmon_histogram_defined=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  remove_unused_ports=1  viva_parsed=1  ram_variant_all=1  requires_full_throughput=1  rollpli_seedset="auto"  force_first_ram_auto=1  force_first_ram_auto_no_latency_change=0  ram_auto_ff_bits_cutoff=96  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=256  ram_auto_ff_depth_cutoff=3  ram_auto_ff_no_la2_depth_cutoff=6  ram_auto_la2_width_cutoff=16  ram_auto_la2_width_cutoff_max_depth=64  ram_auto_la2_depth_cutoff=23  flopram_emu_model=1  reinit=0  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1  allow_mt_rttrb_wr_reg=0 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1

`ifndef SYNTHESIS
    `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
`else
    `ifdef FV_ASSERT_ON
        `define FIFOGEN_KEEP_ASSERTION_VERIF_CODE
    `endif
`endif

`include "simulate_x_tick.vh"


module irq_upstream_reqfifo (
      clk
    , reset_
    , wr_busy
    , wr_idle
    , wr_req
`ifdef FV_RAND_WR_PAUSE
    , wr_pause
`endif
    , wr_data
    , rd_busy
    , rd_req
    , rd_data
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         clk;
input         reset_;
output        wr_busy;
output        wr_idle;
input         wr_req;
`ifdef FV_RAND_WR_PAUSE
input         wr_pause;
`endif
input         wr_data;
input         rd_busy;
output        rd_req;
output        rd_data;
input  [31:0] pwrbus_ram_pd;



`ifdef FV_RAND_WR_PAUSE
// FV forces this signal to trigger random stalling
wire wr_pause = 0;
`endif

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire clk_mgated_enable;   // assigned by code at end of this module
wire clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power clk_mgate( .clk(clk), .reset_(reset_), .clk_en(clk_mgated_enable), .clk_gated(clk_mgated) );

// 
// WRITE SIDE
//
// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
reg wr_pause_rand_in;
`endif
`endif
// VCS coverage on
wire wr_reserving;
reg        wr_req_in;                                // registered wr_req
reg        wr_busy_in;                              // inputs being held this cycle?
assign     wr_busy = wr_busy_in;
wire       wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant wr_req signal
wire       wr_busy_in_next_wr_req_eq_1 = wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (wr_req_in && wr_busy_next) && !wr_reserving;
`ifdef FV_RAND_WR_PAUSE
wire       wr_busy_in_next = (wr_req? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                             || wr_pause ;
`else
wire       wr_busy_in_next = (wr_req? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                              
                            // VCS coverage off
                            `ifndef SYNTH_LEVEL1_COMPILE
                            `ifndef SYNTHESIS
                            || wr_pause_rand
                            `endif
                            `endif
                            // VCS coverage on

 ;
`endif
wire       wr_busy_in_int;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_req_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            wr_req_in  <=  wr_req && !wr_busy_in;
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( wr_busy_in_int ) begin
        end else begin
            wr_req_in  <=  `x_or_0; 
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

reg        wr_busy_int;		        	// copy for internal use
assign       wr_reserving = wr_req_in && !wr_busy_int; // reserving write space?



wire       wr_popping;                          // fwd: write side sees pop?


reg  [6:0] wr_count;			// write-side count

wire [6:0] wr_count_next_wr_popping = wr_reserving ? wr_count : (wr_count - 1'd1); // spyglass disable W164a W484
wire [6:0] wr_count_next_no_wr_popping = wr_reserving ? (wr_count + 1'd1) : wr_count; // spyglass disable W164a W484
wire [6:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_64 = ( wr_count_next_no_wr_popping == 7'd64 );
wire wr_count_next_is_64 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_64;
wire [6:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [6:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     wr_busy_next = wr_count_next_is_64 || // busy next cycle?
                          (wr_limit_reg != 7'd0 &&      // check wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = wr_req_in && wr_busy_int;
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_busy_int <=  1'b0;
        wr_count <=  7'd0;
    end else begin
	wr_busy_int <=  wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    wr_count <=  wr_count_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            wr_count <=  {7{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as wr_req_in

//
// RAM
//

reg  [5:0] wr_adr;			// current write address

// spyglass disable_block W484
// next wr_adr if wr_pushing=1
wire [5:0] wr_adr_next = wr_adr + 1'd1;  // spyglass disable W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_adr <=  6'd0;
    end else begin
        if ( wr_pushing ) begin
            wr_adr <=  wr_adr_next;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [5:0] rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (wr_count > 7'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && wr_req;  
wire rd_data_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


irq_upstream_reqfifo_flopram_rwsa_64x1 ram (
      .clk( clk )
    , .clk_mgated( clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( wr_data )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .wa        ( wr_adr )
    , .ra        ( (wr_count == 0) ? 7'd64 : {1'b0,rd_adr} )
    , .dout        ( rd_data_p )
    );


wire [5:0] rd_adr_next_popping = rd_adr + 1'd1; // spyglass disable W484
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_adr <=  6'd0;
    end else begin
        if ( rd_popping ) begin
            rd_adr <=  rd_adr_next_popping;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !rd_popping ) begin
        end else begin
            rd_adr <=  {6{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately


wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       rd_req_p; 		// data out of fifo is valid

reg        rd_req_int;	// internal copy of rd_req
assign     rd_req = rd_req_int;
assign     rd_popping = rd_req_p && !(rd_req_int && rd_busy);

reg  [6:0] rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [6:0] rd_count_p_next_rd_popping = rd_pushing ? rd_count_p : 
                                                                (rd_count_p - 1'd1);
wire [6:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (rd_count_p + 1'd1) : 
                                                                    rd_count_p;
// spyglass enable_block W164a W484
wire [6:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     rd_req_p = rd_count_p != 0 || rd_pushing;
always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_count_p <=  7'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rd_count_p <=  rd_count_p_next;
        end 
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rd_count_p <=  {7{`x_or_0}};
        end
        // VCS coverage on
        `endif // SYNTHESIS
    end
end
reg  rd_data;         // output data register
wire        rd_req_next = (rd_req_p || (rd_req_int && rd_busy)) ;

always @( posedge clk_mgated or negedge reset_ ) begin
    if ( !reset_ ) begin
        rd_req_int <=  1'b0;
    end else begin
        rd_req_int <=  rd_req_next;
    end
end
always @( posedge clk_mgated ) begin
    if ( (rd_popping) ) begin
        rd_data <=  rd_data_p;
    end 
    `ifndef SYNTHESIS
    // VCS coverage off
    else if ( !((rd_popping)) ) begin
    end else begin
        rd_data <=  {1{`x_or_0}};
    end
    // VCS coverage on
    `endif // SYNTHESIS
end
//
// Read-side Idle Calculation
//
wire   rd_idle = !rd_req_int && !rd_pushing && rd_count_p == 0;


//
// Write-Side Idle Calculation
//
wire wr_idle_d0 = !wr_req_in && rd_idle && !wr_pushing && wr_count == 0
// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
    && !wr_pause_rand_in
`endif
`endif
// VCS coverage on
;
wire wr_idle = wr_idle_d0;


// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// VCS coverage on

// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// VCS coverage on
assign clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (wr_req_in && !wr_busy_int) || (wr_busy_int != wr_busy_next)) || (rd_pushing || rd_popping || (rd_req_int && !rd_busy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // VCS coverage off
                               `ifndef SYNTH_LEVEL1_COMPILE
                               `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
                               `endif
                               `endif
                               // VCS coverage on
;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.irq_upstream_reqfifo_wr_limit_override ? `EMU_FIFO_CFG.irq_upstream_reqfifo_wr_limit : 7'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 7'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 7'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 7'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [6:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 7'd0;
initial begin
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "irq_upstream_reqfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "irq_upstream_reqfifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
initial begin
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

    if ( $test$plusargs( "irq_upstream_reqfifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "irq_upstream_reqfifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "irq_upstream_reqfifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "irq_upstream_reqfifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif


always @( negedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        stall_cycles_left <=  0;
    end else begin
            if ( wr_req && !(wr_busy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        wr_pause_rand_in <=  1'b0;
    end else begin
        wr_pause_rand_in <=  wr_pause_rand;
    end
end

// VCS coverage on
`endif
`endif
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef NO_PERFMON_HISTOGRAM 
`else
// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( clk ) 
    , .max      ( {25'd0, (wr_limit_reg == 7'd0) ? 7'd64 : wr_limit_reg} )
    , .curr	( {25'd0, wr_count} )
    );
`endif
`endif
// VCS coverage on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE
// VCS coverage off
`ifdef ASSERT_ON



`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = |($test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS"));
`endif // ifdef FV_ASSERT_ON

`endif // ifdef SPYGLASS


wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif // ifdef ASSERT_ON
// VCS coverage on
`endif // ifdef FIFOGEN_KEEP_ASSERTION_VERIF_CODE


`ifdef ASSERT_ON

// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
// VCS coverage on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504



`ifdef COVER

wire wr_testpoint_reset_ = ( reset_ === 1'bx ? 1'b0 : reset_ );



`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_Full_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_Full
    `define COVER_OR_TP__Fifo_Full_OR_COVER
  `endif // TP__Fifo_Full

`ifdef COVER_OR_TP__Fifo_Full_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo Full"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=0
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_clk   = clk;
wire testpoint_0_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_0_internal_clk
    reg testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk <= 1'b0;

    always @(posedge testpoint_0_internal_clk) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: irq_upstream_reqfifo ::: Fifo Full ::: wr_count==64");
 `endif
            //VCS coverage on
            //coverage name irq_upstream_reqfifo ::: Fifo Full ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((wr_count==64) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk)
                $display("NVIDIA TESTPOINT: irq_upstream_reqfifo ::: Fifo Full ::: testpoint_0_goal_0");
 `endif
            if ((wr_count==64) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((wr_count==64) && testpoint_got_reset_testpoint_0_internal_wr_testpoint_reset__with_clock_testpoint_0_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_Full_0 (.clk (testpoint_0_internal_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_Full_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_Full_and_wr_req_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_Full_and_wr_req
    `define COVER_OR_TP__Fifo_Full_and_wr_req_OR_COVER
  `endif // TP__Fifo_Full_and_wr_req

`ifdef COVER_OR_TP__Fifo_Full_and_wr_req_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo Full and wr_req"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=0
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_clk   = clk;
wire testpoint_1_internal_wr_testpoint_reset_ = wr_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_wr_testpoint_reset_
    //  Clock signal: testpoint_1_internal_clk
    reg testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk <= 1'b0;

    always @(posedge testpoint_1_internal_clk) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_wr_testpoint_reset_)
            testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: irq_upstream_reqfifo ::: Fifo Full and wr_req ::: wr_count==64 && wr_req");
 `endif
            //VCS coverage on
            //coverage name irq_upstream_reqfifo ::: Fifo Full and wr_req ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_wr_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((wr_count==64 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk)
                $display("NVIDIA TESTPOINT: irq_upstream_reqfifo ::: Fifo Full and wr_req ::: testpoint_1_goal_0");
 `endif
            if ((wr_count==64 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((wr_count==64 && wr_req) && testpoint_got_reset_testpoint_1_internal_wr_testpoint_reset__with_clock_testpoint_1_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_Full_and_wr_req_0 (.clk (testpoint_1_internal_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_Full_and_wr_req_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


wire rd_testpoint_reset_ = ( reset_ === 1'bx ? 1'b0 : reset_ );


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_not_empty_and_rd_busy
    `define COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
  `endif // TP__Fifo_not_empty_and_rd_busy

`ifdef COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo not empty and rd_busy"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=0
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_clk   = clk;
wire testpoint_2_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_2_internal_clk
    reg testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk <= 1'b0;

    always @(posedge testpoint_2_internal_clk) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: irq_upstream_reqfifo ::: Fifo not empty and rd_busy ::: rd_req && rd_busy");
 `endif
            //VCS coverage on
            //coverage name irq_upstream_reqfifo ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((rd_req && rd_busy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk)
                $display("NVIDIA TESTPOINT: irq_upstream_reqfifo ::: Fifo not empty and rd_busy ::: testpoint_2_goal_0");
 `endif
            if ((rd_req && rd_busy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((rd_req && rd_busy) && testpoint_got_reset_testpoint_2_internal_rd_testpoint_reset__with_clock_testpoint_2_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_not_empty_and_rd_busy_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_not_empty_and_rd_busy_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

reg [1:0] testpoint_empty_state;
reg [1:0] testpoint_empty_state_nxt;
reg testpoint_non_empty_to_empty_to_non_empty_reached;

`define FIFO_INIT 2'b00
`define FIFO_NON_EMPTY 2'b01
`define FIFO_EMPTY 2'b10

always @(testpoint_empty_state or (!rd_req)) begin
    testpoint_empty_state_nxt = testpoint_empty_state;
    testpoint_non_empty_to_empty_to_non_empty_reached = 0;
    casez (testpoint_empty_state)
         `FIFO_INIT: begin
             if (!(!rd_req)) begin
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         `FIFO_NON_EMPTY: begin
             if ((!rd_req)) begin
                 testpoint_empty_state_nxt = `FIFO_EMPTY;
             end
         end
         `FIFO_EMPTY: begin
             if (!(!rd_req)) begin
                 testpoint_non_empty_to_empty_to_non_empty_reached = 1;
                 testpoint_empty_state_nxt = `FIFO_NON_EMPTY;
             end
         end
         // VCS coverage off
         default: begin
             testpoint_empty_state_nxt = `FIFO_INIT;
         end
         // VCS coverage on
    endcase
end
always @( posedge clk or negedge reset_ ) begin
    if ( !reset_ ) begin
        testpoint_empty_state <=  2'b00;
    end else begin
         if (testpoint_empty_state != testpoint_empty_state_nxt) begin
             testpoint_empty_state <= testpoint_empty_state_nxt;
         end
     end
end

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // COVER

  `ifdef TP__Fifo_non_empty_to_empty_to_non_empty
    `define COVER_OR_TP__Fifo_non_empty_to_empty_to_non_empty_OR_COVER
  `endif // TP__Fifo_non_empty_to_empty_to_non_empty

`ifdef COVER_OR_TP__Fifo_non_empty_to_empty_to_non_empty_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Fifo non-empty to empty to non-empty"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=0
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_clk   = clk;
wire testpoint_3_internal_rd_testpoint_reset_ = rd_testpoint_reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_rd_testpoint_reset_
    //  Clock signal: testpoint_3_internal_clk
    reg testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk <= 1'b0;

    always @(posedge testpoint_3_internal_clk) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_rd_testpoint_reset_)
            testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: irq_upstream_reqfifo ::: Fifo non-empty to empty to non-empty ::: testpoint_non_empty_to_empty_to_non_empty_reached");
 `endif
            //VCS coverage on
            //coverage name irq_upstream_reqfifo ::: Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_rd_testpoint_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk)
                $display("NVIDIA TESTPOINT: irq_upstream_reqfifo ::: Fifo non-empty to empty to non-empty ::: testpoint_3_goal_0");
 `endif
            if ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((testpoint_non_empty_to_empty_to_non_empty_reached) && testpoint_got_reset_testpoint_3_internal_rd_testpoint_reset__with_clock_testpoint_3_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_Fifo_non_empty_to_empty_to_non_empty_0 (.clk (testpoint_3_internal_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Fifo_non_empty_to_empty_to_non_empty_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


`endif



//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "irq_upstream_reqfifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction




endmodule // irq_upstream_reqfifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module irq_upstream_reqfifo_flopram_rwsa_64x1 (
      clk
    , clk_mgated
    , pwrbus_ram_pd
    , di
    , iwe
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input  clk_mgated;  // write clock mgated
input [31 : 0] pwrbus_ram_pd;
input  [0:0] di;
input  iwe;
input  we;
input  [5:0] wa;
input  [6:0] ra;
output [0:0] dout;

reg [0:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end

`ifdef EMU


wire [0:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [5:0] Wa0_vmw;
reg we0_vmw;
reg [0:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di_d;
end

vmw_irq_upstream_reqfifo_flopram_rwsa_64x1 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[5:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 64) ? di_d : dout_p;

`else

reg [0:0] ram_ff0;
reg [0:0] ram_ff1;
reg [0:0] ram_ff2;
reg [0:0] ram_ff3;
reg [0:0] ram_ff4;
reg [0:0] ram_ff5;
reg [0:0] ram_ff6;
reg [0:0] ram_ff7;
reg [0:0] ram_ff8;
reg [0:0] ram_ff9;
reg [0:0] ram_ff10;
reg [0:0] ram_ff11;
reg [0:0] ram_ff12;
reg [0:0] ram_ff13;
reg [0:0] ram_ff14;
reg [0:0] ram_ff15;
reg [0:0] ram_ff16;
reg [0:0] ram_ff17;
reg [0:0] ram_ff18;
reg [0:0] ram_ff19;
reg [0:0] ram_ff20;
reg [0:0] ram_ff21;
reg [0:0] ram_ff22;
reg [0:0] ram_ff23;
reg [0:0] ram_ff24;
reg [0:0] ram_ff25;
reg [0:0] ram_ff26;
reg [0:0] ram_ff27;
reg [0:0] ram_ff28;
reg [0:0] ram_ff29;
reg [0:0] ram_ff30;
reg [0:0] ram_ff31;
reg [0:0] ram_ff32;
reg [0:0] ram_ff33;
reg [0:0] ram_ff34;
reg [0:0] ram_ff35;
reg [0:0] ram_ff36;
reg [0:0] ram_ff37;
reg [0:0] ram_ff38;
reg [0:0] ram_ff39;
reg [0:0] ram_ff40;
reg [0:0] ram_ff41;
reg [0:0] ram_ff42;
reg [0:0] ram_ff43;
reg [0:0] ram_ff44;
reg [0:0] ram_ff45;
reg [0:0] ram_ff46;
reg [0:0] ram_ff47;
reg [0:0] ram_ff48;
reg [0:0] ram_ff49;
reg [0:0] ram_ff50;
reg [0:0] ram_ff51;
reg [0:0] ram_ff52;
reg [0:0] ram_ff53;
reg [0:0] ram_ff54;
reg [0:0] ram_ff55;
reg [0:0] ram_ff56;
reg [0:0] ram_ff57;
reg [0:0] ram_ff58;
reg [0:0] ram_ff59;
reg [0:0] ram_ff60;
reg [0:0] ram_ff61;
reg [0:0] ram_ff62;
reg [0:0] ram_ff63;

always @( posedge clk_mgated ) begin
    if ( we && wa == 6'd0 ) begin
	ram_ff0 <=  di_d;
    end
    if ( we && wa == 6'd1 ) begin
	ram_ff1 <=  di_d;
    end
    if ( we && wa == 6'd2 ) begin
	ram_ff2 <=  di_d;
    end
    if ( we && wa == 6'd3 ) begin
	ram_ff3 <=  di_d;
    end
    if ( we && wa == 6'd4 ) begin
	ram_ff4 <=  di_d;
    end
    if ( we && wa == 6'd5 ) begin
	ram_ff5 <=  di_d;
    end
    if ( we && wa == 6'd6 ) begin
	ram_ff6 <=  di_d;
    end
    if ( we && wa == 6'd7 ) begin
	ram_ff7 <=  di_d;
    end
    if ( we && wa == 6'd8 ) begin
	ram_ff8 <=  di_d;
    end
    if ( we && wa == 6'd9 ) begin
	ram_ff9 <=  di_d;
    end
    if ( we && wa == 6'd10 ) begin
	ram_ff10 <=  di_d;
    end
    if ( we && wa == 6'd11 ) begin
	ram_ff11 <=  di_d;
    end
    if ( we && wa == 6'd12 ) begin
	ram_ff12 <=  di_d;
    end
    if ( we && wa == 6'd13 ) begin
	ram_ff13 <=  di_d;
    end
    if ( we && wa == 6'd14 ) begin
	ram_ff14 <=  di_d;
    end
    if ( we && wa == 6'd15 ) begin
	ram_ff15 <=  di_d;
    end
    if ( we && wa == 6'd16 ) begin
	ram_ff16 <=  di_d;
    end
    if ( we && wa == 6'd17 ) begin
	ram_ff17 <=  di_d;
    end
    if ( we && wa == 6'd18 ) begin
	ram_ff18 <=  di_d;
    end
    if ( we && wa == 6'd19 ) begin
	ram_ff19 <=  di_d;
    end
    if ( we && wa == 6'd20 ) begin
	ram_ff20 <=  di_d;
    end
    if ( we && wa == 6'd21 ) begin
	ram_ff21 <=  di_d;
    end
    if ( we && wa == 6'd22 ) begin
	ram_ff22 <=  di_d;
    end
    if ( we && wa == 6'd23 ) begin
	ram_ff23 <=  di_d;
    end
    if ( we && wa == 6'd24 ) begin
	ram_ff24 <=  di_d;
    end
    if ( we && wa == 6'd25 ) begin
	ram_ff25 <=  di_d;
    end
    if ( we && wa == 6'd26 ) begin
	ram_ff26 <=  di_d;
    end
    if ( we && wa == 6'd27 ) begin
	ram_ff27 <=  di_d;
    end
    if ( we && wa == 6'd28 ) begin
	ram_ff28 <=  di_d;
    end
    if ( we && wa == 6'd29 ) begin
	ram_ff29 <=  di_d;
    end
    if ( we && wa == 6'd30 ) begin
	ram_ff30 <=  di_d;
    end
    if ( we && wa == 6'd31 ) begin
	ram_ff31 <=  di_d;
    end
    if ( we && wa == 6'd32 ) begin
	ram_ff32 <=  di_d;
    end
    if ( we && wa == 6'd33 ) begin
	ram_ff33 <=  di_d;
    end
    if ( we && wa == 6'd34 ) begin
	ram_ff34 <=  di_d;
    end
    if ( we && wa == 6'd35 ) begin
	ram_ff35 <=  di_d;
    end
    if ( we && wa == 6'd36 ) begin
	ram_ff36 <=  di_d;
    end
    if ( we && wa == 6'd37 ) begin
	ram_ff37 <=  di_d;
    end
    if ( we && wa == 6'd38 ) begin
	ram_ff38 <=  di_d;
    end
    if ( we && wa == 6'd39 ) begin
	ram_ff39 <=  di_d;
    end
    if ( we && wa == 6'd40 ) begin
	ram_ff40 <=  di_d;
    end
    if ( we && wa == 6'd41 ) begin
	ram_ff41 <=  di_d;
    end
    if ( we && wa == 6'd42 ) begin
	ram_ff42 <=  di_d;
    end
    if ( we && wa == 6'd43 ) begin
	ram_ff43 <=  di_d;
    end
    if ( we && wa == 6'd44 ) begin
	ram_ff44 <=  di_d;
    end
    if ( we && wa == 6'd45 ) begin
	ram_ff45 <=  di_d;
    end
    if ( we && wa == 6'd46 ) begin
	ram_ff46 <=  di_d;
    end
    if ( we && wa == 6'd47 ) begin
	ram_ff47 <=  di_d;
    end
    if ( we && wa == 6'd48 ) begin
	ram_ff48 <=  di_d;
    end
    if ( we && wa == 6'd49 ) begin
	ram_ff49 <=  di_d;
    end
    if ( we && wa == 6'd50 ) begin
	ram_ff50 <=  di_d;
    end
    if ( we && wa == 6'd51 ) begin
	ram_ff51 <=  di_d;
    end
    if ( we && wa == 6'd52 ) begin
	ram_ff52 <=  di_d;
    end
    if ( we && wa == 6'd53 ) begin
	ram_ff53 <=  di_d;
    end
    if ( we && wa == 6'd54 ) begin
	ram_ff54 <=  di_d;
    end
    if ( we && wa == 6'd55 ) begin
	ram_ff55 <=  di_d;
    end
    if ( we && wa == 6'd56 ) begin
	ram_ff56 <=  di_d;
    end
    if ( we && wa == 6'd57 ) begin
	ram_ff57 <=  di_d;
    end
    if ( we && wa == 6'd58 ) begin
	ram_ff58 <=  di_d;
    end
    if ( we && wa == 6'd59 ) begin
	ram_ff59 <=  di_d;
    end
    if ( we && wa == 6'd60 ) begin
	ram_ff60 <=  di_d;
    end
    if ( we && wa == 6'd61 ) begin
	ram_ff61 <=  di_d;
    end
    if ( we && wa == 6'd62 ) begin
	ram_ff62 <=  di_d;
    end
    if ( we && wa == 6'd63 ) begin
	ram_ff63 <=  di_d;
    end
end

reg [0:0] dout;

always @(*) begin
    case( ra ) 
    7'd0:       dout = ram_ff0;
    7'd1:       dout = ram_ff1;
    7'd2:       dout = ram_ff2;
    7'd3:       dout = ram_ff3;
    7'd4:       dout = ram_ff4;
    7'd5:       dout = ram_ff5;
    7'd6:       dout = ram_ff6;
    7'd7:       dout = ram_ff7;
    7'd8:       dout = ram_ff8;
    7'd9:       dout = ram_ff9;
    7'd10:       dout = ram_ff10;
    7'd11:       dout = ram_ff11;
    7'd12:       dout = ram_ff12;
    7'd13:       dout = ram_ff13;
    7'd14:       dout = ram_ff14;
    7'd15:       dout = ram_ff15;
    7'd16:       dout = ram_ff16;
    7'd17:       dout = ram_ff17;
    7'd18:       dout = ram_ff18;
    7'd19:       dout = ram_ff19;
    7'd20:       dout = ram_ff20;
    7'd21:       dout = ram_ff21;
    7'd22:       dout = ram_ff22;
    7'd23:       dout = ram_ff23;
    7'd24:       dout = ram_ff24;
    7'd25:       dout = ram_ff25;
    7'd26:       dout = ram_ff26;
    7'd27:       dout = ram_ff27;
    7'd28:       dout = ram_ff28;
    7'd29:       dout = ram_ff29;
    7'd30:       dout = ram_ff30;
    7'd31:       dout = ram_ff31;
    7'd32:       dout = ram_ff32;
    7'd33:       dout = ram_ff33;
    7'd34:       dout = ram_ff34;
    7'd35:       dout = ram_ff35;
    7'd36:       dout = ram_ff36;
    7'd37:       dout = ram_ff37;
    7'd38:       dout = ram_ff38;
    7'd39:       dout = ram_ff39;
    7'd40:       dout = ram_ff40;
    7'd41:       dout = ram_ff41;
    7'd42:       dout = ram_ff42;
    7'd43:       dout = ram_ff43;
    7'd44:       dout = ram_ff44;
    7'd45:       dout = ram_ff45;
    7'd46:       dout = ram_ff46;
    7'd47:       dout = ram_ff47;
    7'd48:       dout = ram_ff48;
    7'd49:       dout = ram_ff49;
    7'd50:       dout = ram_ff50;
    7'd51:       dout = ram_ff51;
    7'd52:       dout = ram_ff52;
    7'd53:       dout = ram_ff53;
    7'd54:       dout = ram_ff54;
    7'd55:       dout = ram_ff55;
    7'd56:       dout = ram_ff56;
    7'd57:       dout = ram_ff57;
    7'd58:       dout = ram_ff58;
    7'd59:       dout = ram_ff59;
    7'd60:       dout = ram_ff60;
    7'd61:       dout = ram_ff61;
    7'd62:       dout = ram_ff62;
    7'd63:       dout = ram_ff63;
    7'd64:       dout = di_d;
    //VCS coverage off
    default:    dout = {1{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // irq_upstream_reqfifo_flopram_rwsa_64x1

// emulation model of flopram guts
//
`ifdef EMU


module vmw_irq_upstream_reqfifo_flopram_rwsa_64x1 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [5:0] Wa0;
input            we0;
input  [0:0] Di0;
input  [5:0] Ra0;
output [0:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 1'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// VCS coverage off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [0:0] mem[63:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [0:0] Q0 = mem[0];
wire [0:0] Q1 = mem[1];
wire [0:0] Q2 = mem[2];
wire [0:0] Q3 = mem[3];
wire [0:0] Q4 = mem[4];
wire [0:0] Q5 = mem[5];
wire [0:0] Q6 = mem[6];
wire [0:0] Q7 = mem[7];
wire [0:0] Q8 = mem[8];
wire [0:0] Q9 = mem[9];
wire [0:0] Q10 = mem[10];
wire [0:0] Q11 = mem[11];
wire [0:0] Q12 = mem[12];
wire [0:0] Q13 = mem[13];
wire [0:0] Q14 = mem[14];
wire [0:0] Q15 = mem[15];
wire [0:0] Q16 = mem[16];
wire [0:0] Q17 = mem[17];
wire [0:0] Q18 = mem[18];
wire [0:0] Q19 = mem[19];
wire [0:0] Q20 = mem[20];
wire [0:0] Q21 = mem[21];
wire [0:0] Q22 = mem[22];
wire [0:0] Q23 = mem[23];
wire [0:0] Q24 = mem[24];
wire [0:0] Q25 = mem[25];
wire [0:0] Q26 = mem[26];
wire [0:0] Q27 = mem[27];
wire [0:0] Q28 = mem[28];
wire [0:0] Q29 = mem[29];
wire [0:0] Q30 = mem[30];
wire [0:0] Q31 = mem[31];
wire [0:0] Q32 = mem[32];
wire [0:0] Q33 = mem[33];
wire [0:0] Q34 = mem[34];
wire [0:0] Q35 = mem[35];
wire [0:0] Q36 = mem[36];
wire [0:0] Q37 = mem[37];
wire [0:0] Q38 = mem[38];
wire [0:0] Q39 = mem[39];
wire [0:0] Q40 = mem[40];
wire [0:0] Q41 = mem[41];
wire [0:0] Q42 = mem[42];
wire [0:0] Q43 = mem[43];
wire [0:0] Q44 = mem[44];
wire [0:0] Q45 = mem[45];
wire [0:0] Q46 = mem[46];
wire [0:0] Q47 = mem[47];
wire [0:0] Q48 = mem[48];
wire [0:0] Q49 = mem[49];
wire [0:0] Q50 = mem[50];
wire [0:0] Q51 = mem[51];
wire [0:0] Q52 = mem[52];
wire [0:0] Q53 = mem[53];
wire [0:0] Q54 = mem[54];
wire [0:0] Q55 = mem[55];
wire [0:0] Q56 = mem[56];
wire [0:0] Q57 = mem[57];
wire [0:0] Q58 = mem[58];
wire [0:0] Q59 = mem[59];
wire [0:0] Q60 = mem[60];
wire [0:0] Q61 = mem[61];
wire [0:0] Q62 = mem[62];
wire [0:0] Q63 = mem[63];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// VCS coverage on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_irq_upstream_reqfifo_flopram_rwsa_64x1] != {} } { set_attr preserve 1 [find / -subdesign vmw_irq_upstream_reqfifo_flopram_rwsa_64x1] }
endmodule // vmw_irq_upstream_reqfifo_flopram_rwsa_64x1

//vmw: Memory vmw_irq_upstream_reqfifo_flopram_rwsa_64x1
//vmw: Address-size 6
//vmw: Data-size 1
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[0:0] data0[0:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[0:0] data1[0:0]
//vmw: 

//qt: CELL vmw_irq_upstream_reqfifo_flopram_rwsa_64x1
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU




