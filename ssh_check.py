import time
import re
import sys
import json
import os.path
from os import path
if path.exists('suspects.json'):
    with open ('suspects.json','r') as f:
        suspectlist=json.load(f)
    f.close
else:
    suspectlist={}
blacklist=[]
if path.exists('blacklist.json'):
    with open ('blacklist.json','r') as f:
        blacklist = json.load(f)
    f.close
else:
    blacklist=[]


def follow(thefile):
    thefile.seek(0,2)
    while True:
            line = thefile.readline()
            if not line:
                time.sleep(0.1) # Sleep briefly
                continue
            yield line

if __name__ == "__main__":
     log = open("/var/log/auth.log")
     lines = follow(log)
     lines = (line for line in lines if "sshd" in line)
     for line in lines:

         if "Failed" in line:
            print("failed login detected")
            ip=re.findall(r'[0-9]+(?:\.[0-9]+){3}',line)

            if ip[0] in suspectlist:
                suspectlist[ip[0]]=suspectlist[ip[0]]+1
                if (ip[0] in blacklist):
                    pass
                elif(suspectlist[ip[0]]>2):
                    blacklist.append(ip[0])
                    
                else:
                    pass

            else:
                suspectlist[ip[0]]=0
            print(suspectlist)
            print('####################################')
            print('suspects:')
            print(suspectlist)
            print('blacklist:')
            print(blacklist)
            print('#################################')

            json1 =json.dumps(suspectlist)
            f=open("suspects.json","w")
            f.write(json1)
            f.close
            json2 =json.dumps(blacklist)
            f=open("blacklist.json","w")
            f.write(json2)
            f.close

         if "Accepted" in line:
            print("success login detected:")
            ip=re.findall(r'[0-9]+(?:\.[0-9]+){3}',line)

            if ip[0] in blacklist:
                print("Alarm!!")
            else:
                print("ALl good")
            print(ip[0])
            print('###################################')
            print('suspects:')
            print(suspectlist)
            print('blacklist:')
            print(blacklist)
            print('#################################')
