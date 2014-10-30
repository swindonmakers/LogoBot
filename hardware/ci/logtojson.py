#!/usr/bin/env python

import os
import shutil
import sys
import re
import json
import openscad

inputfile = '../LogoBot.scad'
logfile = 'openscad.log'
outfile = 'hardware.json'

openscad.run('-o','dummy.csg',inputfile);

js = '[\n'

for line in open(logfile, "rt").readlines():
	r = re.search(r'^.*ECHO\:\s\"(.*)\"$', line, re.I)
	print(r)
	if r:
		s = r.group(1)
		# rewrite single quotes to double quotes, except for where they are used in words, e.g. isn't
		s = re.sub(r"((\w)['](\W|$))","\g<2>\"\g<3>", s)
		s = re.sub(r"((\W|^)['](\w))","\g<2>\"\g<3>", s)
		s = re.sub(r"((\W)['](\W))","\g<2>\"\g<3>", s)
		
		js += s + '\n'

js += ' ]\n';

# Get rid of any empty objects
js = js.replace("{}","")

# get rid of trailing commas
js = re.sub(r",(\s*(\}|\]))","\g<1>", js)

# parse
try:
    jso = json.loads(js)
    
    # prettify
    js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))
    
    print(js)
except Exception as e:
    print(e)
    

		
outfile = open(outfile,'w')
outfile.write(js)		
outfile.close()