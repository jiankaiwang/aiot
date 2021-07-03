# Building Python Package of Tensorflow Lite Runtime


Notice that you have to edit the architecture for the building to the dockerfile.

```dockerfile
ENV arch=rpi
# ...
RUN tensorflow/lite/tools/pip_package/build_pip_package_with_$compiler.sh $arch
```

```sh
# build the python package
cd ./tflite_runtime

# build on arm32 with bazel
docker build -t tflite_runtime_pypkg_arm32 -f tflite_runtime_pypkg_arm32.dockerfile .

# build with cmake
docker build -t tflite_runtime_pypkg -f tflite_runtime_pypkg.dockerfile .
```