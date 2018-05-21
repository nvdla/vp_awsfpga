// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_utils.h

#ifndef TRACE_PLAYER_UTILS_H
#define TRACE_PLAYER_UTILS_H

#include <stdio.h>

#ifdef DEBUG
  #define DEBUG_PRINT(a) printf a
#else
  #define DEBUG_PRINT(a) (void)0
#endif

#endif
