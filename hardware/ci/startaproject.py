#!/usr/bin/env python

# Utility script to start a new project, using the current project as a template

import sys
import os
import string
from shutil import copytree, ignore_patterns, copy2


def startaproject(proj_parent_path, proj_name):

    # TODO: build directory structure, copy key files, use template for root scad file

    proj_path = proj_parent_path + '/' + proj_name

    if (os.path.isdir(proj_parent_path) is not True):
        print("Parent directory does not exist: "+proj_parent_path)
        sys.exit()

    if (os.path.isdir(proj_path)):
        print("Warning: Project directory already exists: "+proj_path)
        try:
            input("Press enter to continue")
        except SyntaxError:
            pass
    else:
        print("Creating project directory: "+proj_path)
        os.mkdir(proj_path)

    print("Create directory structure")
    try:
        os.mkdir(proj_path + '/hardware')
        os.mkdir(proj_path + '/hardware/assemblies')
        os.mkdir(proj_path + '/hardware/config')
        os.mkdir(proj_path + '/hardware/docs')
        os.mkdir(proj_path + '/hardware/images')
        os.mkdir(proj_path + '/hardware/printedparts')
        os.mkdir(proj_path + '/hardware/cutparts')
        os.mkdir(proj_path + '/hardware/sandbox')
    except OSError:
        pass

    print("Copy ci scripts")
    try:
        copytree(".", proj_path + '/hardware/ci', ignore=ignore_patterns('*.pyc', 'tmp*'))
    except OSError:
        pass

    print("Copy util scripts")
    try:
        copytree("../utils", proj_path + '/hardware/utils', ignore=ignore_patterns('*.pyc', 'tmp*'))
    except OSError:
        pass

    print("Copy vitamins")
    try:
        copytree("../vitamins", proj_path + '/hardware/vitamins', ignore=ignore_patterns('*.pyc', 'tmp*'))
    except OSError:
        pass

    print("Copy doc templates, etc")
    try:
        copy2("../docs/VitaminCatalogue.htm",proj_path + "/hardware/docs/VitaminCatalogue.htm")
        copytree("../docs/templates", proj_path + '/hardware/docs/templates', ignore=ignore_patterns('*.pyc', 'tmp*'))
        copytree("../docs/css", proj_path + '/hardware/docs/css', ignore=ignore_patterns('*.pyc', 'tmp*'))
        copytree("../docs/js", proj_path + '/hardware/docs/js', ignore=ignore_patterns('*.pyc', 'tmp*'))
    except OSError:
        pass


    print("Copy common config files")
    copy2("../config/holesizes.scad",proj_path + "/hardware/config/holesizes.scad")
    copy2("../config/colors.scad",proj_path + "/hardware/config/colors.scad")
    copy2("../config/config.scad",proj_path + "/hardware/config/config.scad")
    copy2("../config/utils.scad",proj_path + "/hardware/config/utils.scad")

    print("Copy template config files")
    copy2("assemblies.scad",proj_path + "/hardware/config/assemblies.scad")
    copy2("machine.scad",proj_path + "/hardware/config/machine.scad")
    copy2("printedparts.scad",proj_path + "/hardware/config/printedparts.scad")
    copy2("cutparts.scad",proj_path + "/hardware/config/cutparts.scad")
    copy2("vitamins.scad",proj_path + "/hardware/config/vitamins.scad")

    print("Setup root scad file")
    templateFile = "root.scad"
    outFile = proj_path + "/hardware/" + proj_name + ".scad"
    if os.path.isfile(templateFile):
        f = open(templateFile,"r")
        template = f.read()
        f.close()

        s = string.Template(template).substitute({'name':proj_name});

        with open(outFile,'w') as o:
            o.write(s)
    else:
        print(templateFile + " template is missing")



if __name__ == '__main__':
    if len(sys.argv) == 3:
        startaproject(sys.argv[1], sys.argv[2])
    else:
        print("Usage: ./startaproject.py <in-dir> <name>")
        print("  <in-dir> is directory within which to create the project")
        print("  <name> is used for the top-level directory and for the root scad file, no spaces!")
