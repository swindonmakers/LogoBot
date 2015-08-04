#!/usr/bin/env python
from __future__ import print_function

# Update global config include files 

import os
import sys
import re


def updateconfig_for_cutparts():
    print("  Cut Parts...", end="")
    
    src_dir = "../cutparts"
    target_file = "../config/cutparts.scad"
    
    op =  '// Cut Parts\n'
    op += '// \n'
    op += '// Order alphabetically - cut parts should not have inter-dependencies!\n'
    op += '\n'
    
    scads = [i for i in os.listdir(src_dir) if i[-5:] == ".scad"]

    for scad in scads:
        op += 'include <'+ src_dir + '/' + scad +'>\n'
    
    with open(target_file,'w') as f:
        f.write(op)

    print("Done")


def updateconfig_for_printedparts():
    print("  Printed Parts...", end="")
    
    src_dir = "../printedparts"
    target_file = "../config/printedparts.scad"
    
    op =  '// Printed Parts\n'
    op += '// \n'
    op += '// Order alphabetically - printed parts should not have inter-dependencies!\n'
    op += '\n'
    
    scads = [i for i in os.listdir(src_dir) if i[-5:] == ".scad"]

    for scad in scads:
        op += 'include <'+ src_dir + '/' + scad +'>\n'
    
    with open(target_file,'w') as f:
        f.write(op)

    print("Done")
    

def updateconfig():
    print("Update Config")
    print("-------------")

    updateconfig_for_printedparts();
    
    updateconfig_for_cutparts();

if __name__ == '__main__':
    updateconfig()



