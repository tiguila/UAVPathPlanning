disp('Two drones STL to Occupancy map in progress...')
% Close any open or hidden figures to avoid clutter
close all;
close all hidden;

Scenario = uavScenario;
stltri = stlread("manhattan.stl");
addMesh(Scenario,"custom",{stltri.Points stltri.ConnectivityList},[0.6350 0.0780 0.1840]);
ax = show3D(Scenario);
% Define the total simulation time in seconds
simTime = 240;

% Set the update rate for the simulation in Hz
updateRate = 10;

% Define parameters for snake path
num_points = 1000; % Number of points to represent the snake path
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

% Set the initial position and orientation of the first UAV
initial_pose1 = [0 100 100 1 0 0 0];


% Create a uavPlatform object representing the first UAV with its defined characteristics
plat = uavPlatform("UAV",Scenario,"Trajectory",trajectory,"ReferenceFrame","ENU");

% Update the visual representation of the first UAV to a quadrotor model
updateMesh(plat,"quadrotor",{4},[1 0 0],eye(4));

% Define the lidar sensor parameters for the first UAV
lidarmodel = uavLidarPointCloudGenerator("AzimuthResolution",0.6, ...
    "ElevationLimits",[-90 -20],"ElevationResolution",2.5, ...
    "MaxRange",200,"UpdateRate",2,"HasOrganizedOutput",true);

% Create a uavSensor object representing the lidar sensor attached to the first UAV
lidar = uavSensor("Lidar",plat,lidarmodel,"MountingLocation",[0 0 -1],"MountingAngles",[0 0 0]);

% Create an axis and visualization elements for displaying the 3D environment
[ax, plotFrames] = show3D(Scenario);

% Set axis limits for the visualization
xlim([-15 3100]);
ylim([-15 2600]);
zlim([0 110]);

% Set the viewing angle for the visualization
view([-110 20]);

% Make the axes scales equal for a consistent representation
axis equal;

% Enable plotting multiple elements on the same figure
hold on;

% Initialize a pointCloud object to store the combined lidar point cloud data
ptc = pointCloud(nan(1,1,3));

% Create a scatter plot to visualize the combined lidar data points in 3D
scatterplot = scatter3(nan,nan,nan,1,[0.3020 0.7451 0.9333],...
    "Parent",plotFrames.UAV.Lidar);

% Link the scatter plot's data sources to the underlying combined point cloud data
scatterplot.XDataSource = "reshape(ptc.Location(:,:,1), [], 1)";
scatterplot.YDataSource = "reshape(ptc.Location(:,:,2), [], 1)";
scatterplot.ZDataSource = "reshape(ptc.Location(:,:,3), [], 1)";
scatterplot.CDataSource = "reshape(ptc.Location(:,:,3), [], 1) - min(reshape(ptc.Location(:,:,3), [], 1))";

% Disable plotting multiple elements on the same figure
hold off;

% Initialize an empty array to store the lidar sample times
lidarSampleTime = [];

% Initialize cell arrays to store raw and processed lidar point cloud data for both UAVs
pt = cell(1,((updateRate*simTime) +1));
ptOut = cell(1,((updateRate*simTime) +1));

% Create an occupancyMap3D object to represent the 3D occupancy map
map3D = occupancyMap3D(1);

% Set up the simulation environment
setup(Scenario);

% Counter to limit simulation duration
counter = 0;

% Index for data storage
ptIdx = 0;

tic
% Main simulation loop
while Scenario.IsRunning && counter < 10000
    % Increment index for data storage
    ptIdx = ptIdx + 1;

    % Read the simulated lidar data from both UAVs
    [isUpdated, lidarSampleTime, pt{ptIdx}] = read(lidar);

    % Process lidar data if it's updated
    if isUpdated
        % Get the lidar sensor's pose relative to ENU reference frame for both UAVs
        sensorPose = getTransform(Scenario.TransformTree, "ENU","UAV/Lidar",lidarSampleTime);

        % Process the simulated Lidar pointcloud.
        ptc = pt{ptIdx};
        ptOut{ptIdx} = removeInvalidPoints(pt{ptIdx});
        % Construct the occupancy map using Lidar readings.
        insertPointCloud(map3D,[sensorPose(1:3,4)' tform2quat(sensorPose)],ptOut{ptIdx},500);

        % Update 3D visualization with current simulation state and combined point cloud
        figure(1)
        show3D(Scenario,"Time",lidarSampleTime,"FastUpdate",true,"Parent",ax);
        xlim([0 3100]);
        ylim([0 2500]);
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
toc

% Display completion message
disp('Two drones STL to Occupancy map completed!')

figure
show(map3D)

