#pragma once

#include <stdarg.h>
#include <stdint.h>

#include "morpheus.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct psvr_context {
    int placeholder;
} psvr_context;

typedef struct psvr_sensor_frame {
    uint8_t data[128];
} psvr_sensor_frame;

typedef void (*psvr_log)(const char *msg, va_list args);

int psvr_open(psvr_context **ctx);
void psvr_close(psvr_context *ctx);
void psvr_set_log(psvr_log log_fn);
int psvr_send_command_sync(psvr_context *ctx, int request_id, const uint8_t *data, uint32_t size);
int psvr_read_sync_timeout(int interface_type, psvr_context *ctx, uint8_t *data, uint32_t size, uint32_t timeout_ms);
int psvr_read_sensor_sync(psvr_context *ctx, uint8_t *data, uint32_t size);

#ifdef __cplusplus
}
#endif
