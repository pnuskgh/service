#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : neuralNetwork.py, Version 0.00.001
###     프로그램 설명   : Neural Network
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.19 ~ 2017.04.19
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
import numpy as np

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def testSigmoid():
    print("--- test sigmoid")
    x = np.array([-1.0, 1.0, 2.0])
    y = sigmoid(x)
    print(str(x) + " -> " + str(y))
    print(" ")

def relu(x):
    return np.maximum(0, x)

def testRelu():
    print("--- test relu")
    x = np.array([-1.0, 1.0, 2.0])
    y = relu(x)
    print(str(x) + " -> " + str(y))
    print(" ")

def identity_function(x):
    return x

def softmax(a):
    c = np.max(a)
    exp_a = np.exp(a - c)
    y = exp_a / np.sum(exp_a)
    return y

def testSoftmax():
    print("--- test softmax")
    a = np.array([0.3, 2.9, 4.0])
    y = softmax(a)
    print(str(a) + " -> " + str(y))
    print(" ")

def network_001():
    print("--- test 신경망")
    x = np.array([1.0, 0.5])
    W1 = np.array([[0.1, 0.3, 0.5], [0.2, 0.4, 0.6]])
    b1 = np.array([0.1, 0.2, 0.3])
    print("x  -> " + str(x))
    print("W1 -> " + str(W1))
    print("b1 -> " + str(b1))
    print(" ")

    A1 = np.dot(x, W1) + b1
    Z1 = sigmoid(A1)
    print("A1 -> " + str(A1))
    print("Z1 -> " + str(Z1))
    print(" ")

    W2 = np.array([[0.1, 0.4], [0.2, 0.5], [0.3, 0.6]])
    b2 = np.array([0.1, 0.2])
    print("W2 -> " + str(W2))
    print("b2 -> " + str(b2))
    print(" ")

    A2 = np.dot(Z1, W2) + b2
    Z2 = sigmoid(A2)
    print("A2 -> " + str(A2))
    print("Z2 -> " + str(Z2))
    print(" ")

    W3 = np.array([[0.1, 0.3], [0.2, 0.4]])
    b3 = np.array([0.1, 0.2])
    print("W3 -> " + str(W3))
    print("b3 -> " + str(b3))
    print(" ")

    A3 = np.dot(Z2, W3) + b3
    y = identity_function(A3)
    print("A3 -> " + str(A3))
    print("y  -> " + str(y))
    print(" ")

def init_network():
    network = {}
    network['W1'] = np.array([[0.1, 0.3, 0.5], [0.2, 0.4, 0.6]])
    network['W2'] = np.array([[0.1, 0.4], [0.2, 0.5], [0.3, 0.6]])
    network['W3'] = np.array([[0.1, 0.3], [0.2, 0.4]])
    network['b1'] = np.array([0.1, 0.2, 0.3])
    network['b2'] = np.array([0.1, 0.2])
    network['b3'] = np.array([0.1, 0.2])

    print("W1 -> " + str(network['W1']))
    print("b1 -> " + str(network['b1']))
    print("W2 -> " + str(network['W2']))
    print("b2 -> " + str(network['b2']))
    print("W3 -> " + str(network['W3']))
    print("b3 -> " + str(network['b3']))
    print(" ")
    return network

def forward(network, x):
    W1, W2, W3 = network['W1'], network['W2'], network['W3']
    b1, b2, b3 = network['b1'], network['b2'], network['b3']

    A1 = np.dot(x, W1) + b1
    Z1 = sigmoid(A1)

    A2 = np.dot(Z1, W2) + b2
    Z2 = sigmoid(A2)

    A3 = np.dot(Z2, W3) + b3
    y = identity_function(A3)

    print("A1 -> " + str(A1))
    print("Z1 -> " + str(Z1))
    print("A2 -> " + str(A2))
    print("Z2 -> " + str(Z2))
    print("A3 -> " + str(A3))
    print("y  -> " + str(y))
    print(" ")
    return y

def network_002():
    print("--- test 신경망")
    x = np.array([1.0, 0.5])
    print("x  -> " + str(x))
    print(" ")

    network = init_network()
    y = forward(network, x)

def main():
    testSigmoid()
    testRelu()
    testSoftmax()

    network_001()
    network_002()

### -----------------------------------------------------------------------------------------------
###     Main process
### -----------------------------------------------------------------------------------------------
if __name__ == '__main__':
    main()

### ================================================================================================

