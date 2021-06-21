FROM balenalib/rpi-raspbian:latest

ARG DOWNLOAD_LINK=https://download.01.org/opencv/2020/openvinotoolkit/2020.3/l_openvino_toolkit_runtime_raspbian_p_2020.3.220.tgz
ARG INSTALL_DIR=/opt/intel/openvino 
ARG BIN_FILE=https://download.01.org/opencv/2019/open_model_zoo/R3/20190905_163000_models_bin/person-vehicle-bike-detection-crossroad-0078/FP16/person-vehicle-bike-detection-crossroad-0078.bin
ARG WEIGHTS_FILE=https://download.01.org/opencv/2019/open_model_zoo/R3/20190905_163000_models_bin/person-vehicle-bike-detection-crossroad-0078/FP16/person-vehicle-bike-detection-crossroad-0078.xml
ARG IMAGE_FILE=https://cdn.pixabay.com/photo/2018/07/06/00/33/person-3519503_960_720.jpg

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
   wget && \
   rm -rf /var/lib/apt/lists/*

RUN mkdir -p $INSTALL_DIR && cd $INSTALL_DIR && \
   wget -c $DOWNLOAD_LINK && \
   tar xf l_openvino_toolkit_runtime_raspbian_p*.tgz --strip 1 -C $INSTALL_DIR

# add USB rules
RUN sudo usermod -a -G users "$(whoami)" && \
   /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && \
   sh $INSTALL_DIR/install_dependencies/install_NCS_udev_rules.sh"

# build Object Detection sample
RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> ~/.bashrc && \
   mkdir /root/Downloads && \
   cd $INSTALL_DIR/deployment_tools/inference_engine/samples/c/ && \
   /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && \
   ./build_samples.sh && \
   wget --no-check-certificate $BIN_FILE -O /root/Downloads/person-vehicle-bike-detection-crossroad-0078.bin && \
   wget --no-check-certificate $WEIGHTS_FILE -O /root/Downloads/person-vehicle-bike-detection-crossroad-0078.xml && \
   wget --no-check-certificate $IMAGE_FILE -O /root/Downloads/walk.jpg "

RUN echo "import cv2 as cv\n\
# Load the model.\n\
net = cv.dnn.readNet('person-vehicle-bike-detection-crossroad-0078.xml',\
'person-vehicle-bike-detection-crossroad-0078.bin')\n\
# Specify target device.\n\
net.setPreferableTarget(cv.dnn.DNN_TARGET_MYRIAD)\n\
# Read an image.\n\
frame = cv.imread('walk.jpg')\n\
if frame is None:\n\
   raise Exception('Image not found!')\n\
# Prepare input blob and perform an inference.\n\
blob = cv.dnn.blobFromImage(frame, size=(1024, 1024), ddepth=cv.CV_8U)\n\
net.setInput(blob)\n\
out = net.forward()\n\
# Draw detected faces on the frame.\n\
for detection in out.reshape(-1, 7):\n\
   confidence = float(detection[2])\n\
   xmin = int(detection[3] * frame.shape[1])\n\
   ymin = int(detection[4] * frame.shape[0])\n\
   xmax = int(detection[5] * frame.shape[1])\n\
   ymax = int(detection[6] * frame.shape[0])\n\
   if confidence > 0.5:\n\
      cv.rectangle(frame, (xmin, ymin), (xmax, ymax), color=(0, 255, 0))\n\
# Save the frame to an image file.\n\
cv.imwrite('out.png', frame)\n\
print('Detection results in out.png')" >> /root/Downloads/openvino_fd_myriad.py

RUN echo "import cv2 as cv\n\
from openvino.inference_engine import IECore\n\
ie = IECore()\n\
# Load the model.\n\
net = ie.read_network('person-vehicle-bike-detection-crossroad-0078.xml',\
'person-vehicle-bike-detection-crossroad-0078.bin')\n\
input_blob = next(iter(net.inputs))\n\
output_blob = next(iter(net.outputs))\n\
net.batch_size = 1\n\
_, _, height, width = net.inputs[input_blob].shape\n\
# Read an image.\n\
frame = cv.imread('walk.jpg')\n\
if frame is None:\n\
   raise Exception('Image not found!')\n\
# Prepare input blob and perform an inference.\n\
blob = cv.dnn.blobFromImage(frame, size=(1024, 1024), ddepth=cv.CV_8U)\n\
exec_net = ie.load_network(network=net, device_name=ie.available_devices[0])\n\
res = exec_net.infer(inputs={input_blob: blob})\n\
out = res[output_blob][0]\n\
# Draw detected faces on the frame.\n\
for detection in out.reshape(-1, 7):\n\
   confidence = float(detection[2])\n\
   xmin = int(detection[3] * frame.shape[1])\n\
   ymin = int(detection[4] * frame.shape[0])\n\
   xmax = int(detection[5] * frame.shape[1])\n\
   ymax = int(detection[6] * frame.shape[0])\n\
   if confidence > 0.5:\n\
      cv.rectangle(frame, (xmin, ymin), (xmax, ymax), color=(0, 255, 0))\n\
# Save the frame to an image file.\n\
cv.imwrite('out.png', frame)\n\
print('Detection results in out.png')" >> /root/Downloads/openvino_myriad.py

WORKDIR /root/Downloads

ENTRYPOINT "source /opt/intel/openvino/bin/setupvars.sh" ; "/bin/bash"