map = ".\Maps\manhattan.stl";
mapObsticales = ".\Maps\walls20.stl";
%% Recurring Map target
targetRecurr = '.\Data\map1_0.mat';
%%
reuse = false;

VariableConfig;
TwoDroneSTLtoOMap;
ThreeDto2DOmap;
Astar;
Simulation;

%open_system("DroneProto.slx")
disp("Full suite processed.")