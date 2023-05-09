import os
import cv2.cv2

# 视频文件
video_file = 'DJI_Test03.MP4'
# 间隔帧数
frame_n = 1


# 整形数字转指定位数的字符串
def getName(num):
    return "%08d" % num


# 打开视频
videoCapture = cv2.VideoCapture(video_file)

# 创建文件夹
if not os.path.exists('rgb/'):
    os.makedirs('rgb')

# 从视频中读取一帧
success, frame = videoCapture.read()

if success:
    print('video read success!')
    frame = cv2.resize(frame, (800, 450))
else:
    print('failed to read video!')
    exit(-1)

idx = 1

# 将视频中的每一帧保存出来
while success:
    filename = 'rgb/' + getName(idx) + '.png'
    cv2.imwrite(filename, frame)
    print(filename + 'saved!')

    i = frame_n
    while i > 0:
        success, frame = videoCapture.read()  # 获取下一帧
        i = i - 1
    if success:
        frame = cv2.resize(frame, (800, 450))
    idx = idx + 1

# 生成图片列表
file_object = open('image_list.txt', 'w')
Ostr = ''
num = len(os.listdir('rgb'))
for i in range(1, num + 1):
    name = getName(i)
    Ostr = Ostr + name + '\n'
file_object.writelines(Ostr)
file_object.close()
