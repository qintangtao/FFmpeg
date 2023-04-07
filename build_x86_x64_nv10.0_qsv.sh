#https://blog.csdn.net/u012117034/article/details/123131144

export PKG_CONFIG_PATH=/i/github/FFmpeg/third/libx264-x64/lib/pkgconfig:/i/github/FFmpeg/third/nv-sdk-v10.0/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

./configure --prefix=/f/ff/usr/ffmpeg-6.0/x86_x64/nv-10.0-qsv \
			--enable-shared \
			--disable-static \
    		--enable-gpl \
    		--enable-libx264 \
			--enable-cuda-nvcc \
			--enable-libmfx \
			--enable-libnpp \
			--enable-nonfree \
			--toolchain=msvc \
			--extra-cflags="-I/i/github/FFmpeg/third/libx264-x64/include -I/i/github/FFmpeg/third/nv-sdk-v10.0/include/cuda -I/i/github/FFmpeg/third/libmfx-msvc-x64/include/mfx" \
		    --extra-ldflags="-LIBPATH:/i/github/FFmpeg/third/libx264-x64/lib -LIBPATH:/i/github/FFmpeg/third/nv-sdk-v10.0/lib/cuda/x64 -LIBPATH:/i/github/FFmpeg/third/libmfx-msvc-x64/lib"


# make 前需要把config.h文件中的中文删除掉
# 修改前
# #define CC_IDENT "用于 x64 的 Microsoft (R) C/C++ 优化编译器 19.16.27031.1 版"
# 修改后
# #define CC_IDENT ""

#make -j8
#make install