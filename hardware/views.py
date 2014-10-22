#!/usr/bin/env python

# Renders pre-defined views into the images directory

import os
from PIL import Image
import sys
import shutil
import openscad

def polish(filename, w, h):
	img = Image.open(filename)
	img = img.convert("RGBA")

	pixdata = img.load()

	# Read top left pixel color
	bkc = pixdata[0,0]

	# Set background to white and transparent
	for y in xrange(img.size[1]):
   		for x in xrange(img.size[0]):
   			if pixdata[x, y] == bkc:
   				pixdata[x, y] = (255, 255, 255, 0)
   				
   	# downsample (half the res)
   	img = img.resize((w, h), Image.ANTIALIAS)
   				
   	# Save it
   	img.save(filename)



def views(force_update):
    scad_dir = "views"
    render_dir = "images"

    if not os.path.isdir(render_dir):
        os.makedirs(render_dir)
    
    # List of individual part files
    #
    scads = [i for i in os.listdir(scad_dir) if i[-5:] == ".scad"]

    for scad in scads:
        scad_name = scad_dir + os.sep + scad
        png_name = render_dir + os.sep + scad[:-4] + "png"

        print "Checking: " + scad_name

        for line in open(scad_name, "r").readlines():
            words = line.split()
            if len(words) > 10 and words[0] == "//":
            	
            	cmd = words[1]
            	if cmd == "view":
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
									
						polish(png_name, w/2, h/2)
                    print

if __name__ == '__main__':
	if len(sys.argv) == 2:
		views(sys.argv[1])
	else:
		views(0)
    