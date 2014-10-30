#!/usr/bin/env python

import os
import shutil
import sys
import re
import json

logfile = 'test.log'

js = '[\n'

for line in open(logfile, "rt").readlines():
	r = re.search(r'^ECHO\:\s\"(.*)\"', line, re.I)
	if r:
		# rewrite single quotes to double quotes
		s = r.group(1)
		s = s.replace("'", '"')
		js += s + '\n'

js += '{} ]\n';

# get rid of empty objects
js = re.sub(r"\,\s*\{\}","", js, re.M)

outfile = open('json.json','w')
outfile.write(js)		
outfile.close()
		
# parse
jso = json.loads(js)

# prettify
js = json.dumps(jso, sort_keys=True, indent=4, separators=(',', ': '))


print(js)
		
outfile = open('json.json','w')
outfile.write(js)		
outfile.close()