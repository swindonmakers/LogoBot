#!/usr/bin/env python

import os
import shutil
import sys
import re
import json
import openscad

inputfile = '../sandbox/damian_playground2.scad'
logfile = 'openscad.log'

openscad.run('-o','dummy.csg',inputfile);

js = '[\n'

for line in open(logfile, "rt").readlines():
	r = re.search(r'^ECHO\:\s\"(.*)\"', line, re.I)
	if r:
		# rewrite single quotes to double quotes
		s = r.group(1)
		s = s.replace("'", '"')
		js += s + '\n'

js += '{} ]\n';

outfile = open('json_empties.json','w')
outfile.write(js)		
outfile.close()

# get rid of empty objects
js = re.sub(r"\,\s*\{\}","\n", js, re.M)
js = re.sub(r"\,\s*\{\}","\n", js, re.M)
js = re.sub(r"\{\}","\n", js, re.M)

outfile = open('json_cleaned.json','w')
outfile.write(js)		
outfile.close()
		
# parse
jso = json.loads(js)

# prettify
js = json.dumps(jso, sort_keys=False, indent=4, separators=(',', ': '))


print(js)
		
outfile = open('json.json','w')
outfile.write(js)		
outfile.close()