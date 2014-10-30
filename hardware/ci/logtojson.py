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
	r = re.search(r'^ECHO\:\s\"(.*)\"', line, re.I)
	if r:
		# rewrite single quotes to double quotes
		s = r.group(1)
		# s = s.replace("'", '"')
		s = re.sub(r"([^\\])\'","\g<1>\"", s)
		s = s.replace(r"\'", "'")
		js += s + '\n'

js += ' ]\n';

# Get rid of any empty objects
js = js.replace("{}","")

# get rid of trailing commas
js = re.sub(r",(\s*(\}|\]))","\g<1>", js)

# parse
jso = json.loads(js)

# prettify
js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))
		
outfile = open(outfile,'w')
outfile.write(js)		
outfile.close()