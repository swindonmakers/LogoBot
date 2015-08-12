#!/usr/bin/env python

# Renders views and STL cache for printed parts

import os
import openscad
import slic3r
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

    # store a list of valid STLs to aid cleanup
    stlList = []

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

                    stlpath = os.path.join(target_dir, openscad.stl_filename(p['title']))
                    md5path = os.path.join(target_dir, openscad.stl_filename(p['title']) + '.md5')

                    print("    Checking csg hash")
                    # Get csg hash
                    h = openscad.get_csg_hash(temp_name, p['call']);
                    os.remove(temp_name);

                    # Get old csg hash
                    oldh = ""
                    if os.path.isfile(md5path):
                        with open(md5path,'r') as f:
                            oldh = f.read()

                    hashchanged = h != oldh

                    # update hash in json
                    p['hash'] = h

                    # save new hash
                    with open(md5path,'w') as f:
                        f.write(h)

                    # STL
                    print("    STL")
                    if hashchanged or (not os.path.isfile(stlpath)):
                        print("      Rendering STL...")
                        info = openscad.render_stl(temp_name, stlpath, p['call'])
                        jsontools.json_merge_missing_keys(p, info)

                    # Slice for weight and volume
                    print("    Slice")
                    if hashchanged or ('plasticWeight' not in p):
                        # Slice part and track volume of plastic required
                        # Estimate KG of plastic from density range: 1.23-1.25 g/cm3
                        plasticInfo = slic3r.calc_plastic_required(stlpath)
                        jsontools.json_merge_missing_keys(p, plasticInfo)

                    else:
                        print("      GCode up to date")

                    print("    views")
                    # Views
                    for view in p['views']:
                        print("      "+view['title'])

                        render_view(p['title'], p['call'], view_dir, view, hashchanged, h)

                    # Add to stlList
                    stlList.append(stlpath)
                    stlList.append(md5path)

                else:
                    print("    Error: scad file not found: "+p['file'])


    # Save changes to json
    with open('hardware.json', 'w') as f:
        f.write(json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': ')))

    # clean-up orphaned stls and checksums
    print "Checking for outdated STLs..."
    for f in os.listdir(target_dir):
        fp = os.path.join(target_dir, f)
        try:
            if os.path.isfile(fp) and (fp not in stlList):
                print "Removing: "+fp
                os.remove(fp)
        except Exception, e:
            print e
    print "  Done"

    return 0


if __name__ == '__main__':
    printed()
