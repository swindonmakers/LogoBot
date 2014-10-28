#!/usr/bin/env python

# Perform static code analysis

from __future__ import print_function

import os
import sys
import shutil
import re


# Utility functions

def init_totals():
	return [0 for i in range(SEVERITY_ERROR + 1)];
	
def find_scad_file(assembly):
    for filename in os.listdir(source_dir):
        if filename[-5:] == ".scad":
            #
            # look for module which makes the assembly
            #
            for line in open(source_dir + "/" + filename, "r").readlines():
                words = line.split()
                if len(words) and words[0] == "module":
                    module = words[1].split('(')[0]
                    if module == assembly:
                        return filename


    return None
	
# Severity levels
SEVERITY_OK = 0
SEVERITY_INFO = 1
SEVERITY_WARNING = 2
SEVERITY_ERROR = 3

# Faster regex
_regexp_compile_cache = {}

def match(pattern, s):
  """Matches the string with the pattern, caching the compiled regexp."""
  if pattern not in _regexp_compile_cache:
    _regexp_compile_cache[pattern] = re.compile(pattern)
  return _regexp_compile_cache[pattern].match(s)
	
# Reusable regex patterns
re_upper_camel_case = "([A-Z][a-z0-9]+)+";
	
"""
Report structure

report ->
	count by severity
	section ->
		count by severity
		file ->
			count by severity
			errors [ severity ] [ item ] =  description

"""

# Global vars
	
report = {'totals':init_totals(), 'sections': {} }

# rules
	
def assembly_filename_format(fn):
	print(match(re_upper_camel_case, fn[:-4]))

# * Module name matches filename
# * Assembly module contains step() calls
# * File does not contain any include or use statements
# * Any variables have correct naming convention
# * Any supplementary modules have correct naming convention
# * Any functions have correct naming convention
# * Any included _STL modules have associated _View modules
# * _View modules contain an echo line with correct structure
# * Exists in /config/assemblies.scad

	
# section processors
	
def proc_assemblies(fn, f):
	print("Validating assembly: "+fn)
	
	# Apply validation rules
	assembly_filename_format(fn)
	
# stuff

def update_file_totals(f):
	print("")	

def update_section_totals(sec):
	for f in sec['files']:
		print(f)
	
def add_file(sec, fn):
	f = {'name':fn, 'totals':init_totals(), 'errors':[] }
	sec[fn] = f
	return f
	
def do_section(target_dir, processor, sec):
	print("Section: "+target_dir)
	for filename in os.listdir(target_dir):
		if filename[-5:] == ".scad":
			processor(filename, add_file(sec, filename))

	update_section_totals(sec)
	
def add_section(s):
	sec = {'name':s, 'totals':init_totals(), 'files':{} }
	report['sections'][s] = sec
	return sec

	
def static():
	print()
	print("Static Analysis")
	print("---------------")
	
	do_section('assemblies', proc_assemblies, add_section('Assemblies'))
	
	
	print()
	
if __name__ == '__main__':
    static()