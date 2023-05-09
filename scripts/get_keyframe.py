import os
import cv2
import sys

# 整形数字转指定位数的字符串
def getName(num):
    return "%08d" % num


# 获取id list
dataset_id = sys.argv[1]
id_list = []
file = open(dataset_id + ".txt", mode='r')
for line in file:
    line = line.split()
    num_id = line[0].split(":")[1].split(".")[0]
    id_list.append(int(num_id))
file.close()

# 打开视频
videoCapture = cv2.VideoCapture(dataset_id + ".MP4")

# 创建文件夹
if not os.path.exists(dataset_id + "/"):
    os.makedirs(dataset_id)

# 从视频中读取一帧
success, frame = videoCapture.read()

if success:
    print('video read success!')
    frame = cv2.resize(frame, (1280, 720))
else:
    print('failed to read video!')
    exit(-1)

idx = 1

# 将视频中的每一帧保存出来
while success:
    filename = dataset_id + "/" + getName(idx) + '.png'

    if idx in id_list:
        frame = cv2.resize(frame, (1280, 720))
        cv2.imwrite(filename, frame)
        print(filename + 'saved!')
    success, frame = videoCapture.read()  # 获取下一帧
    idx = idx + 1
