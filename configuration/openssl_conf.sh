#!/usr/bin/env bash

echo "Started openssl configuration script"

echo -n "Insert android architecture (arm, aarch64, x86, x86_64, mips, mips64): "
read arch
echo -n "Insert android api (Eg: android-19): "
read android_api
echo -n "Ndk path (remember to use ndk 13): "
read ndk_root
echo -n "Openssl path (version openssl-1.1.0c, if it is empty it will be downloaded): "
read openssl_path

check_swig = "command -v swig"

if ! eval $check_swig; then
  echo "Installing swig, is required"
  sudo apt-get install swig
fi

export ARCH=$arch
export ANDROID_API=$android_api
export NDK_ROOT=$ndk_root

case $ARCH in
  arm)
    export TOOLCHAIN="arm-linux-androideabi-4.9"
    export OPENSSL_CONFIG_OPTIONS="android-armeabi"
    export TOOL_PREFIX="arm-linux-androideabi-"
    export INSTALL_FOLDER="arch-arm"
    ;;
  aarch64)
    export TOOLCHAIN="aarch64-linux-android-4.9"
    export OPENSSL_CONFIG_OPTIONS="android64-aarch64"
    export TOOL_PREFIX="aarch64-linux-android-"
    export INSTALL_FOLDER="arch-arm64"
    ;;
  x86)
    export TOOLCHAIN="x86-4.9"
    export OPENSSL_CONFIG_OPTIONS="android-x86"
    export TOOL_PREFIX="i686-linux-android-"
    export INSTALL_FOLDER="arch-x86"
    ;;
  x86_64)
    export TOOLCHAIN="x86_64-4.9"
    export OPENSSL_CONFIG_OPTIONS="android64"
    export TOOL_PREFIX="x86_64-linux-android-"
    export INSTALL_FOLDER="arch-x86_64"
    ;;
  mips)
    export TOOLCHAIN="mipsel-linux-android-4.9"
    export OPENSSL_CONFIG_OPTIONS="android-mips"
    export TOOL_PREFIX="mipsel-linux-android-"
    export INSTALL_FOLDER="arch-mips"
    ;;
  mips64)
    export TOOLCHAIN="mips64el-linux-android-4.9"
    export OPENSSL_CONFIG_OPTIONS="android64-mips64"
    export TOOL_PREFIX="mips64el-linux-android-"
    export INSTALL_FOLDER="arch-mips64"
    ;;
  *)
    echo "ERROR: Unknown arch $ARCH"
    exit 1
    ;;
esac

export TOOLCHAIN_DIR="$( pwd )/toolchain-$TOOLCHAIN"
$NDK_ROOT/build/tools/make-standalone-toolchain.sh \
    --install-dir="$TOOLCHAIN_DIR" \
    --platform="$ANDROID_API" \
    --toolchain="$TOOLCHAIN" \
    --arch="$ARCH" \
    --force \
    --verbose

export SYSROOT="$TOOLCHAIN_DIR/sysroot"
export CROSS_SYSROOT="$SYSROOT"
export CROSS_COMPILE="$TOOLCHAIN_DIR/bin/$TOOL_PREFIX"
export ANDROID_DEV="$SYSROOT/usr"

if [ -z "$openssl_path"]; then
    wget "https://www.openssl.org/source/openssl-1.1.0c.tar.gz";
    tar xzvf openssl-1.1.0c.tar.gz;
    export OPEN_SSL_PATH="openssl-1.1.0c"
else
   export OPEN_SSL_PATH=$openssl_path
fi


cd $OPEN_SSL_PATH
if ./Configure $OPENSSL_CONFIG_OPTIONS; then
  if make clean && make; then
    cp lib{ssl,crypto}.{so,a,so.1.1} "$NDK_ROOT/platforms/$ANDROID_API/$INSTALL_FOLDER/usr/lib"
    cp -R include/openssl "$NDK_ROOT/platforms/$ANDROID_API/$INSTALL_FOLDER/usr/include"

    mkdir lib
    cp lib*.a lib/

    cd ..

    echo "Configuration script finished correctly"
  else
    echo "An error ocurred when configurating openssl"
  fi
else
  echo "An error ocurred when configurating openssl"
fi
