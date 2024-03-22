We may or may not need this Local Search implemented


% Given XVariable as a 2D matrix that is the A* path in our
% map. There is possibility that this path has waypoints that are too
% close to objects. Thus, use a local search to smothen the A* path and use
% this updated path as the waypoints to pass to the drone to follow.

waypoints = AStarPath;

for ith in waypoints:
	if(isValidWaypoint(occupancyMap, ith)):
		Do not do anything and move on;
	else:
		try if left, right, down, or up moves are valid
		waypoint(ith) = validWaypoint(occupancyMap, ith)


% return a valid waypoint
function validWaypoint(occupancyMap, ith):
	Assume ith waypoint is not navigable

	flag = true
	while flag:
		x = given a waypoint, move 1.5 meters in each directions relative to the given waypoint
		if isValidWaypoint(occupancyMap, x)
		flag = false
		return x



% validate a given waypoint
function isValidWaypoint(occupancyMap, ith)
	directions are defined as follows - up, right, down, left (e.g., left [x, y] ==> [-1, 0]
	x = [0, 1, 0, -1]
	y = [1, 0, -1, 0]


	for all directions:
		return true iff the radius of ith is at least 1.5 meters away from any obstacle.



