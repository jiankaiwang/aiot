# Quick Start

Please make sure you have already set up Movidius execution environment.

## Installing Tensorflow

### Version r1.4

Remind you that tensorflow package installed is not from the official one.

```sh
$ wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.4.0/tensorflow-1.4.0-cp35-none-linux_armv7l.whl
$ sudo pip3 install tensorflow-1.4.0-cp35-none-linux_armv7l.whl
```

### Version r1.11

We can directly install tensorflow via pip. In the beginning, you have to add the pip source in the pip configuration file (/etc/pip.conf).

```sh
sudo vim /etc/pip.conf

[global]
extra-index-url=https://www.piwheels.org/simple
```

Now you can download and install tensorflow via pip.

```sh
pip3 install tensorflow
```


### Version r1.12 (Build from source)

Cross-compile the Tensorflow source code to build a Python pip package with ARMv7 NEON instructions (NEON is an advanced SIMD architecture extension for ARM Cortex-A series and Cortex-R52 processors) that works on both pi 2 and 3.

Download and install docker first. The build script uses Docker to create a virtual Linux development environment for compilation.

```sh
# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# install docker
sudo apt-get update
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# check your device's arch
uname -a  # armv7l (32 bit)

# select the corresponding arch
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install docker-ce

# quick start to docker
docker --version    
docker run hello-world
```

After installed docker-ce, docker service could not start successfully, and the error message showed "**Failed to start Docker Application Container Engine.**" or "**Error starting daemon: error initializing graphdriver: /var/lib/docker contains several valid graphdrivers: ...**".

**Thus, I tried to rename the folder /var/lib/docker to /var/lib/docker_ori. The docker service was successfully started and also created a new folder /var/lib/docker**. 

```sh
sudo rm -rf /var/lib/docker
```

The second method is to install `docker-hypriot`.

```sh
sudo apt-get install docker-hypriot=1.10.3-1
```

Now we can build the install package based on source code.

```sh
cd ~

# clone the source code
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout remotes/origin/r1.12

# start to compile
sudo -s  # switch to superuser
CI_DOCKER_EXTRA_PARAMS="-e CI_BUILD_PYTHON=python3 -e CROSSTOOL_PYTHON_INCLUDE_PATH=/usr/include/python3.5" \
    tensorflow/tools/ci_build/ci_build.sh PI-PYTHON3 \
    tensorflow/tools/ci_build/pi/build_raspberry_pi.sh
```

### **Tensorflow** 範例

**Notice**: 將 Movidius 連接裝置。

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

## Installing OpenCV

[**Source Code**] 安裝 OpenCV 於 ARM, Raspberry Pi 等。

[https://github.com/ys7yoo/PiOpenCV](github.com/ys7yoo/PiOpenCV)









