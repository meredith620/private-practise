#! /bin/env python2

import sys
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f", "--file",
                  action="store", dest="filename", type="string", 
                  help="write report to FILE", metavar="FILE")
parser.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")
def main():
    (options, args) = parser.parse_args()
    print(options.filename)
    print(options)

if __name__ == "__main__":
    main()

