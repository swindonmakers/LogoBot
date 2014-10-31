#!/usr/bin/env python

# Run the various build scripts

import sys
from parse import parse_machines
from vitamins import vitamins

def build():
    print("Build")
    print("-----")
    
    parse_machines()
    vitamins()

if __name__ == '__main__':
    build()