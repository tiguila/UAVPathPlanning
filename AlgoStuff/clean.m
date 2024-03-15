pyrunfile("./cleanup.py")
img = imread("ManhattanCleaned.jpg");
gray_img = im2gray(img);
bin_img = gray_img > 100;
rawOccMap = ~bin_img;
map2DClean = binaryOccupancyMap(rawOccMap, 1);
show(map2DClean)
"clean Finished"