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

.PHONY: default
default: all

export TRACE_TEST ?= 0

ifeq ($(TRACE_TEST),1)
export TEST ?= trace_test
export C_TEST ?= trace_test
export NVDLA_ENABLE_SIM_MEM ?= "+enable_sim_mem"
else
export TEST ?= test_null
export C_TEST ?= test_null
endif

export CL_ROOT ?= $(PWD)/../..

export CL_COMMON_ROOT = $(CL_ROOT)/../common

export VP_ROOT = $(PWD)/../../../../..

export C_INC_DIR  = -I${CL_COMMON_ROOT}/software/include
export C_SRC_DIR  = $(CL_ROOT)/software/src

export TEST_NAME =  $(CL_ROOT)/verif/tests/$(TEST).sv
ifeq ($(TRACE_TEST),1)
export C_TEST_NAME = $(CL_ROOT)/software/src/$(C_TEST).c $(CL_ROOT)/software/src/trace_test_impl.c $(CL_COMMON_ROOT)/software/src/cl_common_utils.c $(CL_COMMON_ROOT)/software/src/sh_dpi_tasks.c
else
ifeq ($(COSIM), 1)
export C_TEST_NAME = $(CL_ROOT)/software/src/$(C_TEST).c
else
export C_TEST_NAME = $(CL_ROOT)/software/src/$(C_TEST).c $(CL_COMMON_ROOT)/software/src/cl_common_utils.c $(CL_COMMON_ROOT)/software/src/sh_dpi_tasks.c
endif
endif

export SIM_ROOT = $(CL_ROOT)/verif/sim

export NVDLA_TRACE ?= $(CL_ROOT)/software/test_bdma/test_bdma.cfg

ifeq ($(C_TEST),test_null)
  export SIM_DIR = $(SIM_ROOT)/$(TEST)
  export RUN_DIR = $(SIM_ROOT)/$(TEST)
else
ifeq ($(C_TEST),trace_test)
  export SIM_DIR = $(SIM_ROOT)/$(C_TEST)
  export RUN_DIR ?= $(SIM_ROOT)/$(notdir $(NVDLA_TRACE))
else
  export SIM_DIR = $(SIM_ROOT)/$(C_TEST)
  export RUN_DIR = $(SIM_ROOT)/$(C_TEST)
endif
endif

export SCRIPTS_DIR = $(CL_ROOT)/verif/scripts
export XILINX_IP   = $(HDK_SHELL_DESIGN_DIR)/ip
export SH_LIB_DIR  = $(HDK_SHELL_DESIGN_DIR)/lib
export SH_INF_DIR  = $(HDK_SHELL_DESIGN_DIR)/interfaces

export NVDLA_HW_ROOT    ?= $(VP_ROOT)/../hw
export NVDLA_HW_PROJECT ?= nv_small

ifneq ($(NVDLA_HW_PROJECT),nv_small)
export NVDLA_HW_DEFINES ?= +define+NVDLA_CVSRAM_PRESENT
endif

export NVDLA_REGISTER_HEADER_DIR ?= $(NVDLA_HW_ROOT)/outdir/$(NVDLA_HW_PROJECT)/spec/manual

SV_TEST_LIST = 
C_TEST_LIST  = trace_test.c test_null.c

ifeq ($(TRACE_TEST),1)
export NVDLA_TRACE_PLAYER_CFLAGS ?= "-g -DDEBUG"
export NVDLA_TRACE_PLAYER_ROOT ?= $(CL_COMMON_ROOT)/trace_player

include $(NVDLA_TRACE_PLAYER_ROOT)/Makefile.inc
endif

export SIM_BACKDOOR_MEM ?= 1
ifeq ($(SIM_BACKDOOR_MEM),1)
export NVDLA_HW_DEFINES += +define+SIM_BACKDOOR_MEM
endif

all:	make_sim_dir compile run

include $(HDK_COMMON_DIR)/verif/tb/scripts/Makefile.common.inc
