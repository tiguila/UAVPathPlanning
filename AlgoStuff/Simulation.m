disp("Simulation Starting")

Scenario = uavScenario;
if (enableObstacles)
    stltri = stlread(mapObsticales);
else
    stltri = stlread(map);
end
addMesh(Scenario,"custom",{stltri.Points stltri.ConnectivityList},[0.6350 0.0780 0.1840]);
ax = show3D(Scenario);
% Define the total simulation time in seconds
simTime = 240;

% Set the update rate for the simulation in Hz
updateRate = 10;

% Define the initial Euler angles for the UAV's orientation (0 degrees in all directions)
orientation_eul = [0 0 0];

% Convert Euler angles to a quaternion for efficient rotation representation
orientation_quat = quaternion(eul2quat(orientation_eul));

% Create a matrix to repeat the same initial orientation for all waypoints
orientation_vec = repmat(orientation_quat,num_points,1);

% Create a uavPlatform object representing the first UAV with its defined characteristics
plat = uavPlatform("UAV",Scenario,"Trajectory",trajectory,"ReferenceFrame","ENU");

% Update the visual representation of the first UAV to a quadrotor model
updateMesh(plat,"quadrotor",{.1},[1 1 1],eye(4));

% Create the dynamic objects
dynamicObjects = dynamicObject(simTime, Scenario);
dynamicObj1 = dynamicObjects{1};
dynamicObj2 = dynamicObjects{2};

% Add the dynamic objects to the scene
updateMesh(dynamicObj1, "fixedwing", {5},  [1 0 0], eye(4));
updateMesh(dynamicObj2, "fixedwing", {5},  [1 0 0], eye(4));

% Define the lidar sensor parameters for the first UAV
lidarmodel = uavLidarPointCloudGenerator("UpdateRate",10, ...
                                         "MaxRange",9, ...
                                         "RangeAccuracy",3, ...
                                         "AzimuthResolution",AzimuthResolution, ...
                                         "ElevationResolution",ElevationResolution, ...
                                         "AzimuthLimits",AzimuthLimits, ...
                                         "ElevationLimits",ElevationLimits, ...                                       
                                         "HasOrganizedOutput",true);
% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar = uavSensor("Lidar",plat,lidarmodel,"MountingLocation",[0 0 -0.4],"MountingAngles",[0 0 0]);

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);

%InitialPosition = [350 50 -1]; 

show3D(Scenario);
hold on

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
Nx = 14.4947065605712;
Ny = 14.4947065605712;
Nz = 14.4947065605712;

UAVSampleTime = 0.001;
Gravity = 9.81;
DroneMass = 0.1; 

disp("Sim Active")
out = sim("DroneProto.slx");

hold on
points = squeeze(out.trajectoryPoints(1,:,:))'; %This list
plot3(points(:,2),points(:,1),-points(:,3),"-b");
plot3([InitialPosition(1,2); AStarPath(:,2)],[InitialPosition(1,1); AStarPath(:,1)],[-InitialPosition(1,3); -AStarPath(:,3)],"-g")




