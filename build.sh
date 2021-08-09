#!/bin/bash

allow_env="pytorch-code-read"
conda_env=$(conda env list | grep '\*' | awk '{print $1}')
if [[ ${conda_env} != $allow_env ]] ; then
    echo "conda activate $allow_env"
    exit -1
fi

set -ev

export REL_WITH_DEB_INFO=1
export USE_CUDA=1
export USE_CUDNN=1
export USE_KINETO=1

export exclude_file="/usr/include/,/usr/local"
export exclude_file="${exclude_file},third_party/onnx"
export exclude_file="${exclude_file},third_party/ideep"
export exclude_file="${exclude_file},third_party/fbgemm"
export exclude_file="${exclude_file},third_party/XNNPACK"
export exclude_file="${exclude_file},third_party/protobuf"
export exclude_file="${exclude_file},third_party/tensorpipe"
export exclude_file="${exclude_file},third_party/onnx"
export exclude_file="${exclude_file},Logging,logging"

export exclude_func="operator"

export CFLAGS="-finstrument-functions -finstrument-functions-exclude-file-list=${exclude_file} -finstrument-functions-exclude-function-list=${exclude_func} ${CFLAGS}"

python setup.py develop
