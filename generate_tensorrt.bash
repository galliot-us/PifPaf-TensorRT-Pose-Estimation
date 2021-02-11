#!/bin/bash
config="$1"
run_on_jetson="$2"

imageSize=$(sed -nr "/^\[PoseEstimator\]/ { :l /^InputSize[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $config)
IFS=',' read -a marray <<< "$imageSize"
width=${marray[0]}
height=${marray[1]}

workdir="/repo/pose-estimation/"
onnx_dir="${work_dir}data/onnx"
mkdir -p $onnx_dir
onnx_name_openpifpaf="${work_dir}data/onnx/openpifpaf_resnet50_${width}_${height}.onnx"

onnx_openpifpaf_download_url="https://media.githubusercontent.com/media/neuralet/neuralet-models/c874b2bcee0521d770d3480ed5fef25643160abd/ONNX/openpifpaf_12a4/openpifpaf_resnet50_${width}_${height}.onnx"
if [[ ! $run_on_jetson ]] && [[ ! -f $onnx_name_openpifpaf ]]; then
    echo "############## exporting ONNX from OpenPifPaf ##################"
    python3 -m openpifpaf.export_onnx --outfile $onnx_name_openpifpaf  --checkpoint resnet50  --input-width $width --input-height $height
   
elif [[ $run_on_jetson ]] && [[ ! -f $onnx_name_openpifpaf  ]]; then
    wget $onnx_openpifpaf_download_url -O $onnx_name_openpifpaf
fi

tensorrt_dir="${work_dir}data/tensorrt/"
mkdir -p $tensorrt_dir

precision_detector=$(sed -nr "/^\[PoseEstimator\]/ { :l /^TensorrtPrecision[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $config)


tensorrt_name_openpifpaf="${tensorrt_dir}openpifpaf_resnet50_${width}_${height}_d${precision_detector}.trt"

if [ ! -f $tensorrt_name_openpifpaf ]; then
    echo "############## Generating TensorRT Engine for openpifpaf ######################"
    onnx2trt $onnx_name_openpifpaf -o $tensorrt_name_openpifpaf -d $precision_detector -b 1
fi


