FFmpeg Build
=============


## msys2-msvc

> 继承VS环境变量

##### 1. 修改msys2_shell.cmd

路径

```
C:\msys64\msys2_shell.cmd
```

修改前

```
rem set MSYS2_PATH_TYPE=inherit
```

修改后

```
set MSYS2_PATH_TYPE=inherit
```

##### 2. 打开VS工具命令

路径

`所有程序` -> `Visual Studio 2017` -> `Visual Studio Tools`

32位

`VS 2017的开发人员命令提示符 `

64位
 
`VC` -> `适用于 VS 2017 的 x64 本机工具命令提示`


##### 3. 打开mingw

进入msys2的根目录

```
pushd C:\msys64
```

32位

```
msys2_shell.cmd -mingw32
```

64位
 
```
msys2_shell.cmd -mingw64
```
> 使用 "where cl" 和 "where link" 检查编译工具是否配置正常。

```
# where link
C:\msys64\usr\bin\link.exe
E:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\link.exe
```

##### 4. 编译

进入ffmpeg根目录

```
./configure --prefix=/usr/ffmpeg-6.0 --toolchain=msvc
make -j8
make install
```

