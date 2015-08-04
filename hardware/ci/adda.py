#!/usr/bin/env python

# Utility script to create new parts/assemblies

import sys
import os
import string


def adda(t, n, d):

    template = ""
    templateFile = ""
    outFile = ""
    configFile = ""
    module = ""
    sandbox = ""

    if t == "assembly":
        print("Creating assembly")

        templateFile = "assembly.scad"
        outFile = "../assemblies/" + n + ".scad"
        configFile = "../config/assemblies.scad"
        module = n + "Assembly"
        sandbox = module

    elif t == "printedpart":
        print("Creating printedpart")

        templateFile = "printedpart.scad"
        outFile = "../printedparts/" + n + ".scad"
        configFile = "../config/printedparts.scad"
        module = n + "_STL"
        sandbox = n

    elif t == "cutpart":
        print("Creating cutpart")

        templateFile = "cutpart.scad"
        outFile = "../cutparts/" + n + ".scad"
        configFile = "../config/cutparts.scad"
        module = n
        sandbox = n


    elif t == "vitamin":
        print("Creating vitamin")

        templateFile = "vitamin.scad"
        outFile = "../vitamins/" + n + ".scad"
        configFile = "../config/vitamins.scad"
        module = n
        sandbox = n

    if os.path.isfile(outFile):
        print("File already exists!")
        sys.exit();


    if os.path.isfile(templateFile):
        f = open(templateFile,"r")
        template = f.read()
        f.close()

        s = string.Template(template).substitute({'name':n, 'description':d});

        with open(outFile,'w') as o:
            o.write(s)

        with open(configFile, "a") as o:
                o.write("include <"+outFile+">\n")

    else:
        print(templateFile + " template is missing")

    # Sandbox
    templateFile = "sandbox.scad"
    outFile = "../sandbox/" + t + "_" + sandbox + ".scad"
    if os.path.isfile(templateFile):
        f = open(templateFile,"r")
        template = f.read()
        f.close()

        s = string.Template(template).substitute({'module':module});

        with open(outFile,'w') as o:
            o.write(s)

    else:
        print(templateFile + " template is missing")


if __name__ == '__main__':
    if len(sys.argv) == 4:
        adda(sys.argv[1], sys.argv[2], sys.argv[3] )
    else:
        print("Usage: ./adda.py <type> <name> <description>")
        print("Types: assembly | cutpart | printedpart | vitamin")
