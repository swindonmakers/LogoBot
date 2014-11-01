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
from publish import publish

def build(do_publish=0):
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
    
    if errorlevel == 0:
        errorlevel += vitamins()
    if errorlevel == 0:
        errorlevel += printed()
    if errorlevel == 0:
        errorlevel += assemblies()
    if errorlevel == 0:
        errorlevel += machines()

    if errorlevel == 0:
        errorlevel += guides()
        
    if errorlevel == 0 and do_publish > 0:
        publish()
    
    
    # if everything is ok then delete backup - no longer required
    if errorlevel == 0:
        os.remove(oldfile)

    return errorlevel

if __name__ == '__main__':
    if len(sys.argv) == 2:
        sys.exit(build(sys.argv[1]))
    else:
        sys.exit(build(0))