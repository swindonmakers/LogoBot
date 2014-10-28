#!/usr/bin/env python

# Generate the BOM

from __future__ import print_function

import os
import sys
import shutil
import openscad
from views import polish

source_dir = "assemblies"

force_update = 0;

def find_scad_file(assembly):
    for filename in os.listdir(source_dir):
        if filename[-5:] == ".scad":
            #
            # look for module which makes the assembly
            #
            for line in open(source_dir + "/" + filename, "r").readlines():
                words = line.split()
                if len(words) and words[0] == "module":
                    module = words[1].split('(')[0]
                    if module == assembly:
                        return filename


    return None

class BOM:
    def __init__(self):
        self.count = 1
        self.name = ''
        self.vitamins = {}
        self.printed = {}
        self.assemblies = {}
        self.steps = {}

    def add_part(self, s):
        if s[-4:] == ".stl":
            parts = self.printed
        else:
            parts = self.vitamins
        if s in parts:
            parts[s] += 1
        else:
            parts[s] = 1

    def add_assembly(self, ass):
        if ass in self.assemblies:
            self.assemblies[ass].count += 1
        else:
            self.assemblies[ass] = BOM()
            
    def add_step(self, n, s):
        self.steps[n] = {'num': n, 'description': s, 'view': ''}
        
    def add_step_view(self, n, v):
        self.steps[n]['view'] = v

    def make_name(self, ass):
        if self.count == 1:
            return ass
        return ass.replace("assembly", "assemblies")

    def print_bom(self, breakdown, file = None):
        
        if (self.vitamins):
            print("### Vitamins", file=file)
            print(file=file)
        
            headings = ""
            underline = ""
            if breakdown:
                # Table headings
                line = ""
                underline = ""
                for ass in sorted(self.assemblies):
                    name = ass.replace("_assembly","").replace("_"," ").capitalize()
                    headings += name
                    underline += "---"
                    headings += " | "
                    underline += " | "
            headings += " Qty | Vitamin | Image "
            underline += " --- | --- | ---"
            print(headings, file=file)
            print(underline, file=file)
        
            for part in sorted(self.vitamins):
                if ': ' in part:
                    part_no, description = part.split(': ')
                else:
                    part_no, description = "", part
                if breakdown:
                    # Row for each vitamin
                    for ass in sorted(self.assemblies):
                        bom = self.assemblies[ass]
                        if part in bom.vitamins:
                            file.write("%2d|" % bom.vitamins[part])
                        else:
                            file.write("  |")
                print("%3d" % self.vitamins[part], " | ["+description+"](../vitamins/"+description.split("_")[0]+".scad) | ![](../vitamins/views/"+description+".png)", file=file)

            print(file=file)
        
        if (self.printed):
            print("### Printed Parts", file=file)
            print(file=file)
            
            # Table headings
            headings = ""
            underline = ""
            if breakdown:
                for ass in sorted(self.assemblies):
                    name = ass.replace("_assembly","").replace("_"," ").capitalize()
                    headings += name
                    underline += "---"
                    headings += " | "
                    underline += " | "
            headings += " Qty | STL Filename | Image"
            underline += " --- | --- | ---"
            print(headings, file=file)
            print(underline, file=file)
            
            # Row for each printed part
            for part in sorted(self.printed):
                if breakdown:
                    for ass in sorted(self.assemblies):
                        bom = self.assemblies[ass]
                        if part in bom.printed:
                            file.write("%2d|" % bom.printed[part])
                        else:
                            file.write("  |")
                print("%3d" % self.printed[part], " | ["+part+"](../stl/"+part+") | ![](../images/"+part[:-4]+"_STL.png)", file=file)

        print(file=file)
        if self.assemblies:
            print("### Sub-Assemblies", file=file)
            print(file=file)
            
            print("Qty | Sub-Assembly Name", file=file)
            print("--- | ---", file=file)
            
            for ass in sorted(self.assemblies):
                print("%3d | %s" % (self.assemblies[ass].count, "[" + self.assemblies[ass].make_name(ass) + " Assembly](#"+self.assemblies[ass].make_name(ass)+" Assembly)"), file=file)
        
        print(file=file)
        if self.steps and self.name != 'BOM':
            print("### Assembly Steps", file=file)
            print(file=file)
            
            for step in self.steps:
                print(str(self.steps[step]['num']) + '. '+self.steps[step]['description'], file=file)
                png_name = 'images/'+ self.name +'Assembly_Step'+str(self.steps[step]['num'])+'.png'
                print('![](../'+png_name+')', file=file)
                
                # Now generate a matching view!
                words = self.steps[step]['view'].split();
                
                # Up-sample images
                w = int(words[0]) * 2
                h = int(words[1]) * 2
                
                dx = float(words[2])
                dy = float(words[3])
                dz = float(words[4])
                
                rx = float(words[5])
                ry = float(words[6])
                rz = float(words[7])
                
                d = float(words[8])
                camera = "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f" % (dx, dy, dz, rx, ry, rz, d)
                
                src_name = 'assemblies/' + self.name + '.scad'
                scad_name = 'views/temp.scad'
                
                f = open(scad_name, "w")
                f.write("include <../config/config.scad>\n")
                f.write("DebugConnectors = false;\n");
                f.write("DebugCoordinateFrames = false;\n");
                f.write("$Explode = true;\n");
                f.write("$ShowStep = "+ str(step) +";\n");
                f.write("%sAssembly();\n" % self.name);
                f.close()
                
                if (force_update) or (not os.path.isfile(png_name) or os.path.getmtime(png_name) < os.path.getmtime(src_name)):                    
                    openscad.run(
                                "--camera=" + camera,
                                "--imgsize=%d,%d" % (w, h),
                                "--projection=p",
                                "-o", png_name, 
                                scad_name)
                    print                
                    polish(png_name, w/2, h/2)
                else:
                    print("  Up to date")
                    
                os.remove(scad_name)
        

def boms(assembly = None):

    print("BOM")
    print("---")

    bom_dir = "bom"
    if assembly:
        bom_dir += "/accessories"
        if not os.path.isdir(bom_dir):
            os.makedirs(bom_dir)
    else:
        assembly = "LogoBotAssembly"
        if os.path.isdir(bom_dir):
            shutil.rmtree(bom_dir)
        os.makedirs(bom_dir)

    #
    # Find the scad file that makes the module
    #
    scad_file = find_scad_file(assembly)
    if not scad_file:
        raise Exception("can't find source for " + assembly)
    #
    # make a file to use the module
    #
    bom_maker_name = bom_dir + "/bom.scad"
    f = open(bom_maker_name, "w")
    f.write("include <../config/config.scad>\n")
    f.write("%s();\n" % assembly);
    f.close()
    #
    # Run openscad
    #
    print("Generating BOM for "+assembly+" ...")
    openscad.run("-D","$bom=2","-o", "dummy.csg", bom_maker_name)
    os.remove(bom_maker_name)
    print("Parsing BOM ...")

    main = BOM()
    stack = []

    for line in open("openscad.log"):
        pos = line.find('ECHO: "')
        if pos > -1:
            s = line[pos + 7 : line.rfind('"')]
            if s[-1] == '/':
                ass = s[:-1]
                if stack:
                    main.assemblies[stack[-1]].add_assembly(ass)    #add to nested BOM
                stack.append(ass)
                main.add_assembly(ass)                              #add to flat BOM
            else:
                if s[0] == '/':
                    if s[1:] != stack[-1]:
                        raise Exception("Mismatched assembly " + s[1:] + str(stack))
                    stack.pop()
                else:
                    cpos = s.find(': ');
                    if cpos > -1:
                        if s[:4] == 'Step':
                            main.add_step(int(s[5:cpos]), s[cpos+2:])
                            if stack:
                                main.assemblies[stack[-1]].add_step(int(s[5:cpos]), s[cpos+2:])
                        elif s[:4] == 'View':
                            main.add_step_view(int(s[5:cpos]), s[cpos+2:])
                            if stack:
                                main.assemblies[stack[-1]].add_step_view(int(s[5:cpos]), s[cpos+2:])
                    else:
                        main.add_part(s)
                        if stack:
                            main.assemblies[stack[-1]].add_part(s)

    print("Found "+str(len(main.assemblies)) + " sub-assemblies")
    
    if assembly == "LogoBotAssembly":
        print("Writing summary BOM")
        main.name = 'BOM'
        main.print_bom(False, open(bom_dir + "/bom.md","wt"))

    for ass in sorted(main.assemblies):
        print("Writing BOM for sub-assembly: "+ass)
        f = open(bom_dir + "/" + ass + ".md", "wt");
        bom = main.assemblies[ass]
        bom.name = ass
        print("## " + bom.make_name(ass) + " Assembly", file=f)
        print(file=f)
        bom.print_bom(False, f)
        f.close()

    print(" done")

if __name__ == '__main__':
    boms()