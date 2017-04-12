# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : sampleMNIST.py, Version 0.00.001
###     프로그램 설명   : MNIST 예제 실행
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
import os
import inspect
import tensorflow as tf

### -----------------------------------------------------------------------------------------------
###     데이터 준비
###        784 (28 * 28) 픽셀의 숫자 55,000개
### -----------------------------------------------------------------------------------------------
from tensorflow.examples.tutorials.mnist import input_data
data_set = input_data.read_data_sets("/work/tensorflow/MNIST_data/", one_hot=True)

### -----------------------------------------------------------------------------------------------
###     분석 모델링
###        1. 예측 함수
###        2. 비용 함수
###        3. 개선 함수
### -----------------------------------------------------------------------------------------------
#--- 예측 함수 (Predict Function) : y
#--- y = Wx + b
#--- x. 그림 정보 저장 (784 픽셀 = 28 * 28)
#--- W. Weight (가중치), b. Bias
#--- y. 예측 결과 (0~9까지의 가중치), y_. y의 라벨
x  = tf.placeholder(tf.float32, [None, 784], name='input')   #--- 입력값
y_ = tf.placeholder(tf.float32, [None, 10], name='output')   #--- 입력값
W  = tf.Variable(tf.zeros([784, 10]), name='weight')         #--- 찾고자 하는 변수
b  = tf.Variable(tf.zeros([10]), name="bias")                #--- 찾고자 하는 변수

model = tf.matmul(x, W) + b                                  #--- 모델 (예측 함수)
y  = tf.nn.softmax(model, name='predict')

#--- 비용 함수 (Cost Function) : cross_entropy
cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(y), reduction_indices=[1]))
# cross_entropy = -tf.reduce_sum(y_ * tf.log(y))
# tf.summary.scalar('loss', cross_entropy)
# summary_ = tf.summary.merge_all()

#--- 개선 함수 : train
optimizer = tf.train.GradientDescentOptimizer(0.5)
train = optimizer.minimize(cross_entropy)

### -----------------------------------------------------------------------------------------------
###     학습 진행
### -----------------------------------------------------------------------------------------------
#--- 변수 초기화
init = tf.initialize_all_variables()
sess = tf.Session()
sess.run(init)
# sess.run(tf.global_variables_initializer())

# logger = tf.summary.FileWriter("./MNIST.log", sess.graph)

#--- 100개의 랜덤 데이터로 1000번 학습
for step in range(2000):
  batch_xs, batch_ys = data_set.train.next_batch(100)
  summary = sess.run(train, feed_dict={x: batch_xs, y_: batch_ys})
  # logger.add_summary(summary, step)

### -----------------------------------------------------------------------------------------------
###     학습 결과 검증
###         정확도로 결과를 표시 한다.
### -----------------------------------------------------------------------------------------------
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
print(sess.run(accuracy, feed_dict={x: data_set.test.images, y_: data_set.test.labels}))

### ================================================================================================

