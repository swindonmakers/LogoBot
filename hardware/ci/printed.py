#!/usr/bin/env python

# Renders views and STL cache for printed parts

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
import jsontools
from types import *

from views import polish;
from views import render_view;
    

def printed():
    print("Printed Parts")
    print("-------------")

    temp_name =  "temp.scad"

    #
    # Make the target directories
    #
    target_dir = "../printedparts/stl"
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    view_dir = "../printedparts/images"
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
            
            pl = m['printed']
            
            for p in pl:
                print("  "+p['title'])
                fn = '../' + p['file']
                if (os.path.isfile(fn)):
                
                    print("    Checking csg hash")
                    # Get csg hash
                    h = openscad.get_csg_hash(temp_name, p['call']);
                    os.remove(temp_name);
                    
                    hashchanged = ('hash' in p and h != p['hash']) or (not 'hash' in p)
                    
                    # update hash in json
                    p['hash'] = h
                        
                    # STL
                    print("    STL")
                    stlpath = target_dir + '/' + openscad.stl_filename(p['title'])
                    if hashchanged or (not os.path.isfile(stlpath)):
                        print("      Rendering STL...")
                        info = openscad.render_stl(temp_name, stlpath, p['call'])
                        
                        jsontools.json_merge_missing_keys(p, info) 
                        
                    else:
                        print("      STL up to date")
                    
                    print("    views")
                    # Views
                    for view in p['views']:
                        print("      "+view['title'])
                        
                        render_view(p['title'], p['call'], view_dir, view, hashchanged, h)
                        
                else:
                    print("    Error: scad file not found: "+p['file'])
                        
            
    # Save changes to json
    with open('hardware.json', 'w') as f:
        f.write(json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': ')))
        
    return 0
                    

if __name__ == '__main__':
    printed()
