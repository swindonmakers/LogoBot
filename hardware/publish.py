#!/usr/bin/env python

# Publish updated content to the gh-pages branch
# Involves auto-commits!

import sys
import os
import shutil
from subprocess import call

def publish():
    print("Publish")
    print("-------")
    
    # first commit everything in master
    call(['git','add','-A'])
    call(['git','commit','-a','-m','"auto build"'])
    
    # and push it up to origin
    call(['git','push','origin','master'])
    
    # switch to the gh-pages branch
    call(['git','checkout','gh-pages'])
    
    # fun the fetch script
    call(['python','fetch.py'])
    
    # finally switch back to master
    call(['git','checkout','master'])
    
if __name__ == '__main__':
    publish()