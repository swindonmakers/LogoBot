#!/usr/bin/env python

# Fetch web content from master branch

import sys
import os
import shutil
from subprocess import call


def fetch(doCommit):
    print("Fetch")
    print("-----")
    
    os.chdir('..')
    
    # checkout a bunch of stuff
    
    # the guide
    call(["git","checkout","master","docs"]);
    
    # images
    call(["git","checkout","master","images"]);
    call(["git","checkout","master","assemblies"]);
    call(["git","checkout","master","vitamins/images"]);
    call(["git","checkout","master","printedparts/images"]);
    
    # stl
    call(["git","checkout","master","printedparts/stl"]);
    
    # add anything else that's appeared
    call(["git","add","-A"]);
        
    # Commit and push to origin
    if doCommit > 0:
        call(['git','commit','-a','-m','"auto fetch and commit"']);
        call(['git','push','origin','gh-pages']);
        
    os.chdir('ci')
        
if __name__ == '__main__':
    if len(sys.argv) > 1:
        fetch(sys.argv[1])
    else:
        fetch(0)