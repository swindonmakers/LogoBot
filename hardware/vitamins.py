#!/usr/bin/env python

# Renders STL cache for vitamins

import os
import openscad
import shutil
import sys
import c14n_stl
import re

source_dir = 'vitamins'

def bom_to_vitamins(assembly = None):
    #
    # Make a list of all the vitamins in the BOM
    #
    vitamin_files = {}
    if assembly:
        bom = "accessories/%s.md" % assembly
    else:
        bom = "bom.md"
    for line in open("bom/" + bom, "rt").readlines():
        r = re.search(r'\[(.*\_.*)\]\(.*\.scad\)', line, re.M|re.I)
        if r:
            s = r.group(1).split("_")
            vitamin_files[s[0]] = s[1]
    return vitamin_files

def vitamins(parts = None):
    #
    # Make the target directory
    #
    target_dir = "vitamins/stl"
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    #
    # Decide which files to make
    #
    targets = bom_to_vitamins()
    
    #
    # For each target, find the relevant scad file
    #
    
    for t in targets:
        fn = source_dir + '/' + t + '.scad'
        print("Looking for: "+fn)
        if (os.path.isfile(fn)):
            # Make a file to use the module
            print("Checking for _Parts")
            
            #
            # make a file to use the module
            #
            temp_name = source_dir + "/temp.scad"
            f = open(temp_name, "w")
            f.write("include <../config/config.scad>\n")
            f.write(t + "_Parts();\n");
            f.close()
            #
            # Run openscad
            #
            openscad.run("-D","$bom=2","-o", "dummy.csg", temp_name)

            for line in open("openscad.log"):
                pos = line.find('ECHO: "')
                if pos > -1:
                    s = line[pos + 7 : line.rfind('"')]
                    print("Generating part: "+t+s)
                    
                    #
                    # make a file to use the module
                    #
                    stl_maker_name = source_dir + "/temp.scad"
                    f = open(stl_maker_name, "w")
                    f.write("include <../config/config.scad>\n")
                    f.write("UseSTL=false;\n");
                    f.write("UseVitaminSTL=false;\n");
                    f.write("DebugConnectors=false;\n");
                    f.write("DebugCoordinateFrames=false;\n");
                    f.write(t + s + "(" + t +'_'+ targets[t] + "); \n");
                    f.close()
                    #
                    # Run openscad on the created file if timestamps have changed
                    #
                    stl_name = target_dir + "/" + t + s + '_' + targets[t] + ".stl"
                    if (not os.path.isfile(stl_name) or os.path.getmtime(stl_name) < os.path.getmtime(fn)):
                        openscad.run("-D$bom=1","-o", stl_name, stl_maker_name)
                        c14n_stl.canonicalise(stl_name)
                    else:
                        print fn + " is up to date"

if __name__ == '__main__':
    vitamins()
