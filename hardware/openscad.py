from __future__ import print_function

import subprocess

openscad_path = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

def run(*args):
    print("openscad", end=" ")
    for arg in args:
        print(arg, end=" ")
    print()
    log = open("openscad.log", "w")
    subprocess.call([openscad_path] + list(args), stdout = log, stderr = log)
    log.close()
