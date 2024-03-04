% Define map dimensions
map_width = 600;
map_height = 400;

% Define parameters for snake path
num_points = 1000; % Number of points to represent the snake path
frequency = 0.05; % Frequency of the sinusoidal curve
amplitude = 180; % Amplitude of the sinusoidal curve
z_value = 50; % Constant value for the Z dimension

% Initialize variables
snake_path = zeros(num_points, 3); % Transposed to 1000x3

% Generate snake path
x_values = linspace(0, map_width, num_points); % Generate evenly spaced x-values
y_values = (map_height / 2) + amplitude * sin(frequency * x_values); % Calculate corresponding y-values

% Store waypoints with Z dimension
snake_path(:, 1) = x_values;
snake_path(:, 2) = y_values;
snake_path(:, 3) = z_value; % Assign constant Z value

% Display the snake path
disp('Snake Path:');
disp(snake_path);
