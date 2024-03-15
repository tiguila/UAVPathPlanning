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


%What special math magic is this-------------------------------------------
% Proportional Gains
Px = 6;
Py = 6;
Pz = 6.5;

% Derivative Gains
Dx = 1.5;
Dy = 1.5;
Dz = 2.5;

% Integral Gains
Ix = 0;
Iy = 0;
Iz = 0;

% Filter Coefficients
Nx = 10;
Ny = 10;
Nz = 14.4947065605712; 
