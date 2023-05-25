#!/bin/bash

#set temp path
export TMPDIR=`dirname $0`/tmpdir

#set ffmpeg source path
#export SRC_PATH=/F/ff/ffmpeg-4.2

#set ndk path
#NDK=E:/tools/Android/SDK/android-ndk-r21d
#NDK=/F/ff/ndk/21.0.6113669
#NDK=/D/Users/open/android-sdk/ndk/21.0.6113669
NDK=/D/Users/open/android-sdk/ndk/21.4.7075529
#set api version
API=21
# arm aarch64 i686 x86_64
#ARCH=aarch64

#linux-x86_64 windows-x86_64
#host is windows 64 bit
HOST_TAG=windows-x86_64

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin
SYSROOT=$NDK/sysroot

#echo ${NDK}


CFLAG="-D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD -Os -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm"

#create tmep directory
mkdir -p $TMPDIR

#support configure armeabi-v7a and arm64-v8a
configure()
{
    echo "NDK = $NDK"
    #get the parameter
    TARGET_CPU=$1
    mkdir -p `dirname $0`/install/android/$TARGET_CPU
    if [ "$TARGET_CPU" == "x86" ];then
        echo "build i686 32bit lib"
        ARCH=x86
        TARGET=i686-linux-android
        CROSS_PREFIX=$TOOLCHAIN/i686-linux-android-
        CC=$TOOLCHAIN/$TARGET$API-clang
        CXX=$TOOLCHAIN/$TARGET$API-clang++
        #translate the cpu string
        CPU="x86"
    elif [ "$TARGET_CPU" == "x86_64" ];then
        echo "build x86_64 64bit lib"
        ARCH=x86_64
        TARGET=x86_64-linux-android
        CROSS_PREFIX=$TOOLCHAIN/x86_64-linux-android-
        CC=$TOOLCHAIN/$TARGET$API-clang
        CXX=$TOOLCHAIN/$TARGET$API-clang++
        #translate the cpu string
        CPU="x86_64"
    elif [ "$TARGET_CPU" == "armeabi-v7a" ];then
        echo "build 32bit lib"
        ARCH=arm
        TARGET=armv7a-linux-androideabi
        CROSS_PREFIX=$TOOLCHAIN/arm-linux-androideabi-
        CC=$TOOLCHAIN/$TARGET$API-clang
        CXX=$TOOLCHAIN/$TARGET$API-clang++
        #translate the cpu string
        CPU="armv7-a"
    else
        echo "build 64bit lib"
        ARCH=aarch64
        TARGET=aarch64-linux-android
        CROSS_PREFIX=$TOOLCHAIN/aarch64-linux-android-
        CC=$TOOLCHAIN/$TARGET$API-clang
        CXX=$TOOLCHAIN/$TARGET$API-clang++
        #translate the cpu string
        CPU="armv8-a"
    fi
    PREFIX=`dirname $0`/install/android/$TARGET_CPU
    echo "try configure $TARGET_CPU and prefix is $PREFIX"
    ./configure \
    --ln_s="cp -rf" \
    --prefix=$PREFIX \
    --cc=$CC \
    --cxx=$CXX \
    --ld=$CC \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cross-prefix=$CROSS_PREFIX \
    --disable-x86asm \
    --disable-asm \
    --enable-cross-compile \
    --enable-shared \
    --disable-static \
    --enable-runtime-cpudetect \
    --disable-doc \
    --disable-programs \
    --disable-symver \
    --enable-small \
    --enable-gpl --enable-nonfree --enable-version3 --disable-iconv \
    --enable-jni \
    --enable-mediacodec \
    --disable-decoders --enable-decoder=aac --enable-decoder=h264_mediacodec --enable-decoder=hevc_mediacodec --enable-decoder=mpeg4_mediacodec --enable-decoder=vp9_mediacodec --enable-decoder=h264 \
    --disable-encoders --enable-encoder=aac --enable-encoder=h264_mediacodec --enable-encoder=hevc_mediacodec --enable-encoder=mpeg4_mediacodec --enable-encoder=vp9_mediacodec \
    --disable-hwaccels \
    --disable-demuxers --enable-demuxer=rtsp --enable-demuxer=rtp --enable-demuxer=h264 \
    --disable-muxers --enable-muxer=rtsp --enable-muxer=rtp --enable-muxer=h264 \
    --disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264 \
    --disable-protocols --enable-protocol=file --enable-protocol=rtp --enable-protocol=tcp --enable-protocol=udp \
    --disable-bsfs \
    --disable-indevs \
    --disable-outdevs \
    --disable-filters \
    --disable-postproc \
    --extra-cflags="$CFLAG" \
    --extra-ldflags="-marm"
}

build_one()
{
    TARGET_CPU=$1
    echo "configure $TARGET_CPU"
    configure $TARGET_CPU
    echo "build $TARGET_CPU"
    #need to call make clean if you want to build for more than one target
    make clean
    make -j4
    echo "build $TARGET_CPU done"
    make install
    echo "install $TARGET_CPU done"
}

#the entry
build_all()
{
    build_one armeabi-v7a
    build_one arm64-v8a
    build_one x86
    build_one x86_64
}

#call the entry
build_all