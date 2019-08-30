# AIoT : AI + IoT



We integrate Raspberry Pi, Intel Movidius, and Jetson Tx2, etc. to an AIoT prototype architecture. We demonstrate how to use these integrated devices to do AI projects.




## Content


* Raspberry Pi + Movidius Neural Compute Stick

  * NCSDK Basis : 

    * AI Inference Architecture: [MD](pi_movidius/AI_Inference_Architecture.md)
    * Setup AI Framework Environment on NCSDK: [MD](pi_movidius/quickstart.md)
    * Setup Tensorflow Basis Environment on NCSDK: [MD](pi_movidius/Tensorflow_Env.md)
    * Setup Tensorflow Lite Environment: [MD](pi_movidius/TensorflowLite_RaspberryPi.md)
    * Basic Programming on NCSDK: [MD](pi_movidius/basic_programming.md)
    * Compile the tensorflow graph on NCSDK : [MD](pi_movidius/compile_movidius_graph.md)
  * OpenVINO Basis : NCSDK only supported NCS version 1, on contrast, OpenVino supported plenty of intel relative devices, including NCS version 1, NCS version 2, CPU, or FPGA, etc.
      * Preparation : [OpenVINO workflow](pi_movidius/openvino_workflow.md)
      * Tensorflow Object Detection API : 
  * Image Classification
    * Simple MLP Example on NCSDK : [Training via NCSDK](pi_movidius/SimpleMLP_Training.ipynb), [Inference via NCSDK](pi_movidius/SImpleNLP_Movidius.ipynb)
    * Inference Example on NCSDK : [pyscript](pi_movidius/inference.py)
    * Inception v3 on NCSDK : [MD](pi_movidius/inceptionv3.md)
* Jetson Tx2

  * Setup Tensorflow Environment: [MD](tx2/jetson_tx2_quickstart.md)
* Video Streaming
  * MJPG Streamer
    * Environment Setting on Pi : [MD](mjpg_streamer/quickstart.md)
    * Streaming via python : [MD](mjpg_streamer/video_streaming_using_python.md)
  * FFmpeg
    * Environment Setting on Pi : [MD](ffmpeg/quickstart.md)

