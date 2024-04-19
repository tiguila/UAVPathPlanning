%% This  file is related to the variable configuration for the simulation of saved data


%Lidar Resolution Section

AzimuthResolution = 0.5;
ElevationResolution = 2;
%Why change?
%AzimuthResolution = 0.3324099;
%ElevationResolution = 1.25;

%Lidar Range
MaxRange = 9;
AzimuthLimits = [-45 45];
ElevationLimits = [-15 15];

%Global and UAV related settings
Gravity = 9.8 ; %m^2/s
UAVSampleTime = 0.001;
DroneMass = 0.1;

% CHANGE THESE VALUE
height = 20; 
%Start position of Drone
startPose = [50 350 pi/2]; % [meters, meters, radians]
%Ending position of Drone
goalPose = [550 100 -pi/2];
%Initial position of Drone
InitialPosition = [350 50 0]; % [y x z]



% ==== Start - from twodronesstltoOMap.m
Scenario = uavScenario;
stltri = stlread(map);
addMesh(Scenario, "custom", {stltri.Points, stltri.ConnectivityList}, [0.678 0.847 0.902]);
ax = show3D(Scenario);
% Define the total simulation time in seconds
simTime = 240;

% Set the update rate for the simulation in Hz
updateRate = 10;

% Define parameters for snake path
%num_points = 1000; % Number of points to represent the snake path
frequency = pi/4; % Frequency of the sinusoidal curve
z_value = 100; % Constant value for the Z dimension
length = ax.XLim(2);
width = ax.YLim(2);

amplitude = floor(width / 2); % Amplitude of the sinusoidal curve

% Initialize variables
snake_path = zeros(num_points, 3); % Transposed to 1000x3

% Generate snake path
x_values = linspace(0, length, num_points); % Generate evenly spaced x-values
y_values = (width / 2) + amplitude * sin(frequency * x_values); % Calculate corresponding y-values

% Store waypoints with Z dimension
snake_path(:, 1) = x_values;
snake_path(:, 2) = y_values;
snake_path(:, 3) = z_value; % Assign constant Z value

% Define the initial Euler angles for the UAV's orientation (0 degrees in all directions)
orientation_eul = [0 0 0];

% Convert Euler angles to a quaternion for efficient rotation representation
orientation_quat = quaternion(eul2quat(orientation_eul));

% Create a matrix to repeat the same initial orientation for all waypoints
orientation_vec = repmat(orientation_quat,num_points,1);

% Create an array of time points corresponding to each waypoint for a smooth trajectory
time = 0:(simTime/(num_points-1)):simTime;

% Define a waypointTrajectory object representing the UAV's planned path
trajectory = waypointTrajectory("Waypoints",snake_path,"Orientation",orientation_vec, ...
    "SampleRate",updateRate,"ReferenceFrame","ENU","TimeOfArrival",time);
% ====== end - from twoDronesstlToOMap


%What special math magic is this-------------------------------------------
% Proportional Gains
Px = 10;
Py = 10;
Pz = 10.5;

% Derivative Gains
Dx = 5;
Dy = 5;
Dz = 7.5;

% Integral Gains
Ix = 15;
Iy = 15;
Iz = 15;
