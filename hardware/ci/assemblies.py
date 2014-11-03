#!/usr/bin/env python

# Renders views for assembly steps

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
from views import render_view_using_file;
    
    
def machine_dir(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I)
    
    
def assemblies():
    print("Assemblies")
    print("----------")

    temp_name =  "temp.scad"

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            print(m['title'])
            
            al = m['assemblies']
            
            # make target directory
            view_dir = "../assemblies/"+machine_dir(m['title'])
            if not os.path.isdir(view_dir):
                os.makedirs(view_dir)
            
            for a in al:
                print("  "+a['title'])
                fn = '../' + a['file']
                if (os.path.isfile(fn)):
                
                    print("    Checking csg hash")
                    h = openscad.get_csg_hash(temp_name, a['call']);
                    os.remove(temp_name);
                    
                    hashchanged = ('hash' in a and h != a['hash']) or (not 'hash' in a)
                    
                    # update hash in json
                    a['hash'] = h
                        
                    # Steps
                    for step in a['steps']:                  
                        # Generate step file
                        f = open(temp_name, "w")
                        f.write("include <../config/config.scad>\n")
                        f.write("DebugConnectors = false;\n");
                        f.write("DebugCoordinateFrames = false;\n");
                        f.write("$Explode = true;\n");
                        f.write("$ShowStep = "+ str(step['num']) +";\n");
                        f.write(a['call'] + ";\n");
                        f.close()
                          
                        # Views
                        print("      Step "+str(step['num']))
                        for view in step['views']:
                            render_view_using_file(a['title']+'_step'+str(step['num']), temp_name, view_dir, view, hashchanged, h)
                        
                        
                else:
                    print("    Error: scad file not found: "+a['file'])
                        
            
    # Save changes to json
    with open('hardware.json', 'w') as f:
        f.write(json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': ')))
        
    return 0
                    

if __name__ == '__main__':
    assemblies()
