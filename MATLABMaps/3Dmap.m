% Define the 3-D MAP ARRAY range in (x,y,z)
MAX_X = 15;
MAX_Y = 15;
MAX_Z = 15; % Set the maximum Z value for the 3D map
MAP = 2 * ones(MAX_X, MAX_Y, MAX_Z);  % Initialize the 3D map

% Generating random x and y values
randomXVals = randi([1, MAX_X], 1, MAX_X);
randomYVals = randi([1, MAX_Y], 1, MAX_Y);

% Initialize random obstacles at random (x, y) positions
zval = 1;

% Percentage of obstacle reduction
percentage = 0.20;
actualPercentage = floor(MAX_X * percentage);

for i = 1:(MAX_Y-actualPercentage)
    xval = randomXVals(i);
    yval = randomYVals(i);
    
    % Set the corresponding position in the MAP array to -1
    MAP(xval, yval, zval) = -1;
    
    % Add a random number of obstacles in the z-axis for every obstacle at (x, y)
    randomHeightReduction = randi(MAX_Y)/2;
    bldgRandomHeight = randi(MAX_X) - randomHeightReduction;
    for dz = 1:bldgRandomHeight
        if zval + dz <= MAX_Z
            MAP(xval, yval, zval + dz) = -1;
        end
    end
end

% Generating the Start (x,y) ----------

% Initialize (x,y)
xStart = 0;  
yStart = 0;
while true
    % Generate random x and y values for starting position, range [1,5]
    xStart = randi(5);
    yStart = randi(5);

    % Check if the generated starting position is within the bounds of the MAP array
    if xStart > 0 && xStart <= size(MAP, 1) && yStart > 0 && yStart <= size(MAP, 2)
        break;  % Exit the loop when a valid starting position is found
    end
end

% Generating the target (x,y)
xTarget = 0;  % Initialize xStart
yTarget = 0;  % Initialize yStart
while true
    % Generate random x and y values for target, range [max-5, max]
    xTarget = randi([MAX_X-5, MAX_X]);
    yTarget = randi([MAX_X-5, MAX_X]);

    % check if the (x,y) is within the bounds of the MAP
    if xTarget > 0 && xTarget <= size(MAP, 1) && yTarget > 0 && yTarget <= size(MAP, 2)
        break;  % Exit the loop when a valid starting position is found
    end
end

% Robot starting and target position
zStart = 1;
MAP(xStart, yStart, zStart) = 1;

zTarget = 1;
MAP(xTarget, yTarget, zTarget) = 0;


% Create a 3D visualization
[x, y, z] = meshgrid(1:MAX_X, 1:MAX_Y, 1:MAX_Z);
figure;
hold on;

% Center data points in each grid cell
scatter3(x(MAP == 0) + 0.5, y(MAP == 0) + 0.5, z(MAP == 0), 'red', 'filled', 'Marker', 'diamond');
scatter3(x(MAP == -1) + 0.5, y(MAP == -1) + 0.5, z(MAP == -1), 'black', 'filled');
scatter3(x(MAP == 1) + 0.5, y(MAP == 1) + 0.5, z(MAP == 1), 'green', 'filled', 'Marker', 'diamond');

% Label start and target points
text(xStart, yStart, zStart, 'Start', 'FontSize', 12, 'Color', 'b');
text(xTarget, yTarget, zTarget, 'Target', 'FontSize', 12, 'Color', 'b');


% label axis
title("Juan's custum MAP");
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');


% Set min and max for each x, y, z view respectively
axis([1, MAX_X+2, 1, MAX_Y+2, 1, MAX_Z+2]);
grid on;

% 3D perspective
view(3);