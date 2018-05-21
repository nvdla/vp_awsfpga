// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: simulate_x_tick.vh

`ifdef _SIMULATE_X_VH_
`else
`define _SIMULATE_X_VH_

// synopsys translate_off
`define SIMULATION_ONLY
//synopsys translate_on

// useful values
`ifdef SIMULATION_ONLY
`define x_or_0  1'b0
`define x_or_1  1'b1

`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`else
`define x_or_0  1'b0
`define x_or_1  1'b1

`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`endif

// recommended tick defines
`ifdef SIMULATION_ONLY
`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`else
`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`endif

`endif
