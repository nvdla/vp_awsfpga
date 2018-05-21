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

${SH_LIB_DIR}/../ip/axi_clock_converter_0/sim/axi_clock_converter_0.v
${SH_LIB_DIR}/../ip/dest_register_slice/sim/dest_register_slice.v
${SH_LIB_DIR}/../ip/src_register_slice/sim/src_register_slice.v
${SH_LIB_DIR}/../ip/axi_register_slice/sim/axi_register_slice.v
${SH_LIB_DIR}/../ip/axi_register_slice_light/sim/axi_register_slice_light.v

+define+DISABLE_VJTAG_DEBUG
${CL_ROOT}/design/cl_sim_mem.sv
${CL_ROOT}/design/cl_sim_mem_wrap.sv
${CL_ROOT}/design/cl_nvdla_defines.vh
${CL_ROOT}/design/cl_nvdla_pkg.sv
${CL_ROOT}/design/cl_dma_pcis_slv.sv
${CL_ROOT}/design/cl_ila.sv
${CL_ROOT}/design/cl_vio.sv
${CL_ROOT}/design/cl_nvdla.sv
${CL_ROOT}/design/cl_nvdla_wrap.sv

${CL_COMMON_ROOT}/design/xilinx_ip/axi_interconnect_nvdla_64b/axi_interconnect_nvdla_64b_sim_netlist.v
${CL_COMMON_ROOT}/design/xilinx_ip/axi_apb_bridge_0/axi_apb_bridge_0_sim_netlist.v
${CL_COMMON_ROOT}/design/xilinx_ip/axi_dwidth_converter_512b_to_64b/axi_dwidth_converter_512b_to_64b_sim_netlist.v
${CL_COMMON_ROOT}/design/xilinx_ip/axi_protocol_converter_axi_to_axil/axi_protocol_converter_axi_to_axil_sim_netlist.v
${CL_COMMON_ROOT}/design/transactors/irq/cl_irq_up.v
${CL_COMMON_ROOT}/design/transactors/irq/cl_irq_up_bit.v
${CL_COMMON_ROOT}/design/transactors/cfg/cl_cfgreg.sv

-y ${CL_COMMON_ROOT}/design/vlibs
+incdir+${CL_COMMON_ROOT}/design/transactors/irq

+define+NO_PLI_OR_EMU
+define+VLIB_BYPASS_POWER_CG
+define+VERILINT
+define+SYNC_PL_NO_RANDOMIZATION

-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cdma
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cbuf
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/csc
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cmac
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cacc
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/sdp
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/pdp
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cdp
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/bdma
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/rubik
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/car
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/glb
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/csb_master
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/nocif
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/retiming
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/top
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/apb2csb
-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/cfgrom

-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs

#-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/rams
#-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/rams/model
#-y ${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/rams/synth
-y ${NVDLA_HW_ROOT}/vmod/rams/fpga/small_rams

${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs/nv_assert_no_x.vlib
${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs/NV_DW02_tree.v
${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs/NV_DW_lsd.v
${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs/NV_DW_minmax.v
${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/nvdla/nocif/NV_NVDLA_XXIF_libs.v

+incdir+${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/include
+incdir+${NVDLA_HW_ROOT}/outdir/${NVDLA_HW_PROJECT}/vmod/vlibs

+define+NVTOOLS_SYNC2D_GENERIC_CELL
+define+DESIGNWARE_NOEXIST
+define+PRAND_OFF
+define+NO_PERFMON_HISTOGRAM
+define+NO_INIT_MEM_RANDOM_TASK
+define+NO_INIT_MEM_VAL_TASKS
+define+NV_FPGA_FIFOGEN

-f ${HDK_COMMON_DIR}/verif/tb/filelists/tb.${SIMULATOR}.f

${TEST_NAME}
