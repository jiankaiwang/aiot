# Quick Start



## Preparation



* Install necessary packages.

```shell
sudo apt-get update
sudo apt-get install subversion
sudo apt-get install libjpeg8-dev
sudo apt-get install imagemagick
```



* Download the source code, compile it, and install it.

```shell
cd /opt
sudo svn co https://svn.code.sf.net/p/mjpg-streamer/code/
cd code/mjpg-streamer
sudo make
sudo make install

# change owner to get full authorization
sudo chown pi:pi -R /opt/code

# export the path
vim ~/.bashrc
export LD_LIBRARY_PATH=/opt/code/mjpg_streamer
source ~/.bashrc
```

After installing is complete, the execution file would exist on `/usr/local/bin`. And lots of shared file `.so` would also be generated, including `input_file.so`, `input_uvc.so`, `output_file.so`, `output_http.so`, `output_udp.so`, etc.



## Start Video Streaming

* Check the device status.

```shell
# would list the device connecting by USB
lssub

# check the webcam is ready
ls -al /dev/video0
```



* Start the video streaming.

```shell
# basic@command
# mjpg_streamer -i "parameters" -o "parameters"
# param@input
# so : shared library for input mode
# -d : device path
# -y : using YUV instead of RGB
# -r : resolution in pixel, e.g. 640x480, 320x240, etc.
# -f : update frequency, e.g. 10, 20, 30, 60, etc.
# -n : show no error
# param@output
# so : shared library for output mode
# -p : access port, e.g. 8080 for http protocol
# -w : the access path
mjpg_streamer -i "input_uvc.so -d /dev/video0 -y -r 640x480 -f 60 -n" -o "output_http.so -p 8080 -w /opt/code/mjpg_streamer/www"
```

After start to capturing the streaming, you can surf the webpage `<ip>:<port>` e.g. `localhost:8080` or  `192.168.2.1:8080`, etc. to see the video streaming.