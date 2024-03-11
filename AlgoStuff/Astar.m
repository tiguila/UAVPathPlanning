disp("A* in progress...")
% Define your planner and other necessary objects
ss = stateSpaceSE2;
ss.StateBounds = [map2D.XWorldLimits; map2D.YWorldLimits; [-pi pi]];
sv = validatorOccupancyMap(ss);
sv.Map = map2D;
planner = plannerHybridAStar(sv, MinTurningRadius=4, MotionPrimitiveLength=6);

% Define start and goal poses
startPose = [50 350 pi/2]; % [meters, meters, radians]
goalPose = [550 100 -pi/2];

% Plan the path
[refpath] = plan(planner,startPose,goalPose);

% Extract x and y coordinates from the reference path and store them in a 2D matrix
AStarPath= [refpath.States(:,1), refpath.States(:,2)];

disp("A* completed!")

