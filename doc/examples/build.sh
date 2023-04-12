#https://blog.csdn.net/u012117034/article/details/123131144

FFMPEG_PATH=`pwd`/../..
echo FFMPEG_PATH=$FFMPEG_PATH

HOST_TAG=win
ARCH=x86_x64
VERSION_TAG=nv-10.1-qsv-vpl

FFMPEG_LIB_PATH=$HOST_TAG/$ARCH/$VERSION_TAG
echo FFMPEG_LIB_PATH=$FFMPEG_LIB_PATH

export PKG_CONFIG_PATH=$FFMPEG_PATH/install/$FFMPEG_LIB_PATH/lib/pkgconfig:$PKG_CONFIG_PATH
echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH

make -f Makefile.example.win