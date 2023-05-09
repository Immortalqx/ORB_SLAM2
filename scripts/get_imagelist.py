import os

# 生成图片列表
file_object = open('image_list.txt', 'w')
Ostr = ''
num = len(os.listdir('images'))
for i in range(1, num + 1):
    name = getName(i)
    Ostr = Ostr + name + '\n'
file_object.writelines(Ostr)
file_object.close()
