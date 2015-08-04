from __future__ import print_function

import sys
from subprocess import call, check_output
import hashlib
import re


def calc_plastic_required(stlpath):
    p = re.compile("\((.*)cm3\)", re.MULTILINE)
    o = check_output(['slic3r',stlpath])
    res = p.search(o)

    # Match stdout of form: Filament required: 9439.3mm (66.7cm3)
    # weight based on density of 1.26 g/cm3

    if res:
        vol = float(res.group(1))
        weight = vol * 1.25/1000
        return {'volume': vol, 'weight':weight}
    else:
        return {'volume': 0, 'weight':0}

if __name__ == '__main__':
    if len(sys.argv) == 2:
        sys.exit(calc_plastic_required(sys.argv[1]))
    else:
        print("Usage: slic3r.py stlpath")
