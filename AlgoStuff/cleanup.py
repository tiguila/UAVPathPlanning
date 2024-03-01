#DEPENDENCIES
#Pillow
# pip install Pillow
from PIL import Image

im = Image.open("./Manhattan.jpg")
TOLERANCE = 3
#2: Right | 3: Bottom
#print(im.getbbox()[2], im.getbbox()[3])
for x in range(0,im.getbbox()[2]):
    for y in range(0, im.getbbox()[3]):
        pixel = im.getpixel([x,y])
        if pixel[0] <= 255/2:
            im.putpixel((x,y),(0,0,0))
        else:
            im.putpixel((x,y),(255,255,255))
        

for x in range(0,im.getbbox()[2]):
    for y in range(0, im.getbbox()[3]):
        approx = 0
        if x - 1 >= 0 and y - 1 >= 0 and im.getpixel([x-1,y-1])[0] == 0:
            approx = approx + 1
        if x - 1 >= 0 and im.getpixel([x-1,y])[0] == 0:
            approx = approx + 1
        if y - 1 >= 0 and im.getpixel([x,y-1])[0] == 0:
            approx = approx + 1
        if x + 1 < im.getbbox()[2] and y + 1 < im.getbbox()[3] and im.getpixel([x+1,y+1])[0] == 0:
            approx = approx + 1
        if x + 1 < im.getbbox()[2] and im.getpixel([x+1,y])[0] == 0:
            approx = approx + 1
        if y + 1 < im.getbbox()[3] and im.getpixel([x,y+1])[0] == 0:
            approx = approx + 1
        if x + 1 < im.getbbox()[2] and y - 1 >= 0 and im.getpixel([x+1,y-1])[0] == 0:
            approx = approx + 1
        if x - 1 >= 0 and y + 1 < im.getbbox()[3] and im.getpixel([x-1,y+1])[0] == 0:
            approx = approx + 1

        if approx <= TOLERANCE and ((x != 0 and y != 0) and (x != im.getbbox()[2] - 1 and y != im.getbbox()[3] - 1)):
            im.putpixel((x,y),(255,255,255))
        approx = 0
im.save("./ManhattanCleaned.jpg");
