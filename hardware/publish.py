#!/usr/bin/env python

# Publish the web content to ../../snhack.github.io/LogoBot


import sys
import os
import shutil

target_dir = '../../snhack.github.io/LogoBot'


def copyall(src, dst, include=None):
    print('Copying from '+src+ ' to '+dst)
    names = os.listdir(src)
    if include is not None:
        included_names = include(src, names)
    else:
        included_names = set()

    if not os.path.isdir(dst):
        os.makedirs(dst)
    errors = []
    for name in names:
        srcname = os.path.join(src, name)
        dstname = os.path.join(dst, name)
        if name not in included_names and not os.path.isdir(srcname):
            continue
        print(srcname + ' --> '+dstname)
        try:
            if os.path.isdir(srcname):
                copyall(srcname, dstname, include)
            else:
                shutil.copy2(srcname, dstname)
        except (IOError, os.error) as why:
            errors.append((srcname, dstname, str(why)))
    try:
        shutil.copystat(src, dst)
    except shutil.WindowsError:
        # can't copy file access times on Windows
        pass
    except OSError as why:
        errors.extend((src, dst, str(why)))
    if errors:
        for err in errors:
            print(err)

def publish():
    print("Publish")
    print("-------")
    
    if not os.path.isdir(target_dir):
        print('Target_dir missing: '+target_dir)
    else:
        print('Publishing to: '+target_dir)       
        
        for name in os.listdir(target_dir):
            p = os.path.join(target_dir, name)
            if os.path.isdir(p):
                shutil.rmtree(p)
            else:
                os.remove(p)
        
        copyall('./',target_dir, include=shutil.ignore_patterns('*.md', '*.js','*.png','*.css','*.htm','*.stl'))
        
if __name__ == '__main__':
    publish()