#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : tree.py, Version 0.00.001
###     프로그램 설명   : Folder 구조를 보여 준다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.02.13 ~ 2018.02.13
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================
import os
import sys

### ------------------------------------------------------------------------------------------------
###     Functions
### ------------------------------------------------------------------------------------------------
def printCsv(csv, idx):
    pos = 0
    for str in csv:
        if (pos < idx):
            sys.stdout.write('""')
        elif (pos == idx):
            sys.stdout.write('"' + str + '"')
        else:
            sys.stdout.write('""')

        pos = pos + 1
        if (pos  != len(csv)):
            sys.stdout.write(',')
    sys.stdout.write('\n')
    sys.stdout.flush()
    
def getListDir(csv, idx, folder):
    if (len(csv) <= idx):
        print 'Error : list is small.'
        return

    files = os.listdir(folder)
    for file in files:
        if (os.path.isdir(os.path.join(folder, file))):
            csv[idx] = file + '/'
            printCsv(csv, idx)
            getListDir(csv, idx + 1, os.path.join(folder, file))
    for file in files:
        if (os.path.isfile(os.path.join(folder, file))):
            csv[idx] = file
            printCsv(csv, idx)
    csv[idx] = ''

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
csv = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']
cwd = os.getcwd()                       #-- 현재 폴더
getListDir(csv, 0, cwd)

### ================================================================================================

