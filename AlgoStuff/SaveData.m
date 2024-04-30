% This file is used to save the points the path the drone followed.
%% Run it ONLY after the simulation is completed!

folderName = 'Testing';
filePath = fullfile(pwd, folderName, 'PID918203.csv');
fileID = fopen(filePath, 'w');
for i = 1:size(points, 1)
    fprintf(fileID, '%.15f,%.15f,%.15f\n', points(i, :));
end
fclose(fileID);

