# utility functions for working with json

# merges keys from j2 into j1
def json_merge(j1, j2, overwrite=False):
    for key in j2:
        if (not key in j1) or overwrite:
            j1[key] = j2[key];
    