import re
import sqlite3
import os
import fnmatch
import settings


#root = 'D:\\home\\Project\\1c\\'
root = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
#root = 'D:\\home\\fileconf\\'
pattern = '*.bsl'


#file_path = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
file_path = 'D:\\home\\Project\\Python\\1c_change\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
#file_path = '.\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'
#file_path = 'D:\\home\\Project\\1c\\'
#file_path = 'D:\\home\\fileconf\\'
file_name = 'Module.bsl'

def open_file(fullname):
    """Opens the file for search    
    """
    #print(file_path + file_name)
    my_file = open(fullname, 'r', encoding='utf-8')#
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
   # print(my_string)
    mstr = '//+КХ_Пашков_Д_# aaaaaa //-КХ_Пашков_Д_# sdsdsd '
    # pattern = re.compile(r'(\+КХ)((.|\n)*?)(-КХ)')
    # result = pattern.findall(my_string)
    # #print (result[1])
    # if  result:
    #     add_db(result)
    #(\+КХ)((.|\n)*?)(\-КХ Пашков_ГТД \+  Крюгер 13\.03\.2018  @)
    # #№print(result.index)

    res = ''

    #print(re.escape(r'(\+КХ)((.|\n)*?)(#)')  )
    #pattern = re.compile(r'((\+КХ)((.|\n)*?)(#))')    
    #pattern = re.compile(r'\+КХ((.|\n)*?)#')    
    pattern = re.compile(r'(\+КХ)(.+?)(#)')    
    

    

    result = pattern.findall(my_string)
    
    
    res = ''
    if  result:
        for x in result:
           # print(result)
            #print(x)
            begin_pattern = ''.join(x)
            
            #print(begin_pattern)
            end_pattern = custom_replace(begin_pattern, '+', '-', 1)
            
            
            #print(end_pattern)
            #(//\+КХПашков_TEST\+ Крюгер02\.063\.20188@)((.|\n)*?)(//-КХПашков_TEST\+ Крюгер02\.063\.20188@)
            #text = r'(//'+ begin_pattern + ')((.|\\n)*?)(' + '//' + end_pattern + ')'
            #text = r'((//'+ begin_pattern + ')((.|\\n)*?)(' + '//' +  end_pattern + '))'
            text = r'('+"\\"+ begin_pattern + ')(.+?)(' + '//' +  end_pattern + ')'
            # text1 = custom_replace(text, r'\\', '', 1)
            #print(text)
            #print(my_string)
            # print(text1)
            match = re.findall(text, my_string, flags=re.S)
            #print(match)
            
            if match:
                for y in match:
                    print('Found ')
                    result = y[1]
                    print(y[1])
                    print('**********************************************************************')
            else:
                print('Did not find ')
        res = res + result
            
    #print (res)        
    return res        
#            
            #add_db(result)
    #№print(result.index)

def custom_replace(source, substr, repl, num):
    """
    """
    tmp = source.split(substr)
    if (len(tmp)-1) < num:
        return source
    return substr.join(tmp[:num])+repl+substr.join(tmp[num:])
    
def add_db(result):
    # DB
    #print(len(result))
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
        
      #  print (folder)
        for filename in fnmatch.filter(files, pattern):
            fullname = os.path.join(folder, filename)
           # print (fullname)
            open_file(fullname)

if __name__ == "__main__":
    print_file()
   # print(st.path_for_sphinx_dir)



# def find_change(my_string):
#     # pattern = re.compile(r'(\+КХ)((.|\n)*?)(-КХ)')
#     # result = pattern.findall(my_string)
#     # #print (result[1])
#     # if  result:
#     #     add_db(result)
#     #(\+КХ)((.|\n)*?)(\-КХ Пашков_ГТД \+  Крюгер 13\.03\.2018  @)
#     # #№print(result.index)

#     res = ''

#     pattern = re.compile(r'(\+КХ)((.|\n)*?)(@)')
    

#     result = pattern.findall(my_string)
#     # print(type(result))
#     # print(result)
#     if  result:
#         for x in result:
#             # print(type(x))
#             # print(x)
#             text = ''.join(x)

#             #print(text)
#             res = res + text  
#     print (res)        
#     return res        
# #            patternN = re.compile(x)    
#             #add_db(result)
#     #№print(result.index)