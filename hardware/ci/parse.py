#!/usr/bin/env python

# Parse json from machine files, build hardware.json

import os
import shutil
import sys
import re
import json
import openscad
from types import *

def parse_machines():
    src_dir = '../'
    logfile = 'openscad.log'
    outfile = 'hardware.json'
    errorfile = 'invalid.json'
    
    print("Parse")
    print("-----")
    
    print("Looking for machine files...")
    
    # reset error file
    if os.path.isfile(errorfile):
        os.remove(errorfile)
    
    js = '[\n'

    files = 0
    
    for filename in os.listdir(src_dir):
        if filename[-5:] == '.scad':
            print("  Parsing: "+filename)
            scadfile = src_dir + filename
            
            if (files > 0):
                js += ', '
            
            s = parse_machine(scadfile, logfile, errorfile)
            
            if (s > ''):
                js += s
                files += 1
                        
    js += ']';
    
    # get rid of trailing commas
    js = re.sub(r",(\s*(\}|\]))","\g<1>", js, re.M)
    
    # parse
    try:
        jso = json.loads(js)

        print("  Parsed "+str(files)+" machine files")
    
        summarise_files(jso)
        
        summarise_parts(jso)
        
        
        # prettify
        js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))
    
        
    except Exception as e:
        print(e)
        
    with open(outfile, 'w') as f:
        f.write(js)
        
    print("")
        

def parse_machine(scadfile, logfile, errorfile):
    openscad.run('-o','dummy.csg',scadfile);
    
    js = ''
    
    syntaxError = False

    for line in open(logfile, "rt").readlines():
        # errors
        r = re.search(r".*syntax error$", line, re.I)
        if r:
            print("  Syntax error!")
            print(line)
            syntaxError = True
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

    if not syntaxError:
        # Get rid of any empty objects
        js = js.replace("{}","")

        # get rid of trailing commas
        js = re.sub(r",(\s*(\}|\]))","\g<1>", js)
        js = re.sub(r",\s*$","", js)
    
        try:
            jso = json.loads(js)
    
            # prettify
            js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))
    
        except Exception as e:
            print(e)
            print("See "+errorfile+" for malformed json")
            with open(errorfile, 'w') as f:
                f.write(js)
            # Stop malformed machine json screwing up everything else!
            js = ''
    
    return js
    
    
# File Summarisation
# ------------------

def in_files(fn, fs):
    for f in fs:
        if f['type'] == 'file' and f['file'] == fn:
            return True
    return False
    
def add_file(fn, fs):
    if not in_files(fn, fs):
        fs.append({ 'type':'file', 'file':fn })
        
def add_file_for(jso, fs):
    if type(jso) is DictType:
        if 'file' in jso:
            add_file(jso['file'], fs)
        
        if 'children' in jso:
            for c in jso['children']:
                add_file_for(c, fs)
        
def summarise_files(jso):
    print("Summarising files for all machines...")
    
    fl = { 'type':'filelist', 'files':[] }
    
    jso.append(fl)
    
    fs = fl['files']
    
    for m in jso:
        add_file_for(m, fs)
        
    print("  Found "+str(len(fs))+" files")
            

# Part Summarisation
# ------------------

def add_view(jso, o):
    vfound = None
    for v in o['views']:
        if v['title'] == jso['title']:
            vfound = v
            continue
    
    if vfound == None:
        vfound = o['views'].append(jso)
        
def add_views_for(jso, o):
    # check for views in children
    for c in jso['children']:
        if type(c) is DictType and c['type'] == 'view':
            add_view(c, o)
            
            
def add_step(jso, o):
    vfound = None
    for v in o['steps']:
        if v['num'] == jso['num']:
            vfound = v
            continue
    
    if vfound == None:
        vfound = {'num':jso['num'], 'desc':jso['desc'], 'views':[] }
        o['steps'].append(vfound)
        
    add_views_for(jso, vfound)
    
            
def add_steps_for(jso, o):
    # check for steps in children
    for c in jso['children']:
        if type(c) is DictType and c['type'] == 'step':
            add_step(c, o)            

            
            
def add_assembly(jso, al):
    print("  Assembly: "+jso['title'])
    
    afound = None
    for a in al:
        if a['title'] == jso['title']:
            afound = a
            continue
    
    if afound:
        afound['qty'] += 1
    else:
        afound = { 'title':jso['title'], 'call':jso['call'], 'file':jso['file'], 'qty':1, 'views':[], 'steps':[] }
        al.append(afound)
        
    add_views_for(jso, afound) 
    add_steps_for(jso, afound)   
            

def add_vitamin(jso, vl):
    print("  Vitamin: "+jso['title'])
    
    vfound = None
    for v in vl:
        if v['title'] == jso['title']:
            vfound = v
            continue
    
    if vfound:
        vfound['qty'] += 1
    else:
        vfound = { 'title':jso['title'], 'call':jso['call'], 'file':jso['file'], 'qty':1, 'views':[] }
        vl.append(vfound)
        
    add_views_for(jso, vfound)
    
    
def add_printed(jso, pl):
    print("  Printed Part: "+jso['title'])
    
    pfound = None
    for p in pl:
        if p['title'] == jso['title']:
            pfound = p
            continue
    
    if pfound:
        pfound['qty'] += 1
    else:
        pfound = { 'title':jso['title'], 'call':jso['call'], 'file':jso['file'], 'qty':1, 'views':[] }
        pl.append(pfound)
        
    add_views_for(jso, pfound)   
    

def summarise_parts_for(jso, al, pl, vl):
    if type(jso) is DictType:
        tn = jso['type']
        
        if tn == 'vitamin':
            add_vitamin(jso, vl)
        
        if tn == 'assembly':
            add_assembly(jso, al)    
        
        if tn == 'printed':
            add_printed(jso, pl) 
        
        if 'children' in jso:
            for c in jso['children']:
                summarise_parts_for(c, al, pl, vl)

def summarise_parts(jso):
    print("Summarising parts for all machines...")
    
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            print("  "+m['title']+"...")
            
            al = m['assemblies'] = []
            pl = m['printed'] = []
            vl = m['vitamins'] = []
            
            for c in m['children']:
                summarise_parts_for(c, al, pl, vl)
                
            print("  Found:")
            print("    "+str(len(al))+" assemblies")
            print("    "+str(len(pl))+" printed parts")
            print("    "+str(len(vl))+" vitamins")



if __name__ == '__main__':
    parse_machines()