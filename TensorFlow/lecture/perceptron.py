#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : perceptron.py, Version 0.00.001
###     프로그램 설명   : Perceptron
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

def AND(x1, x2):
    x = np.array([x1, x2])
    w = np.array([0.5, 0.5])
    b = -0.7
    tmp = np.sum(w*x) + b
    if tmp <= 0:
        return 0
    else:
        return 1

def testAND():
    print("--- test AND")
    for xs in [(0, 0), (1, 0), (0, 1), (1, 1)]:
        y = AND(xs[0], xs[1])
        print(str(xs) + " -> " + str(y))
    print(" ")

def NAND(x1, x2):
    x = np.array([x1, x2])
    w = np.array([-0.5, -0.5])
    b = 0.7
    tmp = np.sum(w*x) + b
    if tmp <= 0:
        return 0
    else:
        return 1

def testNAND():
    print("--- test NAND")
    for xs in [(0, 0), (1, 0), (0, 1), (1, 1)]:
        y = NAND(xs[0], xs[1])
        print(str(xs) + " -> " + str(y))
    print(" ")

def OR(x1, x2):
    x = np.array([x1, x2])
    w = np.array([0.5, 0.5])
    b = -0.2
    tmp = np.sum(w*x) + b
    if tmp <= 0:
        return 0
    else:
        return 1

def testOR():
    print("--- test OR")
    for xs in [(0, 0), (1, 0), (0, 1), (1, 1)]:
        y = OR(xs[0], xs[1])
        print(str(xs) + " -> " + str(y))
    print(" ")

def XOR(x1, x2):
    s1 = NAND(x1, x2)
    s2 = OR(x1, x2)
    y = AND(s1, s2)
    return y

def testXOR():
    print("--- test XOR")
    for xs in [(0, 0), (1, 0), (0, 1), (1, 1)]:
        y = XOR(xs[0], xs[1])
        print(str(xs) + " -> " + str(y))
    print(" ")

def step_function(x):
    y = x > 0
    return y.astype(np.int)

def testStep_function():
    print("--- test step_function")
    x = np.array([-1.0, 1.0, 2.0])
    y = step_function(x)
    print(str(x) + " -> " + str(y))
    print(" ")

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

def main():
    testAND()
    testNAND()
    testOR()
    testXOR()
    testStep_function()
    testSigmoid()
    testRelu()

### -----------------------------------------------------------------------------------------------
###     Main process
### -----------------------------------------------------------------------------------------------
if __name__ == '__main__':
    main()

### ================================================================================================

