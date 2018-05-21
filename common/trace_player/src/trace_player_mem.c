// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: trace_player_mem.c

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include "trace_player_mem.h"
#include "trace_player_utils.h"
#include "trace_player_impl.h"

#define TRACE_PLAYER_MEM_CHAR2UINT64(array, index) \
    (((uint64_t)(array[index])) \
     | (((uint64_t)(array[index+1]))<<8) \
     | (((uint64_t)(array[index+2]))<<16) \
     | (((uint64_t)(array[index+3]))<<24) \
     | (((uint64_t)(array[index+4]))<<32) \
     | (((uint64_t)(array[index+5]))<<40) \
     | (((uint64_t)(array[index+6]))<<48) \
     | (((uint64_t)(array[index+7]))<<56))
#define TRACE_PLAYER_MEM_CHAR2UINT32(array, index) \
    (((uint32_t)(array[index])) \
     | (((uint32_t)(array[index+1]))<<8) \
     | (((uint32_t)(array[index+2]))<<16) \
     | (((uint32_t)(array[index+3]))<<24))
#define TRACE_PLAYER_MEM_CHAR2UINT16(array, index) \
    (((uint16_t)(array[index])) \
     | (((uint16_t)(array[index+1]))<<8))

typedef enum {RANDOM, ALL_ZERO, ONES, X, AFIVE, FIVEA, ADDR} MEM_PATTERN_E;

static int skip_mem_init = 0;
static int dump_mem_enable = 1;
static int mem_dump_index = 0;

static int trace_player_mem_read64_check(const char *mem_type, uint64_t offset, uint64_t golden_val, uint64_t *rdata)
{
    int rc = 0;
    mem_read64(mem_type, offset, rdata);
    if (*rdata != golden_val) {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_READ64_CHECK: ERROR! addr=0x%lx, exp=0x%lx, act=0x%lx\n", offset, golden_val, *rdata));
        rc = 1;
    }
    return rc;
}

static int trace_player_mem_read32_check(const char *mem_type, uint64_t offset, uint32_t golden_val, uint32_t *rdata)
{
    int rc = 0;
    mem_read32(mem_type, offset, rdata);
    if (*rdata != golden_val) {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_READ32_CHECK: ERROR! addr=0x%lx, exp=0x%x, act=0x%x\n", offset, golden_val, *rdata));
        rc = 1;
    }
    return rc;
}

static int trace_player_mem_read16_check(const char *mem_type, uint64_t offset, uint16_t golden_val, uint16_t *rdata)
{
    int rc = 0;
    mem_read16(mem_type, offset, rdata);
    if (*rdata != golden_val) {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_READ16_CHECK: ERROR! addr=0x%lx, exp=0x%x, act=0x%x\n", offset, golden_val, *rdata));
        rc = 1;
    }
    return rc;
}

static int trace_player_mem_read8_check(const char *mem_type, uint64_t offset, uint8_t golden_val, uint8_t *rdata)
{
    int rc = 0;
    mem_read8(mem_type, offset, rdata);
    if (*rdata != golden_val) {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_READ8_CHECK: ERROR! addr=0x%lx, exp=0x%x, act=0x%x\n", offset, golden_val, *rdata));
        rc = 1;
    }
    return rc;
}

static int trace_player_mem_string_trim(char *str)
{
    char *tmp = str;
    int len = strlen(tmp);

    /* strip tail spaces, '}', and ',' */
    while(isspace((unsigned char)tmp[len-1]) 
            || tmp[len-1] == EOF
            || tmp[len-1] == '\n'
            || tmp[len-1] == ','
            || tmp[len-1] == '}') {
        tmp[--len] = 0;
    }
   
    /* strip front spaces and '{' */
    while(*tmp && (isspace((unsigned char)*tmp) || *tmp == '{')) {
        tmp++;
        len--;
    }

    /* update the original pointer */
    memmove(str, tmp, len+1);
    return len;
}

static char* trace_player_mem_string_trimh_space(char *str)
{
    char *tmp = str;

    while(*tmp && isspace((unsigned char)*tmp)) {
        tmp++;
    }

    return tmp;
}

static int trace_player_mem_parse_line(char *line, uint64_t *p_offset, uint32_t *p_size, unsigned char **p_payload)
{
    int rc = 0;
    
    char *offset_str;
    char *size_str;
    char *payload_str;
    static long int last_size = 0;
    char *tmp;

    // skip comments
    if (line[0] == '#') {
        return 1;
    }
    // trim line
    trace_player_mem_string_trim(line);
    //DEBUG_PRINT(("MEM_PARSER: parse line after trim: %s\n", line));
    // 1st section: offset
    offset_str = strtok(line, ","); 
    if (offset_str == NULL) {
        DEBUG_PRINT(("MEM_PARSE: WARNING! unable to extract offset!\n"));
        return 1;
    }
    // 2nd section: size
    size_str = strtok(NULL, ","); 
    if (size_str == NULL) {
        DEBUG_PRINT(("MEM_PARSE: WARNING! unable to extract size!\n"));
        return 1;
    }
    // 3rd section: payload
    payload_str = strtok(NULL, ","); 
    if (payload_str == NULL) {
        DEBUG_PRINT(("MEM_PARSE: WARNING! unable to extract payload!\n"));
        return 1;
    }

    // parse offset
    tmp = strtok(offset_str, ":");
    if (strcmp(tmp, "offset") != 0) {
        DEBUG_PRINT(("MEM_PARSE: ERROR! offset part (%s) must start with 'offset'!\n", tmp));
        assert(0);
        return 1;
    }
    tmp = strtok(NULL, ":");
    *p_offset = strtol(tmp, NULL, 0);

    // parse size
    tmp = strtok(size_str, ":");
    if (strcmp(trace_player_mem_string_trimh_space(tmp), "size") != 0) {
        DEBUG_PRINT(("MEM_PARSE: ERROR! size part (%s) must start with 'size'!\n", tmp));
        assert(0);
        return 1;
    }
    tmp = strtok(NULL, ":");
    *p_size = strtol(tmp, NULL, 0);

    // parser payload
    tmp = strtok(payload_str, ":");
    if (strcmp(trace_player_mem_string_trimh_space(tmp), "payload") != 0) {
        DEBUG_PRINT(("MEM_PARSE: ERROR! payload part (%s) must start with 'payload'!\n", tmp));
        assert(0);
        return 1;
    }
    tmp = strtok(NULL, ":");
    if (*p_payload == NULL) {
        *p_payload = malloc(*p_size);
        last_size = *p_size;
    } else if (*p_size > last_size) {
        *p_payload = realloc(*p_payload, *p_size);
        last_size = *p_size;
    }
    memset(*p_payload, 0, *p_size);
    int i = 0;
    char *payload_s = strtok(tmp, " ");
    while (payload_s != NULL && i < *p_size) {
        (*p_payload)[i++] = strtol(payload_s, NULL, 0);
        payload_s = strtok(NULL, " ");
    }

    return rc;
}

static uint8_t trace_player_mem_gen_pattern8(MEM_PATTERN_E pattern_e, uint64_t addr)
{
    uint8_t data;
    switch (pattern_e) {
        case RANDOM:
            data = rand()&0xFF;
            break;
        case ALL_ZERO:
            data = 0;
            break;
        case ONES:
            data = 0xFF;
            break;
        case AFIVE:
            data = 0xA5;
            break;
        case FIVEA:
            data = 0x5A;
            break;
        case ADDR:
            data = addr&0xFF;
            break;
        default:
            data = 0;
    }
    return data;
}

static uint16_t trace_player_mem_gen_pattern16(MEM_PATTERN_E pattern_e, uint64_t addr)
{
    uint16_t data;
    switch (pattern_e) {
        case RANDOM:
            data = rand()&0xFFFF;
            break;
        case ALL_ZERO:
            data = 0;
            break;
        case ONES:
            data = 0xFFFF;
            break;
        case AFIVE:
            data = 0xA5A5;
            break;
        case FIVEA:
            data = 0x5A5A;
            break;
        case ADDR:
            data = (((addr+1)&0xFF)<<8)+(addr&0xFF);
            break;
        default:
            data = 0;
    }
    return data;
}

static uint32_t trace_player_mem_gen_pattern32(MEM_PATTERN_E pattern_e, uint64_t addr)
{
    uint32_t data;
    switch (pattern_e) {
        case RANDOM:
            data = ((((uint32_t)rand())&0xFFFF)<<16)+(((uint32_t)rand())&0xFFFF);
            break;
        case ALL_ZERO:
            data = 0;
            break;
        case ONES:
            data = 0xFFFFFFFF;
            break;
        case AFIVE:
            data = 0xA5A5A5A5;
            break;
        case FIVEA:
            data = 0x5A5A5A5A;
            break;
        case ADDR:
            data = (((addr+3)&0xFF)<<24)+(((addr+2)&0xFF)<<16)+(((addr+1)&0xFF)<<8)+(addr&0xFF);
            break;
        default:
            data = 0;
    }
    return data;
}

static uint64_t trace_player_mem_gen_pattern64(MEM_PATTERN_E pattern_e, uint64_t addr)
{
    uint64_t data;
    switch (pattern_e) {
        case RANDOM:
            data = ((((uint64_t)rand())&0xFFFF)<<48)+((((uint64_t)rand())&0xFFFF)<<32)+((((uint64_t)rand())&0xFFFF)<<16)+(((uint64_t)rand())&0xFFFF);
            break;
        case ALL_ZERO:
            data = 0;
            break;
        case ONES:
            data = 0xFFFFFFFFFFFFFFFF;
            break;
        case AFIVE:
            data = 0xA5A5A5A5A5A5A5A5;
            break;
        case FIVEA:
            data = 0x5A5A5A5A5A5A5A5A;
            break;
        case ADDR:
            data = (((addr+7)&0xFF)<<56)+(((addr+6)&0xFF)<<48)+(((addr+5)&0xFF)<<40)+(((addr+4)&0xFF)<<32)+(((addr+3)&0xFF)<<24)+(((addr+2)&0xFF)<<16)+(((addr+1)&0xFF)<<8)+(addr&0xFF);
            break;
        default:
            data = 0;
    }
    return data;
}

static uint32_t trace_player_mem_calc_crc(const char* mem_type, uint64_t base, uint32_t len)
{
    static const uint32_t crc32_table[] = {0x00000000,0x77073096,0xee0e612c,0x990951ba,
                                           0x076dc419,0x706af48f,0xe963a535,0x9e6495a3,
                                           0x0edb8832,0x79dcb8a4,0xe0d5e91e,0x97d2d988,
                                           0x09b64c2b,0x7eb17cbd,0xe7b82d07,0x90bf1d91,
                                           0x1db71064,0x6ab020f2,0xf3b97148,0x84be41de,
                                           0x1adad47d,0x6ddde4eb,0xf4d4b551,0x83d385c7,
                                           0x136c9856,0x646ba8c0,0xfd62f97a,0x8a65c9ec,
                                           0x14015c4f,0x63066cd9,0xfa0f3d63,0x8d080df5,
                                           0x3b6e20c8,0x4c69105e,0xd56041e4,0xa2677172,
                                           0x3c03e4d1,0x4b04d447,0xd20d85fd,0xa50ab56b,
                                           0x35b5a8fa,0x42b2986c,0xdbbbc9d6,0xacbcf940,
                                           0x32d86ce3,0x45df5c75,0xdcd60dcf,0xabd13d59,
                                           0x26d930ac,0x51de003a,0xc8d75180,0xbfd06116,
                                           0x21b4f4b5,0x56b3c423,0xcfba9599,0xb8bda50f,
                                           0x2802b89e,0x5f058808,0xc60cd9b2,0xb10be924,
                                           0x2f6f7c87,0x58684c11,0xc1611dab,0xb6662d3d,
                                           0x76dc4190,0x01db7106,0x98d220bc,0xefd5102a,
                                           0x71b18589,0x06b6b51f,0x9fbfe4a5,0xe8b8d433,
                                           0x7807c9a2,0x0f00f934,0x9609a88e,0xe10e9818,
                                           0x7f6a0dbb,0x086d3d2d,0x91646c97,0xe6635c01,
                                           0x6b6b51f4,0x1c6c6162,0x856530d8,0xf262004e,
                                           0x6c0695ed,0x1b01a57b,0x8208f4c1,0xf50fc457,
                                           0x65b0d9c6,0x12b7e950,0x8bbeb8ea,0xfcb9887c,
                                           0x62dd1ddf,0x15da2d49,0x8cd37cf3,0xfbd44c65,
                                           0x4db26158,0x3ab551ce,0xa3bc0074,0xd4bb30e2,
                                           0x4adfa541,0x3dd895d7,0xa4d1c46d,0xd3d6f4fb,
                                           0x4369e96a,0x346ed9fc,0xad678846,0xda60b8d0,
                                           0x44042d73,0x33031de5,0xaa0a4c5f,0xdd0d7cc9,
                                           0x5005713c,0x270241aa,0xbe0b1010,0xc90c2086,
                                           0x5768b525,0x206f85b3,0xb966d409,0xce61e49f,
                                           0x5edef90e,0x29d9c998,0xb0d09822,0xc7d7a8b4,
                                           0x59b33d17,0x2eb40d81,0xb7bd5c3b,0xc0ba6cad,
                                           0xedb88320,0x9abfb3b6,0x03b6e20c,0x74b1d29a,
                                           0xead54739,0x9dd277af,0x04db2615,0x73dc1683,
                                           0xe3630b12,0x94643b84,0x0d6d6a3e,0x7a6a5aa8,
                                           0xe40ecf0b,0x9309ff9d,0x0a00ae27,0x7d079eb1,
                                           0xf00f9344,0x8708a3d2,0x1e01f268,0x6906c2fe,
                                           0xf762575d,0x806567cb,0x196c3671,0x6e6b06e7,
                                           0xfed41b76,0x89d32be0,0x10da7a5a,0x67dd4acc,
                                           0xf9b9df6f,0x8ebeeff9,0x17b7be43,0x60b08ed5,
                                           0xd6d6a3e8,0xa1d1937e,0x38d8c2c4,0x4fdff252,
                                           0xd1bb67f1,0xa6bc5767,0x3fb506dd,0x48b2364b,
                                           0xd80d2bda,0xaf0a1b4c,0x36034af6,0x41047a60,
                                           0xdf60efc3,0xa867df55,0x316e8eef,0x4669be79,
                                           0xcb61b38c,0xbc66831a,0x256fd2a0,0x5268e236,
                                           0xcc0c7795,0xbb0b4703,0x220216b9,0x5505262f,
                                           0xc5ba3bbe,0xb2bd0b28,0x2bb45a92,0x5cb36a04,
                                           0xc2d7ffa7,0xb5d0cf31,0x2cd99e8b,0x5bdeae1d,
                                           0x9b64c2b0,0xec63f226,0x756aa39c,0x026d930a,
                                           0x9c0906a9,0xeb0e363f,0x72076785,0x05005713,
                                           0x95bf4a82,0xe2b87a14,0x7bb12bae,0x0cb61b38,
                                           0x92d28e9b,0xe5d5be0d,0x7cdcefb7,0x0bdbdf21,
                                           0x86d3d2d4,0xf1d4e242,0x68ddb3f8,0x1fda836e,
                                           0x81be16cd,0xf6b9265b,0x6fb077e1,0x18b74777,
                                           0x88085ae6,0xff0f6a70,0x66063bca,0x11010b5c,
                                           0x8f659eff,0xf862ae69,0x616bffd3,0x166ccf45,
                                           0xa00ae278,0xd70dd2ee,0x4e048354,0x3903b3c2,
                                           0xa7672661,0xd06016f7,0x4969474d,0x3e6e77db,
                                           0xaed16a4a,0xd9d65adc,0x40df0b66,0x37d83bf0,
                                           0xa9bcae53,0xdebb9ec5,0x47b2cf7f,0x30b5ffe9,
                                           0xbdbdf21c,0xcabac28a,0x53b39330,0x24b4a3a6,
                                           0xbad03605,0xcdd70693,0x54de5729,0x23d967bf,
                                           0xb3667a2e,0xc4614ab8,0x5d681b02,0x2a6f2b94,
                                           0xb40bbe37,0xc30c8ea1,0x5a05df1b,0x2d02ef8d};

    DEBUG_PRINT(("TRACE_PLAYER_MEM_CALC_CRC: base=0x%lx, len=0x%x\n", base, len));
    uint32_t result = 0xFFFFFFFF;
    
    assert(base%4==0 && len%4==0);

    FILE *wstream;
    int dump_nbytes=0;
    if (dump_mem_enable) {
        char file_path[256];
        sprintf(file_path, "trace_player_mem_dump_%d_base_0x%lx_size_0x%x.dat", mem_dump_index++, base, len);
        wstream = fopen(file_path, "w");
    }
    
    uint32_t rdata;
    int i;
    while (len >= 4) {
        mem_read32(mem_type, base, &rdata);
        for (i=0; i<4; i++) {
            uint8_t b = (rdata>>(i*8)) & 0xFF;
            result = (result>>8) ^ crc32_table[(result&0xFF)^b];
        }
        if (dump_mem_enable) {
            if (dump_nbytes == 0) {
                fprintf(wstream, "{offset:0x%lx, size:32, payload:", base);
            }
            fprintf(wstream, "0x%x 0x%x 0x%x 0x%x", rdata&0xFF, (rdata>>8)&0xFF, (rdata>>16)&0xFF, (rdata>>24)&0xFF);
            dump_nbytes += 4;
            if (dump_nbytes == 32) {
                fprintf(wstream, "},\n");
                dump_nbytes = 0;
            } else {
                fprintf(wstream, " ");
            }
        }
        base += 4;
        len -= 4;
    }
    
    if (dump_mem_enable) {
        fclose(wstream);
    }
        
    return ~result;
}

void trace_player_mem_set_skip_mem_init(int val)
{
    skip_mem_init = val;
}

void trace_player_mem_set_dump_mem_enable(int val)
{
    dump_mem_enable = val;
}

int trace_player_mem_load(const char *mem_type, uint64_t base, const char *file_path)
{
    DEBUG_PRINT(("MEM_LOAD: mem_type=%s, base=0x%lx, file_path=%s\n", mem_type, base, file_path));
    int rc = 0; 
    FILE *stream;
    stream = fopen(file_path, "r");
  
    if (stream == NULL) {
        DEBUG_PRINT(("MEM_LOAD: ERROR! open file %s failed!\n", file_path));
        assert(0);
        return 1;
    }

    int max_len = 256;
    char buf[max_len];
    uint64_t offset;
    uint32_t size;
    unsigned char *payload = NULL;
    while(fgets(buf, max_len, stream)) {
        char *line = strdup(buf);
        // parse one line to get payload
        //DEBUG_PRINT(("MEM_LOAD: parser line: %s\n", line));
        if (0 != trace_player_mem_parse_line(line, &offset, &size, &payload)) {
            continue;
        }
        // write payload to memory
        offset+=base;
        int num_written = 0;
        while (num_written < size) {
            if ((size-num_written >= 8) && ((offset+num_written)%8==0)) {
                mem_write64(mem_type, offset+num_written, TRACE_PLAYER_MEM_CHAR2UINT64(payload, num_written));
                num_written += 8;
            } else if ((size-num_written >= 4) && ((offset+num_written))%4==0) {
                mem_write32(mem_type, offset+num_written, TRACE_PLAYER_MEM_CHAR2UINT32(payload, num_written));
                num_written += 4;
            } else if ((size-num_written >= 2) && ((offset+num_written))%2==0) {
                mem_write16(mem_type, offset+num_written, TRACE_PLAYER_MEM_CHAR2UINT16(payload, num_written));
                num_written += 2;
            } else {
                mem_write8(mem_type, offset+num_written, payload[num_written]);
                num_written += 1;
            }
        }
        free(line);
    }
    if (payload) {
        free(payload);
    }
    fclose(stream);

    return rc;
}

int trace_player_mem_init_pattern(const char *mem_type, uint64_t base, uint32_t size, const char *pattern)
{
    DEBUG_PRINT(("MEM_INIT_PATTERN: mem_type=%s, base=0x%lx, size=0x%x, pattern=%s\n", mem_type, base, size, pattern));
    
    if (skip_mem_init) {
        DEBUG_PRINT(("MEM_INIT_PATTERN: WARNING! skip mem_init_pattern!\n"));
        return 0;
    }

    MEM_PATTERN_E pattern_e;
    if (strcmp(pattern, "RANDOM") == 0) {
        pattern_e = RANDOM;
    } else if (strcmp(pattern, "ALL_ZERO") == 0) {
        pattern_e = ALL_ZERO;
    } else if (strcmp(pattern, "ONES") == 0) {
        pattern_e = ONES;
    } else if (strcmp(pattern, "X") == 0) {
        pattern_e = X;
    } else if (strcmp(pattern, "AFIVE") == 0) {
        pattern_e = AFIVE;
    } else if (strcmp(pattern, "FIVEA") == 0) {
        pattern_e = FIVEA;
    } else if (strcmp(pattern, "ADDR") == 0) {
        pattern_e = ADDR;
    }

    // write payload to memory
    int num_written = 0;
    while (num_written < size) {
        if ((size-num_written >= 8) && ((base+num_written)%8==0)) {
            mem_write64(mem_type, base+num_written, trace_player_mem_gen_pattern64(pattern_e, base+num_written));
            num_written += 8;
        } else if ((size-num_written >= 4) && ((base+num_written))%4==0) {
            mem_write32(mem_type, base+num_written, trace_player_mem_gen_pattern32(pattern_e, base+num_written));
            num_written += 4;
        } else if ((size-num_written >= 2) && ((base+num_written))%2==0) {
            mem_write16(mem_type, base+num_written, trace_player_mem_gen_pattern16(pattern_e, base+num_written));
            num_written += 2;
        } else {
            mem_write8(mem_type, base+num_written, trace_player_mem_gen_pattern8(pattern_e, base+num_written));
            num_written += 1;
        }
    }
    return 0;
}

int trace_player_mem_init_file(const char *mem_type, uint64_t base, const char *file_path)
{
    DEBUG_PRINT(("MEM_INIT_FILE: mem_type=%s, base=0x%lx, file_path=%s\n", mem_type, base, file_path));
    return trace_player_mem_load(mem_type, base, file_path);
}

int trace_player_mem_check_crc(const char *mem_type, uint64_t base, uint32_t size, uint32_t golden_crc)
{
    DEBUG_PRINT(("TRACE_PLAYER_MEM_CHECK_CRC: mem_type=%s, base=0x%lx, size=%d, golden_crc=0x%x\n", mem_type, base, size, golden_crc));
    int rc = 0;

    uint32_t crc_calc = trace_player_mem_calc_crc(mem_type, base, size);
    if (crc_calc != golden_crc) {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_CHECK_CRC: ERROR! expect_crc=0x%x, act_crc=0x%x\n", golden_crc, crc_calc));
        rc = 1;
    } else {
        DEBUG_PRINT(("TRACE_PLAYER_MEM_CHECK_CRC: PASS! expect_crc=0x%x, act_crc=0x%x\n", golden_crc, crc_calc));
    }

    return rc;
}

int trace_player_mem_check_file(const char *mem_type, uint64_t base, uint32_t size, const char *file_path)
{
    DEBUG_PRINT(("CHECK_FILE: mem_type=%s, base=0x%lx, size=%d, file_path=%s\n", mem_type, base, size, file_path));
    int rc = 0; 
    FILE *stream;
    stream = fopen(file_path, "r");
  
    if (stream == NULL) {
        DEBUG_PRINT(("CHECK_FILE: ERROR! open file %s failed!\n", file_path));
        assert(0);
        return 1;
    }
    
    FILE *wstream;
    if (dump_mem_enable) {
        char file_path[256];
        sprintf(file_path, "trace_player_mem_dump_%d_base_0x%lx_size_0x%x.dat", mem_dump_index++, base, size);
        wstream = fopen(file_path, "w");
    }

    int max_len = 256;
    char buf[max_len];
    uint64_t offset;
    uint32_t size_f;
    unsigned char *payload = NULL;
    int num_compared = 0;
    while(fgets(buf, max_len, stream)) {
        char *line = strdup(buf);
        // parse one line to get payload
        if (0 != trace_player_mem_parse_line(line, &offset, &size_f, &payload)) {
            continue;
        }
        //dump mem head
        if (dump_mem_enable) {
            fprintf(wstream, "{offset:0x%lx, size:%d, payload:", offset, size_f);
        }
        // compare memory
        offset+=base;
        int num_read = 0;
        while (num_read < size_f) {
            if ((size_f-num_read >= 8) && ((offset+num_read)%8==0)) {
                uint64_t rdata;
                if (0 != trace_player_mem_read64_check(mem_type, offset+num_read, TRACE_PLAYER_MEM_CHAR2UINT64(payload, num_read), &rdata)) {
                    rc = 1;
                }
                num_read += 8;
                if (dump_mem_enable) {
                    fprintf(wstream, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x", (uint8_t)(rdata&0xFF), (uint8_t)((rdata>>8)&0xFF), (uint8_t)((rdata>>16)&0xFF), (uint8_t)((rdata>>24)&0xFF), (uint8_t)((rdata>>32)&0xFF), (uint8_t)((rdata>>40)&0xFF), (uint8_t)((rdata>>48)&0xFF), (uint8_t)((rdata>>56)&0xFF));
                }
            } else if ((size_f-num_read >= 4) && ((offset+num_read)%4==0)) {
                uint32_t rdata;
                if (0 != trace_player_mem_read32_check(mem_type, offset+num_read, TRACE_PLAYER_MEM_CHAR2UINT32(payload, num_read), &rdata)) {
                    rc = 1;
                }
                num_read += 4;
                if (dump_mem_enable) {
                    fprintf(wstream, "0x%x 0x%x 0x%x 0x%x", rdata&0xFF, (rdata>>8)&0xFF, (rdata>>16)&0xFF, (rdata>>24)&0xFF);
                }
            } else if ((size_f-num_read >= 2) && ((offset+num_read)%2==0)) {
                uint16_t rdata;
                if (0 != trace_player_mem_read16_check(mem_type, offset+num_read, TRACE_PLAYER_MEM_CHAR2UINT16(payload, num_read), &rdata)) {
                    rc = 1;
                }
                num_read += 2;
                if (dump_mem_enable) {
                    fprintf(wstream, "0x%x 0x%x", rdata&0xFF, (rdata>>8)&0xFF);
                }
            } else {
                uint8_t rdata;
                if (0 != trace_player_mem_read8_check(mem_type, offset+num_read, payload[num_read], &rdata)) {
                    rc = 1;
                }
                num_read += 1;
                if (dump_mem_enable) {
                    fprintf(wstream, "0x%x", rdata&0xFF);
                }
            }
            if (dump_mem_enable) {
                if (num_read == size_f) {
                    fprintf(wstream, "},\n");
                } else {
                    fprintf(wstream, " ");
                }
            }
        }
        num_compared+=size_f;
        free(line);
    }
    if (payload) {
        free(payload);
    }
    fclose(stream);
    if (dump_mem_enable) {
        fclose(wstream);
    }

    return rc;
}
