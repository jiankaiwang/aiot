# Inference via OpenVINO on Docker

Containerization becomes a hit in recent years. It provides application-level virtualization and makes the deployment easier. In this topic, we are going to demonstrate how to do the inference via OpenVINO on the Docker container.

## Prepare and Run the Docker Image

First of all, it is necessary to prepare the Docker environment. You can refer to the [webpage](https://docs.docker.com/engine/install/ubuntu/) to install the Docker engine.

The OpenVINO is a toolkit for running an AI application on the Intel processors. Here we use the `OpenVINO runtime` for the demo.

```sh
# pull the latest openvino runtime docker image
docker pull openvino/ubuntu18_runtime:latest
```

Run an openvino container.

```sh
# an example for running a container
docker run --rm --name openvino -v model_zoo:/opt/intel/model_zoo -p 8888:8888 -d openvino/ubuntu18_runtime:latest
```

After activating the container, install the jupyter lab for demonstration.

```sh
# access the container
docker exec -it openvino bash

# install the jupyter lab
pip3 install --no-cache-dir wheel jupyterlab

# run the jupyter lab
~/.local/bin/jupyter lab --notebook-dir=./ --ip 0.0.0.0
```

## Inference via OpenVINO

The following is the flow of inference via OpenVINO. Here we use the Intel CPU as the target running processor.

```py
# import the necessary library
from openvino.inference_engine import IECore

# plugin initialization
ie = IECore()

# read the intermediate representations
net = ie.read_network("model.xml", "model.bin")

# prepare the I/Os
input_blob = next(iter(net.inputs))
output_blob = next(iter(net.outputs))
net.batch_size = 1

# read and preprocess input images
# in openvino, the shape is (batch_size, channels, height, width)
_, _, height, width = net.inputs[input_blob].shape

# the example for data preprocessing in shape of [B, C, H, W]
image = preprocessing(image_path, (height, width))

# loading the model to the plugin
exec_net = ie.load_network(network=net, device_name="CPU")

# start the sync inference
res = exec_net.infer(inputs={input_blob: image})

# processing the outputs
outputs = res[output_blob][0]
```

The above is the general flow of inference using OpenVINO.