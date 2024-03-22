#DEPENDENCIES
#Pillow
# pip install Pillow
from PIL import Image, ImageDraw

TOLERANCE = 3
with Image.open("./Manhattan.jpg") as im:
    (MAX_X , MAX_Y) = im.size
    drawImg = ImageDraw.Draw(im)
    allPixels = im.load();
    #2: Right | 3: Bottom
    #print(im.getbbox()[2], im.getbbox()[3])
    
    for x in range(MAX_X):
        for y in range(MAX_Y):
            # print(allPixels[x,y], end=' ')
            if allPixels[x,y] <= 255/2:
                drawImg.point([x,y], 0)
            else:
                drawImg.point([x,y], 255)
    
    for x in range(MAX_X):
        for y in range(MAX_Y):
            approx = 0
            if allPixels[x,y] == 0:
                for dy in [-1, 0, 1]:
                    for dx in [-1, 0, 1]:
                        if 0 <= x + dx < MAX_X and 0 <= y + dy < MAX_Y:
                            if allPixels[dx,dy] == 0:
                                approx = approx + 1
            if approx <= TOLERANCE:
                drawImg.point([x,y], 255)
            else:
                drawImg.point([x,y], 0)

    im.save("./ManhattanCleaned.jpg");
    im.show()
print("CLEANING DONE")
                
