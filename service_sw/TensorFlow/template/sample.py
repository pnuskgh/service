#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : sample.py, Version 0.00.001
###     프로그램 설명   : 회귀분석을 하는 TensorFlow Sample
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
#--- !/usr/bin/python2.7
#--- https://tensorflowkorea.gitbooks.io/tensorflow-kr/g3doc/get_started/
import os
import inspect
import tensorflow as tf
import numpy as np

### -----------------------------------------------------------------------------------------------
###     데이터 준비
### -----------------------------------------------------------------------------------------------
x_data = np.random.rand(100).astype(np.float32)
y_data = x_data * 0.1 + 0.3

### -----------------------------------------------------------------------------------------------
###     분석 모델링
###        1. 예측 모델
###        2. 비용 함수
###        3. 개선 함수
### -----------------------------------------------------------------------------------------------
#--- 예측 모델
W = tf.Variable(tf.random_uniform([1], -1.0, 1.0))
b = tf.Variable(tf.zeros([1]))
y = W * x_data + b

#--- 비용 함수 (Cost Function)
cost = tf.reduce_mean(tf.square(y - y_data))

#--- 개선 함수
optimizer = tf.train.GradientDescentOptimizer(0.5)
train = optimizer.minimize(cost)

### -----------------------------------------------------------------------------------------------
###     학습
### -----------------------------------------------------------------------------------------------
#--- 변수 초기화
init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init)

#--- 학습 진행
for step in range(200):
    sess.run(train)
    if (step % 20 == 0):
        print(step, sess.run(W), sess.run(b))

sess.close()

### -----------------------------------------------------------------------------------------------
###     학습 결과 검증
### -----------------------------------------------------------------------------------------------

### ================================================================================================
