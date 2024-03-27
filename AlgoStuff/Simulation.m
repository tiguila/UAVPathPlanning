disp("Simulation Starting")

Scenario = uavScenario;
stltri = stlread("./wall.stl");
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
                                         "MaxRange",9, ...
                                         "RangeAccuracy",3, ...
                                         "AzimuthResolution",AzimuthResolution, ...
                                         "ElevationResolution",ElevationResolution, ...
                                         "AzimuthLimits",AzimuthLimits, ...
                                         "ElevationLimits",ElevationLimits, ...                                       
                                         "HasOrganizedOutput",true);
% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar = uavSensor("Lidar",plat,lidarmodel,"MountingLocation",[0 0 -0.4],"MountingAngles",[0 0 180]);

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);

InitialPosition = [350 50 -10]; 

show3D(Scenario);
hold on


% Proportional Gains
Px = 91;
Py = 91;
Pz = 91;

% Derivative Gains
Dx = 26;
Dy = 26;
Dz = 26;

% Integral Gains
Ix = 82;
Iy = 82;
Iz = 82;

% Filter Coefficients
Nx = 10;
Ny = 10;
Nz = 14.4947065605712;

UAVSampleTime = 0.001;
Gravity = 9.81;
DroneMass = 0.1; 

disp("Sim Active")
out = sim("DroneProto.slx");

hold on
points = squeeze(out.trajectoryPoints(1,:,:))';
plot3(points(:,2),points(:,1),-points(:,3),"-r");
plot3([InitialPosition(1,2); AStarPath(:,2)],[InitialPosition(1,1); AStarPath(:,1)],[-InitialPosition(1,3); -AStarPath(:,3)],"-g")

    

