#https://blog.csdn.net/u012117034/article/details/123131144

export PKG_CONFIG_PATH=/i/github/FFmpeg/third/libx264-x64/lib/pkgconfig:/i/github/FFmpeg/third/nv-sdk-v10.0/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=/f/ff/usr/ffmpeg-6.0/x86_x64/nv-10.0 \
			--enable-shared \
			--disable-static \
    		--enable-gpl \
    		--enable-libx264 \
			--enable-cuda-nvcc \
			--enable-libnpp \
			--enable-nonfree \
			--toolchain=msvc \
			--extra-cflags="-I/i/github/FFmpeg/third/libx264-x64/include -I/i/github/FFmpeg/third/nv-sdk-v10.0/include/cuda" \
		    --extra-ldflags="-LIBPATH:/i/github/FFmpeg/third/libx264-x64/lib -LIBPATH:/i/github/FFmpeg/third/nv-sdk-v10.0/lib/cuda/x64"

#make -j8
#make install