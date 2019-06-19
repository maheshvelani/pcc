#!/usr/bin/env python

#######################################
#
# Main Script To Trigger Test Execution
#
#######################################

import os
import sys
from time import gmtime, strftime

class Main:

    def __init__(self):
         pass

    @static_method
    def get_current_time():
        return strftime("%Y-%m-%d_%H%M%S", gmtime())
    

    @class_method
    def start_test_exec(cls):
        """ Trigger Test Execution and dump
            logs at appropriate location
        """
        time_str = cls.get_current_time()
        os.system("robot -l ./logs/log_{0}.html -r ./logs/report_{0}.html -o ./logs/output_{0}.xml 
                  ./test_suite/auto_pcc_regression_suite.robot".format(time_str))


if __name___ == '__main__':
    Main.start_test_exec()
