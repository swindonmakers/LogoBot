#!/usr/bin/env python

# Generate the vitamin catalogue

import os
import shutil
import sys
import re
import json
import jsontools
import openscad
import syntax
from types import *

from views import polish;
from views import render_view;
from views import view_filename;


def vit_filename(v):
    # return just the filaname component
    # cheap hack - just assume all the paths start vitamins/
    return v['file'][9:]

def output_vitamin(v):
    md = ""

    md += "## " + vit_filename(v) + '\n\n'

    md += 'Title | Call | Image\n'
    md += '--- | --- | ---\n'

    for t in v['types']:
        md += t['title'] + " | `" + t['call'] + "` | "

        # per view
        for view in t['children']:
            if type(view) is DictType and view['type'] == 'view':
                md += '!['+t['title']+']('+view['png_name']+')\n'

    md += '\n'
    return md


def add_vitamin(n, dom):
    vfound = None
    for v in dom['vitamins']:
        if v['file'] == n['file']:
            vfound = v
            continue

    if vfound == None:
        vfound = {'file':n['file'], 'types':[ n ] }
        dom['vitamins'].append(vfound)
    else:
        vfound['types'].append(n)

    return vfound


def compile_vitamin(v, dom):

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
        h = openscad.get_csg_hash(temp_name, v['call'], [fn]);
        os.remove(temp_name);

        hashchanged = ('hash' in v and h != v['hash']) or (not 'hash' in v)

        # update hash in json
        v['hash'] = h

        # STL
        print("    STL Parts")
        for part in v['children']:
            if type(part) is DictType and part['type'] == 'part':
                stlpath = target_dir + '/' + openscad.stl_filename(part['title'])
                if hashchanged or (not os.path.isfile(stlpath)):
                    print("      Rendering STL...")
                    openscad.render_stl(temp_name, stlpath, part['call'], [fn])
                else:
                    print("      STL up to date")

        # Views
        print("    Views")
        for view in v['children']:
            if type(view) is DictType and view['type'] == 'view':
                print("      "+view['title'])

                render_view(v['title'], v['call'], view_dir, view, hashchanged, h, [fn], False)

                png_name = view_dir + '/' + view_filename(v['title'] + '_' + view['title'])
                view['png_name'] = png_name


        node = add_vitamin(v, dom)


    else:
        print("    Error: scad file not found: "+v['file'])


def parse_vitamin(vitaminscad, use_catalogue_call=False):

    tempscadfile =  "temp.scad"
    logfile = 'openscad.log'

    vitamincall = vitaminscad[:-5];

    print("  Calling: "+ vitamincall + "();")

    # Generate a wrapper scad file for the vitamin file
    with open(tempscadfile, "w") as f:
        f.write("include <../config/config.scad>\n")
        f.write("include <../vitamins/"+vitaminscad+">\n")
        if use_catalogue_call:
            f.write(vitamincall + "_Catalogue();\n");
        else:
            f.write(vitamincall + "();\n");

    openscad.run('-D','$ShowBOM=true','-o','dummy.csg',tempscadfile);

    js = ''

    errorlevel = 0

    for line in open(logfile, "rt").readlines():
        # errors
        r = re.search(r".*syntax error$", line, re.I)
        if r:
            print("  Syntax error!")
            print(line)
            errorlevel = 2
            continue

        # echo lines
        r = re.search(r'^.*ECHO\:\s\"(.*)\"$', line, re.I)
        if r:
            s = r.group(1)
            # rewrite single quotes to double quotes, except for where they are used in words, e.g. isn't
            s = re.sub(r"((\w)['](\W|$))","\g<2>\"\g<3>", s)
            s = re.sub(r"((\W|^)['](\w))","\g<2>\"\g<3>", s)
            s = re.sub(r"((\W)['](\W))","\g<2>\"\g<3>", s)

            js += s + '\n'

    if errorlevel == 0:
        # Get rid of any empty objects
        js = js.replace("{}","")

        # get rid of trailing commas
        js = re.sub(r",(\s*(\}|\]))","\g<1>", js)
        js = re.sub(r",\s*$","", js)

        # catalogue calls return a set of values but without at array enclosure so will fail syntax check
        if not use_catalogue_call:
            try:
                jso = json.loads(js)

                # prettify
                js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))

            except Exception as e:
                print("  "+e)
                # Stop malformed machine json screwing up everything else!
                js = ''

    else:
        raise Exception("Syntax error")

    return js


def vit_file(v):
    return v['file']

def catalogue():
    print("Catalogue")
    print("---------")

    md = "# Vitamin Catalogue\n\n"


    target_dir = "../docs"
    src_dir = "../vitamins/"

    print("Looking for vitamin files...")

    js = '[\n'

    files = 0
    errorlevel = 0

    for filename in os.listdir(src_dir):
        if filename[-5:] == '.scad':
            print("  Parsing: "+filename)

            s = ''

            try:
                s = parse_vitamin(filename, True)
            except:
                errorlevel = 1

            if (s > ''):
                if (files > 0):
                    js += ', '
                js += s
                files += 1

            if s == '':
                print ("  Trying the default vitamin...")
                try:
                    s = parse_vitamin(filename, False)
                except:
                    errorlevel = 1

                if (s > ''):
                    if (files > 0):
                        js += ', '
                    js += s
                    files += 1



    js += ']';

    # get rid of trailing commas
    js = re.sub(r",(\s*(\}|\]))","\g<1>", js, re.M)


    # parse - ignore errors up to this point
    try:
        jso = json.loads(js)

        print("Parsed "+str(files)+" vitamin files")

        dom = {'vitamins':[]}

        for v in jso:
            if type(v) is DictType and v['type'] == 'vitamin':
                try:
                    compile_vitamin(v, dom)
                except Exception as e:
                    print("Exception: ")
                    print(e)

        # table of contents
        dom['vitamins'].sort(key=vit_file, reverse=False)
        md += "### Contents\n"
        for v in dom['vitamins']:
            md += " * [" + vit_filename(v).replace('_','\\_') + " ](#" + vit_filename(v).replace('.','').lower() + ")\n"

        md += "\n\n"

        # vitamin tables
        for v in dom['vitamins']:
            md += output_vitamin(v)


    except Exception as e:
        print(e)
        errorlevel = 1



    print("Saving markdown")
    mdpath = target_dir + '/VitaminCatalogue.md'
    with open(mdpath,'w') as f:
        f.write(md)






if __name__ == '__main__':
    sys.exit(catalogue())
