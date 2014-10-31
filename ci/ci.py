#!/usr/bin/env python

# run the continuous integration process
# includes watching the git repo for pull requests and commits

import os
import sys
import requests
from time import sleep, gmtime, strftime
from subprocess import call, check_output, CalledProcessError

repo_owner = 'snhack'
repo_name = 'LogoBot'

repos_rel_dir = '../../'
primary_repo_dir = 'LogoBot'
staging_repo_dir = primary_repo_dir + 'Staging'

ci_log_name = 'ci.log'
prhist = []

def dict_in_array(dict, key, value):
    res = False
    for item in dict:
        if item[key] == value:
            res = True
            exit
    return res

def poll(un, pw, proxies):
    
    cilog = open(ci_log_name, 'a+')
    cilog.seek(0)
    
    # load cilog into prhist
    lines = cilog.readlines()
    for line in lines:
        line = line.split('_')
        num = int(line[0])
        dt = line[1]
        if not dict_in_array(prhist, 'number', num):
            prhist.append({'number':num, 'updated_at':dt})

    print("Polling for pull requests for commits...")
    print("")
    
    while True:
        print(strftime("%H:%M:%S", gmtime()))
        print("Getting list of pull requests...")
        
        r = requests.get('https://api.github.com/repos/'+repo_owner+'/'+repo_name+'/pulls', auth=(un, pw), proxies=proxies)
        
        json = r.json()
        
        print("  Found: "+str(len(json))+" pull request(s)")
        
        for p in json:
            print("Checking: #"+str(p['number']) + " - "+ p['title'] + " by "+p['user']['login'])
            """
            print(p['body'])
            print(p['state'])
            print(p['merged_at'])
            print(p['updated_at'])
            """
            
            # check if the pull request is ready to be merged
            if p['state'] == 'open' and p['merged_at']== None:
            
                # check if we've done it before?
                if not dict_in_array(prhist, 'number', p['number']):            
                    try:
                        # Refresh the repo in staging (master branch)
                        print("  Reset staging")
                        o = check_output(['git','reset','--hard','HEAD'])
                            
                        print("  Clean")
                        o = check_output(['git','clean','-f','-d'])
                        print("  Pull master")
                        o = check_output(['git','pull','origin','master'])
                        print(o)
            
                        branch = p['head']['ref']
                        
                        """
                        # Checkout the pull request branch
                        
                        print("  Checkout pull request from: "+branch)
                        o = check_output(['git','checkout','-B',branch,'origin/'+branch])
                        # print(o)
            
                        # merge the pull request into master
                        print("  Merge into master")
                        o = check_output(['git','merge','master'])
                        # print(o)
                        """
                        
                        print("  Checkout master")
                        o = check_output(['git','checkout','master'])
                        print(o)
                        
                        print("  Merge branch: "+branch)
                        o = check_output(['git','merge',branch])
                        print(o)
                        
                        # Now run the build process    
                        print("  Building")
                        
                        os.chdir('hardware/ci')
                        try:
                            o = check_output(['./build.py'])
                        except:
                            print("  Error!")
                        
                        os.chdir('../../')
                
                        # Log this request so we don't process it again
                        hist = {'number':p['number'], 'updated_at':p['updated_at']}
                        prhist.append(hist)
                        cilog.write(str(p['number']) + '_' + p['updated_at'] + '\n')
                        cilog.flush()
                
                
                    except CalledProcessError as e:
                        print("Error: "+ str(e.returncode))
                else:
                    print("  Skipping")
                    
            else:
                print("  Error: Pull request not open or already merged")
            
        print("")
        sleep(60)
        call(['clear'])
        
    cilog.close()
    

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
            
            contents = os.listdir('.')
            if len(contents) == 0:
                print("  Staging empty - cloning repo")
                o = check_output(['git','clone','git@github.com:'+repo_owner+'/'+repo_name,'.'])
            
            poll(un, pw, proxies)
        
        else:
            print("  Error: Staging dir does not exist")
        
    
    else:
        print("  Error")
        print("  Status Code: "+r.status_code)
        print("  Response: "+r.text)
    
    
    
    # o = check_output(['git','branch'])

if __name__ == '__main__':
    if len(sys.argv) == 3:
        ci(sys.argv[1], sys.argv[2], "", "")
    elif len(sys.argv) > 3:
        ci(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    else:
        print("Usage: ci <git-username> <git-password> <http_proxy> <https_proxy>")