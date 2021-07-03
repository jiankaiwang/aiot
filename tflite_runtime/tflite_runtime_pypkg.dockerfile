FROM ubuntu:18.04

Label maintainer="JianKai Wang (gljankai@gmail.com)"

RUN apt-get update && \
    apt-get install -y wget libssl-dev make python3-pip && \
    pip3 install --no-cache-dir pybind11 && \
    apt-get autoremove -y

# install cmake for compiling the tensorflow lite runtime
WORKDIR /temp
ENV version=3.19
ENV build=1
RUN wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz && \
    tar -xzvf cmake-$version.$build.tar.gz && \
    rm -rf /temp/cmake-$version.$build.tar.gz

WORKDIR /temp/cmake-$version.$build
RUN ./bootstrap && \
    make -j$(nproc) && \
    make install

# clone and build the tensorflow source code
WORKDIR /temp
RUN apt-get install -y git && \
    git clone https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git checkout 855c4c0ee34257b98ce2d01121940efb5423a059

WORKDIR /temp/tensorflow
ENV arch=rpi
ENV compiler=cmake
ENV PYTHON=python3
RUN pip3 install --no-cache-dir Cython==0.29.22 numpy==1.19.5 && \
    ln -s /usr/local/lib/python3.6/dist-packages/numpy/core/include/numpy /usr/include/
RUN tensorflow/lite/tools/pip_package/build_pip_package_with_$compiler.sh $arch

# multi-stage build
RUN cp -r /temp/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist \
          /temp/tensorflow/output

CMD ["/bin/bash"]
