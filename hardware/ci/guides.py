#!/usr/bin/env python

# Generate the assembly guides for each machine, as well as index files

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
import jsontools
import views
import pystache
from types import *
from assemblies import machine_dir

def md_filename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I) + '.md'
    
def htm_filename(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I) + '.htm'
    
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


def gen_assembly(m, a):
    md = '## '+a['title']
    if a['qty'] > 1:
        md += ' (x'+str(a['qty'])+')'
    md += '\n\n'
    
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
        
    # assembly steps
    if len(a['steps']) > 0:
        md += '### Assembly Steps\n\n'
        for step in a['steps']:
            md += str(step['num']) + '. '+step['desc'] + '\n'
            for view in step['views']:
                md += '![](../assemblies/'+machine_dir(m['title'])+'/'+views.view_filename(a['title']+'_step'+str(step['num'])+'_'+view['title'])+')\n'
        md += '\n'
    
    md += '\n'
    
    return md


def assembly_level(a):
    return a['level']

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

    guide_template = target_dir + "/templates/AssemblyGuide.htm"
    index_template = target_dir + "/templates/index.htm"
    index_file = target_dir + '/index.htm'

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()
    
    dl = {'type':'docs', 'guides':[] }
    jso.append(dl)
    
    # for each machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine':
            print(m['title'])
            
            md = ''
        
            md += '# '+m['title'] + '\n'
            md += '# Assembly Guide\n\n'
            
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
            # sort by level desc
            m['assemblies'].sort(key=assembly_level, reverse=True)
            for a in m['assemblies']:
                md += gen_assembly(m,a)
            
            
            print("  Saving markdown")
            mdfilename = md_filename(m['title'] +'AssemblyGuide')
            mdpath = target_dir + '/' +mdfilename
            with open(mdpath,'w') as f:
                f.write(md)
                
            print("  Generating htm")
            htmfilename = htm_filename(m['title'] +'AssemblyGuide')
            htmpath = target_dir + '/' + htmfilename
            with open(htmpath, 'w') as f:
                for line in open(guide_template, "r").readlines():
                    line = line.replace("{{mdfilename}}", mdfilename)
                    f.write(line)
                
            dl['guides'].append({'title':m['title'], 'mdfilename':mdfilename, 'htmfilename':htmfilename})
                    
                
    # Generate index file
    print("Saving index")
    with open(index_file,'w') as o:
        with open(index_template,'r') as i:
            o.write(pystache.render(i.read(), dl))
                
    
                
    return 0
            

if __name__ == '__main__':
    guides()