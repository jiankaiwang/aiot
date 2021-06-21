# Compile the Movidius graph file

Before using movidius as the training or inference device, you have to compile the model file to graph.

* Reference: 
	* [https://movidius.github.io/ncsdk/tools/compile.html](https://movidius.github.io/ncsdk/tools/compile.html)
	* [https://movidius.github.io/ncsdk/tf_modelzoo.html](https://movidius.github.io/ncsdk/tf_modelzoo.html)

## Tensorflow

Tensorflow has several types of model format, e.g. `.pb`, `.ckpt`, etc. Here we demo how to compile each of them into movidius recognizing graph file.

Several tips must be followed.

*   **The compile target must conserve the variables, otherwise, the model cannot be compiled.**
*   The input and output layers are the node name with scope name in the graph, e.g. `mlp_model/input` and `mlp_model/output/output`.
*   Multiple input layers or output layers can be assigned separately by the comma, e.g. `-on=mlp_model/output/output_class, mlp_model/output/output_prob`.

### compile with a frozen.pb

```sh
mvNCCompile inception_v3_frozen.pb -s 12 -in=input -on=InceptionV3/Predictions/Reshape_1
```

### compile with a .ckpt and a .meta

```sh
mvNCCompile network.meta \
	[-s max_number_of_shaves] \
	[-in input_node_name] \
	[-on output_node_name] \
	[-is input_width input_height] \
	[-o output_graph_filename] \
	[ ... ]
```

for example,

```sh
mvNCCompile inception-v1.meta \
	-s 12 \
	-in=input \
	-on=InceptionV1/Logits/Predictions/Reshape_1 \
	-is 224 224 \
	-o InceptionV1.graph
	
# by default, the compiler would automatically use the ckpt 
# whose name is identical with the .meta file
mvNCCompile model-ckpt-445500.meta \
    [-w .ckpt] \
    -s 12 \
    -in mlp_model/input \
    -on mlp_model/output/output \
    -o mnist_mlp_v1.graph
```

