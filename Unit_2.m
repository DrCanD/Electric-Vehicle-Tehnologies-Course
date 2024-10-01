% Parameters for Powertrain Model
m = 1000; % mass of vehicle in kg
initial_velocity = 0; % Initial velocity in m/s
acceleration = 2; % Acceleration in m/s^2
time = linspace(0, 150, 1501); % Time array in seconds
threshold_speed = 20; % Threshold speed where ICE takes over in m/s
electric_motor_torque = 450; % Torque of electric motor in Nm
ICE_torque = 280; % Torque of internal combustion engine in Nm
regenerative_efficiency = 0.85; % Efficiency of regenerative braking
battery_capacity = 50000; % Battery capacity in Wh (Watt-hour)
battery_voltage = 400; % Battery voltage in Volts

% Initializing arrays to store velocity, torque, regenerative energy, and battery state
velocity = zeros(1, length(time));
torque = zeros(1, length(time));
regenerative_energy_Ah = zeros(1, length(time)); % Array to store regenerative energy in Ah
battery_state_percent = zeros(1, length(time)); % Array to store battery state of charge in percent
battery_state_percent(1) = 50; % Start at 50% state of charge

% Simulating the vehicle's behavior
for i = 2:length(time)
    if i > 1000 && i <= 1200 % Simulating a road gradient or heavy load
        acceleration = -1.5; % Increased negative acceleration for more regenerative braking
    elseif i > 1200
        acceleration = -1; % Lighter braking towards the end
    else
        if velocity(i-1) < threshold_speed
            torque(i) = electric_motor_torque; % Electric motor propulsion
        else
            torque(i) = ICE_torque; % Switch to ICE propulsion
        end
        acceleration = torque(i) / m; % a = F/m (F = torque / wheel radius)
    end

    % Update velocity
    velocity(i) = velocity(i-1) + acceleration * (time(i) - time(i-1));

    % Regenerative braking during deceleration
    if acceleration < 0 && velocity(i) > 0
        regenerative_power = regenerative_efficiency * abs(acceleration) * m * velocity(i);
        regenerative_energy_Wh = regenerative_power * (time(i) - time(i-1)) / 3600; % Convert power to Wh
        regenerative_energy_Ah(i) = regenerative_energy_Wh / battery_voltage; % Convert Wh to Ah
        battery_state_percent(i) = min(battery_state_percent(i-1) + (regenerative_energy_Wh / battery_capacity) * 100, 100); % Update battery SoC in percent
    else
        battery_state_percent(i) = battery_state_percent(i-1); % Maintain previous state if no regen energy is generated
    end
end



% Plotting the results
figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.2, 0.5, 0.8]);
subplot(3,1,1);
plot(time, velocity, 'LineWidth', 1.5);
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on;

subplot(3,1,2);
plot(time, torque, 'LineWidth', 1.5);
title('Torque vs Time');
xlabel('Time (s)');
ylabel('Torque (Nm)');
grid on;

subplot(3,1,3);
yyaxis left
plot(time, regenerative_energy_Ah, 'LineWidth', 1.5); % Plotting in Ah
ylabel('Regenerative Energy (Ah)');
yyaxis right
plot(time, battery_state_percent, 'r', 'LineWidth', 1.5); % Plot battery SoC in percent
ylabel('Battery State of Charge (%)');
title('Regenerative Energy and Battery State vs Time');
xlabel('Time (s)');
grid on;
