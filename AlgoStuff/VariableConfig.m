%Lidar Resolution Section
AzimuthResolution = 0.5;
ElevationResolution = 2;

%Lidar Range
MaxRange = 7;
AzimuthLimits = [-179 179];
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
