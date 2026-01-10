#include "psvr.h"

#include <stdlib.h>
#include <string.h>

static psvr_log g_psvr_log = NULL;

int psvr_open(psvr_context **ctx) {
    if (!ctx) {
        return -1;
    }

    *ctx = (psvr_context *)calloc(1, sizeof(psvr_context));
    if (!*ctx) {
        return -1;
    }

    return 0;
}

void psvr_close(psvr_context *ctx) {
    free(ctx);
}

void psvr_set_log(psvr_log log_fn) {
    g_psvr_log = log_fn;
    (void)g_psvr_log;
}

int psvr_send_command_sync(psvr_context *ctx, int request_id, const uint8_t *data, uint32_t size) {
    (void)ctx;
    (void)request_id;
    (void)data;
    (void)size;

    return 0;
}

int psvr_read_sync_timeout(int interface_type, psvr_context *ctx, uint8_t *data, uint32_t size, uint32_t timeout_ms) {
    (void)interface_type;
    (void)ctx;
    (void)timeout_ms;

    if (data && size > 0) {
        memset(data, 0, size);
    }

    return 0;
}

int psvr_read_sensor_sync(psvr_context *ctx, uint8_t *data, uint32_t size) {
    (void)ctx;

    if (data && size > 0) {
        memset(data, 0, size);
    }

    return 0;
}
