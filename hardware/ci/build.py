#!/usr/bin/env python

# Run the various build scripts

import sys
from parse import parse_machines
from machines import machines
from vitamins import vitamins
from printed import printed
from guides import guides

def build():
    print("Build")
    print("-----")
    
    parse_machines()
    
    machines()
    vitamins()
    printed()
    
    guides()

if __name__ == '__main__':
    build()