FROM jiankaiwang/armbazel:4.1.0

Label maintainer="JianKai Wang (gljankai@gmail.com)"

RUN apt-get update && \
    apt-get install -y wget libssl-dev make python3-pip && \
    pip3 install --no-cache-dir pybind11 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get autoremove -y

# clone and build the tensorflow source code
WORKDIR /temp
RUN apt-get install -y git && \
    git clone https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git checkout 855c4c0ee34257b98ce2d01121940efb5423a059

WORKDIR /temp/tensorflow
RUN pip3 install --no-cache-dir Cython==0.29.22 numpy==1.19.5 && \
    ln -s /usr/local/lib/python3.6/dist-packages/numpy/core/include/numpy /usr/include/

ENV arch=rpi
ENV compiler=bazel
ENV PYTHON=python3
RUN bazel --version && \
    tensorflow/lite/tools/pip_package/build_pip_package_with_$compiler.sh $arch

# multi-stage build
RUN cp -r /temp/tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist \
          /temp/tensorflow/output

CMD ["/bin/bash"]
