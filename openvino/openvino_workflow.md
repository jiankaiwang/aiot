# OpenVINO Workflow

## Reference

* Transforming from Intel Movidius NCSDK to OpenVINO Toolkit : https://software.intel.com/en-us/articles/transitioning-from-intel-movidius-neural-compute-sdk-to-openvino-toolkit
* Pretrained Models On OpenVINO : https://software.intel.com/en-us/openvino-toolkit/documentation/pretrained-models
* OpenVINO Code Sample : https://software.intel.com/en-us/openvino-toolkit/documentation/code-samples
* **OpenVINO Toolkit Download** : https://software.intel.com/en-us/openvino-toolkit/choose-download/free-download-linux
* Download OpenVINO toolkit for Linux : https://software.intel.com/en-us/articles/OpenVINO-Install-Linux
* Model Optimizer Developer Guide : https://software.intel.com/en-us/articles/OpenVINO-ModelOptimizer#configuring-the-model-optimizer

## Preparation

* Linux : https://software.intel.com/en-us/articles/OpenVINO-Install-Linux
* Windows : https://software.intel.com/en-us/articles/OpenVINO-Install-Windows
  * Set the Environment Variables
  * the Model Optimizer : The path is located on `C:\Intel\computer_vision_sdk_<version>\deployment_tools\model_optimizer`, where `<version>` is the version of Intel OpenVINO toolkit.



## Model Optimizer 

Please refer to webpage https://software.intel.com/en-us/articles/OpenVINO-ModelOptimizer , the basic concept is like the below image. ![Reference from https://software.intel.com/en-us/articles/OpenVINO-ModelOptimizer(2019)](https://software.intel.com/sites/default/files/managed/2a/fb/CVSDK_Flow.png)

### MO Script

* Linux : The default optimizer script path is located on  `/opt/intel/computer_vision_sdk_2018.5.455/deployment_tools/model_optimizer/install_prerequisites`.
* Windows : The default optimizer script path is located on  `C:\Intel\computer_vision_sdk_<version>\deployment_tools\model_optimizer\install_prerequisites`.

### Configure the MO

Here we use Tensorflow framework (https://software.intel.com/en-us/articles/OpenVINO-Using-TensorFlow) as the example.

* Configure the model optimizer and its basic flow:

```sh
# Linux
cd /opt/intel/computer_vision_sdk_2018.5.455/deployment_tools/model_optimizer/
./install_prerequisites/install_prerequisties.sh

# for tensorflow framework
./install_prerequisites/install_prerequisites_tf.sh
```

```bat
:: Windows
cd C:\Intel\computer_vision_sdk_<version>\deployment_tools\model_optimizer
.\install_prerequisites\install_prerequisties.sh

:: for tensorflow framework
.\install_prerequisites\install_prerequisites_tf.sh
```

You can also **manually** configure the framework as well.

You can now provide a pretrained model as the input and convert it into IR (intermediate representation, .xml) and a binary data (.bin) containing the weights and biases data.

* Converting a model to intermediate representation (IR). The default path of the model optimizer script (mo.py) is `/opt/intel/computer_vision_sdk_2018.5.455/deployment_tools/model_optimizer/`.

```sh
cd /opt/intel/computer_vision_sdk_2018.5.455/deployment_tools/model_optimizer/
# the basic format as 
# python3 mo.py --input_model <INPUT_MODEL>
python3 mo.py --input_model /path/to/model/model.pb --framework tf --input Placeholder --output final_result --input_shape [1,128,128,3]
```

After optimizing the model, two main components, IR (.xml) and data (.bin), are generated. 

## Inference Engine

Please refer to webpage https://software.intel.com/en-us/articles/OpenVINO-InferEngine.

The neural compute stick reference : https://software.intel.com/en-us/neural-compute-stick/get-started

*   `ldconfig` issue : You might encounter errors reporting `.so` files are not symbilic files. You can solve the issue via replacing the symbolic links.

```sh
sudo rm /opt/intel/common/mdf/lib64/igfxcmrt64.so
sudo ln -s /opt/intel/common/mdf/lib64/libigfxcmrt64.so /opt/intel/common/mdf/lib64/igfxcmrt64.so

sudo rm /opt/intel/mediasdk/lib64/libva-x11.so.2
sudo ln -s /opt/intel/mediasdk/lib64/libva-x11.so /opt/intel/mediasdk/lib64/libva-x11.so.2

sudo rm /opt/intel/mediasdk/lib64/libva.so.2
sudo ln -s /opt/intel/mediasdk/lib64/libva.so /opt/intel/mediasdk/lib64/libva.so.2

sudo rm /opt/intel/mediasdk/lib64/libva-glx.so.2
sudo ln -s /opt/intel/mediasdk/lib64/libva-glx.so /opt/intel/mediasdk/lib64/libva-glx.so.2

sudo rm /opt/intel/mediasdk/lib64/libva-drm.so.2
sudo ln -s /opt/intel/mediasdk/lib64/libva-drm.so /opt/intel/mediasdk/lib64/libva-drm.so.2

sudo rm /opt/intel/mediasdk/lib64/libigdgmm.so.1
sudo ln -s /opt/intel/mediasdk/lib64/libigdgmm.so /opt/intel/mediasdk/lib64/libigdgmm.so.1

sudo rm /opt/intel/mediasdk/lib64/libmfx.so.1
sudo ln -s /opt/intel/mediasdk/lib64/libmfx.so /opt/intel/mediasdk/lib64/libmfx.so.1

sudo rm /opt/intel/mediasdk/lib64/libmfxhw64.so.1
sudo ln -s /opt/intel/mediasdk/lib64/libmfxhw64.so /opt/intel/mediasdk/lib64/libmfxhw64.so.1
```

* Quick Demo

```sh
cd ~/intel/computer_vision_sdk/deployment_tools/model_optimizer/install_prerequisites/
# install for all frameworks
./install_prerequisites.sh

/opt/intel/computer_vision_sdk/bin/setupvars.sh

cd ~/intel/computer_vision_sdk/deployment_tools/demo
# -d : use NCS devices
./demo_squeezenet_download_convert_run.sh -d MYRIAD
```

