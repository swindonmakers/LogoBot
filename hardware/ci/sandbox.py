#!/usr/bin/env python
from __future__ import print_function

# Create development wrappers in the sandbox for all used parts 

import os
import sys
import re
import json
from types import *

def makefilename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I)

def make_sandbox_file_for(title, obj_call, showStep=False):
    target_dir = "../sandbox/"
    fn = target_dir + makefilename(title) + '.scad'
    
    if not os.path.isfile(fn):
        with open(fn, "w") as f:
            f.write("include <../config/config.scad>\n")
            f.write("UseSTL=false;\n");
            f.write("UseVitaminSTL=true;\n");
            f.write("DebugConnectors=true;\n");
            if (showStep):
                f.write("$ShowStep=1;\n");
            f.write("DebugCoordinateFrames=true;\n");
            f.write(obj_call + ";\n");


def fill_sandbox_with_assemblies(m):
    print("  Assemblies...")
    for a in m['assemblies']:
        print("    "+a['title'])
        make_sandbox_file_for('assembly_'+a['title'], a['call'], True)
    
def fill_sandbox_with_cutparts(m):
    print("  Cut Parts...")
    for a in m['cut']:
        print("    "+a['title'])
        make_sandbox_file_for('cutpart_'+a['title'], a['call'], True)
    
    
def fill_sandbox_with_printedparts(m):
    print("  Printed Parts...")
    for a in m['printed']:
        print("    "+a['title'])
        make_sandbox_file_for('printedpart_'+a['title'], a['call'])
            
def fill_sandbox_with_vitamins(m):
    print("  Vitamins...")
    for a in m['vitamins']:
        print("    "+a['title'])
        make_sandbox_file_for('vitamin_'+a['title'], a['call'])

def sandbox():
    print("Sandbox")
    print("-------")

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            print(m['title'])
    
            fill_sandbox_with_assemblies(m)
        
            fill_sandbox_with_cutparts(m)
            
            fill_sandbox_with_printedparts(m)
            
            fill_sandbox_with_vitamins(m)
    
if __name__ == '__main__':
    sandbox()



