#!/usr/bin/env python

# Fetch web content from master branch

import sys
import os
import shutil
from subprocess import call


def fetch():
    print("Fetch")
    print("-----")
    
    # checkout a bunch of stuff
    call(["git","checkout","master","*.md"]);
    call(["git","checkout","master","*.htm"]);
    
    
    # add anything else that's appeared
    call(["git","add","-A"]);
        
    # Commit and push to origin
    call(['git','commit','-a','-m','"auto fetch and commit"']);
    call(['git','push','origin','gh-pages']);
    
    
    
    # copyall('./',target_dir, include=shutil.ignore_patterns('*.md', '*.js','*.png','*.css','*.htm','*.stl'))
        
if __name__ == '__main__':
    fetch()