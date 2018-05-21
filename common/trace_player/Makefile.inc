# ================================================================
# NVDLA Open Source Project
# 
# Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
# NVDLA Open Hardware License; Check \"LICENSE\" which comes with 
# this distribution for more information.
# ================================================================

export NVDLA_TRACE_PARSER ?= $(NVDLA_TRACE_PLAYER_ROOT)/parser/nvdla_trace_parser.py
export NVDLA_TRACE_PARSER_COMMAND_NAME ?= trace_parser_command
export NVDLA_TRACE_PARSER_COMMAND_SRC ?= $(addsuffix .c, $(NVDLA_TRACE_PARSER_COMMAND_NAME))
export NVDLA_TRACE_PARSER_COMMAND_OBJ ?= $(addsuffix .o, $(NVDLA_TRACE_PARSER_COMMAND_NAME))
export NVDLA_TRACE_PARSER_COMMAND_LIB ?= $(addprefix lib, $(addsuffix .so, $(NVDLA_TRACE_PARSER_COMMAND_NAME)))

export NVDLA_TRACE_PLAYER_INCLUDES ?= $(NVDLA_TRACE_PLAYER_ROOT)/include
export NVDLA_TRACE_PLAYER_SRC_DIR ?= $(NVDLA_TRACE_PLAYER_ROOT)/src
export NVDLA_TRACE_PLAYER_SRCS ?= \
    trace_player_cmd.c \
    trace_player_intr.c \
    trace_player_sync.c \
    trace_player_reg.c \
    trace_player_mem.c \
    trace_player_thread.c \

export NVDLA_TRACE_PLAYER_LIB_DIR ?= $(NVDLA_TRACE_PLAYER_ROOT)/build
export NVDLA_TRACE_PLAYER_LIB ?= trace_player_shared

export NVDLA_TRACE_PLAYER_SRCS_FULLPATH ?= $(addprefix $(NVDLA_TRACE_PLAYER_SRC_DIR)/,${NVDLA_TRACE_PLAYER_SRCS})  

$(NVDLA_TRACE_PARSER_COMMAND_SRC):
	$(NVDLA_TRACE_PARSER) -f $(NVDLA_TRACE)

$(NVDLA_TRACE_PARSER_COMMAND_LIB): $(NVDLA_TRACE_PARSER_COMMAND_SRC)
	$(CC) -fPIC -c $(NVDLA_TRACE_PARSER_COMMAND_SRC) -o $(NVDLA_TRACE_PARSER_COMMAND_OBJ) -I$(NVDLA_TRACE_PLAYER_INCLUDES) -I$(NVDLA_REGISTER_HEADER_DIR)
	$(CC) -fPIC -shared -o $(NVDLA_TRACE_PARSER_COMMAND_LIB) $(NVDLA_TRACE_PARSER_COMMAND_OBJ)

$(NVDLA_TRACE_PLAYER_LIB_DIR)/$(NVDLA_TRACE_PLAYER_LIB):
	cd $(NVDLA_TRACE_PLAYER_LIB_DIR) && make clean && make NVDLA_TRACE_PLAYER_CFLAGS=$(NVDLA_TRACE_PLAYER_CFLAGS) CC=$(CC)
