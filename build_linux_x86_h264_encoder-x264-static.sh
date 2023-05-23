#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/third/libx264-x86_static_linux/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/linux/x86/h264-encoder-x264-static \
			--enable-gpl \
			--disable-x86asm \
			--enable-libx264 \
			--enable-nonfree \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
		    --disable-encoders \
		    --enable-encoder=libx264rgb \
		    --enable-encoder=libx264 \
		    --disable-hwaccels \
		    --disable-demuxers \
		    --disable-muxers \
		    --disable-parsers \
		    --disable-protocols \
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
