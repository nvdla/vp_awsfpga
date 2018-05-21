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

#VPATH = src:include:$(HDK_DIR)/common/software/src:$(HDK_DIR)/common/software/include
VPATH = src:../../../common/software/src

INCLUDES = -I../../../common/software/include -I../include
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

ifndef VP_TEST
LDLIBS = -lfpga_mgmt -lrt -lpthread
endif

SRC = test_memdut.c cl_common_utils.c test_utils.c
OBJ = $(SRC:.c=.o)
ifdef VP_TEST
BIN = aarch64_test_memdut
else
BIN = test_memdut
endif

ifdef VP_TEST
all: $(BIN)
else
all: $(BIN) check_env
endif

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f *.o $(BIN)

ifndef VP_TEST
check_env:
ifndef SDK_DIR
    $(error SDK_DIR is undefined. Try "source sdk_setup.sh" to set the software environment)
endif
endif
