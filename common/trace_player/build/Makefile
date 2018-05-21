# ================================================================
# NVDLA Open Source Project
# 
# Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
# NVDLA Open Hardware License; Check \"LICENSE\" which comes with 
# this distribution for more information.
# ================================================================

VPATH = ../src

INCLUDES = -I../../../common/software/include -I../include

CC ?= gcc
CFLAGS = -Wall -fPIC $(INCLUDES) $(NVDLA_TRACE_PLAYER_CFLAGS)
LDLIBS = -ldl

SRC = \
    trace_player.c \
    trace_player_cmd.c \
    trace_player_intr.c \
    trace_player_sync.c \
    trace_player_reg.c \
    trace_player_mem.c \
    trace_player_thread.c \

OBJ = $(SRC:.c=.o)
TARGET = libtrace_player_shared.so

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -shared -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f *.o $(TARGET)
