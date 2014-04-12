#! /bin/env python
import unittest

if __name__ == "__main__":
    tests = unittest.TestLoader().discover(start_dir = ".", pattern='unittest_*.py')
    unittest.runner.TextTestRunner(verbosity=2).run(tests)
    
    
