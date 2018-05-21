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


module cosim_test();
`ifdef COSIM_TOP
import "DPI-C" context function void  sv_done_notify(input longint unsigned ev_idx);
    cosim_top cosim_top();
    event ev_apb_wr;
    event ev_ram_wr;
    event ev_irq_wr;
    event ev_apb_rd;
    event ev_ram_rd;
    event ev_irq_rd;
    event ev_tb_power_on;

    longint unsigned apb_addr_rd;
    longint unsigned apb_addr_wr;
    int unsigned     apb_data_rd;
    int unsigned     apb_data_wr;

    longint unsigned ram_addr_rd;
    longint unsigned ram_addr_wr;
    longint unsigned ram_data_rd;
    longint unsigned ram_data_wr;
    int unsigned     ram_size_rd;
    int unsigned     ram_size_wr;

    int unsigned irq_wr;
    int unsigned irq_rd;

    export "DPI-C" function set_apb_wr;
    export "DPI-C" function set_apb_rd;
    export "DPI-C" function set_ram_wr;
    export "DPI-C" function set_ram_rd;
    export "DPI-C" function set_irq_wr;
    export "DPI-C" function set_irq_rd;
    export "DPI-C" function set_ev_trigger;
    export "DPI-C" function apb_read_ack;
    export "DPI-C" function ram_read_ack;
    export "DPI-C" function irq_read_ack;

    function set_apb_wr(input longint unsigned addr, input int unsigned data);
        apb_addr_wr = addr;
        apb_data_wr = data;
    endfunction

    function set_apb_rd(input longint unsigned addr, input int unsigned data);
        apb_addr_rd = addr;
        apb_data_rd = data;
    endfunction

    function set_ram_wr(input longint unsigned addr, input longint unsigned data, input int unsigned size);
        ram_addr_wr = addr;
        ram_data_wr = data;
        ram_size_wr = size;
    endfunction

    function set_ram_rd(input longint unsigned addr, input longint unsigned data, input int unsigned size);
        ram_addr_rd = addr;
        ram_data_rd = data;
        ram_size_rd = size;
    endfunction

    function set_irq_wr(input int unsigned data);
        irq_wr = data;
    endfunction

    function set_irq_rd(input int unsigned data);
        irq_rd = data;
    endfunction

    function int unsigned apb_read_ack();
        return apb_data_rd; 
    endfunction

    function longint unsigned ram_read_ack();
        return ram_data_rd; 
    endfunction

    function int unsigned irq_read_ack();
        return irq_rd; 
    endfunction

    function set_ev_trigger(input int unsigned ev_idx);
`ifdef COSIM_LOG
                $display( "Set event trigger index: %H", ev_idx);
`endif
        case (ev_idx)
            0 : begin
                ->ev_apb_wr;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_apb_wr");
`endif
            end
            1 : begin
                ->ev_ram_wr;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_ram_wr");
`endif
            end
            2 : begin
                ->ev_irq_wr;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_irq_wr");
`endif
            end
            3 : begin
                ->ev_apb_rd;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_apb_rd");
`endif
            end
            4 : begin
                ->ev_ram_rd;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_ram_rd");
`endif
            end
            5 : begin
                ->ev_irq_rd;
`ifdef COSIM_LOG
                $display( "Set event trigger ev_irq_rd");
`endif
            end
            default: begin
                $display("Error: Invlid event ID!");
            end
        endcase
    endfunction

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_apb_wr");
`endif
        forever begin
            @(ev_apb_wr)
`ifdef COSIM_LOG
            $display( "Before Get APB write event Address: %H  Data: %H", apb_addr_wr, apb_data_wr);
`endif
            tb.cl_poke_ocl(apb_addr_wr, apb_data_wr);
`ifdef COSIM_LOG
            $display( "Get APB write event Address: %H  Data: %H", apb_addr_wr, apb_data_wr);
`endif
            sv_done_notify(32'h0000_0000);
        end
    end

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_ram_wr");
`endif
        forever begin
            @(ev_ram_wr)
`ifdef COSIM_LOG
            $display( " Before Get RAM write event Address: %H  Data: %H", ram_addr_wr, ram_data_wr);
`endif
            tb.cl_poke_pcis(ram_addr_wr, ram_data_wr, ram_size_wr);
`ifdef COSIM_LOG
            $display( "Get RAM write event Address: %H  Data: %H", ram_addr_wr, ram_data_wr);
`endif
            sv_done_notify(32'h0000_0001);
        end
    end

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_irq_wr");
`endif
        forever begin
            @(ev_irq_wr)
`ifdef COSIM_LOG
            $display( "Before Get INT write event Value: %H", irq_wr);
`endif
            tb.cl_poke_bar1(32'h0000_0000, irq_wr);
`ifdef COSIM_LOG
            $display( "Get INT write event Value: %H", irq_wr);
`endif
            sv_done_notify(32'h0000_0002);
        end
    end

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_apb_rd");
`endif
        forever begin
            @(ev_apb_rd)
`ifdef COSIM_LOG
            $display( "Before Get APB read event Address: %H  Data: %H", apb_addr_rd, apb_data_rd);
`endif
            tb.cl_peek_ocl(apb_addr_rd, apb_data_rd);
`ifdef COSIM_LOG
            $display( "Get APB read event Address: %H  Data: %H", apb_addr_rd, apb_data_rd);
`endif
            sv_done_notify(32'h0000_0003);
        end
    end

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_ram_rd");
`endif
        forever begin
            @(ev_ram_rd);
`ifdef COSIM_LOG
            $display( "Before Get RAM read event Address: %H  Data: %H", ram_addr_rd, ram_data_rd);
`endif
            tb.cl_peek_pcis(ram_addr_rd, ram_data_rd, ram_size_rd);
`ifdef COSIM_LOG
            $display( "Get RAM read event Address: %H  Data: %H", ram_addr_rd, ram_data_rd);
`endif
            sv_done_notify(32'h0000_0004);
        end
    end

    initial begin
        @(ev_tb_power_on);
`ifdef COSIM_LOG
        $display("ev_irq_rd");
`endif
        forever begin
            @(ev_irq_rd)
`ifdef COSIM_LOG
             $display( "Before Get INT read event Value: %H", irq_rd);
`endif
            tb.cl_peek_bar1(32'h0000_0000, irq_rd);
`ifdef COSIM_LOG
             $display( "Get INT read event Value: %H", irq_rd);
`endif
            sv_done_notify(32'h0000_0005);
        end
    end
`endif
    initial begin
        int exit_code;
        tb.power_up();
        tb.nsec_delay(500);
        ->ev_tb_power_on;
        sv_done_notify(32'h0000_0006);
    end

endmodule // cosim_test
