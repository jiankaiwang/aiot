# Quick Start



Please make sure you have already set up Movidius execution environment.



## Preparation



### Install the tensorflow



[**Source Code**] 安裝 OpenCV 於 ARM, Raspberry Pi 等。

[https://github.com/ys7yoo/PiOpenCV](github.com/ys7yoo/PiOpenCV)



[**Ubuntu**] 安裝 Tensorflow==1.4。

```bash
$ wget https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0-cp35-cp35m-linux_x86_64.whl
$ pip3 install tensorflow-1.4.0-cp35-cp35m-linux_x86_64.whl
```



[**Raspberry Pi 3**] 安裝 Tensorflow==1.4。

```bash
$ wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.4.0/tensorflow-1.4.0-cp35-none-linux_armv7l.whl
$ sudo pip3 install tensorflow-1.4.0-cp35-none-linux_armv7l.whl
```



**Notice**: 將 Movidius 連接裝置。



### **Tensorflow** 範例

```bash
# example for tensorflow
$ cd examples/tensorflow
$ cd inception_v3

# check for 'Result: Validation Pass'
$ make check

# make profile to run the sdk profile
# and generate the output_report.html
$ make profile

# run the example
$ make all
$ python run.py
```











