%Lidar Resolution Section
AzimuthResolution = 0.5;
ElevationResolution = 2;

%Lidar Range
MaxRange = 10;
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

%What special math magic is this-------------------------------------------
%% Proportional gains
% Valid range	[0.5, 91]
% Higher P gains typically result in faster response but may lead to oscillations or instability if too high.
%%
Px = 91;
Py = 91;
Pz = 91;

%% Integral Gains
% Valid range	[0.0.1, 82]
% It helps eliminate steady-state error by integrating the error over time. It's useful for correcting long-term
% errors that may not be addressed by P and D gains alone. However, too high I gains can lead to instability/oscillations.
%%
Ix = 82;
Iy = 82;
Iz = 82;


%% Derivative Gains
% Valid range	[0.1, 26] 
% It helps reduce oscillations and improve stability. It acts on the rate of change of the error signal. Too
% high D gains can lead to a sluggish response, while too low can result in oscillations.
%%
Dx = 26;
Dy = 26;
Dz = 26;

% Filter Coefficients
Nx = 10;
Ny = 10;
Nz = 14.4947065605712;