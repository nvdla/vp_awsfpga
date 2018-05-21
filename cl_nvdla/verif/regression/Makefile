# ================================================================
# NVDLA Open Source Project
# 
# Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
# NVDLA Open Hardware License; Check \"LICENSE\" which comes with 
# this distribution for more information.
# ================================================================

RUN_TEST_MAKEFILE_DIR = $(abspath ../scripts)
CL_ROOT = $(abspath ../..)

NVDLA_HW_ROOT ?= ../../../../../../hw
NVDLA_HW_ROOT_FULL_PATH = $(abspath $(NVDLA_HW_ROOT))
NVDLA_HW_PROJECT ?= nv_small

NVDLA_HW_TRACE_LIST ?= nv_small_sanity

NVDLA_HW_TRACE_DIR ?= $(shell cat $(NVDLA_HW_TRACE_LIST))

NVDLA_HW_TRACE_ROOT ?= $(NVDLA_HW_ROOT_FULL_PATH)/verif/tests/trace_tests/$(NVDLA_HW_PROJECT)

TIMESTAMP := $(shell /bin/date "+%Y-%m-%d_%H-%M-%S")

ifdef AWS_FPGA
OUT_DIR ?= $(PWD)/regression_$(NVDLA_HW_PROJECT)_$(NVDLA_HW_TRACE_LIST)_$(TIMESTAMP)_AWS_FPGA
else
OUT_DIR ?= $(PWD)/regression_$(NVDLA_HW_PROJECT)_$(NVDLA_HW_TRACE_LIST)_$(TIMESTAMP)
endif
LSF_GROUP = /regression_$(NVDLA_HW_PROJECT)_$(NVDLA_HW_TRACE_LIST)_$(TIMESTAMP)

CHECK_OUT_DIR ?= $(shell ls -rtd -- regression_* | tail -1)

NVDLA_HW_TRACE_LST_1 = $(wordlist 1,40,$(NVDLA_HW_TRACE_DIR))
NVDLA_HW_TRACE_LST_2 = $(wordlist 41,81,$(NVDLA_HW_TRACE_DIR))

ifdef AWS_FPGA
CL_ROOT ?= $(PWD)/../..
CL_TRACE_TEST_BUILD = $(CL_ROOT)/software/src
CL_TRACE_TEST_BIN ?= $(OUT_DIR)/$(trace)/test
RUN_OUT_DIR ?= $(shell ls -rtd -- regression_* | tail -1)
NVDLA_HW_TRACE_LST_1 = $(wordlist 1,100,$(NVDLA_HW_TRACE_DIR))
NVDLA_HW_TRACE_LST_2 = $(wordlist 101,200,$(NVDLA_HW_TRACE_DIR))
endif

.PHONY: all
all: compile run

compile:

ifdef AWS_FPGA
ifdef RANDOM_TEST
		$(foreach trace, $(NVDLA_HW_TRACE_LST_1),                              \
			$(eval trace_base := $(shell echo $(trace) | sed 's/_[0-9]//g')) \
			mkdir -p $(CL_TRACE_TEST_BIN);                                    \
			make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace_base)/$(trace_base).cfg; \
			cp $(CL_TRACE_TEST_BUILD)/trace_test $(CL_TRACE_TEST_BIN);        \
			cp $(CL_TRACE_TEST_BUILD)/libtrace_parser_command.so $(CL_TRACE_TEST_BIN); \
			make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace_base)/$(trace_base).cfg clean;)
		$(foreach trace, $(NVDLA_HW_TRACE_LST_2),                              \
			$(eval trace_base := $(shell echo $(trace) | sed 's/_[0-9]//g')) \
			mkdir -p $(CL_TRACE_TEST_BIN);                                    \
			make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace_base)/$(trace_base).cfg; \
			cp $(CL_TRACE_TEST_BUILD)/trace_test $(CL_TRACE_TEST_BIN);        \
			cp $(CL_TRACE_TEST_BUILD)/libtrace_parser_command.so $(CL_TRACE_TEST_BIN); \
			make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace_base)/$(trace_base).cfg clean;)
else
		$(foreach trace, $(NVDLA_HW_TRACE_LST_1), mkdir -p $(CL_TRACE_TEST_BIN) && make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg && cp $(CL_TRACE_TEST_BUILD)/trace_test $(CL_TRACE_TEST_BIN) && cp $(CL_TRACE_TEST_BUILD)/libtrace_parser_command.so $(CL_TRACE_TEST_BIN) && make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg clean;)
		$(foreach trace, $(NVDLA_HW_TRACE_LST_2), mkdir -p $(CL_TRACE_TEST_BIN) && make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg && cp $(CL_TRACE_TEST_BUILD)/trace_test $(CL_TRACE_TEST_BIN) && cp $(CL_TRACE_TEST_BUILD)/libtrace_parser_command.so $(CL_TRACE_TEST_BIN) && make -C $(CL_TRACE_TEST_BUILD) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg clean;)
endif
else
ifdef LSF_CMD
	cd $(RUN_TEST_MAKEFILE_DIR) && $(LSF_CMD) -Is make CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) TRACE_TEST=1 SIM_BACKDOOR_MEM=1 make_sim_dir compile
else
	cd $(RUN_TEST_MAKEFILE_DIR) && make -C $(RUN_TEST_MAKEFILE_DIR) CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) TRACE_TEST=1 SIM_BACKDOOR_MEM=1 make_sim_dir compile
endif
endif

run:
ifdef AWS_FPGA
	cd $(RUN_OUT_DIR) && $(foreach trace, $(NVDLA_HW_TRACE_DIR), cd $(trace)/test && echo 'sudo ./trace_test ./libtrace_parser_command.so' > $(trace).sh && chmod +x *.sh && sudo ./trace_test ./libtrace_parser_command.so | tee ../trace_test.log && cd ../..;)
else
	mkdir -p $(OUT_DIR)
ifdef LSF_CMD
	cd $(OUT_DIR) && echo "bkill -g $(LSF_GROUP) 0" > kill.sh && chmod +x kill.sh && $(foreach trace, $(NVDLA_HW_TRACE_LST_1), mkdir -p $(OUT_DIR)/$(trace) && cd $(OUT_DIR)/$(trace) && cp -r $(NVDLA_HW_TRACE_ROOT)/$(trace) ./ && echo '$(LSF_CMD) -g $(LSF_GROUP) -eo $(trace).log2 -oo $(trace).log make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run' > $(trace).cmd.sh && echo 'make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run' > $(trace).sh && chmod +x *.sh && $(LSF_CMD) -g $(LSF_GROUP) -eo $(trace).log2 -oo $(trace).log make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run;)
	cd $(OUT_DIR) && echo "bkill -g $(LSF_GROUP) 0" > kill.sh && chmod +x kill.sh && $(foreach trace, $(NVDLA_HW_TRACE_LST_2), mkdir -p $(OUT_DIR)/$(trace) && cd $(OUT_DIR)/$(trace) && cp -r $(NVDLA_HW_TRACE_ROOT)/$(trace) ./ && echo '$(LSF_CMD) -g $(LSF_GROUP) -eo $(trace).log2 -oo $(trace).log make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run' > $(trace).cmd.sh && echo 'make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run' > $(trace).sh && chmod +x *.sh && $(LSF_CMD) -g $(LSF_GROUP) -eo $(trace).log2 -oo $(trace).log make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run;)
else
	cd $(OUT_DIR) && $(foreach trace, $(NVDLA_HW_TRACE_DIR), mkdir -p $(OUT_DIR)/$(trace) && cd $(OUT_DIR)/$(trace) && echo 'make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run' > $(trace).sh && chmod +x *.sh && make -C $(RUN_TEST_MAKEFILE_DIR) TRACE_TEST=1 RUN_DIR="$(OUT_DIR)/$(trace)" CL_ROOT=$(CL_ROOT) VCS=1 NVDLA_HW_ROOT=$(NVDLA_HW_ROOT_FULL_PATH) NVDLA_HW_PROJECT=$(NVDLA_HW_PROJECT) NVDLA_TRACE=$(NVDLA_HW_TRACE_ROOT)/$(trace)/$(trace).cfg run |& tee $(trace).log;)
endif
endif

check:
	@echo "Regression status: $(CHECK_OUT_DIR)" && cd $(CHECK_OUT_DIR) && $(foreach trace, $(NVDLA_HW_TRACE_DIR), test -f $(trace)/trace_test.log && (grep -sqF -- "Test PASS" $(trace)/trace_test.log && echo -e "\033[0;32mPASS\033[0m: $(trace)" || (grep -sqF -- "Test FAIL" $(trace)/trace_test.log && echo -e "\033[0;31mFAIL\033[0m: $(trace)" || (grep -sqF -- "Test TIMEOUT" $(trace)/trace_test.log && echo -e "\033[0;31mTIMEOUT\033[0m: $(trace)" || echo -e "\033[0;33mINCOMPLETE\033[0m: $(trace)"))) || echo -e "NOTRUN: $(trace)" ;)

kill:
	@echo "Kill regression: $(CHECK_OUT_DIR)" && $(CHECK_OUT_DIR)/kill.sh

clean:
	rm -rf regression_*

help:
	@echo "Running NVDLA-AWS-FPGA trace test regression"
	@echo ""
	@echo "Examples:"
	@echo "    make LSF_CMD='<your-lsf-command>' all # compile design and running regression nv_small_sanity"
	@echo "    make LSF_CMD='<your-lsf-command>' run # running regression nv_small_sanity"
	@echo "    make check                            # check last regression status"
	@echo "    make kill                             # kill last regression lsf jobs"
	@echo "    make AWS_FPGA=1 all                   # compile design and running regression with AWS FPGA  nv_small_sanity"
	@echo ""
	@echo "Options:"
	@echo "    LSF_CMD=<your-lsf-cmd>                # Specify the lsf command"
	@echo "                                          # Default: empty, meaning all the tests will be running in local host sequentially"
	@echo "    NVDLA_HW_ROOT=<nvdla-hw-root>         # Specify NVDLA HW repository location"
	@echo "                                          # Default: ../../../../../../hw"
	@echo "    NVDLA_HW_PROJECT=<nvdla-hw-root>      # Specify NVDLA HW project"
	@echo "                                          # Default: nv_small"
	@echo "    NVDLA_HW_TRACE_LIST=<testlist>        # Specify the testlist to run"
	@echo "                                          # Default: nv_small_sanity"
	@echo "    CHECK_OUT_DIR=<dir>                   # Specify regression directory that you want to check status"
	@echo "    RUN_OUT_DIR=<dir>                     # Specify regression directory that you want to run"
	@echo "                                          # Default: the latest regression run directory"
