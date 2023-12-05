MAKEFILE_DIR = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CURRENT_DIR = $(shell pwd)
PROJECT_DIR = $(MAKEFILE_DIR:$(CURRENT_DIR)/%=%)

HDL = ghdl
FLAGS = --std=08 -fsynopsys
WORK_DIR = $(PROJECT_DIR)/build

PACKAGES_SRC = functions.vhd block_memory.vhd jenkins_final.vhd jenkins_mix.vhd jenkins_hash.vhd
PACKAGES_DIR_SRC = $(addprefix $(PROJECT_DIR)/../comp/, $(PACKAGES_SRC))
CIRCUIT_SRC = $(PROJECT_DIR)/../filter_ent.vhd $(PROJECT_DIR)/../filter.vhd
TESTBENCH_SRC = $(PROJECT_DIR)/latency_tb.vhd
TESTBENCH_UNIT = latency_tb

ALL_SRC = $(CIRCUIT_SRC) $(TESTBENCH_SRC)

.PHONY: all compile elaborate simulate run clean

all: compile elaborate run
simulate: compile elaborate

compile:
	@mkdir -p $(WORK_DIR)
	$(HDL) -a $(FLAGS) --workdir=$(WORK_DIR) $(PACKAGES_DIR_SRC)
	$(HDL) -a $(FLAGS) --workdir=$(WORK_DIR) $(ALL_SRC)

elaborate:
	$(HDL) -e $(FLAGS) --workdir=$(WORK_DIR) $(TESTBENCH_UNIT)

run:
	$(HDL) -r $(FLAGS) --workdir=$(WORK_DIR) $(TESTBENCH_UNIT) | grep -v "There is an 'U'|'X'|'W'|'Z'|"

clean:
	$(HDL) --clean --workdir=$(WORK_DIR)
	rm -rf $(WORK_DIR)
