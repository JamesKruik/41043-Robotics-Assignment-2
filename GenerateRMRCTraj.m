function [qMatrix] = GenerateRMRCTraj(robot,linearTraj,theta, steps, deltaT, epsilon, initialGuess, weightingMatrix)



%GENERATERMRCTRAJ Summary of this function goes here
%   %[qMatrix] = GenerateRMRCTraj(robot,linearTraj,theta, steps, deltaT, epsilon, initialGuess, weightingMatrix)


T = [rpy2r(theta(1,1),theta(1,2),theta(1,3)) linearTraj(1,:)';zeros(1,3) 1]; % Create transformation of first point and angle

q0 = zeros(1,robot.n);
qMatrix = zeros(steps,robot.n);       % Array for joint anglesR% Initial guess for joint angles
qMatrix(1,:) = robot.ikcon(T,initialGuess);

for i = 1:steps-1
    T = robot.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = linearTraj(i+1,:)' - T(1:3,4);                                  % Get position error from next waypoint
    Rd = rpy2r(theta(1,1),theta(1,2),theta(1,3));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                           % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    %deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = weightingMatrix*[linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = robot.jacob0(qMatrix(i,:));                 % Get Jacobian at current joint state
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = inv(J'*J + lambda *eye(robot.n))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot)';                                                % Solve the RMRC equation (you may need to transpose the         vector)
    for j = 1:robot.n                                                             % Loop through joints 1 to 6
        if qMatrix(i,j) + deltaT*qdot(i,j) < robot.qlim(j,1)                     % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > robot.qlim(j,2)                 % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                         	% Update next joint state based on joint velocities
    %positionError(:,i) = (linearTraj(i+1,:)' - T(1:3,4))';                     % For plotting
    %angleError(:,i) = deltaTheta';                                             % For plotting
end

% for i = 1:steps-1
%     xdot = (linearTraj(i+1,:) - linearTraj(i+1,:))/deltaT;      % Calculate velocity at discrete time step
%     J = robot.jacob0(qMatrix(i,:));            % Get the Jacobian at the current state
%     %J = J(1:2,:);                           % Take only first 2 rows
%     qdot = J/xdot;                             % Solve velocitities via RMRC
%     qMatrix(i+1,:) =  qMatrix(i,:) + deltaT*qdot';                   % Update next joint state
% end


end

