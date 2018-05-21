// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: cosim_top.cpp

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <iostream>

#include "cosim_top.h"

enum EVENT_TYPE
{
    EVENT_APB_WR = 0,
    EVENT_RAM_WR,
    EVENT_IRQ_WR,
    EVENT_APB_RD,
    EVENT_RAM_RD,
    EVENT_IRQ_RD,
    EVENT_ST
};

#define SIZE_UINT8  0
#define SIZE_UINT16 1
#define SIZE_UINT32 2
#define SIZE_UINT64 3

#define LOW_32b(a)  ((uint32_t)((uint64_t)(a) & 0xffffffff))
#define HIGH_32b(a) ((uint32_t)(((uint64_t)(a)) >> 32L))

static sc_core::sc_event apb_rd_done_event;
static sc_core::sc_event apb_wr_done_event;
static sc_core::sc_event ram_rd_done_event;
static sc_core::sc_event ram_wr_done_event;
static sc_core::sc_event irq_rd_done_event;
static sc_core::sc_event irq_wr_done_event;
static sc_core::sc_event start_event;

extern "C" {

#include <stdarg.h>
#include "svdpi.h"
extern void sv_int_ack(uint32_t int_num);
extern void sv_printf(char *msg);
void host_memory_putc(uint64_t addr, uint8_t data)
{
  *(uint8_t *)addr = data;
}

uint8_t host_memory_getc(uint64_t addr)
{
  return *(uint8_t *)addr;
}

void log_printf(const char *format, ...)
{
  static char sv_msg_buffer[256];
  va_list args;

  va_start(args, format);
  vsprintf(sv_msg_buffer, format, args);
  sv_printf(sv_msg_buffer);

  va_end(args);
}

void int_handler(uint32_t int_num)
{
  svScope scope;
  scope = svGetScopeFromName("tb");
  svSetScope(scope);

  log_printf("Received interrupt %2d", int_num);
  sv_int_ack(int_num);
}


extern void set_apb_rd(uint64_t addr, uint32_t *data);
extern void set_apb_wr(uint64_t addr, uint32_t  data);
extern void set_irq_rd(uint32_t *data);
extern void set_irq_wr(uint32_t  data);
extern void set_ram_rd(uint64_t addr, uint64_t *data, uint32_t size);
extern void set_ram_wr(uint64_t addr, uint64_t  data, uint32_t size);
extern void set_ev_trigger(uint32_t int_num);
extern uint32_t apb_read_ack();
extern uint64_t ram_read_ack();
extern uint64_t irq_read_ack();

// Called by sv side to notify the DPI process is done
void sv_done_notify(int idx)
{
    switch(idx)
    {
        case EVENT_APB_WR:
            apb_wr_done_event.notify();
            break;
        case EVENT_RAM_WR:
            ram_wr_done_event.notify();
            break;
        case EVENT_IRQ_WR:
            irq_wr_done_event.notify();
            break;
        case EVENT_APB_RD:
            apb_rd_done_event.notify();
            break;
        case EVENT_RAM_RD:
            ram_rd_done_event.notify();
            break;
        case EVENT_IRQ_RD:
            irq_rd_done_event.notify();
            break;
        case EVENT_ST:
            start_event.notify();
            break;
        default:
            cout<< "Error: Invild event index!" << endl;
            sc_stop();
            break;
    }
}

}


cosim_top::cosim_top( sc_core::sc_module_name name)    
        : sc_core::sc_module( name )
{
    poll_time_ns = 1;

    char *cosim_pid = getenv("COSIM_PID_HOST");

    std::stringstream apb_channel_str;
    std::stringstream ram_channel_str;
    std::stringstream irq_channel_str;

    apb_channel_str << "apb_ipc_db_" << cosim_pid;
    irq_channel_str << "irq_ipc_db_" << cosim_pid;
    ram_channel_str << "ram_ipc_db_" << cosim_pid;

    apb_ipc_db_nm = new char [apb_channel_str.str().length()+1];
    strcpy(apb_ipc_db_nm, apb_channel_str.str().c_str());
    irq_ipc_db_nm = new char [irq_channel_str.str().length()+1];
    strcpy(irq_ipc_db_nm, irq_channel_str.str().c_str());
    ram_ipc_db_nm = new char [ram_channel_str.str().length()+1];
    strcpy(ram_ipc_db_nm, ram_channel_str.str().c_str());

    apb_ipc_db = new simdb(const_cast<char *>(apb_channel_str.str().c_str()), SIMDB_BLOCK_SIZE, SIMDB_BLOCK_COUNT);
    irq_ipc_db = new simdb(const_cast<char *>(irq_channel_str.str().c_str()), SIMDB_BLOCK_SIZE, SIMDB_BLOCK_COUNT);
    ram_ipc_db = new simdb(const_cast<char *>(ram_channel_str.str().c_str()), SIMDB_BLOCK_SIZE, SIMDB_BLOCK_COUNT);

    SC_THREAD(apb_ipc_channel);
    SC_THREAD(irq_ipc_channel);
    SC_THREAD(ram_ipc_channel);
}

cosim_top::~cosim_top()
{
    if (apb_ipc_db)
    {
        apb_ipc_db->close();
        delete apb_ipc_db;
    }
    if (irq_ipc_db)
    {
        irq_ipc_db->close();
        delete irq_ipc_db;
    }
    if (ram_ipc_db)
    {
        ram_ipc_db->close();
        delete ram_ipc_db;
    }

    if (apb_ipc_db_nm)
        delete apb_ipc_db_nm;
    if (irq_ipc_db_nm)
        delete irq_ipc_db_nm;
    if (ram_ipc_db_nm)
        delete ram_ipc_db_nm;
}
void cosim_top::apb_ipc_channel()
{
    uint64_t addr = 0;
    uint32_t data = 0xdeadbeef;

    std::stringstream str_wr_up;
    std::stringstream str_wr_dn;
    std::stringstream str_rd_up;
    std::stringstream str_rd_dn;
    str_wr_up << apb_ipc_db_nm << "_wr_up";
    str_wr_dn << apb_ipc_db_nm << "_wr_dn";
    str_rd_up << apb_ipc_db_nm << "_rd_up";
    str_rd_dn << apb_ipc_db_nm << "_rd_dn";

    // Make sure the RTL testbench is ready
    sc_core::wait(start_event);
    while(1)
    {
        wait(poll_time_ns, SC_NS);
        auto tpv_dn = apb_ipc_db->get<struct trans_payload>(str_wr_dn.str());
        auto tpv_up = apb_ipc_db->get<struct trans_payload>(str_wr_up.str());
        if (!tpv_dn.empty()) // handle the write transaction
        {
            tpv_up = apb_ipc_db->get<struct trans_payload>(str_wr_up.str());
            if (!tpv_up.empty())
            {
                cout << name() << "WARNING: The last write stream FIFO is not empty!" << endl;
                apb_ipc_db->del(str_wr_up.str()); // Clear the ack fifo which should be cleared by QEMU side.
            }
            addr = tpv_dn[0].addr;
            data = tpv_dn[0].data;

            svSetScope(svGetScopeFromName("cosim_test"));
            set_apb_wr(addr, data); // call dpi function
            set_ev_trigger(EVENT_APB_WR);

            sc_core::wait(apb_wr_done_event);

            struct trans_payload t;
            t.addr = addr;
            t.data = data;
            std::vector<struct trans_payload> v;
            v.push_back(t);

            apb_ipc_db->del(str_wr_dn.str()); // Clear the write FIFO
            apb_ipc_db->put<struct trans_payload>(str_wr_up.str(), v);
        }

        tpv_dn = apb_ipc_db->get<struct trans_payload>(str_rd_dn.str());
        if (!tpv_dn.empty()) // handle the read transaction
        {
            tpv_up = apb_ipc_db->get<struct trans_payload>(str_rd_up.str());
            if (!tpv_up.empty())
            {
                cout << name() << "WARNING: The last read stream FIFO is not empty!\n";
                apb_ipc_db->del(str_rd_up.str()); // Clear the ack fifo which should be cleared by QEMU side.
            }
            addr = tpv_dn[0].addr;

            svSetScope(svGetScopeFromName("cosim_test"));
            set_apb_rd(addr, &data); // call dpi function
            set_ev_trigger(EVENT_APB_RD);

            sc_core::wait(apb_rd_done_event);

            data = apb_read_ack();

            struct trans_payload t;
            t.addr = addr;
            t.data = data;
            std::vector<struct trans_payload> v;
            v.push_back(t);

            apb_ipc_db->del(str_rd_dn.str()); // Clear the read FIFO
            apb_ipc_db->put<struct trans_payload>(str_rd_up.str(), v);
        }

    }
}
void cosim_top::ram_ipc_channel()
{
    uint64_t addr = 0;
    uint64_t data = 0xdeadbeef;

    std::stringstream str_wr_up;
    std::stringstream str_wr_dn;
    std::stringstream str_rd_up;
    std::stringstream str_rd_dn;
    str_wr_up << ram_ipc_db_nm << "_wr_up";
    str_wr_dn << ram_ipc_db_nm << "_wr_dn";
    str_rd_up << ram_ipc_db_nm << "_rd_up";
    str_rd_dn << ram_ipc_db_nm << "_rd_dn";

    // Make sure the RTL testbench is ready
    sc_core::wait(start_event);
    while(1)
    {
        wait(poll_time_ns, SC_NS);
        auto tpv_dn = ram_ipc_db->get<struct trans_payload>(str_wr_dn.str());
        auto tpv_up = ram_ipc_db->get<struct trans_payload>(str_wr_up.str());
        if (!tpv_dn.empty()) // handle the write transaction
        {
            tpv_up = ram_ipc_db->get<struct trans_payload>(str_wr_up.str());
            if (!tpv_up.empty())
            {
                cout << name() << "WARNING: The last write stream FIFO is not empty!\n";
                ram_ipc_db->del(str_wr_up.str()); // Clear the ack fifo which should be cleared by QEMU side.
            }
            addr = tpv_dn[0].addr;
            data = tpv_dn[0].data;

            svSetScope(svGetScopeFromName("cosim_test"));
            set_ram_wr(addr, data, SIZE_UINT32); // call dpi function
            set_ev_trigger(EVENT_RAM_WR);

            sc_core::wait(ram_wr_done_event);

            struct trans_payload t;
            t.addr = addr;
            t.data = data;
            std::vector<struct trans_payload> v;
            v.push_back(t);

            ram_ipc_db->del(str_wr_dn.str()); // Clear the write FIFO
            ram_ipc_db->put<struct trans_payload>(str_wr_up.str(), v);
        }

        tpv_dn = ram_ipc_db->get<struct trans_payload>(str_rd_dn.str());
        if (!tpv_dn.empty()) // handle the read transaction
        {
            tpv_up = ram_ipc_db->get<struct trans_payload>(str_rd_up.str());
            if (!tpv_up.empty())
            {
                cout << name() << "WARNING: The last read stream FIFO is not empty!\n";
                ram_ipc_db->del(str_rd_up.str()); // Clear the ack fifo which should be cleared by QEMU side.
            }
            addr = tpv_dn[0].addr;
            data = tpv_dn[0].data;

            svSetScope(svGetScopeFromName("cosim_test"));
            set_ram_rd(addr, &data, SIZE_UINT32); // call dpi function
            set_ev_trigger(EVENT_RAM_RD);

            sc_core::wait(ram_rd_done_event);

            data = ram_read_ack();

            struct trans_payload t;
            t.addr = addr;
            t.data = LOW_32b(data);
            std::vector<struct trans_payload> v;
            v.push_back(t);

            ram_ipc_db->del(str_rd_dn.str()); // Clear the read FIFO
            ram_ipc_db->put<struct trans_payload>(str_rd_up.str(), v);
        }

    }
}
void cosim_top::irq_ipc_channel()
{
    uint32_t data = 0;

    // Make sure the RTL testbench is ready
    sc_core::wait(start_event);
    while(1)
    {
        wait(poll_time_ns, SC_NS);
        auto tpv_dn = irq_ipc_db->get<struct irq_trans_payload>("irq_ipc_db_dn");
        auto tpv_up = irq_ipc_db->get<struct irq_trans_payload>("irq_ipc_db_up");

        if (!tpv_up.empty())
        {
            cout << name() << "WARNING: The last INT up stream FIFO is not empty!\n";
            irq_ipc_db->del("irq_ipc_db_up");
        }
        if (!tpv_dn.empty())
        {
            cout << name() << "WARNING: The last INT down stream FIFO is not empty!\n";
            irq_ipc_db->del("irq_ipc_db_dn");
        }

        svSetScope(svGetScopeFromName("cosim_test"));
        set_irq_rd(&data); // call dpi function
        set_ev_trigger(EVENT_IRQ_RD);

        sc_core::wait(irq_rd_done_event);

        data = irq_read_ack();

        if (data != 0)
        {
            struct irq_trans_payload irq_stat;
            irq_stat.value = data;
            std::vector<struct irq_trans_payload> v;
            v.push_back(irq_stat);
            irq_ipc_db->put<struct irq_trans_payload>("irq_ipc_db_up", v);

            while(1)
            {
                tpv_dn = irq_ipc_db->get<struct irq_trans_payload>("irq_ipc_db_dn");
                if(!tpv_dn.empty())
                {
                    svSetScope(svGetScopeFromName("cosim_test"));
                    set_irq_wr(data); // call dpi function
                    set_ev_trigger(EVENT_IRQ_WR);

                    sc_core::wait(irq_wr_done_event);
                    break;
                }
                wait(poll_time_ns, SC_NS);
            }

            irq_ipc_db->del("irq_ipc_db_dn");
        }
    }
}
