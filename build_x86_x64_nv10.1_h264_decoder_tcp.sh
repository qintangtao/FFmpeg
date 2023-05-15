#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/third/nv-sdk-v10.1/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/win/x86_x64/nv-10.1-h264-decoder-tcp \
			--enable-gpl \
			--enable-cuda-nvcc \
			--enable-libnpp \
			--enable-nonfree \
			--toolchain=msvc \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
			--enable-decoder=h264_cuvid \
			--enable-decoder=h264 \
		    --disable-encoders \
		    --disable-hwaccels \
		    --enable-hwaccel=h264_d3d11va \
		    --enable-hwaccel=h264_d3d11va2 \
		    --enable-hwaccel=h264_dxva2 \
		    --enable-hwaccel=h264_nvdec \
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
		    --disable-txtpages \
		    --extra-cflags="-I$FFMPEG_PATH/third/nv-sdk-v10.1/include/cuda" \
		    --extra-ldflags="-LIBPATH:$FFMPEG_PATH/third/nv-sdk-v10.1/lib/cuda/x64"
	    