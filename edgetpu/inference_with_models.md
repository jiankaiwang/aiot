# Inference with Prebuilt Models

In this topic, we are going to demonstrate how to infer an image using a pre-built Model on the Edge TPU. Here we use the USB Accelerator for demonstration.

## Official Example

We first `git clone` the official repository. Prepare the runtime environment.

```sh
git clone https://github.com/google-coral/tflite.git
cd ./tflite/python/examples/classification/
bash install_requirements.sh
```

Download the tflite runtime from the [link](https://www.tensorflow.org/lite/guide/python). Here we use an intel x86_64 platform as the example. For example, 

```sh
# select the specific version
pip3 install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp36-cp36m-linux_x86_64.whl

# the better way
pip3 install --index-url https://google-coral.github.io/py-repo/ tflite_runtime
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

## How to use the Edge TPU by Tensorflow Lite API

The following is the example of using the Edge TPU by the Tensorflow Lite API. The core concept of inference on the Edge TPU is similar to other accelerators by using the node ID, or the operator ID. After setting the data tensor to the input node ID, triggering the inference by the activating function, like `invoke()` in Tensorflow, or `infer()` in OpenVINO. The inference result can be accessed by the output node ID.

Run one of the types of tflite runtime.

```python
# you can import the tf.lite from tensorflow directly
from tensorflow import lite as tflite

# in the better way of deploying the model on the edge device
# you can install the tflite_runtime first, 
# and then import the runtime 
import tflite_runtime.interpreter as tflite
```

Is there the Edge TPU device available?

```python
# the model optimized by the full integer quantization
tfliteQuantPath = "/path/to/optimized/tflite/model"

# load the model and initialize it
interpreter = tflite.Interpreter(model_path=tfliteQuantPath)

# or you can access the Edge TPU to load and initialize the model
# by using the shared library built from the previous step
# or install the package by the pip3 command
interpreter = tflite.Interpreter(tfliteQuantPath,
  experimental_delegates=[tflite.load_delegate('libedgetpu.so.1')])

interpreter.allocate_tensors()
```

Infer the test data. The process is similar to the one of running a Tensorflow Lite model.

```python
# get the input and output details
# more details, you have to find the node ID for the further use
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print(input_details, output_details)

# load and preprocess the data
# expand the dim of data in batch
testDataPath = "/path/to/your/data"
testData = preprocessData(testDataPath)
assert testData.ndim == 4

# inference body by setting the data tensor to the input node ID
# get the results from the output node ID
# invoke() is the function to start inference
interpreter.set_tensor(input_details[0]['index'], testData)
interpreter.invoke()
results = interpreter.get_tensor(output_details[0]['index'])

# further analyzing the results
testRes = np.where(results > 0.5)[1]
```