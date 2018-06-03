
import re
import sqlite3
import os
import fnmatch
import settings


root = 'D:\\home\\Project\\1c\\'
pattern = '*.bsl'


#file_path = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
#file_path = 'D:\\home\\Project\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
#file_path = '.\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
file_path = 'D:\\home\\Project\\1c\\'
file_name = 'Module.bsl'

def open_file(fullname):
    """Открывает файл для поиска    
    """
    #print(file_path + file_name)
    my_file = open(fullname, 'r', encoding='utf-8')#, encoding='utf-8'
    try:
        my_string = my_file.read()
    except UnicodeDecodeError:
        print('Ошибка кодировки при чтении из - ' + str(fullname) )
    else:    
        find_change(my_string)

    finally:
        pass
    
    my_file.close()

def find_change(my_string):
    pattern = re.compile(r'(\+КХ)((.|\n)*?)(-КХ)')
    result = pattern.findall(my_string)
    #print (result[1])
    if  result:
        add_db(result)
    #№print(result.index)
    

    
    
def add_db(result):
    # DB
    print(len(result))
    #path_db = 'D:/home/Project/Python/1c_change/data/main.db'
    conn = sqlite3.connect(settings.path_db) 
    cur = conn.cursor()

    for t_rec in result: 
        rec = [(None,'test', 'test task','2014/05/11' ,'test desk',str(t_rec))]
        cur.executemany('INSERT INTO change VALUES (?,?,?,?,?,?)', rec)
    #self.cur.execute("SELECT MAX (id_change) from change")
    
    conn.commit()


def print_file():
    
    for folder, subdirs, files in os.walk(root):
        #print (folder)
        for filename in fnmatch.filter(files, pattern):
            fullname = os.path.join(folder, filename)
            print (fullname)
            open_file(fullname)

if __name__ == "__main__":
    print_file()
   # print(st.path_for_sphinx_dir)
