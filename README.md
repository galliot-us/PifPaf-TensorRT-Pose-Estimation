> **Galliot now hosts all Neuralet’s content and expertise gained in three years of work and completing high-quality applications, mainly in Computer Vision and Deep Learning. [More Info](https://galliot.us/blog/neuralet-migrated-to-galliot/)**

# TensorRT OpenPifPaf Pose Estimation 

TensorRT OpenPifPaf Pose Estimation is a Jetson-friendly application that runs inference using a [TensorRT](https://developer.nvidia.com/tensorrt) engine to extract human poses. The provided TensorRT engine is generated from an ONNX model exported from [OpenPifPaf](https://github.com/vita-epfl/openpifpaf) version 0.12a4 using [ONNX-TensorRT](https://github.com/onnx/onnx-tensorrt) repo.

You can read [this article](https://galliot.us/blog/pose-estimation-on-nvidia-jetson-platforms-using-openpifpaf/) on our website to learn more about the TensorRT OpenPifPaf Pose Estimation application.

## Getting Started

The following instructions will help you get started.

### Prerequisites

**Hardware**
* [NVIDIA Jetson TX2](https://developer.nvidia.com/embedded/jetson-tx2)
* [NVIDIA Jetson Nano](https://developer.nvidia.com/embedded/jetson-nano)

**Software**
* You should have [Docker](https://docs.docker.com/get-docker/) on your device.

### Install


```bash
git clone https://github.com/galliot-us/pose-estimation.git
cd pose-estimation/
```

### Usage

##### Run on Jetson
* You need to have [JetPack 4.4](https://developer.nvidia.com/jetpack-43-archive) installed on your Jetson device to run this Pose Estimation application.
* This application gets an image or a video as input in 321x193 or 641x369 resolutions. The two ONNX models with these input sizes of OpenPifPaf version 0.12a4 (`openpifpaf_resnet50_321_193.onnx` and `openpifpaf_resnet50_641_369.onnx`) are provided in [Galliot-Models](https://github.com/galliot-us/models/tree/master/ONNX/openpifpaf_12a4).
* The ONNX model will be downloaded based on the specifications in the Config file and the TensorRT Engine will be generated from the ONNX model automatically through the application with performing the following steps.
* Note that you need to have installed nvidia-container-runtime and set docker daemon default runtime to nvidia in `/etc/docker/daemon.json` to have GPU access during docker build
```bash
# 1) Download/Copy Sample input
./download_sample_video.sh

# 3) Build Docker image for Jetson (This step is optional, you can skip it if you want to pull the container from neuralet dockerhub)
docker build -f jetson-4-4-openpifpaf.Dockerfile -t "galliot/pose-estimation-openpifpaf:latest-jetson-4-4" .

# 4) Run Docker container:
docker run --runtime nvidia --privileged -it -v $PWD:/repo galliot/pose-estimation-openpifpaf:latest-jetson-4-4
```

