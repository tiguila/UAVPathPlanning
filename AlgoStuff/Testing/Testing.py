import csv
import statistics

fileName = "PID918203"
astar_csv_file = 'astarpath.csv'
points_csv_file = fileName+".csv"

Xs = []
Ys = []
starX = []
starY = []

# store the drone path as a matrix for "resuming iteration from a specific point" later
dronePath = []
with open(points_csv_file, 'r') as pointsfile:
    points_csv_reader = csv.reader(pointsfile)
    for point in points_csv_reader:
        dronex = float(point[0])
        droney = float(point[1])
        dronePath.append([dronex, droney])

