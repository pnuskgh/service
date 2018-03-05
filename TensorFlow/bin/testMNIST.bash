#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : testMNIST.bash, Version 0.00.001
###     프로그램 설명   : MNITEST를 진행 한다.
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
###     데이터셋 준비
### ------------------------------------------------------------------------------------------------
yum -y install wget > /dev/null 2>&1

mkdir -p /work/tensorflow/MNIST_data
cd /work/tensorflow/MNIST_data

# # Train : [offset] [type] [value] [description]
# if [[ ! -f train-labels-idx1-ubyte ]]; then
#     wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz > /dev/null 2>&1
#     gzip -d train-labels-idx1-ubyte.gz > /dev/null 2>&1
# fi
# 
# if [[ ! -f train-images-idx3-ubyte ]]; then
#     wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz > /dev/null 2>&1
#     gzip -d train-images-idx3-ubyte.gz > /dev/null 2>&1
# fi
# 
# # T10k : [offset] [type] [value] [description]
# if [[ ! -f t10k-labels-idx1-ubyte ]]; then
#     wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz > /dev/null 2>&1
#     gzip -d t10k-labels-idx1-ubyte.gz > /dev/null 2>&1
# fi
# 
# if [[ ! -f t10k-images-idx3-ubyte ]]; then
#     wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz > /dev/null 2>&1
#     gzip -d t10k-images-idx3-ubyte.gz > /dev/null 2>&1
# fi

### ------------------------------------------------------------------------------------------------
###     TensorFlow 실행
### ------------------------------------------------------------------------------------------------
cd /work/tensorflow
python ${WORKING_DIR}/template/sampleMNIST.py

### ================================================================================================

