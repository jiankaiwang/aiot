
# Environment

* Raspberry Pi model 3B
    * Raspbian GNU/Linux 9.1 (stretch)
    * gcc version 6.3.0

## Cross Compiling

```sh
# install toolchain
sudo apt-get update
sudo apt-get install crossbuild-essential-armhf

# clone the repository
cd ~
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow

# only need to execute the command once
# docker image: tensorflow/tensorflow:nightly-devel
sudo bash ./tensorflow/contrib/lite/tools/make/download_dependencies.sh

# compile
./tensorflow/contrib/lite/tools/make/build_rpi_lib.sh

# static library
tensorflow/contrib/lite/tools/make/gen/lib/rpi_armv7/libtensorflow-lite.a
```

## Naive Compiling

### Older Version

```sh
# install toolchain
sudo apt-get install build-essential
cd ~
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow

# switch to the specific branch
# only need to execute the command once
git branch --list --all
git checkout remotes/origin/r1.12
bash ./tensorflow/contrib/lite/tools/make/download_dependencies.sh

# compile
./tensorflow/contrib/lite/tools/make/build_rpi_lib.sh

# static library
tensorflow/contrib/lite/tools/make/gen/lib/rpi_armv7/libtensorflow-lite.a
```

### Newer Version

```sh
# install toolchain
sudo apt-get install build-essential
cd ~
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow

# the master branch
git checkout master

# download necessary requirements
chmod +x ./tensorflow/lite/tools/make/download_dependencies.sh
./tensorflow/lite/tools/make/download_dependencies.sh

# compile
chmod +x ./tensorflow/lite/tools/make/build_rpi_lib.sh
./tensorflow/lite/tools/make/build_rpi_lib.sh

/home/pi/devops/tensorflow/tensorflow/lite/tools/make/gen/rpi_armv7l/obj/tensorflow/lite
```

