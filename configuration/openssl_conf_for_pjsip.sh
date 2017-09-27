#!/usr/bin/env bash
echo "Started openssl configuration script"

echo -n "Insert android architecture (armv7a, arm, aarch64, x86, x86_64, mips, mips64): "
read arch
echo -n "Insert android api (Eg: android-19): "
read android_api
echo -n "Ndk path (remember to use ndk 13): "
read ndk_root
echo -n "Openssl path (version openssl-1.1.0c, if it is empty it will be downloaded): "
read openssl_path

check_swig="command -v swig"

if ! eval $check_swig; then
  echo "Installing swig, is required"
  sudo apt-get install swig
fi

ARCH=$arch
ANDROID_API=$android_api
NDK_ROOT=$ndk_root

cd $openssl_path

export NDK=$ndk_root

case $ARCH in
  armv7a)
    $NDK/build/tools/make-standalone-toolchain.sh --platform=$ANDROID_API --toolchain=arm-linux-androideabi-4.9 --install-dir=`pwd`/android-toolchain-armv7
    export TOOLCHAIN_PATH=`pwd`/android-toolchain-armv7/bin
    export TOOL=arm-linux-androideabi
    export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
    export CC=$NDK_TOOLCHAIN_BASENAME-gcc
    export CXX=$NDK_TOOLCHAIN_BASENAME-g++
    export LINK=${CXX}
    export LD=$NDK_TOOLCHAIN_BASENAME-ld
    export AR=$NDK_TOOLCHAIN_BASENAME-ar
    export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
    export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
    export ARCH_FLAGS=
    export ARCH_LINK=
    export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
    export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export LDFLAGS=" ${ARCH_LINK} "
    ./Configure android-armv7 shared --force
  ;;
  x86)
    $NDK/build/tools/make-standalone-toolchain.sh --platform=$ANDROID_API --toolchain=x86-4.9 --install-dir=`pwd`/i686-linux-android
    export TOOLCHAIN_PATH=`pwd`/i686-linux-android/bin
    export TOOL=i686-linux-android
    export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
    export CC=$NDK_TOOLCHAIN_BASENAME-gcc
    export CXX=$NDK_TOOLCHAIN_BASENAME-g++
    export LINK=${CXX}
    export LD=$NDK_TOOLCHAIN_BASENAME-ld
    export AR=$NDK_TOOLCHAIN_BASENAME-ar
    export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
    export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
    export ARCH_FLAGS=
    export ARCH_LINK=
    export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
    export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export LDFLAGS=" ${ARCH_LINK} "
    ./Configure android-x86 shared --force
  ;;
esac
make
mkdir -p lib && cp lib*.a lib/
