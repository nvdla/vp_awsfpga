/*
 * Copyright 2015-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You may
 * not use this file except in compliance with the License. A copy of the
 * License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

// Copyright (c) 2009-2017, NVIDIA CORPORATION. All rights reserved.
// NVIDIA’s contributions are offered under the Amazon Software License


#ifndef VIVADO_SIM
#include "svdpi.h"
#endif

#include "sh_dpi_tasks.h"

void host_memory_putc(uint64_t addr, uint8_t data)
{
  *(uint8_t *)addr = data;
}

//void host_memory_getc(uint64_t addr, uint8_t *data)
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
// Vivado does not support svGetScopeFromName
#ifndef VIVADO_SIM
  svScope scope;
  scope = svGetScopeFromName("tb");
  svSetScope(scope);
#endif

  log_printf("Received interrupt %2d", int_num);
  sv_int_ack(int_num);
  
  cl_int_handler(int_num);

}
