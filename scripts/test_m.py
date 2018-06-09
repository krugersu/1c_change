"""Test module for debugging"""

import re
 


def custom_replace(source, substr, repl, num):
    """
    """
    tmp = source.split(substr)
    if (len(tmp)-1) < num:
        return source
    return substr.join(tmp[:num])+repl+substr.join(tmp[num:])

#+КХ)((.|\n)*?)(@) 
st_text = '+КХ Пашков_Д +  Крюгер 13.03.2018   @'
st_text1 = '+КХ Пашков_Д +  Крюгер 13.03.2018   @'
res = custom_replace(st_text1, '+', '-', 1)
text = r'(\\'+ st_text + ')((.|\n)*?)(' + res + ')'

print(text)
 
# print(st_text1[:5])
# print(st_text1[5:])
# print(st_text1[5:].replace('+','-',0))

# print(st_text1[:5].replace('+','-',1)+st_text1[5:])
