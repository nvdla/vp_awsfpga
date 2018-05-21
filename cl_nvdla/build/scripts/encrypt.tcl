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

# TODO:
# Add check if CL_DIR and HDK_SHELL_DIR directories exist
# Add check if /build and /build/src_port_encryption directories exist
# Add check if the vivado_keyfile exist

set HDK_SHELL_DIR $::env(HDK_SHELL_DIR)
set HDK_SHELL_DESIGN_DIR $::env(HDK_SHELL_DESIGN_DIR)
set CL_DIR $::env(CL_DIR)
set NV_HW_ROOT $::env(NV_HW_ROOT)

set TARGET_DIR $CL_DIR/build/src_post_encryption
set UNUSED_TEMPLATES_DIR $HDK_SHELL_DESIGN_DIR/interfaces


# Remove any previously encrypted files, that may no longer be used
exec rm -f $TARGET_DIR/*

#---- Developr would replace this section with design files ----

## Change file names and paths below to reflect your CL area.  DO NOT include AWS RTL files.
file copy -force $CL_DIR/design/cl_nvdla_defines.vh                                   $TARGET_DIR
file copy -force $CL_DIR/../common/design/transactors/cfg/cl_cfgreg.sv               $TARGET_DIR
file copy -force $CL_DIR/../common/design/transactors/irq/cl_irq_up.v                $TARGET_DIR
file copy -force $CL_DIR/../common/design/transactors/irq/cl_irq_up_bit.v            $TARGET_DIR
file copy -force $CL_DIR/../common/design/transactors/irq/simulate_x_tick.vh         $TARGET_DIR
file copy -force $CL_DIR/design/cl_dma_pcis_slv.sv                                   $TARGET_DIR
file copy -force $CL_DIR/design/cl_id_defines.vh                                     $TARGET_DIR
file copy -force $CL_DIR/design/cl_ila.sv                                            $TARGET_DIR
file copy -force $CL_DIR/design/cl_nvdla_pkg.sv                                      $TARGET_DIR
file copy -force $CL_DIR/design/cl_nvdla_wrap.sv                                     $TARGET_DIR
file copy -force $CL_DIR/design/cl_vio.sv                                            $TARGET_DIR
file copy -force $CL_DIR/design/cl_nvdla.sv                                          $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_apppf_irq_template.inc  $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_cl_sda_template.inc     $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_ddr_a_b_d_template.inc  $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_ddr_c_template.inc      $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_dma_pcis_template.inc   $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_pcim_template.inc       $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_sh_bar1_template.inc    $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_flr_template.inc        $TARGET_DIR
source ./nvdla_file.tcl

#---- End of section replaced by Developr ---
exec chmod +w {*}[glob $TARGET_DIR/*]
#encrypt -k $HDK_SHELL_DIR/build/scripts/vivado_keyfile.txt -lang verilog  [glob -nocomplain -- $TARGET_DIR/*.{v,sv}] [glob -nocomplain -- $TARGET_DIR/*.vh] [glob -nocomplain -- $TARGET_DIR/*.inc]
