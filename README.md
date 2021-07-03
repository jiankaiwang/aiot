# Edging Accelerating for ML/AI

[![](https://img.shields.io/badge/doc-stable-green)](README.md)

In this repository, we introduce several edge-AI platforms and demonstrate how to use them from scratch. Most of them are expanded from the concept of IoT. In the following, we focus on several famous platforms. They are Intel OpenVINO, Movidius NCS stick, Coral Edge TPU, Nvidia Jetson series, etc.

For most accelerators of ML/AI applications, there are two necessary components. One is the device with new architecture, for example, the Tensor-based accelerating. The other is the library for using the device, and most of it is built on C/C++.

## Movidius Neural Compute Stick

[**Deprecated**] **We encourage you to use OpenVINO toolkit for Movidius devices, not to use the original NCS SDK**.

Movidius was merged and acquired by Intel at 2016. Movidius purposed an architecture called VPU, that can provide running in the low power but with high calculation capability of computer-vision-based AI inference. You can access the [link](movidius/) for more information about the naive NCS SDK.

## OpenVINO

OpenVINO is a toolkit to leverage the Intel processors for the capability of model inference. In addition, you can utilize the Movidius devices by OpenVINO as well. Now OpenVINO is regared as the main inference framework for all Intel-based chips.

**[**Notice**] There is another famous framework called ONNX Runtime that is also available for utilizing Intel-based chips. However, the Onnx runtime can't utilize the Movidius devices.**

* Preparation: [MD](openvino/openvino_workflow.md)
* OpenVINO on Official Docker
  * Build the OpenVINO 2020.03 docker image on Raspberry Pi for utilizing Movidius NCS: [dockerfile](openvino/pi_for_openvino.dockerfile)
  * Build the OpenVINO toolkit (2018.R5) docker image on x86_64: [dockerfile](openvino/openvino_2018R5.dockerfile)  
* Use OpenVINO by Python API
  * The flow of using OpenVINO for inference: [MD](openvino/inference_openvino_docker.md)
  * The vision example of person detection: [notebook](openvino/person-detection.ipynb)
  * The text example of question answering using BERT: [notebook]
  
## Jetson Series

Jetson series are provided and supported by NVidia and target the solution of the edge AI. However, nowadays edge AI is a highly complex field. NVidia provides different products addressing different issues, like from Jetson Tx2 to Jetson nano, etc.

* Setup Tensorflow Environment on Jetson Nano: [MD](jetson/jetson_tx2_quickstart.md)

## TensorRT

Nvidia also provides an advanced SDK for high-performance deep learning inference, TensorRT. The following are topics about how to program via this platform.

* MINST Example from Training to Inference on TensorRT
  * Training via Tensorflow 2 and Convertion to TensorRT: [MD](tensorrt/trainingMNIST.md)
  * Inference on TensorRT-supported accelerators: [notebook](tensorrt/TensorRTInference.ipynb)

## Tensorflow Lite

Tensorflow Lite is a solution provided by Google and targets the inference on the edge, local, or resource-limited devices. In practical, Tensorflow Lite consists of two components. One is Tensorflow Lite runtime, and the other is model converted to the special format.

### Tensorflow 2.x

* Prepare the Python package of Tensorflow Lite Runtime on different platforms. Follow the tutorial ([MD](tflite_runtime/)).
  * Building the pypkg on general platforms via `bazel`. [dockerfile](tflite_runtime/tflite_runtime.dockerfile)
  * Building the pypkg on general platforms via `cmake`. [dockerfile](tflite_runtime/tflite_runtime_pypkg.dockerfile)
  * Building the pypkg on `arm 32-bit` platforms. [dockerfile](tflite_runtime/tflite_runtime_pypkg_arm32.dockerfile)

* Convert a MNIST model in SavedModel format to Tensorflow Lite: [notebook](tensorflowlite/tf2lite_savedmodel.ipynb)

### Tensorflow 1.x

> Some of the following topics are inherited from the [Sophia](https://github.com/jiankaiwang/sophia) project.

* API introduction and convertion: [notebook](tensorflowlite/TensorflowLite_API.ipynb)
* Advanced convertion and network editing via shell commands: [notebook](tensorflowlite/TensorflowLite_CommandLine.ipynb)
* A flow from convertion to doing an inference: [notebook](tensorflowlite/TFLite_FromFrozenModel_Inference.ipynb)
* Editing Network and Convert to TFLite: [notebook](tensorflowlite/NetworkEditing_TFLite_Keras.ipynb)

## Edge TPU

Tensor Processing Unit (TPU) is designed by Google. There are two types of TPU, they are Cloud TPU and Edge TPU. In this repository, we primarily address the Edge TPU. The way of developing edge TPU is wrapped as the `Coral` toolkit. Coral is a complete toolkit to build local AI products.

For using Coral Edge TPU devices, two components are required. One is the Tensorflow Lite (TFLite) runtime (or you can use `PyCoral API` alternatively). The TFLite runtime helps you load the model and infer the data. The other is the shared library for accessing Edge TPU devices. In this repo, two types of resources can be built and deployed or installed furtherly. The way of building the TFLite runtime please refer to the above [`Tensorflow 2.x` section](https://github.com/jiankaiwang/aiot#tensorflow-2x). Running on the Edge TPU is basically divided into three steps. We also demo each of them in the following.

* The first step is to compile the TFlite model. You need the edgetpu compiler for compiling the model.
  * Edge TPU Compiler on Docker: [Dockerfile](edgetpu/edgetpu_compiler.dockerfile)
  * Before running a model on the Edge TPU. You have to compile the Tensorflow Lite model into the format supported by the Edge TPU. That is the model in the full integer quantization. Flow of creating a model: [MD](edgetpu/create_models.md)

* The second step is preparing the TFLite runtime and the shared library for accessing the Edge TPU. The following is the building example for the shared library of edge TPU. 
  * Please refer to the tutorial ([MD](edgetpu/building_edgetpu_so.md)).
  * The [dockerfile](edgetpu/libedgetpu.dockerfile) for building shared library for accessing the Edge TPU. [Dockerfile in Windows](edgetpu/Dockerfile.windows)

* The third step is to run the optimized Tensorflow Lite model.
  * Inference flow of using Edge TPU: [MD](edgetpu/inference_with_models.md)

## Video Streaming

### MJPG Streamer
* Environment Setting on Pi : [MD](mjpg_streamer/quickstart.md)
* Streaming via python : [MD](mjpg_streamer/video_streaming_using_python.md)

### FFmpeg
* Environment Setting on Pi : [MD](ffmpeg/quickstart.md)

