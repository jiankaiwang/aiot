# Compile the Movidius graph file

Before using movidius as the training or inference device, you have to compile the model file to graph.

* Reference: 
	* [https://movidius.github.io/ncsdk/tools/compile.html](https://movidius.github.io/ncsdk/tools/compile.html)
	* [https://movidius.github.io/ncsdk/tf_modelzoo.html](https://movidius.github.io/ncsdk/tf_modelzoo.html)

## Tensorflow

Tensorflow has several types of model format, e.g. `.pb`, `.ckpt`, etc. Here we demo how to compile each of them into movidius recognizing graph file.

* frozen.pb

```sh
mvNCCompile -s 12 inception_v3_frozen.pb -in=input -on=InceptionV3/Predictions/Reshape_1
```

* .ckpt /w .meta

```sh
mvNCCompile network.meta \
	[-s max_number_of_shaves] \
	[-in input_node_name] \
	[-on output_node_name] \
	[-is input_width input_height] \
	[-o output_graph_filename] \
	[-ec]
```

example,

```sh
mvNCCompile inception-v1.meta \
	-s 12 \
	-in=input \
	-on=InceptionV1/Logits/Predictions/Reshape_1 \
	-is 224 224 \
	-o InceptionV1.graph
```