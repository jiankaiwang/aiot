FROM ubuntu:18.04

WORKDIR /tmp/Downloads

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
   apt-utils \
   automake \
   cmake \
   cpio \
   gcc \
   g++ \
   libatlas-base-dev \
   libstdc++6 \
   libtool \
   libusb-1.0.0-dev \
   lsb-release \
   make \
   python3-pip \
   python3-numpy \
   python3-scipy \
   libgtk-3-0 \
   pkg-config \
   libavcodec-dev \
   libavformat-dev \
   libswscale-dev \
   sudo \
   udev \
   unzip \
   vim \
   libpython3.7 \
   usbutils \
   pciutils \
   wget && \
   rm -rf /var/lib/apt/lists/*

COPY ./l_openvino_toolkit_p_2018.5.455.tgz .
RUN tar -zxf ./l_openvino_toolkit_p_2018.5.455.tgz

WORKDIR /tmp/Downloads/l_openvino_toolkit_p_2018.5.455
RUN /bin/sed -i 's/sudo\ -E//g' ./install_cv_sdk_dependencies.sh && \
    ./install_cv_sdk_dependencies.sh

RUN sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg

RUN pip3 install -U pip wheel setuptools && \
    pip3 install --no-cache-dir networkx==2.3

WORKDIR /opt/intel/computer_vision_sdk/deployment_tools/demo

RUN echo "source /opt/intel/computer_vision_sdk/bin/setupvars.sh" >> ~/.bashrc
RUN ./demo_squeezenet_download_convert_run.sh

CMD ["/bin/bash"]
