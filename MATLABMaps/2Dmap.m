% Define the 2-D MAP ARRAY range in (x, y)
MAX_X = 15;
MAX_Y = 15;
MAP = 2 * ones(MAX_X, MAX_Y);  % Initialize the 2D map

% Generating random x and y values
randomXVals = randi([1, MAX_X], 1, MAX_X);
randomYVals = randi([1, MAX_Y], 1, MAX_Y);

% Initialize random obstacles at random (x, y) positions
for i = 1:MAX_Y
    xval = randomXVals(i);
    yval = randomYVals(i);
    
    % Set the corresponding position in the MAP array to -1
    MAP(xval, yval) = -1;
end

% Generating the Start (x, y)
xStart = 0;
yStart = 0;
while true
    % Generate random x and y values for starting position, range [1, 5]
    xStart = randi(5);
    yStart = randi(5);

    % Check if the generated starting position is within the bounds of the MAP array
    if xStart > 0 && xStart <= MAX_X && yStart > 0 && yStart <= MAX_Y
        break;  % Exit the loop when a valid starting position is found
    end
end

% Generating the target (x, y)
xTarget = 0;  % Initialize xStart
yTarget = 0;  % Initialize yStart
while true
    % Generate random x and y values for target, range [max-5, max]
    xTarget = randi([MAX_X-5, MAX_X]);
    yTarget = randi([MAX_Y-5, MAX_Y]);

    % check if the (x, y) is within the bounds of the MAP
    if xTarget > 0 && xTarget <= MAX_X && yTarget > 0 && yTarget <= MAX_Y
        break;  % Exit the loop when a valid starting position is found
    end
end

% Robot starting and target position
MAP(xStart, yStart) = 1;
MAP(xTarget, yTarget) = 0;

% Create a 2D visualization
[x, y] = meshgrid(1:MAX_X, 1:MAX_Y);
figure;
hold on;

% Scatter points on the 2D plane
scatter(x(MAP == 0) + 0.5, y(MAP == 0) + 0.5, 'red', 'filled', 'diamond');
scatter(x(MAP == -1) + 0.5, y(MAP == -1) + 0.5, 'black', 'filled');
scatter(x(xStart, yStart) + 0.5, y(yStart) + 0.5, 'green', 'filled', 'diamond');

% Label start and target points
text(xStart, yStart, 'Start', 'FontSize', 12, 'Color', 'b');
text(xTarget, yTarget, 'Target', 'FontSize', 12, 'Color', 'b');

% Label axis
title("2D Map");
xlabel('X-axis');
ylabel('Y-axis');

% Set min and max for each x, y view respectively
axis([1, MAX_X+2, 1, MAX_Y+2]);
grid on;
