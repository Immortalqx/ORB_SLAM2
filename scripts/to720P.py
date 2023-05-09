import glob
import os
from PIL import Image

img_path = glob.glob("*.png")
path_save = "./720P"
for file in img_path:
    name = os.path.join(path_save, file)
    im = Image.open(file)
    im.thumbnail((1280,720))
    print(im.format, im.size, im.mode)
    im.save(name,'PNG')
