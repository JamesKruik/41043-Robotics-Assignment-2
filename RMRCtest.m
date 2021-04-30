clc
clf

mdl_puma560

q0 = [0 0 0 0 0 0];


% Get position of 'home' configuration
qHome = [0.0559    1.5551   -3.0788    0.2932    0.1047    0.2786]
homeTr = p560.fkine(qHome);
p560.plot(qHome);
% generate points to simulate the matchboxes
matchbox1 = transl(0.4,   0.25,   0.020)*trotx(pi);        %ensures it's always on the bench (same height as UR3)
matchbox2 = transl(0.3,  0.26,   0.020)*trotx(pi);        %ensures it's always on the bench (same height as UR3)
matchbox3 = transl(0.35,   0.3,   0.020)*trotx(pi);

% plot the matchbox points
hold on
matchbox1Point = plot3(matchbox1(1,4), matchbox1(2,4), matchbox1(3,4), '*', 'color', 'b');
matchbox2Point = plot3(matchbox2(1,4), matchbox2(2,4), matchbox2(3,4), '*', 'color', 'b');
matchbox3Point = plot3(matchbox3(1,4), matchbox3(2,4), matchbox3(3,4), '*', 'color', 'b');

matchboxCell = {matchbox1, matchbox2, matchbox3};

% switch case to generate points for the destinations (three options)

% Horizontal line = 1;
% Pyramid = 2;
% Vertical tower = 3;

assemblyOption = 1;

switch assemblyOption
    case 1          % Horizontal line
        disp('Horizontal line')
        
drop1 = transl(0.44, -0.4, 0.020)*trotx(pi);
drop2 = transl(0.5, -0.4, 0.020)*trotx(pi);
drop3 = transl(0.56, -0.4, 0.020)*trotx(pi);

dropCell = {drop1, drop2, drop3};

hold on
drop1Point = plot3(drop1(1,4), drop1(2,4), drop1(3,4), '*', 'color', 'r');
drop2Point = plot3(drop2(1,4), drop2(2,4), drop2(3,4), '*', 'color', 'r');
drop3Point = plot3(drop3(1,4), drop3(2,4), drop3(3,4), '*', 'color', 'r');

    case 2          % Matchmox pyramid
        disp('Matchmox pyramid')
        
drop1 = transl(0.45, -0.4, 0.020)*trotx(pi);
drop2 = transl(0.5, -0.4, 0.020)*trotx(pi);
drop3 = transl(0.475, -0.4, 0.040)*trotx(pi);

dropCell = {drop1, drop2, drop3};

hold on
drop1Point = plot3(drop1(1,4), drop1(2,4), drop1(3,4), '*', 'color', 'r');
drop2Point = plot3(drop2(1,4), drop2(2,4), drop2(3,4), '*', 'color', 'r');
drop3Point = plot3(drop3(1,4), drop3(2,4), drop3(3,4), '*', 'color', 'r');
        
    case 3          % Vertical tower
        disp('Vertical tower')
        
drop1 = transl(0.5, -0.4, 0.020)*trotx(pi);
drop2 = transl(0.5, -0.4, 0.040)*trotx(pi);
drop3 = transl(0.5, -0.4, 0.060)*trotx(pi);

dropCell = {drop1, drop2, drop3};

hold on
drop1Point = plot3(drop1(1,4), drop1(2,4), drop1(3,4), '*', 'color', 'r');
drop2Point = plot3(drop2(1,4), drop2(2,4), drop2(3,4), '*', 'color', 'r');
drop3Point = plot3(drop3(1,4), drop3(2,4), drop3(3,4), '*', 'color', 'r');
        
    otherwise
        disp('Select an assembly option')
end

% Set parameters for the simulation
t = 10;                                     % Total time (s)
deltaT = 0.02;                              % Control frequency
steps = t/deltaT;                           % No. of steps for simulation
delta = 2*pi/steps;                         % Small angle change
epsilon = 0.1;                              % Threshold value for manipulability/Damped Least Squares
W = diag([1 1 1 0.1 0.1 0.1]);              % Weighting matrix for the velocity vector

% Allocate array data
m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,6);       % Array for joint anglesR
qdot = zeros(steps,6);          % Array for joint velocities
theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory
positionError = zeros(3,steps); % For plotting trajectory error
angleError = zeros(3,steps);    % For plotting trajectory error



% Make hard coded trajectories from home position to each drop off;
homePoint = (homeTr(1:3,4));
s1 = LinearTrajectory(homePoint', drop1(1:3,4)', 100);
s1 = LinearTrajectory(homePoint', drop2(1:3,4)', 100);
s1 = LinearTrajectory(homePoint', drop3(1:3,4)', 100);
% Generate the trajectories from the matchboxes (random pos.) to the home

%% track the trajectory with RMRC
% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = p560.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = x(:,i+1) - T(1:3,4);                                         	% Get position error from next waypoint
    Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                                % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = W*[linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = p560.jacob0(qMatrix(i,:));                 % Get Jacobian at current joint state
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = inv(J'*J + lambda *eye(6))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot)';                                                % Solve the RMRC equation (you may need to transpose the         vector)
    for j = 1:6                                                             % Loop through joints 1 to 6
        if qMatrix(i,j) + deltaT*qdot(i,j) < p560.qlim(j,1)                     % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > p560.qlim(j,2)                 % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                         	% Update next joint state based on joint velocities
    positionError(:,i) = x(:,i+1) - T(1:3,4);                               % For plotting
    angleError(:,i) = deltaTheta;                                           % For plotting
end
