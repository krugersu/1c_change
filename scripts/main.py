
import re
import sqlite3
import settings as st


file_path = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'

file_name = 'Module.bsl'

def open_file():
    """Открывает файл для поиска    
    """
    #print(file_path + file_name)
    my_file = open(file_path + file_name, 'r')#, encoding='utf-8'
    my_string = my_file.read()
    find_change(my_string)
    
    
    my_file.close()

def find_change(my_string):
    pattern = re.compile(r'(\+КХ)((.|\n)*?)(-КХ)')
    result = pattern.findall(my_string)
    print (result[1])
    add_db(result)
    #№print(result.index)
    

    
    
def add_db(result):
    # DB
    print(len(result))
    path_db = 'D:/home/Project/Python/1c_change/data/main.db'
    conn = sqlite3.connect(path_db) 
    cur = conn.cursor()

    for t_rec in result: 
        rec = [(None,'test', 'test task','2014/05/11' ,'test desk',str(t_rec))]
        cur.executemany('INSERT INTO change VALUES (?,?,?,?,?,?)', rec)
    #self.cur.execute("SELECT MAX (id_change) from change")
    
    conn.commit()

if __name__ == "__main__":
   # open_file()
    print(st.path_for_sphinx_dir)
