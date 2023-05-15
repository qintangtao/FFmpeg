#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH


./configure --prefix=$FFMPEG_PATH/install/win/x86/nv-10.1-qsv-vpl-h264-decoder \
			--enable-gpl \
			--enable-nonfree \
			--toolchain=msvc \
			--disable-avdevice \
		    --disable-avfilter \
		    --disable-postproc \
		    --disable-swresample \
			--disable-decoders \
			--enable-decoder=h264 \
		    --disable-encoders \
		    --disable-hwaccels \
		    --enable-hwaccel=h264_d3d11va \
		    --enable-hwaccel=h264_d3d11va2 \
		    --enable-hwaccel=h264_dxva2 \
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
