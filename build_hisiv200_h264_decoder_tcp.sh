#!/bin/bash
#注意需要重新下载代码，原因如下

#问题
#FFmpeg编译过程中，运行make命令提示如下错误：

#ffbuild/common.mak:173: *** missing separator.  Stop.

#原因
#原因是不同系统上对于行尾结束符号的标记不一致，Windows系统上的文件是CRLF，而Mac和Linux系统上，则是LF。

#解决
#解决方法就是关闭行末结束符号的自动转换，运行如下命令：

#git config --global core.autocrlf false

#删除本地暂存分区上的文件：

#git rm --cached -r .

#同步线上代码：

#git reset --hard

#登录后复制 
#$ git reset --hard
#Checking out files: 100% (7105/7105), done.
#HEAD is now at 393eff8 avcodec/nvenc: use framerate if available

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

#export PKG_CONFIG_PATH=$FFMPEG_PATH/third/nv-sdk-v10.1/lib/pkgconfig:$FFMPEG_PATH/third/libvpl-msvc-x64/lib/pkgconfig:$PKG_CONFIG_PATH
#echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/linux/hisiv200/h264-decoder-tcp \
			--enable-gpl \
			--enable-cross-compile \
			--cross-prefix=arm-hisiv200-linux-	\
			--arch=arm \
			--target-os=linux \
			--host-os=linux \
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
