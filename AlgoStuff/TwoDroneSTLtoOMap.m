% Close any open or hidden figures to avoid clutter
close all;
close all hidden;

% Define the total simulation time in seconds
simTime = 60;

% Set the update rate for the simulation in Hz
updateRate = 10;

% Create arrays for the x, y, and z coordinates of the waypoints (forming a grid)
x = 0:600;
y = 300*ones(1,length(x))
z = 100*ones(1,length(x));

% Create arrays for the x, y, and z coordinates of the waypoints (forming a grid)
x1 = 0:600;
y1 = 100*ones(1,length(x))

% Combine x, y, and z into a 3D matrix representing the waypoints
waypoints = [x' y' z'];
% Combine x, y, and z into a 3D matrix representing the waypoints
waypoints1 = [x1' y1' z'];
disp(waypoints1)

% Define the initial Euler angles for the UAV's orientation (0 degrees in all directions)
orientation_eul = [0 0 0];

% Convert Euler angles to a quaternion for efficient rotation representation
orientation_quat = quaternion(eul2quat(orientation_eul));

% Create a matrix to repeat the same initial orientation for all waypoints
orientation_vec = repmat(orientation_quat,length(x),1);

% Create an array of time points corresponding to each waypoint for a smooth trajectory
time = 0:(simTime/(length(x)-1)):simTime;

% Define a waypointTrajectory object representing the UAV's planned path
trajectory1 = waypointTrajectory("Waypoints",waypoints,"Orientation",orientation_vec, ...
    "SampleRate",updateRate,"ReferenceFrame","ENU","TimeOfArrival",time);

% Set the initial position and orientation of the first UAV
initial_pose1 = [0 100 100 1 0 0 0];

% Create a uavPlatform object representing the first UAV with its defined characteristics
plat1 = uavPlatform("UAV1",Scenario,"Trajectory",trajectory1,"ReferenceFrame","ENU");

% Update the visual representation of the first UAV to a quadrotor model
updateMesh(plat1,"quadrotor",{4},[1 0 0],eye(4));

% Define the lidar sensor parameters for the first UAV
lidarmodel1 = uavLidarPointCloudGenerator("AzimuthResolution",0.6, ...
    "ElevationLimits",[-90 -20],"ElevationResolution",2.5, ...
    "MaxRange",200,"UpdateRate",2,"HasOrganizedOutput",true);

% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar1 = uavSensor("Lidar1",plat1,lidarmodel1,"MountingLocation",[0 0 -1],"MountingAngles",[0 0 0]);


% Define a waypointTrajectory object representing the second UAV's planned path (opposite diagonal)
trajectory2 = waypointTrajectory("Waypoints",[flipud(waypoints1(:,1:2)), waypoints1(:,3)], ...
    "Orientation",orientation_vec, "SampleRate",updateRate,"ReferenceFrame","ENU","TimeOfArrival",time);

% Set the initial position and orientation of the second UAV
initial_pose2 = [0 300 100 1 0 0 0]; % Opposite diagonal corner

% Create a uavPlatform object representing the second UAV with its defined characteristics
plat2 = uavPlatform("UAV2",Scenario,"Trajectory",trajectory2,"ReferenceFrame","ENU");

% Update the visual representation of the second UAV to a quadrotor model
updateMesh(plat2,"quadrotor",{4},[0 0 1],eye(4)); % Change color to differentiate from the first UAV

% Define the lidar sensor parameters for the second UAV
lidarmodel2 = uavLidarPointCloudGenerator("AzimuthResolution",0.6, ...
    "ElevationLimits",[-90 -20],"ElevationResolution",2.5, ...
    "MaxRange",200,"UpdateRate",2,"HasOrganizedOutput",true);

% Create a uavSensor object representing the lidar sensor attached to the second UAV
lidar2 = uavSensor("Lidar2",plat2,lidarmodel2,"MountingLocation",[0 0 -1],"MountingAngles",[0 0 0]);

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);

% Set axis limits for the visualization
xlim([-15 630]);
ylim([-15 630]);
zlim([0 110]);

% Set the viewing angle for the visualization
view([-110 20]);

% Make the axes scales equal for a consistent representation
axis equal;

% Enable plotting multiple elements on the same figure
hold on;

% Initialize a pointCloud object to store the combined lidar point cloud data
combined_ptc = pointCloud(nan(1,1,3));

% Create a scatter plot to visualize the combined lidar data points in 3D
combined_scatterplot1 = scatter3(nan,nan,nan,1,[0.3020 0.7451 0.9333],...
    "Parent",plotFrames.UAV1.Lidar1);

% Create a scatter plot to visualize the combined lidar data points in 3D
combined_scatterplot2 = scatter3(nan,nan,nan,1,[0.3020 0.7451 0.9333],...
    "Parent",plotFrames.UAV2.Lidar2);

% Link the scatter plot's data sources to the underlying combined point cloud data
combined_scatterplot.XDataSource = "reshape(combined_ptc.Location(:,:,1), [], 1)";
combined_scatterplot.YDataSource = "reshape(combined_ptc.Location(:,:,2), [], 1)";
combined_scatterplot.ZDataSource = "reshape(combined_ptc.Location(:,:,3), [], 1)";
combined_scatterplot.CDataSource = "reshape(combined_ptc.Location(:,:,3), [], 1) - min(reshape(combined_ptc.Location(:,:,3), [], 1))";

% Disable plotting multiple elements on the same figure
hold off;

% Initialize an empty array to store the lidar sample times
lidarSampleTime = [];

% Initialize cell arrays to store raw and processed lidar point cloud data for both UAVs
pt1 = cell(1,((updateRate*simTime) +1));
ptOut1 = cell(1,((updateRate*simTime) +1));
pt2 = cell(1,((updateRate*simTime) +1));
ptOut2 = cell(1,((updateRate*simTime) +1));

% Create an occupancyMap3D object to represent the 3D occupancy map
map3D = occupancyMap3D();

% Set up the simulation environment
setup(Scenario);

% Counter to limit simulation duration
counter = 0;

% Index for data storage
ptIdx = 0;

% Main simulation loop
while Scenario.IsRunning && counter < 1000
    % Increment index for data storage
    ptIdx = ptIdx + 1;

    % Read the simulated lidar data from both UAVs
    [isUpdated1, lidarSampleTime1, pt1{ptIdx}] = read(lidar1);
    [isUpdated2, lidarSampleTime2, pt2{ptIdx}] = read(lidar2);

    % Process lidar data if it's updated
    if isUpdated1 || isUpdated2
        % Get the lidar sensor's pose relative to ENU reference frame for both UAVs
        sensorPose1 = getTransform(Scenario.TransformTree, "ENU","UAV1/Lidar1",lidarSampleTime1);
        sensorPose2 = getTransform(Scenario.TransformTree, "ENU","UAV2/Lidar2",lidarSampleTime2);

        % Update point cloud object with raw data from the first UAV
        if isUpdated1
            ptc1 = pt1{ptIdx};
            ptOut1{ptIdx} = removeInvalidPoints(ptc1);
            insertPointCloud(map3D,[sensorPose1(1:3,4)' tform2quat(sensorPose1)],ptOut1{ptIdx},500);
        end

        % Update point cloud object with raw data from the second UAV
        if isUpdated2
            ptc2 = pt2{ptIdx};
            ptOut2{ptIdx} = removeInvalidPoints(ptc2);
            insertPointCloud(map3D,[sensorPose2(1:3,4)' tform2quat(sensorPose2)],ptOut2{ptIdx},500);
        end

        % Combine lidar point cloud data from both UAVs
        combined_ptc = pcmerge(ptOut1{ptIdx}, ptOut2{ptIdx}, 0.1);

        % Update 3D visualization with current simulation state and combined point cloud
        figure(1)
        show3D(Scenario,"Time",max(lidarSampleTime1, lidarSampleTime2),"FastUpdate",true,"Parent",ax);
        xlim([0 600]);
        ylim([0 400]);
        zlim([0 110]);
        view([-110 20]);
        refreshdata
        drawnow limitrate

    end

    % Advance the simulation and update sensors
    advance(Scenario);
    updateSensors(Scenario);

    % Increment counter
    counter = counter + 1;
end

% Display completion message
disp('ended')

figure
show(map3D)

