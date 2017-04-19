#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : intro_mnist.py, Version 0.00.002
###     프로그램 설명   : MNIST 초급
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.12 ~ 2017.04.19
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================
#--- !/usr/bin/python2.7
#--- https://tensorflowkorea.gitbooks.io/tensorflow-kr/g3doc/tutorials/mnist/beginners/
import sys, os
# sys.path.append(os.pardir)    #--- import할 path 추가
import inspect
import numpy as np
import tensorflow as tf

DEBUG=True

### -----------------------------------------------------------------------------------------------
###     데이터 준비
###        784 (28 * 28) 픽셀의 숫자 55,000개
### -----------------------------------------------------------------------------------------------
def ready_dataset():
    from tensorflow.examples.tutorials.mnist import input_data

    #--- data_set.train      : 55,000개의 학습 데이터
    #---     train.labels[55000, 10], train.images[55000, 784] - 28 * 28 이미지
    #--- data_set.test       : 10,000개의 테스트 데이터
    #--- data_set.validation :  5,000개의 검증 데이터
    #--- options
    #---     normalize=False : True. 입력값을 정규화 (0 ~ 255 픽셀값을 0 ~ 1 사이로 변환)
    #---     flatten=True    : True. 1차원 배열로 변환
    #---     one_hot=True    : True. 결과를 배열로 저장, False. 결과를 숫자로 저장
    #---                       7 -> [0, 0, 0, 0, 0, 0, 0, 1, 0, 0]
    data_set = input_data.read_data_sets("/work/tensorflow/MNIST_data/", one_hot=True)

    if  DEBUG:
        print("train.images      : " + str(data_set.train.images.shape))
        print("train.labels      : " + str(data_set.train.labels.shape))
        print("test.images       : " + str(data_set.test.images.shape))
        print("test.labels       : " + str(data_set.test.labels.shape))
        print("validation.images : " + str(data_set.validation.images.shape))
        print("validation.labels : " + str(data_set.validation.labels.shape))
        print(" ")

    return data_set

#--- img_show(data_set.train.images[0], data_set.train.labels[0])
def img_show(img, label):
    from PIL import Image

    img = img.reshape(28, 28)
    pil_img = Image.fromarray(np.uint8(img))
    pil_img.show()

### -----------------------------------------------------------------------------------------------
###     분석 모델링
###        1. 예측 모델
###        2. 비용 함수
###        3. 개선 함수
### -----------------------------------------------------------------------------------------------
def ready_model():
    global x, y_, y

    #--- 예측 모델 (Predict Model) : y
    #--- y = Wx + b
    #--- x. 그림 정보 저장 (784 픽셀 = 28 * 28)
    #--- W. Weight (가중치), b. Bias
    #--- y. 예측 결과 (0~9까지의 가중치), y_. y의 라벨
    x  = tf.placeholder(tf.float32, [None, 784], name='input')   #--- 입력값
    y_ = tf.placeholder(tf.float32, [None, 10], name='output')   #--- 입력값
    W  = tf.Variable(tf.zeros([784, 10]), name='weight')         #--- 찾고자 하는 변수
    b  = tf.Variable(tf.zeros([10]), name="bias")                #--- 찾고자 하는 변수

    #--- Softmax regression
    model = tf.matmul(x, W) + b                                  #--- 예측 모델
    y  = tf.nn.softmax(model, name='predict')                    

    #--- 비용 함수 (Cost Function) : cost
    cost = tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(y), reduction_indices=[1]))
    # cost = -tf.reduce_sum(y_ * tf.log(y))
    # tf.summary.scalar('loss', cost)
    # summary_ = tf.summary.merge_all()

    #--- 개선 함수 : train
    optimizer = tf.train.GradientDescentOptimizer(0.5)
    train = optimizer.minimize(cost)

    return train

### -----------------------------------------------------------------------------------------------
###     학습
### -----------------------------------------------------------------------------------------------
def run_train(data_set, train):
    #--- 변수 초기화
    init = tf.initialize_all_variables()
    sess = tf.Session()
    sess.run(init)

    # logger = tf.summary.FileWriter("./MNIST.log", sess.graph)

    #--- 100개의 랜덤 데이터로 1000번 학습 진행
    for step in range(1000):
        batch_xs, batch_ys = data_set.train.next_batch(100)
        summary = sess.run(train, feed_dict={x: batch_xs, y_: batch_ys})
        # if  DEBUG:
        #     print(str(step) + " -> " + str(summary))

    return sess

### -----------------------------------------------------------------------------------------------
###     학습 결과 검증
###         정확도로 결과를 표시 한다.
### -----------------------------------------------------------------------------------------------
def run_validate(sess, data_set):
    correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
    print(sess.run(accuracy, feed_dict={x: data_set.test.images, y_: data_set.test.labels}))

### -----------------------------------------------------------------------------------------------
###     Main function
### -----------------------------------------------------------------------------------------------
def main():
    #--- 데이터 준비
    data_set = ready_dataset()

    train = ready_model()
    sess = run_train(data_set, train)
    run_validate(sess, data_set)
    sess.close()
    print(" ")

### -----------------------------------------------------------------------------------------------
###     Main process
### -----------------------------------------------------------------------------------------------
if __name__ == '__main__':
    main()

exit(0)
### ================================================================================================

