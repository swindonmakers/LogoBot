#!/usr/bin/env python

# Run the various build scripts

import sys
from static import static
from bom import boms
from stls import stls
from views import views
from vitamins import vitamins
from publish import publish

def build(force_update):
    print("Build")
    print("---")
    
    if static() == 0:
        boms()
        stls()
        vitamins(force_update)
        views(force_update)
        publish()
    else:
        print("Build Aborted - Static analysis found errors!")

if __name__ == '__main__':
    if len(sys.argv) == 2:
        build(sys.argv[1])
    else:
        build(0)
    