
import re
import sqlite3

file_path = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'

file_name = 'Module.bsl'

def open_file():
    """Открывает файл для поиска    
    """
    #print(file_path + file_name)
    my_file = open(file_path + file_name, 'r')#, encoding='utf-8'
    my_string = my_file.read()
    pattern = re.compile(r'(\+КХ)((.|\n)*?)(-КХ)')
    result = pattern.findall(my_string)
    #№print(result.index)
    print (result[1])

    # DB
    path_db = 'D:/home/Project/Python/1c_change/data/main.db'
    conn = sqlite3.connect(path_db) 
    cur = conn.cursor()

    rec = [(None,'test', 'test task','2014/05/11' ,'test desk',str(result[1]))]

    cur.executemany('INSERT INTO change VALUES (?,?,?,?,?,?)', rec)
    #self.cur.execute("SELECT MAX (id_change) from change")
    
    conn.commit()
    
    
    my_file.close()

def find_change(file):
    pass


if __name__ == "__main__":
    open_file()

