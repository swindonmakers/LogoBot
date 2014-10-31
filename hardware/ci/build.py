#!/usr/bin/env python

# Run the various build scripts

import sys
import os
from parse import parse_machines
from machines import machines
from assemblies import assemblies
from vitamins import vitamins
from printed import printed
from guides import guides

def build():
    print("Build")
    print("-----")
    
    outfile = 'hardware.json'
    oldfile = 'backup.json'
    
    print("Backup current json...")
    oldjso = None
    if os.path.isfile(outfile) and not os.path.isfile(oldfile):
        os.rename(outfile, oldfile) 
    
    errorlevel = 0
    
    errorlevel += parse_machines()
    
    errorlevel += vitamins()
    errorlevel += printed()
    errorlevel += assemblies()
    errorlevel += machines()
    
    errorlevel += guides()
    
    
    # if everything is ok then delete backup - no longer required
    if errorlevel == 0:
        os.remove(oldfile)

    return errorlevel

if __name__ == '__main__':
    sys.exit(build())