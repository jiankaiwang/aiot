# A Training Example on MNIST for TensorRT

During training, you have to take care of the layers you used to make sure the availability of TensorRT supported.

## Training Progress

The following are the flow of training a MNIST MLP model. The flow is similar to the one of the usual progress that you train a model.

```python
import logging
import tqdm
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
import tensorflow_datasets as tfds

tfds.disable_progress_bar()

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s : %(message)s')
logging.info("Tensorflow Version: {}".format(tf.__version__))
logging.info("Tensorflow Dataset Version: {}".format(tfds.__version__))

logging.debug("GPU is{} available.".format("" if tf.config.list_physical_devices("GPU") else " not"))

# dataset preprocessing
trainDatasets = tfds.load("MNIST", split='train[:90%]', as_supervised=True)
valDatasets = tfds.load("MNIST", split='train[90%:]', as_supervised=True)
testDatasets = tfds.load("MNIST", split='test', as_supervised=True)

def normalize(img, label):
  """Normalize the image to the scale in [-1, 1]."""
  img = tf.cast(img, tf.float32)
  img = (img - 127.5) / 127.5
  return img, label

trainBatchDataset = trainDatasets.map(normalize).cache().shuffle(1000).batch(128)
trainBatchDataset = trainBatchDataset.prefetch(tf.data.experimental.AUTOTUNE)
valBatchDataset = valDatasets.map(normalize).batch(128)
valBatchDataset = valBatchDataset.prefetch(tf.data.experimental.AUTOTUNE)
testBatchDataset = testDatasets.map(normalize).batch(128)
testBatchDataset = testBatchDataset.prefetch(tf.data.experimental.AUTOTUNE)

# model building
def seqModel():
  model = tf.keras.Sequential()
  model.add(tf.keras.layers.Reshape(target_shape=[784]))
  model.add(tf.keras.layers.Dense(512, activation="relu", kernel_initializer='he_normal'))
  model.add(tf.keras.layers.Dense(256, activation="relu", kernel_initializer='he_normal'))
  model.add(tf.keras.layers.Dropout(0.5))
  return model

inputs = tf.keras.layers.Input(shape=(28, 28, 1))
modelBody = seqModel()
features = modelBody(inputs)
outputs = tf.keras.layers.Dense(10, activation="tanh", kernel_initializer='glorot_uniform')(features)
model = tf.keras.Model(inputs=inputs, outputs=outputs)

model.summary()

# object function and optimizer
lossObject = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)

def step(usedModel, x, y):
  with tf.GradientTape() as tape:
    y_ = usedModel(x, training=True)
    losses = lossObject(y_true=y, y_pred=y_)
  grads = tape.gradient(losses, usedModel.trainable_variables)
  return losses, grads, y_

avgLosses = tf.keras.metrics.Mean()
accuracy = tf.keras.metrics.SparseCategoricalAccuracy()
valAvgLosses = tf.keras.metrics.Mean()
valAccuracy = tf.keras.metrics.SparseCategoricalAccuracy()

lossHistory = []
accHistory = []
valLossHistory = []
valAccHistory = []

# the train loop
schedulers = [{'optimizer': tf.keras.optimizers.SGD(learning_rate=0.001), 'epochs': 450}, 
              {'optimizer': tf.keras.optimizers.SGD(learning_rate=0.0001), 'epochs': 200}]

valSteps = 10

for schedulerIdx in range(len(schedulers)):

  optimizer = schedulers[schedulerIdx]["optimizer"]
  epochs = schedulers[schedulerIdx]["epochs"]

  for epoch in tqdm.trange(epochs):
    avgLosses.reset_states()
    accuracy.reset_states()

    for x, y in trainBatchDataset:
      losses, grads, y_ = step(model, x, y)
      optimizer.apply_gradients(zip(grads, model.trainable_variables))

      accuracy(y, y_)
      avgLosses(losses)

    avgLossVal = avgLosses.result()
    accVal = accuracy.result()
    lossHistory.append(avgLossVal)
    accHistory.append(accVal)

    if (epoch + 1) % valSteps == 0:
      valAvgLosses.reset_states()
      valAccuracy.reset_states()

      for valX, valY in valBatchDataset:
        valY_ = model(valX, training=False)
        valLoss = lossObject(y_true=valY, y_pred=valY_)

        valAvgLosses(valLoss)
        valAccuracy(valY, valY_)

      valAvgLossVal = valAvgLosses.result()
      valAccVal = valAccuracy.result()
      valLossHistory.append(valAvgLossVal)
      valAccHistory.append(valAccVal)
      
      logging.info("Epoch {}: Acc {:.2%}, Loss {:.6f}, Val_Acc {:.2%}, Val_Loss {:.6f}".format(
        epoch + 1, accVal, avgLossVal, valAccVal, valAvgLossVal))
```

The above is a simple example training a MNIST model. After training a model, you can export it in a savedModel format.

```python
modelSave = False
modelPath = "~/mnist"

if modelSave:
  model.save(modelPath)
else:
  model = tf.keras.models.load_model(modelPath)
```

Next you can optimize the saved model using the TensorRT converter. In order to keep the converting environment simple, we use a NVidia docker image for converting the model. You can surf the [link](https://docs.nvidia.com/deeplearning/frameworks/tensorflow-release-notes/rel_20-07.html#rel_20-07) to select the best version for you.

Start the docker for the convertion.

```sh
docker pull nvcr.io/nvidia/tensorflow:20.03-tf2-py3

docker run --gpus all -it --rm -p 8886:8888 -v ~/mnist:/tmp/mnist nvcr.io/nvidia/tensorflow:20.03-tf2-py3
```

The following are the script for converting the TF2 model to the one optimized by TensorRT. The following script would convert the model to a FP32-supported model.

```python
import logging
import os
import tensorflow as tf
from tensorflow.python.compiler.tensorrt import trt_convert as trt

logging.basicConfig(level=logging.DEBUG, 
                    format="%(asctime)s-%(levelname)s: %(message)s")
logging.info("Tensorflow Version: {}".format(tf.__version__))

# In[]

savedModelPath = "/tmp/mnist"
assert os.path.exists(savedModelPath)
outputTensorrtPath = "/tmp/mnist_tensorrt"

try:
  converter = trt.TrtGraphConverterV2(input_saved_model_dir=savedModelPath)
  converter.convert()
  converter.save(outputTensorrtPath)
except Exception as e:
  logging.error("Error in converting the savedmodel format. ({})".format(e))
```

In advanced, the following script would convert the model to a FP16-supported model.

```python
savedModelPath = "/tmp/mnist"
outputTensorrtPathFP16 = "/tmp/mnist_tensorrt_FP16"
conversionParams = trt.DEFAULT_TRT_CONVERSION_PARAMS._replace(
  precision_mode=trt.TrtPrecisionMode.FP16,
  max_workspace_size_bytes=8*1024*1024*1024)  # 8GB

try:
  converter = trt.TrtGraphConverterV2(input_saved_model_dir=savedModelPath,
    conversion_params=conversionParams)
  converter.convert()
  converter.save(outputTensorrtPathFP16)
except Exception as e:
  logging.error("Error in converting the savedmodel format. ({})".format(e))
```

The output file would still be a savedModel format.