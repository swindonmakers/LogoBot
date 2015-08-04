#!/usr/bin/env python

# Renders views and STL cache for vitamins

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


def compile_vitamin(v):

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

    # Compile
    print("  "+v['title'])
    fn = '../' + v['file']
    if (os.path.isfile(fn)):

        print("    Checking csg hash")
        h = openscad.get_csg_hash(temp_name, v['call']);
        os.remove(temp_name);

        hashchanged = ('hash' in v and h != v['hash']) or (not 'hash' in v)

        # update hash in json
        v['hash'] = h

        # STL
        print("    STL Parts")
        if 'parts' in v:
            for part in v['parts']:
                stlpath = target_dir + '/' + openscad.stl_filename(part['title'])
                if hashchanged or (not os.path.isfile(stlpath)):
                    print("      Rendering STL...")
                    openscad.render_stl(temp_name, stlpath, part['call'])
                else:
                    print("      STL up to date")

        # Views
        print("    Views")
        for view in v['views']:
            print("      "+view['title'])

            render_view(v['title'], v['call'], view_dir, view, hashchanged, h)


    else:
        print("    Error: scad file not found: "+v['file'])

def vitamins():
    print("Vitamins")
    print("--------")

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
                compile_vitamin(v)


    # Save changes to json
    with open('hardware.json', 'w') as f:
        f.write(json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': ')))

    return 0


if __name__ == '__main__':
    vitamins()
