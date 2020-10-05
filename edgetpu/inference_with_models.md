# Inference with Prebuilt Models

In this topic, we are going to demonstrate how to infer an image using a pre-built Model on the Edge TPU. Here we use the USB Accelerator for demonstration.

## Official Example

We first `git clone` the official repository. Prepare the runtime environment.

```sh
git clone https://github.com/google-coral/tflite.git
cd ./tflite/python/examples/classification/
bash install_requirements.sh
```

Download the tflite runtime from the [link](https://www.tensorflow.org/lite/guide/python). Here we use an intel x86_64 platform as the example.

```sh
pip3 install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp36-cp36m-linux_x86_64.whl
```

You can simply check the environment using the  `python` environemt.

```python
>>> import tensorflow as tf
>>> import tflite_runtime.interpreter as tflite
>>> exit()
```

If you can import the library successfully, you can plugin the USB Accelerator and run the command for a quick demonstration.

```sh
python classify_image.py \
    --model models/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite \
    --labels models/inat_bird_labels.txt \
    --input images/parrot.jpg
```