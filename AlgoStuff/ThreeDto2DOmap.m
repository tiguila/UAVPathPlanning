disp('3D to 2D Occupancy map in progress...')

% Create arrays for the x, y, and z coordinates of the waypoints (forming a grid)
x = 0:ax.XLim(2);
y = 0:ax.YLim(2);

% Create a 2D occupancy map from the 3D map
map2D = binaryOccupancyMap(ax.XLim(2),ax.YLim(2));
for Ix = x
    for Iy = y
        % Check if the corresponding point in 3D map is occupied
        if checkOccupancy(map3D,[Ix Iy height])
            % Set the corresponding point in 2D map to occupied
            setOccupancy(map2D, [Ix Iy],1)
        end
    end
end

% Visualize the 2D and 3D occupancy maps
%figure
%show(map2D)
%axis off;
%set(gcf, "Name", '');
binaryData = occupancyMatrix(map2D);
regularData = ~binaryData;
imshow(regularData, 'InitialMagnification', 'fit');
imwrite(regularData, "Manhattan.jpg");
disp("ThreeDto2DOmap Finished");
disp('3D to 2D Occupancy map completed!')