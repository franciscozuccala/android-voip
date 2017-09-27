#!/usr/bin/env bash

echo "Started pjsip configuration script"

echo -n "Insert Ndk path (Use ndk 13b): "
read android_ndk
echo -n "Insert target abi (Eg: armeabi-v7a, x86): "
read target_abi
echo -n "Insert android api (Eg: android-19): "
read android_api
echo -n "With openssl? (y/n): "
read has_openssl

ANDROID_NDK=$android_ndk

COMMAND="TARGET_ABI=$target_abi APP_PLATFORM=$android_api ./configure-android --use-ndk-cflags"

if [ $has_openssl = "y" ]; then
  echo -n "Openssl path (version openssl-1.1.0c): ";
  read openssl_path
  COMMAND="$COMMAND --with-ssl=$openssl_path"
fi

if [ ! -d "/trunk" ]; then
  svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
fi

cd trunk/

export ANDROID_NDK_ROOT=$ANDROID_NDK
echo "COMMAND INFO: $COMMAND"
if eval $COMMAND; then
  cd pjlib/include/pj

  touch config_site.h
  > config_site.h
  echo "/*Activate Android specific settings in the 'config_site_sample.h'*/

  #define PJ_CONFIG_ANDROID 1
  #define PJ_HAS_SSL_SOCK 1
  #include <pj/config_site_sample.h>" >> config_site.h

  cd ../../..

  if make dep && make clean && make; then
    cd pjsip-apps/src/swig && make

    cd ../../../..
    echo "Configuration script finished correctly"
  else
    echo "An error ocurred when making pjsip"
  fi
else
  echo "An error ocurred when configurating pjsip"
fi
