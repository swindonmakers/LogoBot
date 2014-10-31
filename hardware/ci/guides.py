#!/usr/bin/env python

# Generate the assembly guides for each machine

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
import jsontools
import views
from types import *

def md_filename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I) + '.md'
    
    
def gen_intro(m):
    md = ''
    
    note = jsontools.get_child_by_key_values(m, kvs={'type':'markdown', 'section':'introduction'})
    if note:
        md += note['markdown'] + '\n\n'
        
    return md
    
def gen_bom(m):
    md = '## Bill of Materials\n\n'
    
    md += 'Make sure you have all of the following parts before you begin.\n\n'
     
    # vitamins
    if len(m['vitamins']) > 0:
        md += '### Vitamins\n\n'
        md += 'Qty | Vitamin | Image\n'
        md += '--- | --- | ---\n'
        for v in m['vitamins']:
            md += str(v['qty']) + ' | '
            md += '['+v['title']+']() | '
            md += '![](../vitamins/images/'+views.view_filename(v['title']+'_view') + ') | '
            md += '\n'
        md += '\n'
                
    # printed parts
    if len(m['printed']) > 0:
        md += '### Printed Parts\n\n'
        md += 'Qty | Part Name | Image\n'
        md += '--- | --- | ---\n'
        for v in m['printed']:
            md += str(v['qty']) + ' | '
            md += '['+v['title']+'](../printedparts/stl/'+ openscad.stl_filename(v['title']) +') | '
            md += '![](../printedparts/images/'+views.view_filename(v['title']+'_view') + ') | '
            md += '\n'
        md += '\n'
    
    md += '\n'
    
    return md


def gen_assembly(a):
    md = '## '+a['title']+'\n\n'
    
    # vitamins
    if len(a['vitamins']) > 0:
        md += '### Vitamins\n\n'
        md += 'Qty | Vitamin | Image\n'
        md += '--- | --- | ---\n'
        for v in a['vitamins']:
            md += str(v['qty']) + ' | '
            md += '['+v['title']+']() | '
            md += '![](../vitamins/images/'+views.view_filename(v['title']+'_view') + ') | '
            md += '\n'
        md += '\n'
                
    # printed parts
    if len(a['printed']) > 0:
        md += '### Printed Parts\n\n'
        md += 'Qty | Part Name | Image\n'
        md += '--- | --- | ---\n'
        for v in a['printed']:
            md += str(v['qty']) + ' | '
            md += '['+v['title']+'](../printedparts/stl/'+ openscad.stl_filename(v['title']) +') | '
            md += '![](../printedparts/images/'+views.view_filename(v['title']+'_view') + ') | '
            md += '\n'
        md += '\n'
            
    # sub-assemblies
    if len(a['assemblies']) > 0:
        md += '### Sub-Assemblies\n\n'
        md += 'Qty | Name \n'
        md += '--- | --- \n'
        for v in a['assemblies']:
            md += str(v['qty']) + ' | '
            md += v['title']
            md += '\n'
        md += '\n'
    
    md += '\n'
    
    return md


def guides():
    print("Guides")
    print("------")

    temp_name =  "temp.scad"

    #
    # Make the target directories
    #
    target_dir = "../docs"
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            
            md = ''
        
            md += '# '+m['title'] + ' Assembly Guide\n\n'
            
            # machine views
            for c in m['children']:
                if type(c) is DictType and c['type'] == 'view':
                    view = c
                    md += '!['+view['caption']+']('+ view['filepath'] +')\n\n'
            
            # intro
            md += gen_intro(m)
            
            
            # BOM
            md += gen_bom(m)
            
            # Assemblies
            for a in m['assemblies']:
                md += gen_assembly(a)
            
            
            print("  Saving markdown")
            mdfile = target_dir + '/' +md_filename(m['title'] +'AssemblyGuide')
            with open(mdfile,'w') as f:
                f.write(md)
            

if __name__ == '__main__':
    guides()