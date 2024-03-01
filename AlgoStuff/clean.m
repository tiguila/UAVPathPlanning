img = imread("ManhattanCleaned.jpg");
gray_img = rgb2gray(img);
bin_img = gray_img > 100;
rawOccMap = ~bin_img;
map2DClean = binaryOccupancyMap(rawOccMap, 1);
show(map2DClean)