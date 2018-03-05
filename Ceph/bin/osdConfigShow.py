#!/usr/bin/env python
# -*- coding: utf-8 -*-
### ================================================================================================
###     프로그램 명     : osdConfigShow.py, Version 0.00.001
###     프로그램 설명   : OSD 설정 정보 조회
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.04 ~ 2017.04.04
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================
#--- https://docs.python.org/2/library/subprocess.html
import os, re, sys, urllib
sys.path.append('/service/util')

import subprocess
import shlex
import json

### ------------------------------------------------------------------------------------------------
###     run_pipe() : Pipe 처리
### ------------------------------------------------------------------------------------------------
def run_pipe():
    while 1:
        try:
            input = sys.stdin.readline()
            if input:
                sys.stdout.write('Stdout: %s' % input)
                sys.stderr.write('Stderr: %s' % input)
            else:
                sys.exit()
        except:
            sys.exit()

### ------------------------------------------------------------------------------------------------
###     run_cmd() : 외부 명령어 실행
### ------------------------------------------------------------------------------------------------

def run_cmd(cmd):
    process = subprocess.Popen(cmd,
    #                           stdin=subprocess.PIPE, 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE,
                               shell=True)
    # process = subprocess.Popen(shlex.split(cmd),
    #                            stdin=subprocess.PIPE, 
    #                            stdout=subprocess.PIPE, 
    #                            stderr=subprocess.PIPE,
    #                            shell=False)

    # (strOut, strErr) = process.communicate()
    # return (strOut, strErr)

    return process.stdout.read().split("\n")

def zz_run_cmd_001(cmd):
    os.system(cmd)
    return

def zz_run_cmd_002(cmd):
    result = subprocess.check_output(cmd, shell=True)
    return result

def zz_run_cmd_003(cmd_list):
    stdin_prev = None
    process = None

    for str_cmd in cmd_list:
        cmd = str_cmd.split()
        process = subprocess.Popen(cmd, stdin=stdin_prev, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdin_prev = process.stdout

    (strOut, strErr) = process.communicate()
    return strOut, strErr

### ------------------------------------------------------------------------------------------------
###     split() : 문자열 분할
### ------------------------------------------------------------------------------------------------
def split(strInp):
    rtList = []
    items = strInp.strip().split(' ')
    for idx in range(len(items)):
        if items[idx] != '':
            rtList.append(items[idx])
    return rtList

### ------------------------------------------------------------------------------------------------
###     getStorages() : Storage 목록 조회
### ------------------------------------------------------------------------------------------------
def getStorages():
    rtList = []
    lines = run_cmd("ssh controller001 ceph osd tree | grep host")
    for line in lines:
        items = split(line)
        if 1 < len(items):
            rtList.append(items[3])
    return sorted(rtList)

### ------------------------------------------------------------------------------------------------
###     getOSDs() : OSD 목록 조회
### ------------------------------------------------------------------------------------------------
def getOSDs():
    rtList = []
    for osdId in run_cmd("ssh controller001 ceph osd ls"):
        osdId = osdId.strip()
        if osdId != '':
            lines = run_cmd("ssh controller001 ceph osd find %s | grep host" % osdId)
            host = split(lines[0])[1]
            host = host.replace(',', '').replace('"', '')
            rtList.append({ 'id': osdId, 'host': host })
    return rtList

### ------------------------------------------------------------------------------------------------
###     getOsdConfig() : OSD 설정 정보 조회
### ------------------------------------------------------------------------------------------------
def getOsdConfig():
    osdConfig = []
    for osd in getOSDs():
        osd['idx'] = osd['host'] + "_" + osd['id'].zfill(5)
        lines = run_cmd('ssh {0} ceph daemon osd.{1} config show'.format(osd['host'], osd['id']))
        osd['json'] = json.loads(' '.join(lines))
        osdConfig.append(osd)
    return sorted(osdConfig, key=lambda x:x['idx'])

### ------------------------------------------------------------------------------------------------
###     scrubSetting() : Scrub 설정 정보
### ------------------------------------------------------------------------------------------------
def scrubSetting():
    config = {}
    # config['osd_scrub_thread_timeout'] = 60
    # config['osd_scrub_thread_suicide_timeout'] = 300
    # config['osd_scrub_finalize_thread_timeout'] = 600
    # config['osd_scrub_invalid_stats'] = True
    config['osd_max_scrubs'] = 1
    # config['osd_scrub_begin_hour'] = 0
    # config['osd_scrub_end_hour'] = 24
    config['osd_scrub_load_threshold'] = 5.0
    config['osd_scrub_min_interval'] = 172800
    config['osd_scrub_max_interval'] = 1209600
    config['osd_scrub_interval_randomize_ratio'] = 1.0
    config['osd_scrub_chunk_min'] = 1
    config['osd_scrub_chunk_max'] = 1
    config['osd_scrub_sleep'] = 0.1
    config['osd_deep_scrub_interval'] = 1209600
    config['osd_deep_scrub_stride'] = 1048576
    # config['osd_deep_scrub_update_digest_min_age'] = 7200
    # config['osd_debug_scrub_chance_rewrite_digest'] = 0

    config['osd_disk_thread_ioprio_class'] = "idle"
    config['osd_disk_thread_ioprio_priority'] = 0
    return config

### ------------------------------------------------------------------------------------------------
###     main() : Main Process
###         /var/run/ceph/
### ------------------------------------------------------------------------------------------------
def main():
    # sys.argv[1]
    osdConfig = getOsdConfig()
    for key, value in scrubSetting().items():
        for config in osdConfig:
            jsonObj = config['json']
            print '%12s %5s, %s : %s (%s)' % (config['host'], config['id'], key, jsonObj[key], value)
        print ' '
    
    print ' '
    print ' '
    print ' '
    for key, value in scrubSetting().items():
        print "ssh controller001 ceph tell osd.* injectargs '--%s %s'" % (key, value)

### ------------------------------------------------------------------------------------------------
###     Main Process 호출
### ------------------------------------------------------------------------------------------------
if __name__ == '__main__':
   main()

### ================================================================================================

