disp("A* in progress...")
% Define your planner and other necessary objects
ss = stateSpaceSE2;
ss.StateBounds = [map2D.XWorldLimits; map2D.YWorldLimits; [-pi pi]];
sv = validatorOccupancyMap(ss);
sv.Map = map2D;
planner = plannerHybridAStar(sv, MinTurningRadius=4, MotionPrimitiveLength=6,InterpolationDistance=15);

% Define start and goal poses
startPose = [50 350 pi/2]; % [meters, meters, radians]
goalPose = [550 100 -pi/2];

% Plan the path
[refpath] = plan(planner,startPose,goalPose);

% ================== Creating the z dimention - Start ==================
xLength = size(refpath.States, 1);

% zLength is 7 percent of xLength, the length of A*'s path.
zLength = round(xLength * 0.07);

% Generate Zlength incrementing doubles, evenly spaced that are between 0 and height
start = linspace(0, height, zLength);

% Inverse the start
tail = fliplr(start); % this is when the path starts descending.

% Create a variable called body that stores (xLength - 2*(zLength)) elements of value height.
bodyLength = xLength - 2*zLength;
body = ones(bodyLength, 1) * height;

% Concatenate start, body, and tail becomes the z dimention
zElements = [start, body', tail];
% ================== Creating the z dimention - end ==================


% Extract x and y coordinates from the reference path and  the z dimention and store them in a 3D matrix

AStarPath = [refpath.States(:,2), refpath.States(:,1), zElements'*-1];

disp("A* completed!")


% clear workspace vars, vars not needed
clear zElements;
clear body;
clear bodyLength;
clear tail;
clear start;
clear zLength;
clear xLength;
clear height;

