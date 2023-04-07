#https://blog.csdn.net/u012117034/article/details/123131144

export PKG_CONFIG_PATH=/f/ff/usr/ffmpeg-6.0/x86_x64/nv-10.0-qsv/lib/pkgconfig:$PKG_CONFIG_PATH
echo $PKG_CONFIG_PATH

make -f Makefile.example.win