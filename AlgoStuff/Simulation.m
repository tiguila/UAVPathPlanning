disp("Simulation Starting")

Scenario = uavScenario;
stltri = stlread(".\Maps\walls20.stl");
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

% Define the lidar sensor parameters for the first UAV
lidarmodel = uavLidarPointCloudGenerator("UpdateRate",10, ...
                                         "MaxRange",MaxRange, ...
                                         "RangeAccuracy",3, ...
                                         "AzimuthResolution",AzimuthResolution, ...
                                         "ElevationResolution",ElevationResolution, ...
                                         "AzimuthLimits",AzimuthLimits, ...
                                         "ElevationLimits",ElevationLimits, ...                                       
                                         "HasOrganizedOutput",true);
% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar = uavSensor("Lidar",plat,lidarmodel,"MountingLocation",[0 0 -0.4],"MountingAngles",[0 0 180]);%magic

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);

show3D(Scenario);
hold on


disp("Sim Active")
out = sim("DroneProto.slx");

hold on
points = squeeze(out.trajectoryPoints(1,:,:))'; %This list
plot3(points(:,2),points(:,1),-points(:,3),"-b");
plot3([InitialPosition(1,2); AStarPath(:,2)],[InitialPosition(1,1); AStarPath(:,1)],[-InitialPosition(1,3); -AStarPath(:,3)],"-g")




