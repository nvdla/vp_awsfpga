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

module trace_test();

   initial begin
      int exit_code;
      string trace_output_lib;
      int enable_sim_mem = 0;
      
      tb.power_up();

//      tb.nsec_delay(500);
//      tb.poke_stat(.addr(8'h0c), .ddr_idx(0), .data(32'h0000_0000));
//      tb.poke_stat(.addr(8'h0c), .ddr_idx(1), .data(32'h0000_0000));
//      tb.poke_stat(.addr(8'h0c), .ddr_idx(2), .data(32'h0000_0000));
//      
     
      $value$plusargs("trace_output_lib=%s", trace_output_lib);

`ifdef SIM_BACKDOOR_MEM
      if ($test$plusargs("enable_sim_mem"))
         enable_sim_mem = 1;
`endif         

      if ($test$plusargs("enable_mem_log"))
         tb.enable_backdoor_mem_log(1);
      else
         tb.enable_backdoor_mem_log(0);

      @(tb.card.fpga.CL.bar1_slv_sync_rst_n === 1'b1);
      
      #50ns;

      tb.trace_test_main(exit_code, trace_output_lib, enable_sim_mem);
      
      #50ns;

      tb.power_down();
      
      $finish;
   end

endmodule // trace_test
