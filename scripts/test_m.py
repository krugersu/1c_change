"""Тестовый модуль для отладки"""

import os
import sys
import fnmatch
#root = 'D:\\home\\Project\\1c_change\\fileconf\\'
root = 'D:\\home\\Project\\1c\\'
pattern = '*.bsl'



def print_file():

    for folder, subdirs, files in os.walk(root):
        #print (folder)
        for filename in fnmatch.filter(files, pattern):
            fullname = os.path.join(folder, filename)
            print (fullname)







if __name__ == "__main__":
    print_file()
    
