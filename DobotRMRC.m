clc
clf

% This function was an attempt to use existing RMRC code for the Puma560,
% and adapt it for the DoBot. However since the Jacobian is not square, it
% did not work initially.
% If time allowed, i would have explored using a 3x3 jacobian, as we only
% care about the x,y,z position of the end effector.


L1 = Link('d',0.1,      'a',0,      'alpha', pi/2,   'offset',pi,   'qlim', [deg2rad(-135), deg2rad(135)]);
L2 = Link('d',0.0,      'a',-0.135,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(5), deg2rad(80)]);
L3 = Link('d',0.0,      'a',-0.147,    'alpha',0,    'offset',0,   'qlim', [deg2rad(15), deg2rad(170)]);
L4 = Link('d',0.0,      'a',-0.05245,    'alpha',-pi/2,    'offset',0,   'qlim', [deg2rad(-90), deg2rad(90)]);
L5 = Link('d',-0.08,      'a',0,    'alpha',0,    'offset',0,   'qlim', [deg2rad(-85), deg2rad(85)]);

model = SerialLink([L1 L2 L3 L4 L5],'name','DobotMagician');

qHome = [0 0.7854 1.3090 0.2618 -0.8727];
qHome(1,4) = pi/2 - qHome(1,2)-qHome(1,3);
model.plot(qHome);

t = 10;             % Total time (s)
deltaT = 0.02;      % Control frequency
steps = t/deltaT;   % No. of steps for simulation
delta = 2*pi/steps; % Small angle change
epsilon = 0.1;      % Threshold value for manipulability/Damped Least Squares
W = diag([1 1 1 0.1 0.1 0.1]);    % Weighting matrix for the velocity vector

% 1.2) Allocate array data
m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,3);       % Array for joint anglesR
qdot = zeros(steps,3);          % Array for joint velocities
theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory
positionError = zeros(3,steps); % For plotting trajectory error
angleError = zeros(3,steps);    % For plotting trajectory error

% 1.3) Set up trajectory, initial pose
s = lspb(0,1,steps);                % Trapezoidal trajectory scalar
for i=1:steps
    x(1,i) = (1-s(i))*0.35 + s(i)*0.35;     % Points in x
    x(2,i) = (1-s(i))*-0.55 + s(i)*0.55;    % Points in y
    x(3,i) = 0.5 + 0.2*sin(i*delta);        % Points in z
    theta(1,i) = 0;                         % Roll angle 
    theta(2,i) = 5*pi/9;                    % Pitch angle
    theta(3,i) = 0;                         % Yaw angle
end
 
T = [rpy2r(theta(1,1),theta(2,1),theta(3,1)) x(:,1);zeros(1,3) 1];          % Create transformation of first point and angle
q0 = zeros(1,model.n);                                                            % Initial guess for joint angles
newQMatrix = model.ikcon(T,q0);
qMatrix(1,:) = newQMatrix(1, 1:3);                                            % Solve joint angles to achieve first waypoint

% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = model.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = x(:,i+1) - T(1:3,4);                                         	% Get position error from next waypoint
    Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                                % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = W*[linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = model.jacob0(qMatrix(i,:));                 % Get Jacobian at current joint state
    J = J(1:3, 1:3);
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = inv(J'*J + lambda *eye(3))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot(1:3,1))';                                                % Solve the RMRC equation (you may need to transpose the         vector)
    
    for j = 1:3                                                             % Loop through joints 1 to 6
        if qMatrix(i,j) + deltaT*qdot(i,j) < model.qlim(j,1)                     % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > model.qlim(j,2)                 % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                         	% Update next joint state based on joint velocities
    positionError(:,i) = x(:,i+1) - T(1:3,4);                               % For plotting
    angleError(:,i) = deltaTheta;                                           % For plotting
end

% 1.5) Plot the results
figure(1)
plot3(x(1,:),x(2,:),x(3,:),'k.','LineWidth',1)
model.plot(qMatrix,'trail','r-')

for i = 1:6
    figure(2)
    subplot(3,2,i)
    plot(qMatrix(:,i),'k','LineWidth',1)
    title(['Joint ', num2str(i)])
    ylabel('Angle (rad)')
    refline(0,model.qlim(i,1));
    refline(0,model.qlim(i,2));
    
    figure(3)
    subplot(3,2,i)
    plot(qdot(:,i),'k','LineWidth',1)
    title(['Joint ',num2str(i)]);
    ylabel('Velocity (rad/s)')
    refline(0,0)
end

figure(4)
subplot(2,1,1)
plot(positionError'*1000,'LineWidth',1)
refline(0,0)
xlabel('Step')
ylabel('Position Error (mm)')
legend('X-Axis','Y-Axis','Z-Axis')

subplot(2,1,2)
plot(angleError','LineWidth',1)
refline(0,0)
xlabel('Step')
ylabel('Angle Error (rad)')
legend('Roll','Pitch','Yaw')
figure(5)
plot(m,'k','LineWidth',1)
refline(0,epsilon)
title('Manipulability')
