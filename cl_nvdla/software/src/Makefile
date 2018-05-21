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

#VPATH = src:include:$(HDK_DIR)/common/software/src:$(HDK_DIR)/common/software/include

.PHONY: default
default: all

NVDLA_HW_ROOT    ?= $(abspath ../../../../../../hw)
NVDLA_HW_PROJECT ?= nv_small

NVDLA_TRACE_PLAYER_ROOT ?= $(abspath ../../../common/trace_player)
NVDLA_TRACE_PLAYER_CFLAGS = "-DDEBUG -g"
NVDLA_REGISTER_HEADER_DIR ?= $(NVDLA_HW_ROOT)/outdir/$(NVDLA_HW_PROJECT)/spec/manual
NVDLA_TRACE ?= ../test_bdma/test_bdma.cfg

include $(NVDLA_TRACE_PLAYER_ROOT)/Makefile.inc

VPATH = src:../../../common/software/src:$(NVDLA_TRACE_PLAYER_SRC_DIR)
INCLUDES = -I../../../common/software/include -I../include -I$(NVDLA_REGISTER_HEADER_DIR) -I$(NVDLA_TRACE_PLAYER_INCLUDES)
ifndef VP_TEST
INCLUDES += -I$(SDK_DIR)/userspace/include
endif

ifdef VP_TEST
CC = aarch64-linux-gnu-gcc
else
CC = gcc
endif
CFLAGS = -DCONFIG_LOGLEVEL=4 -g -Wall $(INCLUDES)
ifdef VP_TEST
CFLAGS += -DVP_TEST
else
CFLAGS += -L$(SDK_DIR)/userspace/lib/so
endif

LDFLAGS = -Wl,-rpath $(NVDLA_TRACE_PLAYER_LIB_DIR) -L$(NVDLA_TRACE_PLAYER_LIB_DIR)
LDLIBS = -l$(NVDLA_TRACE_PLAYER_LIB)
ifndef VP_TEST
LDLIBS += -lfpga_mgmt -lrt -lpthread
endif

SRC = trace_test.c trace_test_impl.c cl_common_utils.c
OBJ = $(SRC:.c=.o)
ifdef VP_TEST
BIN = aarch64_trace_test
else
BIN = trace_test
endif

ifdef VP_TEST
all: $(NVDLA_TRACE_PARSER_COMMAND_LIB) $(NVDLA_TRACE_PLAYER_LIB_DIR)/$(NVDLA_TRACE_PLAYER_LIB) $(BIN)
else
all: $(NVDLA_TRACE_PARSER_COMMAND_LIB) $(NVDLA_TRACE_PLAYER_LIB_DIR)/$(NVDLA_TRACE_PLAYER_LIB) $(BIN) check_env 
endif

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f *.o $(BIN) $(NVDLA_TRACE_PARSER_COMMAND_SRC) $(NVDLA_TRACE_PARSER_COMMAND_OBJ) $(NVDLA_TRACE_PARSER_COMMAND_LIB) *.dat *.log

ifndef VP_TEST
check_env:
ifndef SDK_DIR
    $(error SDK_DIR is undefined. Try "source sdk_setup.sh" to set the software environment)
endif
endif
