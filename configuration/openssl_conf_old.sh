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

TOOLCHAIN_DIR="$(pwd)/toolchain"
PREFIX="$(pwd)/build"
CROSS_SYSROOT="$TOOLCHAIN_DIR/sysroot"
CFLAGS="-funroll-loops -ffast-math -O3 -fPIC"


if [ "$ARCH" == "armv7a" ]; then
    echo "Chosen arch: armv7a"
    CROSS_PREFIX="$TOOLCHAIN_DIR/bin/arm-linux-androideabi-"
    TARGET="android-armv7"
    CFLAGS="$CFLAGS -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"
    if [ -f "$TOOLCHAIN_DIR/touch" ]; then
        echo "Using existing toolchain..."
    else
        echo "Make standalone toolchain..."
        rm -rf $TOOLCHAIN_DIR
        $NDK_ROOT/build/tools/make-standalone-toolchain.sh \
                --toolchain=arm-linux-androideabi-4.9 \
                --platform=$ANDROID_API \
                --install-dir=$TOOLCHAIN_DIR
        touch $TOOLCHAIN_DIR/touch
    fi
elif [ "$ARCH" == "arm64" ]; then
    echo "Chosen arch: arm64"
    CROSS_PREFIX="$TOOLCHAIN_DIR/bin/aarch64-linux-android-"
    TARGET="linux-aarch64"
    if [ -f "$TOOLCHAIN_DIR/touch" ]; then
        echo "Using existing toolchain..."
    else
        echo "Make standalone toolchain..."
        rm -rf $TOOLCHAIN_DIR
        $NDK_ROOT/build/tools/make-standalone-toolchain.sh \
                --toolchain=aarch64-linux-android-4.9 \
                --platform=$ANDROID_API \
                --install-dir=$TOOLCHAIN_DIR
        touch $TOOLCHAIN_DIR/touch
    fi
elif [ "$ARCH" == "x86" ]; then
    echo "Chosen arch: x86"
    CROSS_PREFIX="$TOOLCHAIN_DIR/bin/i686-linux-android-"
    TARGET="android-x86"
    CFLAGS="$CFLAGS -march=atom -msse3 -mfpmath=sse"
    if [ -f "$TOOLCHAIN_DIR/touch" ]; then
        echo "Using existing toolchain..."
    else
        echo "Make standalone toolchain..."
        rm -rf $TOOLCHAIN_DIR
        $NDK_ROOT/build/tools/make-standalone-toolchain.sh \
                --toolchain=x86-4.9 \
                --platform=$ANDROID_API \
                --install-dir=$TOOLCHAIN_DIR
        touch $TOOLCHAIN_DIR/touch
    fi
elif [ "$ARCH" == "x86_64" ]; then
    echo "Chosen arch: x86_64"
    CROSS_PREFIX="$TOOLCHAIN_DIR/bin/x86_64-linux-android-"
    TARGET="linux-x86_64"
    if [ -f "$TOOLCHAIN_DIR/touch" ]; then
        echo "Using existing toolchain..."
    else
        echo "Make standalone toolchain..."
        rm -rf $TOOLCHAIN_DIR
        $NDK_ROOT/build/tools/make-standalone-toolchain.sh \
                --toolchain=x86_64-4.9 \
                --platform=$ANDROID_API \
                --install-dir=$TOOLCHAIN_DIR
        touch $TOOLCHAIN_DIR/touch
    fi
else
    echo "Unknown arch: $ARCH"
    exit 0
fi

cd $openssl_path

echo "Configurating..."
./Configure \
        --prefix=$PREFIX \
        --openssldir=$openssl_path \
        --cross-compile-prefix=$CROSS_PREFIX \
        --force \
        zlib-dynamic \
        shared \
        $TARGET \
    $CFLAGS

echo "Compiling..."
make && make install
mkdir -p lib && cp lib*.a lib/

echo "Done"
