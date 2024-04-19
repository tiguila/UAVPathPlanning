%% Use this file to run the simulation using saved occupancy map data

% Your 3D STL map
map = ".\Maps\manhattan.stl";
mapObsticales = ".\Maps\walls20.stl";
%% Recurring Map target
targetRecurr = '.\Data\map1_0.mat';
%%
%% Obstacles
enableObstacles = true;
%%

% Enable static obstacles in the environment (use a modified map)
enableObstacles = true;

reuse = true;
num_points = 1000; % Number of points to represent the snake path

VariableConfiguration;
Astar;
Simulation;

disp("Full suite processed.")