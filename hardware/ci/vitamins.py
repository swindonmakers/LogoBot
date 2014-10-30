#!/usr/bin/env python

# Renders STL cache for vitamins

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
from types import *

from views import polish;
from views import render_view;


def view_filename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I)
    

def vitamins():
    print("Vitamins")
    print("--------")

    temp_name =  "temp.scad"

    #
    # Make the target directories
    #
    target_dir = "../vitamins/stl"
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    view_dir = "../vitamins/images"
    if not os.path.isdir(view_dir):
        os.makedirs(view_dir)

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            print(m['title'])
            
            vl = m['vitamins']
            
            for v in vl:
                print("  "+v['title'])
                fn = '../' + v['file']
                if (os.path.isfile(fn)):
                
                    print("    Checking vitamin csg hash...")
                    # Get csg hash of vitamin module
                    f = open(temp_name, "w")
                    f.write("include <../config/config.scad>\n")
                    f.write(v['call'] + ";\n");
                    f.close()
                    h = openscad.get_csg_hash(temp_name);
                    os.remove(temp_name);
                    
                    hashchanged = ('hash' in v and h != v['hash']) or (not 'hash' in v)
                    
                    # update hash in json
                    v['hash'] = h
                        
                    # STL
                        
                    
                    # Views
                    for view in v['views']:
                        print("      "+view['title'])
                        
                        png_name = view_dir + '/' + view_filename(v['title'] + '_'+view['title']) + '.png'
                        
                        if (not os.path.isfile(png_name) or (hashchanged)):            
                            print("        Updating: "+png_name)
            
                            # Up-sample images
                            w = view['size'][0] * 2
                            h = view['size'][1] * 2
            
                            dx = float(view['translate'][0])
                            dy = float(view['translate'][1])
                            dz = float(view['translate'][2])
            
                            rx = float(view['rotate'][0])
                            ry = float(view['rotate'][1])
                            rz = float(view['rotate'][2])
            
                            d = float(view['dist'])
                            camera = "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f" % (dx, dy, dz, rx, ry, rz, d)
            
            
                            # make a file to use the module
                            #
                            f = open(temp_name, "w")
                            f.write("include <../config/config.scad>\n")
                            f.write("UseSTL=false;\n");
                            f.write("UseVitaminSTL=false;\n");
                            f.write("DebugConnectors=false;\n");
                            f.write("DebugCoordinateFrames=false;\n");
                            f.write(v['call'] + ";\n");
                            f.close()
                                           
                            openscad.run(                            
                                        "--imgsize=%d,%d" % (w, h),
                                        "--projection=p",
                                        "--camera=" + camera,
                                        "-o", png_name, 
                                        temp_name)
                        
                            polish(png_name, w/2, h/2)
                            print
                
                            os.remove(temp_name)
                        else:
                            print("        View up to date")
                            
                        
                        
                    
                    """
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
            
                    os.remove(temp_name)

                    # Generate part STLs
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
                    
                            os.remove(stl_maker_name)
                        
                    render_view(t, t+'_'+targets[t], source_dir, view_dir, fn)
                    
                    """
            
    # Save changes to json
    with open('hardware.json', 'w') as f:
        f.write(json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': ')))
                    

if __name__ == '__main__':
    vitamins()
