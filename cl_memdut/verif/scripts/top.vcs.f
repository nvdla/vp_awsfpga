# Amazon FPGA Hardware Development Kit
#
# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions and
# limitations under the License.

# Copyright (c) 2009-2017, NVIDIA CORPORATION. All rights reserved.
# NVIDIA’s contributions are offered under the Amazon Software License

+define+VCS_SIM

+libext+.v
+libext+.sv
+libext+.svh

-y ${CL_ROOT}/design
-y ${SH_LIB_DIR}
-y ${SH_INF_DIR}
-y ${HDK_SHELL_DESIGN_DIR}/sh_ddr/sim

+incdir+${CL_ROOT}/design
+incdir+${CL_ROOT}/verif/sv
+incdir+${CL_COMMON_ROOT}/verif/include
+incdir+${SH_LIB_DIR}
+incdir+${SH_INF_DIR}
+incdir+${HDK_SHELL_DESIGN_DIR}/sh_ddr/sim

${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_xbar_0/sim/cl_axi_interconnect_xbar_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_s00_regslice_0/sim/cl_axi_interconnect_s00_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_s01_regslice_0/sim/cl_axi_interconnect_s01_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_m00_regslice_0/sim/cl_axi_interconnect_m00_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_m01_regslice_0/sim/cl_axi_interconnect_m01_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_m02_regslice_0/sim/cl_axi_interconnect_m02_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/ip/cl_axi_interconnect_m03_regslice_0/sim/cl_axi_interconnect_m03_regslice_0.v
${SH_LIB_DIR}/../ip/cl_axi_interconnect/hdl/cl_axi_interconnect.v
${SH_LIB_DIR}/../ip/axi_clock_converter_0/sim/axi_clock_converter_0.v
${SH_LIB_DIR}/../ip/dest_register_slice/sim/dest_register_slice.v
${SH_LIB_DIR}/../ip/src_register_slice/sim/src_register_slice.v
${SH_LIB_DIR}/../ip/axi_register_slice/sim/axi_register_slice.v
${SH_LIB_DIR}/../ip/axi_register_slice_light/sim/axi_register_slice_light.v

+define+DISABLE_VJTAG_DEBUG
${CL_ROOT}/design/axil_slave.sv
${CL_ROOT}/design/cl_memdut_defines.vh
${CL_ROOT}/design/cl_memdut_pkg.sv
${CL_ROOT}/design/cl_dma_pcis_slv.sv
${CL_ROOT}/design/cl_ila.sv
${CL_ROOT}/design/cl_vio.sv
${CL_ROOT}/design/cl_memdut.sv
${CL_ROOT}/design/cl_memdut_wrap.sv

${CL_COMMON_ROOT}/design/xilinx_ip/axi_interconnect_nvdla_256b/axi_interconnect_nvdla_256b_sim_netlist.v
${CL_COMMON_ROOT}/design/xilinx_ip/axi_apb_bridge_0/axi_apb_bridge_0_sim_netlist.v
${CL_COMMON_ROOT}/design/transactors/irq/cl_irq_up.v
${CL_COMMON_ROOT}/design/transactors/irq/cl_irq_up_bit.v
${CL_COMMON_ROOT}/design/transactors/cfg/cl_cfgreg.sv

-y ${CL_COMMON_ROOT}/design/vlibs
+incdir+${CL_COMMON_ROOT}/design/transactors/irq

+define+NO_PLI_OR_EMU
+define+VLIB_BYPASS_POWER_CG
+define+VERILINT
+define+PRAND_OFF
+define+SYNC_PL_NO_RANDOMIZATION
+define+NO_PERFMON_HISTOGRAM

${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut.v
${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut_apb_slave.v
${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut_axi_256_256.v
${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut_axi_req_256.v
${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut_axi_req_gen_256.v
${CL_ROOT}/design/simple_dut/NV_FPGA_unit_checkbox_mem_dut_axi_resp_256.v
${CL_ROOT}/design/simple_dut/nv_ram_rws_256x128.v
${CL_ROOT}/design/simple_dut/nv_ram_rws_256x27.v
${CL_ROOT}/design/simple_dut/nv_ram_rws_512x256.v
${CL_ROOT}/design/simple_dut/nv_ram_rws_512x32.v
+define+NO_INIT_MEM_RANDOM_TASK
+define+NO_INIT_MEM_VAL_TASKS

-f ${HDK_COMMON_DIR}/verif/tb/filelists/tb.${SIMULATOR}.f

${TEST_NAME}
