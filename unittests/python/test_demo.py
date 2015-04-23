# -*- coding: utf-8 -*-
# torun: python test_demo.py  OR  python -m unittest test_demo
import unittest
import sys,os
# sys.path.append(os.path.join(os.path.dirname(__file__), os.path.join("..","..")))

# from baseclis import *

class DemoTestCase(unittest.TestCase):
    def setUp(self):
        print("setUp")
    def tearDown(self):
        print("tearDown")
    def test_case1(self):
        print("test case 1")

def self_test():
    testsuite = unittest.TestSuite([
        unittest.TestLoader().loadTestsFromTestCase(DemoTestCase)
    ])
    unittest.TextTestRunner(verbosity=2).run(testsuite)
    ### or
    # unittest.main(verbosity=2)
        
if __name__ == "__main__":
    self_test()


