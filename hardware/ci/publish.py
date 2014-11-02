#!/usr/bin/env python

# Publish updated content to the gh-pages branch
# Involves auto-commits!

import sys
import os
import shutil
from subprocess import call, check_output
import re

def publish():
    print("Publish")
    print("-------")
    
    # Check we're in the master branch, otherwise abort
    p = re.compile("^\*\smaster", re.MULTILINE)
    o = check_output(['git','branch'])
    res = p.search(o)
    
    # also check we're fully up to date!
    p2 = re.compile(r"nothing to commit", re.MULTILINE)
    res2 = p2.search(o)
    print(res2)
    
    if res != None and res2 != None:
    
        # switch to the gh-pages branch
        call(['git','checkout','gh-pages'])
        
        # pull any remote changes
        call(['git','pull','origin'])
        
        # update the fetch script!
        call(["git","checkout","master","fetch.py"]);
    
        # fun the fetch script
        call(['python','fetch.py','1'])
    
        # finally switch back to master
        call(['git','checkout','master'])
    else:
        print("Error - On the wrong branch or working directory not clean!")
    
if __name__ == '__main__':
    publish()