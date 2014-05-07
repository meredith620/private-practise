#! /bin/env python
import unittest
debug = False
def plog(s):
    if debug:
        print(s)
        
class TestCaseDemo(unittest.TestCase):
    def setUp(self):
        pass
        plog("in case demo setup")
    def tearDown(self):
        pass
        plog("in case demo teardown")
    def test_demo_case_1(self):
        plog("in demo case 1")
        self.assertTrue(True)
    def test_demo_case_2(self):
        plog("in demo case 2")
        self.assertTrue(True)
        
class TestCaseDemo2(unittest.TestCase):
    def setUp(self):
        pass
        plog("in case demo2 setup")
    def tearDown(self):
        pass
        plog("in case demo2 teardown")
    def test_demo2_case_1(self):
        plog("in demo2 case 1")
        self.assertTrue(True)
    def test_demo2_case_2(self):
        plog("in demo2 case 2")
        self.assertTrue(True)
        
# if __name__ == '__main__':
#     s1 = unittest.TestLoader().loadTestsFromTestCase(TestCaseDemo)
#     s2 = unittest.TestLoader().loadTestsFromTestCase(TestCaseDemo2)
#     unittest.TextTestRunner(verbosity=2).run(s1)
#     unittest.TextTestRunner(verbosity=2).run(s2)
    # unittest.main()
