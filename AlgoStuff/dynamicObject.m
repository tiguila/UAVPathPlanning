% In this file, create n, where n can be any number, of dymaic objects. Define the waypoints, time
% to reach each waypoint as a 1D vector, and a trajectory for each dymaic
% object. Each element in dynamObj2Time corresponds to one waypoint in dynamObj1waypts.

%% retrn type: dynamicObjects matrix of n objects.

function dynamicObjects = dynamicObject(maxTime, Scenario)
    
    % Object 1
    dynamObj1waypts = [
    165 353 0;
    176 350 5;
    178 345 9.5;
    178 345 0
    ];
    dynamObj1Time = [5 50 75 maxTime];
    dynamObj1Trajec = waypointTrajectory(dynamObj1waypts, "TimeOfArrival", dynamObj1Time, "ReferenceFrame", "ENU", "AutoBank", true);
    object1 = uavPlatform("UAV1", Scenario, "Trajectory", dynamObj1Trajec, "ReferenceFrame", "ENU");


    % Object 2
    dynamObj2waypts = [
        62 354 4;
        68 354 7;
        70 354 9;
        70 354 10
    ];
    dynamObj2Time = [3 13 29 maxTime];  
    dynamObj2Trajec = waypointTrajectory(dynamObj2waypts, "TimeOfArrival", dynamObj2Time, "ReferenceFrame", "ENU", "AutoBank", true);
    object2 = uavPlatform("UAV2", Scenario, "Trajectory", dynamObj2Trajec, "ReferenceFrame", "ENU");

    dynamicObjects = {object1, object2};

end

