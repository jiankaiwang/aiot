# Flow of Creating a Model

On this page, we are going to show how to create a model inherited from Tensorflow and running on the Edge TPU. In short, the Edge TPU executes a deep feed-forward neural network and supports only Tensorflow Lite models that are fully 8-bit quantized and then compiled specifically for the Edge TPU. The following figure shows the basic flow of creating a model running on the edge TPU.

![](../assert/images/edgetpu_compile.png)

Refer to the Coral (2020), https://coral.ai/docs/edgetpu/models-intro/#compatibility-overview.

* In the first step, you have trained a model on the Tensorflow 1 or 2 (for now, the Edge TPU or Tensorflow Lite mainly supports Tensorflow 1).
* You can export the trained model as a serialized model format (`.pb`) or a savedModel format (a `folder`).
* You can further quantize the model or purge the model.
* After you create the quantized and purged model, you now can convert it to the Tensorflow Lite format (`.tflite`).
* In the final, you can compile the Tensorflow Lite model to the Edge TPU format, which is still a `.tflite` file.
* You now can deploy it to the Edge TPU and start the inference.


## An Example

Here we prepared a TF2 model which is trained on the MNIST dataset. The detail training progress please refer to [A Training Example on MNIST](https://github.com/jiankaiwang/aiot/blob/master/tensorrt/trainingMNIST.md).

After you trained a model, you can convert the saved model to the tensorflow lite format, and you can also refer to [Tensorflow Lite with Quantization](https://github.com/jiankaiwang/aiot/blob/master/tensorflowlite/tf2lite_savedmodel.ipynb).

If you get a tensorflow lite model, you can compiler it for the Edge TPU. You can surf the [link](https://coral.ai/docs/edgetpu/compiler/) for more information.

```sh
# tflite path: /tmp/mnist_savedmodel_quant.tflite
docker run -it --rm --name edgetpu -v /Volumes/Data/tmp:/tmp jiankaiwang/edgetpucompiler:14.1 /bin/bash

edgetpu_compiler --version

# outputs are like:
# ...
# Number of operations that will run on Edge TPU: 5
# Number of operations that will run on CPU: 2
# ...
edgetpu_compiler --min_runtime_version 13 /tmp/mnist_savedmodel_quant.tflite
```