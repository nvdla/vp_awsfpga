// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cosim_top.h

#ifndef _COSIM_TOP_H_
#define _COSIM_TOP_H_

#include <systemc.h>
#include "shm_lib/simdb.hpp"
#include "shm_lib/shm_defs.h"

#ifndef SC_INCLUDE_DYNAMIC_PROCESSES
#define SC_INCLUDE_DYNAMIC_PROCESSES
#endif
#define SIMDB_BLOCK_SIZE  1024
#define SIMDB_BLOCK_COUNT 1024

using namespace std;

class cosim_top : public sc_core::sc_module{
public:
    SC_HAS_PROCESS(cosim_top);
    cosim_top( sc_core::sc_module_name name = "cosim_top");
    ~cosim_top();

private:
	uint32_t poll_time_ns;

    simdb *apb_ipc_db;
    simdb *irq_ipc_db;
    simdb *ram_ipc_db;

    char *apb_ipc_db_nm;
    char *irq_ipc_db_nm;
    char *ram_ipc_db_nm;

    void apb_ipc_channel();
    void irq_ipc_channel();
    void ram_ipc_channel();
};

#endif
