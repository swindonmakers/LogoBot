# utility functions for working with json

from types import *

# merges keys from j2 into j1
def json_merge(j1, j2, overwrite=False):
    for key in j2:
        if (not key in j1) or overwrite:
            j1[key] = j2[key];
    
def get_child_by_key_values(j1, kvs={}):
    if 'children' in j1:
        for c in j1['children']:
            if type(c) is DictType:
                match = True
                for kv in kvs:
                    if not (kv in c and c[kv] == kvs[kv]):
                        match = False
                if match:
                    return c
    return None
    