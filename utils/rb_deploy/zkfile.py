#! /bin/env python2

import os
import sys
import ConfigParser
import getopt

sys.path.append(os.path.join(os.path.dirname(__file__), os.path.join(".", "lib")))
from kazoo.client import KazooClient

def usage():
    print("%s -z [zkserver] -l [localfile] -r [remotefile] -m [up/down]")
    sys.exit(1)

def zkupload(zk, localfile, remotefile):
    zknodeStats = zk.exists(remotefile)
    with open(localfile, "r") as f:
        value = f.read()
        if zknodeStats == None:
            zk.create(remotefile, value)
        else:
            zk.set(remotefile, value)

def zkdownload(zk, localfile, remotefile):
    with open(localfile, "w") as f:
        (value, c) = zk.get(remotefile)
        f.write(value)
    
def main():    
    # parse option
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hz:l:r:m:", ["help", "zookeeper=", "local=", "remote=", "mode="])
    except getopt.GetoptError as err:
        print("err: %s" % err)
        usage()

    zkserver = None
    localfile = None
    remotefile = None
    mode = None
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit(-1)
        elif o in ("-z", "--zookeeper"):
            zkserver = a
        elif o in ("-l", "--local"):
            localfile = a
        elif o in ("-r", "--remote"):
            remotefile = a            
        elif o in ("-m", "--mode"):
            mode = a
        else:
            assert False, "unhandled option"
    if zkserver == None or localfile == None or remotefile == None or mode == None:
        usage()

    print("zk: %s" % zkserver)
    print("local: %s" % localfile)
    print("remote: %s" % remotefile)
    print("mode: %s" % mode)

    operator = None
    if mode == "up":
        operator = zkupload
    elif mode == "down":
        operator = zkdownload
    else :
        usage()

    zk = KazooClient(hosts = zkserver)
    zk.start()
    operator(zk, localfile, remotefile)

if __name__ == "__main__":
    main()
