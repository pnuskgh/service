#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : expert_mnist.py, Version 0.00.002
###     프로그램 설명   : MNIST 고급
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.13 ~ 2017.04.19
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================
#--- !/usr/bin/python2.7
#--- https://tensorflowkorea.gitbooks.io/tensorflow-kr/g3doc/tutorials/mnist/pros/
import sys, os
import inspect
import tensorflow as tf
import numpy as np

### -----------------------------------------------------------------------------------------------
###     가중치 함수
### -----------------------------------------------------------------------------------------------
def weight_variable(shape):
  initial = tf.truncated_normal(shape, stddev=0.1)
  return tf.Variable(initial)

### -----------------------------------------------------------------------------------------------
###     편향 함수
### -----------------------------------------------------------------------------------------------
def bias_variable(shape):
  initial = tf.constant(0.1, shape=shape)
  return tf.Variable(initial)

### -----------------------------------------------------------------------------------------------
###     합성곱 함수
### -----------------------------------------------------------------------------------------------
def conv2d(x, W):
  return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')

### -----------------------------------------------------------------------------------------------
###     풀링 함수
### -----------------------------------------------------------------------------------------------
def max_pool_2x2(x):
  return tf.nn.max_pool(x, ksize=[1, 2, 2, 1],
                        strides=[1, 2, 2, 1], padding='SAME')

### -----------------------------------------------------------------------------------------------
###     데이터 준비
###        784 (28 * 28) 픽셀의 숫자 55,000개
### -----------------------------------------------------------------------------------------------
from tensorflow.examples.tutorials.mnist import input_data
data_set = input_data.read_data_sets("/work/tensorflow/MNIST_data/", one_hot=True)
#--- data_set.train      : 55,000개의 학습 데이터
#---     train.labels[55000, 10], train.images[55000, 784]
#--- data_set.text       : 10,000개의 테스트 데이터
#--- data_set.validation :  5,000개의 검증 데이터

### -----------------------------------------------------------------------------------------------
###     분석 모델링
### -----------------------------------------------------------------------------------------------
x  = tf.placeholder(tf.float32, [None, 784], name='input')   #--- 입력값
y_ = tf.placeholder(tf.float32, [None, 10], name='output')   #--- 입력값

#--- 첫번째 합성곱
W_conv1 = weight_variable([5, 5, 1, 32])
b_conv1 = bias_variable([32])

x_image = tf.reshape(x, [-1,28,28,1])

h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)
h_pool1 = max_pool_2x2(h_conv1)

#--- 두번째 합성곱
W_conv2 = weight_variable([5, 5, 32, 64])
b_conv2 = bias_variable([64])

h_conv2 = tf.nn.relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 = max_pool_2x2(h_conv2)

#--- 완전 연결 계층
W_fc1 = weight_variable([7 * 7 * 64, 1024])
b_fc1 = bias_variable([1024])

h_pool2_flat = tf.reshape(h_pool2, [-1, 7*7*64])
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)

#--- 드롭아웃
keep_prob = tf.placeholder(tf.float32)
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

#--- 최종 소프트맥스 계층
W_fc2 = weight_variable([1024, 10])
b_fc2 = bias_variable([10])

y_conv=tf.nn.softmax(tf.matmul(h_fc1_drop, W_fc2) + b_fc2)

#--- 비용 함수 (Cost Function) : cost
cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(y_conv), reduction_indices=[1]))

#--- 개선 함수 : train
optimizer = tf.train.AdamOptimizer(1e-4)
train = optimizer.minimize(cross_entropy)

correct_prediction = tf.equal(tf.argmax(y_conv,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

### -----------------------------------------------------------------------------------------------
###     학습
### -----------------------------------------------------------------------------------------------
#--- 변수 초기화
init = tf.initialize_all_variables()
sess = tf.InteractiveSession()
sess.run(init)

### -----------------------------------------------------------------------------------------------
###     학습
### -----------------------------------------------------------------------------------------------
for i in range(20000):
    batch = data_set.train.next_batch(50)
    if i % 100 == 0:
        train_accuracy = accuracy.eval(feed_dict={x:batch[0], y_: batch[1], keep_prob: 1.0})
        print("step %d, training accuracy %g"%(i, train_accuracy))
    train.run(feed_dict={x: batch[0], y_: batch[1], keep_prob: 0.5})

print("test accuracy %g"%accuracy.eval(feed_dict={
    x: data_set.test.images, y_: data_set.test.labels, keep_prob: 1.0}))

sess.close()
### ================================================================================================

