#!/usr/bin/env python
import os
import sys
import subprocess
from time import sleep, gmtime, strftime

polling_interval = 1

def run(fn):
    tmp = subprocess.call([fn])
    print('Exit Code: '+str(tmp))
    
def rerun(fn):
    while True:
        tmp = subprocess.call('clear', shell=True)
        print(strftime("%H:%M:%S", gmtime()) + " - running: "+fn)
        ft = os.stat(fn).st_mtime
        run(fn)
    
        while (os.stat(fn).st_mtime <= ft):
            sleep(polling_interval)

if __name__ == '__main__':
    if len(sys.argv) == 2:
        rerun(sys.argv[1])
    else:
        print("usage: rerun.py filename")