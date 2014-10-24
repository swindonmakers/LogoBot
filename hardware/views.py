#!/usr/bin/env python

# Renders pre-defined views into the images directory

import os
from PIL import Image
import sys
import shutil
import openscad

# OpenSCAD default background colour
bkc = (255,255,229,255)

def polish(filename, w, h):
    img = Image.open(filename)
    img = img.convert("RGBA")

    pixdata = img.load()

    # Read top left pixel color - not robust to zoomed in images
    # bkc = pixdata[0,0]

    # init clipping bounds
    x1 = img.size[0]
    x2 = 0
    y1 = img.size[1]
    y2 = 0
    
    
    # Set background to white and transparent
    for y in xrange(img.size[1]):
        solidx = 0
        solidy = 0
        for x in xrange(img.size[0]):
            if pixdata[x, y] == bkc:
                pixdata[x, y] = (255, 255, 255, 0)
            else:
                if solidx == 0 and x < x1:
                    x1 = x
                if solidy == 0 and y < y1:
                    y1 = y
                solidx = x
                solidy = y
        if solidx > x2:
            x2 = solidx
        if solidy > y2:
            y2 = solidy
            
    x2 += 2
    y2 += 2
    
    print(x1, x1, x2, y2)
                
    # downsample (half the res)
    img = img.resize((w, h), Image.ANTIALIAS)
                
    # crop
    img = img.crop((x1/2,y1/2,x2/2,y2/2))
                
    # Save it
    img.save(filename)



def views(force_update):
    print("Views")
    print("---")

    scad_dir = "views"
    render_dir = "images"

    if not os.path.isdir(render_dir):
        os.makedirs(render_dir)
    
    # List of "view" scad files
    #
    scads = [i for i in os.listdir(scad_dir) if i[-5:] == ".scad"]

    for scad in scads:
        scad_name = scad_dir + os.sep + scad
        png_name = render_dir + os.sep + scad[:-4] + "png"

        print "Checking: " + scad_name

        view_count = 0
        for line in open(scad_name, "r").readlines():
            words = line.split()
            if len(words) > 10 and words[0] == "//":
                
                cmd = words[1]
                if cmd == "view":
                    view_count += 1
                    
                    # Up-sample images
                    w = int(words[2]) * 2
                    h = int(words[3]) * 2
                    
                    dx = float(words[4])
                    dy = float(words[5])
                    dz = float(words[6])
                    
                    rx = float(words[7])
                    ry = float(words[8])
                    rz = float(words[9])
                    
                    d = float(words[10])
                    camera = "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f" % (dx, dy, dz, rx, ry, rz, d)
                    
                    if (force_update) or (not os.path.isfile(png_name) or os.path.getmtime(png_name) < os.path.getmtime(scad_name)):                    
                        openscad.run("--projection=p",
                                    ("--imgsize=%d,%d" % (w, h)),
                                    "--camera=" + camera,
                                    "-o", png_name, 
                                    scad_name)
                        print                
                        polish(png_name, w/2, h/2)
                    else:
                        print("  Up to date")
                    
        if view_count < 1:
            print("  No views found - you need to define at least one view")

if __name__ == '__main__':
    if len(sys.argv) == 2:
        views(sys.argv[1])
    else:
        views(0)
    