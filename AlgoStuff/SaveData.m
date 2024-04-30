% This file is for testing purposes only
% This file is used to save the points in the path the drone followed - used in finding the Percent Error in the drone path.
%% Run it ONLY after the simulation is completed!

folderName = 'Testing';
filePath = fullfile(pwd, folderName, 'PID918226.csv');
fileID = fopen(filePath, 'w');
for i = 1:size(points, 1)
    fprintf(fileID, '%.15f,%.15f,%.15f\n', points(i, :));
end
fclose(fileID);

