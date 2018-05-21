
import re


file_path = 'D:\\home\\Project\\Python\\1c\\fileconf\\ПоступлениеТоваров\\Forms\\ФормаДокумента\\Ext\\Form\\'

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
    print (result)

    

    
    
    my_file.close()

def find_change(file):
    pass


if __name__ == "__main__":
    open_file()

