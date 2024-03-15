Scenario = uavScenario;
stltri = stlread("manhattan.stl");
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
updateMesh(plat,"quadrotor",{.5},[1 1 1],eye(4));

% Define the lidar sensor parameters for the first UAV
lidarmodel = uavLidarPointCloudGenerator("AzimuthResolution",0.6, ...
    "ElevationLimits",[-90 -20],"ElevationResolution",2.5, ...
    "MaxRange",200,"UpdateRate",2,"HasOrganizedOutput",true);

% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar = uavSensor("Lidar",plat,lidarmodel,"MountingLocation",[0 0 -1],"MountingAngles",[0 0 0]);

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);
