#!/bin/bash

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

./configure --prefix=$FFMPEG_PATH/install/linux/x86/h264-decoder-tcp-static \
			--enable-gpl \
			--disable-x86asm \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
			--enable-decoder=h264 \
		    --disable-encoders \
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
