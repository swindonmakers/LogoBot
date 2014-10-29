#!/usr/bin/env python

# run the continuous integration process
# includes watching the git repo for pull requests and commits

import os
import sys
import requests
from time import sleep, gmtime, strftime

repo_owner = 'snhack'
repo_name = 'LogoBot'

repos_rel_dir = '../../../'
primary_repo_dir = 'LogoBot'
staging_repo_dir = primary_repo_dir + 'Staging'

def poll(un, pw, proxies):
    print("Polling for pull requests for commits...")
    
    while True:
        print(strftime("%H:%M:%S", gmtime()))
        print("Getting list of pull requests...")
        
        r = requests.get('https://api.github.com/repos/'+repo_owner+'/'+repo_name+'/pulls', auth=(un, pw), proxies=proxies)
        
        json = r.json()
        
        for p in json:
            print(p['number'])
            print(p['title'])
            print(p['body'])
            print(p['state'])
            print(p['merged_at'])
            print(p['updated_at'])
            
            # Refresh the repo in staging (master branch)
            
            o = check_output(['git','pull','origin','master'])
            print(o)
            
        
        sleep(60)
    

def ci(un, pw, http_proxy="", https_proxy=""):
    print("Continuous Integration")
    print("----------------------")
    
    proxies = {
      "http": http_proxy,
      "https": https_proxy,
    }
    
    print("")
    print("Checking connection to github...")
    
    r = requests.get('https://api.github.com/user', auth=(un, pw), proxies=proxies)
    if r.status_code == 200:
        print("  OK")
        
        print("Changing working directory...")
        os.chdir(repos_rel_dir)
        
        print("  Now in: "+os.getcwd())
        
        print("Changing to staging dir: "+staging_repo_dir)
        if os.path.isdir(staging_repo_dir):
            os.chdir(staging_repo_dir)
            print("  OK")
            
            # Could check for empty dir here and if so, do a git clone?
            # git clone git@github.com:snhack/LogoBot .
            
            poll(un, pw, proxies)
        
        else:
            print("  Error: Staging dir does not exist")
        
    
    else:
        print("  Error")
        print("  Status Code: "+r.status_code)
        print("  Response: "+r.text)
    
    
    
    # o = check_output(['git','branch'])

if __name__ == '__main__':
    if len(sys.argv) >= 3:
        ci(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    else:
        print("Usage: ci <git-username> <git-password> <http_proxy> <https_proxy>")