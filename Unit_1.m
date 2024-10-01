% 1. Define Parameters
masses = [500, 1000, 1500]; % Masses in kg
initial_velocity = 0; % Initial velocity in m/s
acceleration = 2; % Constant acceleration in m/s^2
time = 0:0.1:10; % Time array from 0 to 10 seconds

% Initialize arrays for velocity and force
velocities = zeros(length(masses), length(time));
forces = zeros(length(masses), 1);

% 2. Compute Velocity and Force for Each Mass
for i = 1:length(masses)
    velocities(i, :) = initial_velocity + acceleration * time; % v = u + at
    forces(i) = masses(i) * acceleration; % F = ma
end

%% 3. Plot Velocity vs. Time for Different Masses
figure;
for i = 1:length(masses)
    plot(time, velocities(i, :), 'DisplayName', ['Mass = ' num2str(masses(i)) ' kg'], 'LineWidth', 1.5);
    hold on;
end
title('Velocity vs Time for Different Vehicle Masses');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend(Location="southeast");
grid on;
hold off;

%% 4. Plot Force vs. Time (Force is Constant for Each Mass)
figure;
for i = 1:length(masses)
    plot(time, forces(i) * ones(size(time)), 'DisplayName', ['Mass = ' num2str(masses(i)) ' kg'], 'LineWidth', 1.5);
    hold on;
end
title('Force vs Time for Different Vehicle Masses');
xlabel('Time (s)');
ylabel('Force (N)');
legend;
ylim([0 4000])
grid on;
hold off;