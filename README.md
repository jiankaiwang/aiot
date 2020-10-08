# AIoT : AI + IoT

[![](https://img.shields.io/badge/doc-stable-green)](README.md)

In this repository, we introduce several edge-AI platforms and demonstrate how to use them from scratch. Most of them are expanded from the concept of IoT.

In the following, we focus on several famous platforms, that are Intel OpenVINO, Movidius NCS stick, Coral Edge TPU with Google, and Nvidia Jetson series.

The following table is the basic compare.

| Products | NVidia Jetson Nano | Coral Edge TPU (Dev Board) | Raspberry Pi 3B+ /w Intel NCS 2 |
| -- | -- | -- | -- |
| CPU | Cortex A57 x 4 | Cortext A53 x 4 + Cortex M4F x 1 | Cortex A53 x 4 (Rpb Pi 3B+) |
| GPU / NPU | Maxwell GPU 128 Cuda Core | GC7000 GPU + Google Edge TPU | Movidius Myriad X VPU (NCS2) |
| RAM | 4GB LPDDR4 | 1GB LPDDR4 | 1GB LPDDR2 (Pi 3B+) |
| Compute Capability | 472 GFLOPS (FP16) | 4 TOPS (INT8) | 100 GFLOPS (NCS2) |

## Content

### Movidius Neural Compute Stick

Movidius was merged and acquired by Intel since 2016. Movidius purposed an architecture called VPU, that can provide running in the low power but with high calculation capability of computer-vision-based AI inference.

* AI Inference Architecture: [MD](pi_movidius/AI_Inference_Architecture.md)
* Setup AI Framework Environment on NCSDK: [MD](pi_movidius/quickstart.md)
* Setup Tensorflow Basis Environment on NCSDK: [MD](pi_movidius/Tensorflow_Env.md)
* Setup Tensorflow Lite Environment: [MD](pi_movidius/TensorflowLite_RaspberryPi.md)
* Basic Programming on NCSDK: [MD](pi_movidius/basic_programming.md)
* Compile the tensorflow graph on NCSDK : [MD](pi_movidius/compile_movidius_graph.md)
* Image Classification Task
  * Simple MLP Example on NCSDK : [Training via Tensorflow 1](pi_movidius/SimpleMLP_Training.ipynb), [Inference via NCSDK](pi_movidius/SimpleMLP_Movidius.ipynb)
  * Inference Example on NCSDK : [pyscript](pi_movidius/inference.py)

### OpenVINO

OpenVINO is a toolkit to leverage the Intel processors with the capability of deep learning. 

* Preparation : [OpenVINO workflow](openvino/openvino_workflow.md)
* Inference via OpenVINO on Docker: [MD](openvino/inference_openvino_docker.md)
  
### Jetson Series

Jetson series are provided and supported by NVidia and target the solution of the edge AI. However, nowadays edge AI is a highly complex field. NVidia provides different products addressing different issues, like from Jetson Tx2 to Jetson nano, etc.

* Setup Tensorflow Environment on Jetson Nano: [MD](jetson/jetson_tx2_quickstart.md)

### TensorRT

Nvidia also provides an advanced SDK for high-performance deep learning inference, TensorRT. The following are topics about how to program via this platform.

* MINST Example from Training to Inference on TensorRT
  * Training via Tensorflow 2 and Convertion to TensorRT: [MD](tensorrt/trainingMNIST.md)
  * Inference on TensorRT-supported accelerators: [notebook](tensorrt/TensorRTInference.ipynb)

### Tensorflow Lite

Tensorflow Lite is a solution provided by Google and targets the inference on the edge, local, or resource-limited devices.

#### Tensorflow 2.x

* Convert a MNIST model in SavedModel format to Tensorflow Lite: [notebook](tensorflowlite/tf2lite_savedmodel.ipynb)

#### Tensorflow 1.x

> Some of the following topics are inherited from the [Sophia](https://github.com/jiankaiwang/sophia) project.

* API introduction and convertion: [notebook](tensorflowlite/TensorflowLite_API.ipynb)
* Advanced convertion and network editing via shell commands: [notebook](tensorflowlite/TensorflowLite_CommandLine.ipynb)
* A flow from convertion to doing an inference: [notebook](tensorflowlite/TFLite_FromFrozenModel_Inference.ipynb)
* Editing Network and Convert to TFLite: [notebook](tensorflowlite/NetworkEditing_TFLite_Keras.ipynb)

### Edge TPU

Tensor Processing Unit (TPU) is designed by Google. There are two types of TPU, they are Cloud TPU and Edge TPU. In this repository, we primarily address the Edge TPU. The way of developing edge TPU is wrapped as the `Coral` toolkit. Coral is a complete toolkit to build local AI products.

* Flow of creating a model: [MD](edgetpu/create_models.md)
* Flow of running a model: [MD](edgetpu/inference_with_models.md)

### Video Streaming

#### MJPG Streamer
* Environment Setting on Pi : [MD](mjpg_streamer/quickstart.md)
* Streaming via python : [MD](mjpg_streamer/video_streaming_using_python.md)

#### FFmpeg
* Environment Setting on Pi : [MD](ffmpeg/quickstart.md)

