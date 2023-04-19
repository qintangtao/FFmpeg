#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`
echo $FFMPEG_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/third/libx264-x64/lib/pkgconfig:$FFMPEG_PATH/third/nv-sdk-v10.1/lib/pkgconfig$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=$FFMPEG_PATH/install/win/x86_x64/nv-10.0 \
			--enable-shared \
			--disable-static \
    		--enable-gpl \
    		--enable-libx264 \
			--enable-cuda-nvcc \
			--enable-libnpp \
			--enable-nonfree \
			--toolchain=msvc \
			--extra-cflags="-I$FFMPEG_PATH/third/libx264-x64/include -I$FFMPEG_PATH/third/nv-sdk-v10.0/include/cuda" \
		    --extra-ldflags="-LIBPATH:$FFMPEG_PATH/third/libx264-x64/lib -LIBPATH:$FFMPEG_PATH/third/nv-sdk-v10.0/lib/cuda/x64"

#make -j8
#make install