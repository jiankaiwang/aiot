FROM ubuntu:18.04

Label maintainer="JianKai Wang (gljankai@gmail.com)"

RUN apt-get update && \
    apt-get install -y wget libssl-dev make python3-pip && \
    pip3 install --no-cache-dir pybind11 && \
    apt-get autoremove -y

# install cmake for compiling the opencv
WORKDIR /temp
ENV version=3.19
ENV build=1
RUN wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz && \
    tar -xzvf cmake-$version.$build.tar.gz

WORKDIR /temp/cmake-$version.$build
RUN ./bootstrap && \
    make -j$(nproc) && \
    make install

# environment for opencv-python
RUN pip3 install --no-cache-dir Cython scikit-build numpy
RUN pip3 install opencv-python

# for multiple-stage builds
# COPY --from=build /root/.cache/pip/wheels/*/*/*/*/opencv_python-4.5.1.48-cp36-cp36m-linux_armv7l.whl
WORKDIR /temp/build
RUN cp $(find /root/.cache/pip/wheels | grep whl) .

ENV PYTHONUNBUFFERED=1
CMD ["python3", "-c", "import cv2; print('OpenCV version: {}'.format(cv2.__version__))"]

