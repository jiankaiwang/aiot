# Building the shared library of EdgeTPU

Notice that the version compatibility between the libedgetpu and tflite runtime package. You can edit the dockerfile with the git version commit ID of Tensorflow.

```dockerfile
RUN apt-get install -y git && \
    git clone https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git checkout 855c4c0ee34257b98ce2d01121940efb5423a059
```

The following is the building example for the shared library of edge TPU.

```sh
# build libedgetpu shared library
cd ./edgetpu
docker build --build-arg IMAGE=ubuntu:18.04 -t edgetpu -f ./libedgetpu.dockerfile .
```