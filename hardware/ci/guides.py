#!/usr/bin/env python

# Generate the assembly guides for each machine

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
import jsontools
from types import *

def md_filename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I) + '.md'

def guides():
    print("Guides")
    print("------")

    temp_name =  "temp.scad"

    #
    # Make the target directories
    #
    target_dir = "../docs"
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            
            md = ''
        
            md += '# '+m['title'] + ' Assembly Guide\n\n'
            
            
            
            
            mdfile = target_dir + '/' +md_filename(m['title'] +'AssemblyGuide')
            
            print("  Saving markdown")
            with open(mdfile,'w') as f:
                f.write(md)
            

if __name__ == '__main__':
    guides()