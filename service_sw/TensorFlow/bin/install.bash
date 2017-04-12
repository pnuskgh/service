#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : TensorFlow를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.12 ~ 2017.04.12
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1
source ${UTIL_DIR}/common.bash > /dev/null 2>&1

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     TensorFlow 설정
### ------------------------------------------------------------------------------------------------
GPU_SUPPORT="False"
STORAGE_URL="https://storage.googleapis.com/tensorflow/linux"

### ------------------------------------------------------------------------------------------------
###     TensorFlow 설치
###     https://www.tensorflow.org/
###     https://www.tensorflow.org/install/install_linux
### ------------------------------------------------------------------------------------------------
yum -y install python-pip python-devel
yum -y install gcc gcc-c++ atlas atlas-devel gcc-gfortran openssl-devel libffi-devel

pip install --upgrade pip
pip install --upgrade virtualenv

virtualenv --system-site-packages ~/venvs/tensorflow

source ~/venvs/tensorflow/bin/activate
echo "source ~/venvs/tensorflow/bin/activate" >> ~/.bash_profile
pip install --upgrade numpy scipy wheel cryptography

# python -V
# Python 2.7.5
if [[ "GPU_SUPPORT" == "False" ]]; then
    export TF_BINARY_URL=${STORAGE_URL}/cpu/tensorflow-0.11.0-cp27-none-linux_x86_64.whl
    # export TF_BINARY_URL=${STORAGE_URL}/cpu/tensorflow-0.11.0-cp34-cp34m-linux_x86_64.whl
    # export TF_BINARY_URL=${STORAGE_URL}/cpu/tensorflow-0.11.0-cp35-cp35m-linux_x86_64.whl
else 
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
    export CUDA_HOME=/usr/local/cuda

    export TF_BINARY_URL=${STORAGE_URL}/gpu/tensorflow-0.11.0-cp27-none-linux_x86_64.whl
    # export TF_BINARY_URL=${STORAGE_URL}/gpu/tensorflow-0.11.0-cp34-cp34m-linux_x86_64.whl
    # export TF_BINARY_URL=${STORAGE_URL}/gpu/tensorflow-0.11.0-cp35-cp35m-linux_x86_64.whl
fi

pip install --upgrade ${TF_BINARY_URL}
# pip3 install --upgrade ${TF_BINARY_URL}

ls -alF ~/venvs/tensorflow
# /root/venvs/tensorflow/lib/python2.7/site-packages/tensorflow

python -c "import tensorflow as tf"

### ================================================================================================

