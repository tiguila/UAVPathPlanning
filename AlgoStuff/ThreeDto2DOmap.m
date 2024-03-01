% Create arrays for the x, y, and z coordinates of the waypoints (forming a grid)
x = 0:600;
y = 0:450;

% Create a 2D occupancy map from the 3D map
map2D = binaryOccupancyMap(600,450);
for Ix = x
    for Iy = y
        % Check if the corresponding point in 3D map is occupied
        if checkOccupancy(map3D,[Ix Iy 10])
            % Set the corresponding point in 2D map to occupied
            setOccupancy(map2D, [Ix Iy],1)
        end
    end
end

% Visualize the 2D and 3D occupancy maps
figure
show(map2D)
imsave