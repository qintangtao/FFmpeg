#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/third/libx264-x64/lib/pkgconfig:$FFMPEG_PATH/third/nv-sdk-v10.0/lib/pkgconfig:$FFMPEG_PATH/third/libvpl-msvc-x64/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/win/x86_x64/nv-10.1-qsv-vpl-h264-encoder \
			--enable-gpl \
			--enable-cuda-nvcc \
			--enable-libvpl \
			--enable-libnpp \
			--enable-libx264 \
			--enable-nonfree \
			--toolchain=msvc \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
		    --disable-encoders \
		    --enable-encoder=h264_nvenc \
		    --enable-encoder=h264_qsv \
		    --enable-encoder=h264_mf \
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
		    --disable-txtpages \
		    --extra-cflags="-I$FFMPEG_PATH/third/libx264-x64/include -I$FFMPEG_PATH/third/nv-sdk-v10.0/include/cuda" \
		    --extra-ldflags="-LIBPATH:$FFMPEG_PATH/third/libx264-x64/lib -LIBPATH:$FFMPEG_PATH/third/nv-sdk-v10.0/lib/cuda/x64"
