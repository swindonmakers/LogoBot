#!/usr/bin/env python

# Run the various build scripts

import sys
from bom import boms
from stls import stls
from views import views
from vitamins import vitamins
from publich import publish

def build(force_update):
    print("Build")
    print("---")
    
    boms()
    stls()
    vitamins(force_update)
    views(force_update)
    publish()

if __name__ == '__main__':
    if len(sys.argv) == 2:
        build(sys.argv[1])
    else:
        build(0)
    