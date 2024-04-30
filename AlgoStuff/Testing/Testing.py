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

# keep track where you left off in the previous iteration
current = 0


# Clean up the data - find closest A* points match within the points in the actual drone path
with open(astar_csv_file, 'r') as astarfile:
    astar_csv_reader = csv.reader(astarfile)
    
    for main_row in astar_csv_reader:
        
        starx = float(main_row[0])
        stary = float(main_row[1])

        for observed in dronePath:
            dronex = float(observed[0])
            droney = float(observed[1])
            if int(starx) == int(dronex):
                Ys.append(droney)
                Xs.append(dronex)
                starX.append(starx)
                starY.append(stary)
                break 
            current +=1

# Percent Error formula
def percent_error(measured_value, true_value):
    return abs((measured_value - true_value) / true_value) * 100

# Find percent Error
results = []
index = 0
for x in Xs:
    a = percent_error(Xs[index], starX[index])
    b = percent_error(Ys[index], starY[index])
    results.append(a)
    results.append(b)
    index +=1

# Results
averagePercentError = statistics.mean(results)
print(fileName + "\n"+ "Percent Error:", averagePercentError)