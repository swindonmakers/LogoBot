#!/usr/bin/env python

# Fetch web content from master branch

import sys
import os
import shutil
from subprocess import call


def fetch(doCommit):
    print("Fetch")
    print("-----")
    
    # checkout a bunch of stuff
    
    # the guide
    call(["git","checkout","master","*.md"]);
    call(["git","checkout","master","*.htm"]);
    
    # bom
    call(["git","checkout","master","bom/*.md"]);
    
    # images
    call(["git","checkout","master","images/*.png"]);
    
    # js
    call(["git","checkout","master","js"]);
    
    # css
    call(["git","checkout","master","css"]);
    
    # stl
    call(["git","checkout","master","stl/*.stl"]);
    
    # vitamins views
    call(["git","checkout","master","vitamins/views/*.png"]);
    
    
    # add anything else that's appeared
    call(["git","add","-A"]);
        
    # Commit and push to origin
    if doCommit > 0:
        call(['git','commit','-a','-m','"auto fetch and commit"']);
        call(['git','push','origin','gh-pages']);
    
    # copyall('./',target_dir, include=shutil.ignore_patterns('*.md', '*.js','*.png','*.css','*.htm','*.stl'))
        
if __name__ == '__main__':
    if len(sys.argv) > 1:
        fetch(sys.argv[1])
    else:
        fetch(0)