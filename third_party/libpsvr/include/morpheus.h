#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define PSVR_INTERFACE_HID_CONTROL 0

typedef enum psvr_request_id {
    eRID_DeviceInfo = 0x00,
    eRID_HeadsetPower = 0x17,
    eRID_SetMode = 0x1A
} psvr_request_id;

typedef enum psvr_response_type {
    eRT_Info = 0x08
} psvr_response_type;

typedef struct psvr_control_frame_header {
    uint8_t r_id;
} psvr_control_frame_header;

typedef struct psvr_device_info_serial {
    char serialNumber[16];
} psvr_device_info_serial;

typedef struct psvr_device_info_payload {
    psvr_device_info_serial s;
} psvr_device_info_payload;

typedef struct psvr_control_frame_payload {
    psvr_control_frame_header header;
    psvr_device_info_payload dinfo;
} psvr_control_frame_payload;

typedef struct psvr_control_frame {
    psvr_control_frame_payload s;
} psvr_control_frame;

#ifdef __cplusplus
}
#endif
