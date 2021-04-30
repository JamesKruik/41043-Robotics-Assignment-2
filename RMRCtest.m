clc
clf

mdl_puma560

q0 = [0 0 0 0 0 0];


% Get position of 'home' configuration
qHome = [0.0559    1.5551   -3.0788    0.2932    0.1047    0.2786]
homeTr = p560.fkine(qHome);
homePoint = (homeTr(1:3,4));
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

assemblyOption = 2;

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

    case 2          % Matchbox pyramid
        disp('Matchbox pyramid')
        
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
t = 1;                                     % Total time (s)
deltaT = 0.02;                              % Control frequency
steps = t/deltaT;                           % No. of steps for simulation
delta = 2*pi/steps;                         % Small angle change
epsilon = 0.1;                              % Threshold value for manipulability/Damped Least Squares
W = diag([1 1 1 0.1 0.1 0.1]);              % Weighting matrix for the velocity vector

% Allocate array data
m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,6);       % Array for joint anglesR
qdot = zeros(steps,6);          % Array for joint velocities
%theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory
positionError = zeros(3,steps); % For plotting trajectory error
angleError = zeros(3,steps);    % For plotting trajectory error


%% Trajectories
% Create way points
drop1Waypoint = drop1(1:3,4);
drop1Waypoint(3,1) = drop1Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff
drop2Waypoint = drop2(1:3,4);
drop2Waypoint(3,1) = drop2Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff
drop3Waypoint = drop3(1:3,4);
drop3Waypoint(3,1) = drop3Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff

pick1Waypoint = matchbox1(1:3,4);
pick1Waypoint(3,1) = pick1Waypoint(3,1)+0.1;        % Create way point 100mm above matchbox
pick2Waypoint = matchbox2(1:3,4);
pick2Waypoint(3,1) = pick2Waypoint(3,1)+0.1;        % Create way point 100mm above matchbox
pick3Waypoint = matchbox3(1:3,4);
pick3Waypoint(3,1) = pick3Waypoint(3,1)+0.1;        % Create way point 100mm above matchbox

% Generate the trajectories from the matchboxes to the way points
pick1WaypointTraj1 = LinearTrajectory(homePoint', pick1Waypoint', steps/2);
pick2WaypointTraj2 = LinearTrajectory(homePoint', pick2Waypoint', steps/2);
pick3WaypointTraj3 = LinearTrajectory(homePoint', pick3Waypoint', steps/2);

% Generate the trajectories from the waypoints to the pickup position
pickTraj1 = LinearTrajectory(pick1Waypoint', matchbox1(1:3,4)', steps/2);
pickTraj2 = LinearTrajectory(pick2Waypoint', matchbox2(1:3,4)', steps/2);
pickTraj3 = LinearTrajectory(pick3Waypoint', matchbox3(1:3,4)', steps/2);

% Concatenate the two trajectories
pickTraj1 = [pick1WaypointTraj1; pickTraj1];
pickTraj2 = [pick2WaypointTraj2; pickTraj2];
pickTraj3 = [pick3WaypointTraj3; pickTraj3];

% Create reverse trajectory from matchbox to home point
matchbox1toHome = flip(pickTraj1);
matchbox2toHome = flip(pickTraj2);
matchbox3toHome = flip(pickTraj3);

pickUpTrajCellArray = {pickTraj1, pickTraj2, pickTraj3;
               matchbox1toHome, matchbox2toHome, matchbox3toHome}; 

% plot the trajectorties
plot3(pickTraj1(:,1),pickTraj1(:,2),pickTraj1(:,3),'b.','LineWidth',0.25)
plot3(pickTraj2(:,1),pickTraj2(:,2),pickTraj2(:,3),'b.','LineWidth',0.25)
plot3(pickTraj3(:,1),pickTraj3(:,2),pickTraj3(:,3),'b.','LineWidth',0.25)

%Dropping off the matchbox
% Create waypoint trajectories (homepoint to waypoint)
drop1WaypointTraj1 = LinearTrajectory(homePoint', drop1Waypoint', steps/2);
drop2WaypointTraj2 = LinearTrajectory(homePoint', drop2Waypoint', steps/2);
drop3WaypointTraj3 = LinearTrajectory(homePoint', drop3Waypoint', steps/2);

% Create dropoff trajectories (waypoint to drop-off)
dropTraj1 = LinearTrajectory(drop1Waypoint', drop1(1:3,4)', steps/2);
dropTraj2 = LinearTrajectory(drop2Waypoint', drop2(1:3,4)', steps/2);
dropTraj3 = LinearTrajectory(drop3Waypoint', drop3(1:3,4)', steps/2);

% Concatenate the two trajectories
dropTraj1 = [drop1WaypointTraj1; dropTraj1];
dropTraj2 = [drop2WaypointTraj2; dropTraj2];
dropTraj3 = [drop3WaypointTraj3; dropTraj3];

dropoff1toHome = flip(dropTraj1);
dropoff2toHome = flip(dropTraj2);
dropoff3toHome = flip(dropTraj3);

dropOffTrajCellArray = {dropTraj1, dropTraj2, dropTraj3;
               dropoff1toHome, dropoff2toHome, dropoff3toHome};

plot3(dropTraj1(:,1),dropTraj1(:,2),dropTraj1(:,3),'r.','LineWidth',0.25)
plot3(dropTraj2(:,1),dropTraj2(:,2),dropTraj2(:,3),'r.','LineWidth',0.25)
plot3(dropTraj3(:,1),dropTraj3(:,2),dropTraj3(:,3),'r.','LineWidth',0.25)

%% track the trajectory with RMRC
roll = pi;
pitch = 0;
yaw = pi;
theta = [roll pitch yaw];    

% Animate all the bricks
for x = 1:3

T = [rpy2r(theta(1,1),theta(1,2),theta(1,3)) pickUpTrajCellArray{1,x}(1,:)';zeros(1,3) 1]; % Create transformation of first point and angle
q0 = zeros(1,6);                                                            % Initial guess for joint angles
qMatrix(1,:) = p560.ikcon(T,qHome);

% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = p560.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = pickUpTrajCellArray{1,x}(i+1,:)' - T(1:3,4);                  % Get position error from next waypoint
    Rd = rpy2r(theta(1,1),theta(1,2),theta(1,3));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                           % Calculate rotation matrix error
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
    positionError(:,i) = (pickUpTrajCellArray{1,x}(i+1,:)' - T(1:3,4))';                               % For plotting
    angleError(:,i) = deltaTheta';                                           % For plotting
end

AnimateLinearTraj(p560, qMatrix, 0.001);

% return to the home
T = [rpy2r(theta(1,1),theta(1,2),theta(1,3)) pickUpTrajCellArray{2,x}(1,:)';zeros(1,3) 1]; % Create transformation of first point and angle

q0 = zeros(1,6);
qMatrix = zeros(steps,6);       % Array for joint anglesR% Initial guess for joint angles
qMatrix(1,:) = p560.ikcon(T,qHome);

for i = 1:steps-1
    T = p560.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = pickUpTrajCellArray{2,x}(i+1,:)' - T(1:3,4);                                  % Get position error from next waypoint
    Rd = rpy2r(theta(1,1),theta(1,2),theta(1,3));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                           % Calculate rotation matrix error
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
    positionError(:,i) = (pickUpTrajCellArray{2,x}(i+1,:)' - T(1:3,4))';                               % For plotting
    angleError(:,i) = deltaTheta';                                           % For plotting
end

AnimateLinearTraj(p560, qMatrix, 0.001);
qMatrix

%% drop off

T = [rpy2r(theta(1,1),theta(1,2),theta(1,3)) dropOffTrajCellArray{1,x}(1,:)';zeros(1,3) 1]; % Create transformation of first point and angle
q0 = zeros(1,6);                                                            % Initial guess for joint angles
qMatrix(1,:) = p560.ikcon(T,qHome);



% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = p560.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = dropOffTrajCellArray{1,x}(i+1,:)' - T(1:3,4);                                  % Get position error from next waypoint
    Rd = rpy2r(theta(1,1),theta(1,2),theta(1,3));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                           % Calculate rotation matrix error
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
    positionError(:,i) = (dropOffTrajCellArray{1,x}(i+1,:)' - T(1:3,4))';                               % For plotting
    angleError(:,i) = deltaTheta';                                           % For plotting
end

AnimateLinearTraj(p560, qMatrix, 0.001);

% return to the home
T = [rpy2r(theta(1,1),theta(1,2),theta(1,3)) dropOffTrajCellArray{2,x}(1,:)';zeros(1,3) 1]; % Create transformation of first point and angle
q0 = zeros(1,6);
qMatrix = zeros(steps,6);       % Array for joint anglesR% Initial guess for joint angles
qMatrix(1,:) = p560.ikcon(T,qHome);

for i = 1:steps-1
    T = p560.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = dropOffTrajCellArray{2,x}(i+1,:)' - T(1:3,4);                                  % Get position error from next waypoint
    Rd = rpy2r(theta(1,1),theta(1,2),theta(1,3));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                           % Calculate rotation matrix error
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
    positionError(:,i) = (dropOffTrajCellArray{2,x}(i+1,:)' - T(1:3,4))';                               % For plotting
    angleError(:,i) = deltaTheta';                                           % For plotting
end

AnimateLinearTraj(p560, qMatrix, 0.001);

end
