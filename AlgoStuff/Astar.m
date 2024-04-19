%% Create an optimal path from  A-B using the built in Hybrid A* function from MATLAB.

disp("A* in progress...")

% Save the 2D occupancy map using the following one line:
%save('occupancy_map.mat', 'map2D');

if reuse && isfile(targetRecurr)
    % load saved data
    path = targetRecurr;
    occupancyMap = load(path).map2D;
else
    % load new occupancy map data
    occupancyMap = map2D;
end

% Preparing the environment for the A* algorithm; Defining the planner and other necessary objects
ss = stateSpaceSE2;
ss.StateBounds = [occupancyMap.XWorldLimits; occupancyMap.YWorldLimits; [-pi pi]];
sv = validatorOccupancyMap(ss);
sv.Map = occupancyMap;
planner = plannerHybridAStar(sv, MinTurningRadius=4, MotionPrimitiveLength=6,InterpolationDistance=15);


% Plan the path
[refpath] = plan(planner,startPose,goalPose);

% ================== Creating the z dimention - Start ==================
xLength = size(refpath.States, 1);

% zLength is 7 percent of xLength, the length of A*'s path.
% What if: its actually 10 percent?
zLength = round(xLength * 0.1);%round(xLength * 0.07);

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

% Clear not required variables from workspace
%clear occupancyMap;
%clear planner;
%clear refpath;
%clear tail;
%clear xLength;
%clear zElements;
%clear zLength;
%%clear body;
%clear bodyLength;
%clear height;
%clear ss;
%clear start;
%clear startPose;
%clear goalPose;
%clear sv;
%clear path;
%clear flag;

