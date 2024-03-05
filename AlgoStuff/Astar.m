ss = stateSpaceSE2;

ss.StateBounds = [map2D.XWorldLimits; map2D.YWorldLimits; [-pi pi]];

sv = validatorOccupancyMap(ss);

sv.Map = map2DClean;

planner = plannerHybridAStar(sv, ...
                             MinTurningRadius=4, ...
                             MotionPrimitiveLength=6);

startPose = [50 350 pi/2]; % [meters, meters, radians]
goalPose = [550 100 -pi/2];
[refpath] = plan(planner,startPose,goalPose);     
show(planner)
"A* Complete"