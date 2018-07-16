# Quick Start



## Preparation



* Install the dependencies.

```shell
sudo apt-get install texinfo texi2html automake
```



* Install x264 library.

```shell
cd /usr/src
sudo git clone http://git.videolan.org/git/x264.git
cd ./x264
sudo ./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
sudo make
sudo make install
```



* Install ffmpeg.

```shell
cd /usr/src
sudo git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
sudo ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
sudo make
sudo make install
```

