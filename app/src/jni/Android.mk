LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libpjsua
LOCAL_SRC_FILES := libssl.so.1.0.0, libpjsua2.so, libcrypto.so.1.0.0
include $(PREBUILT_SHARED_LIBRARY)

LOCAL_SHARED_LIBRARIES := libpjsua