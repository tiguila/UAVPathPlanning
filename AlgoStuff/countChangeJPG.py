from PIL import Image

with Image.open("./Manhattan.jpg") as srcIm:
    with Image.open("./ManhattanCleaned.jpg") as destIm:
        (Length, Width) = srcIm.size
        pixelsChanged = 0
        for x in range (Length):
            for y in range(Width):
                if srcIm.getpixel([x,y]) != destIm.getpixel([x,y]):
                    pixelsChanged = pixelsChanged + 1
                    
        print(f"Pixels Changed: {pixelsChanged}")