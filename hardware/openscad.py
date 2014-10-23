from __future__ import print_function

import subprocess

# openscad_path = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

def which(program):
    import os
    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None

def run(*args):
    print("openscad", end=" ")
    for arg in args:
        print(arg, end=" ")
    print()
    log = open("openscad.log", "w")
    prog = which('OpenSCAD')
    if prog == None:
        print("Unable to locate OpenSCAD executable... check your PATH")
    else:
        subprocess.call([prog] + list(args), stdout = log, stderr = log)
    log.close()
