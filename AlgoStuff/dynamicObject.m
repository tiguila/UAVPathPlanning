% In this file, create n, where n can be any number, of dymaic objects. Define the waypoints, time
% to reach each waypoint as a 1D vector, and a trajectory for each dymaic
% object. Each element in dynamObj2Time corresponds to one waypoint in dynamObj1waypts.

%% retrn type: dynamicObjects matrix of n objects.

function dynamicObjects = dynamicObject(maxTime, Scenario)
    
    % Object 1
    strPose = [60 350 0];
    golPs =  [77 355 0];
    
    dynamObj1waypts = Astar(strPose, golPs);
    n1 = size(dynamObj1waypts(:, 1), 1);
    
    % Range [0 - maxTime] and contains n elements.
    time1 = linspace(0, maxTime/3, n1)';
    
    % Define the trajectory for the dynamic object
    dynamObj1Trajec = waypointTrajectory(dynamObj1waypts, "TimeOfArrival", time1, "ReferenceFrame", "ENU", "AutoBank", true);
    object1 = uavPlatform("UAV1", Scenario, "Trajectory", dynamObj1Trajec, "ReferenceFrame", "ENU");

    % Object 2
    obj2StartPose = [150 360 0];
    obj2EndPose = [170 360 0];

    dynamObj2waypts = Astar(obj2StartPose, obj2EndPose);
    n2 = size(dynamObj2waypts(:, 1), 1);
    
    % Range [0 - maxTime] and contains n elements.
    time2 = linspace(0, maxTime/2, n2)';
    
    dynamObj2Trajec = waypointTrajectory(dynamObj2waypts, "TimeOfArrival", time2, "ReferenceFrame", "ENU", "AutoBank", true);
    object2 = uavPlatform("UAV2", Scenario, "Trajectory", dynamObj2Trajec, "ReferenceFrame", "ENU");

    % return the objects as a list/vector
    dynamicObjects = {object1, object2};

end


