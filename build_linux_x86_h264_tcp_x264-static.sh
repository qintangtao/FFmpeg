#!/bin/bash

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/third/libx264-x86_static_linux/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/linux/x86/h264-tcp-x264-static \
			--enable-gpl \
			--enable-libx264 \
			--disable-x86asm \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
			--enable-decoder=h264 \
		    --disable-encoders \
		    --enable-encoder=libx264rgb \
		    --enable-encoder=libx264 \
		    --disable-hwaccels \
		    --disable-demuxers --enable-demuxer=h264 \
		    --disable-muxers \
		    --disable-parsers \
		    --enable-parser=h264 \
		    --disable-protocols --enable-protocol=tcp \
		    --disable-bsfs \
		    --disable-indevs \
		    --disable-outdevs \
		    --disable-devices \
		    --disable-filters \
		    --disable-postproc \
		    --disable-programs \
		    --disable-ffmpeg \
		    --disable-ffplay \
		    --disable-ffprobe \
		    --disable-doc \
		    --disable-htmlpages \
		    --disable-manpages \
		    --disable-podpages \
		    --disable-txtpages 
