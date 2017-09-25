# android-voip
Probando generar una librería con voip 
ref https://trac.pjsip.org/repos/wiki/Getting-Started/Android

[Download_NDK](http://pnsurez.blogspot.com.ar/2015/07/download-android-ndk-tools.html)

[Download_Openssl](https://www.openssl.org/source/openssl-1.0.2a.tar.gz)

1 intento:
Usando android ndk10d, generando .so con armeabi-v7a

Pasos seguidos:
- svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
- cd trunk/
- Crear archivo config_site.h en /pjlib/include/pj que tenga:
```
/*Activate Android specific settings in the 'config_site_sample.h'*/

#define PJ_CONFIG_ANDROID 1
#define PJ_HAS_SSL_SOCK 1
#include <pj/config_site_sample.h>
```
- export ANDROID_NDK_ROOT=/path_to_android_ndk10d_dir
- TARGET_ABI=armeabi-v7a APP_PLATFORM=android-19 ./configure-android --use-ndk-cflags --with-ssl=/dir/to/openssl-1.0.1g
- make dep && make clean && make

Para generar openssl:
Ref: https://stackoverflow.com/a/18577811
- Ejecutar en openssl-1.0.2a/
```
tar xzvf ~/Downloads/openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
export NDK=~/android-ndk-r13b
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-16 --toolchain=arm-linux-androideabi-4.0 --install-dir=`pwd`/android-toolchain-arm
export TOOLCHAIN_PATH=`pwd`/android-toolchain-arm/bin
export TOOL=arm-linux-androideabi
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
export ARCH_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
export ARCH_LINK="-march=armv7-a -Wl,--fix-cortex-a8"
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=-D__ANDROID_API__=$API
export LDFLAGS=" ${ARCH_LINK} "
```
- ./Configure android-armv7
- PATH=$TOOLCHAIN_PATH:$PATH make

