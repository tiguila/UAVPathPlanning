%% Use this file to run the simulation using saved occupancy map data

% Your 3D STL map
map = ".\manhattan.stl";
num_points = 1000; % Number of points to represent the snake path

VariableConfiguration;
Astar;
Simulation;

disp("Full suite processed.")