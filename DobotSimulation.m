clear all
clf
clc

L1 = Link('d',0.08,      'a',0,      'alpha', pi/2,   'offset',pi,   'qlim', [deg2rad(-135), deg2rad(135)]);
L2 = Link('d',0.0,      'a',-0.135,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(5), deg2rad(80)]);
L3 = Link('d',0.0,      'a',-0.147,    'alpha',0,    'offset',0,   'qlim', [deg2rad(15), deg2rad(170)]);
L4 = Link('d',0.0,      'a',-0.05254,    'alpha',-pi/2,    'offset',0,   'qlim', [deg2rad(-90), deg2rad(90)]);
L5 = Link('d',-0.08,      'a',0,    'alpha',0,    'offset',0,   'qlim', [deg2rad(-85), deg2rad(85)]);


robot = SerialLink([L1 L2 L3 L4 L5],'name','DobotMagician');

qHome = [ 0    0.4189    1.3090   -0.1466   -0.8727];
qHome2 = [ 0    0.500    1.3080   -0.146   -0.873];
qHome(1,4) = pi/2 - qHome(1,2) -qHome(1,3);
qHome2(1,4) = pi/2 - qHome2(1,2) -qHome2(1,3);
robot.plot(qHome);

homeTr = robot.fkine(qHome);
homePoint = homeTr(1:3,4);


%% Set up points
% generate points to simulate the matchboxes
matchbox1 = transl(0.2,   0.2,   0.02);        %ensures it's always on the bench (same height as UR3)
matchbox2 = transl(0.22,  0.18,   0.020);        %ensures it's always on the bench (same height as UR3)
matchbox3 = transl(0.24,   0.16,   0.020);

hold on
%matchbox1_h = trplot(matchbox1);
%matchbox2_h = trplot(matchbox2);
%matchbox3_h = trplot(matchbox3);
% plot the matchbox points
hold on
matchbox1Point = plot3(matchbox1(1,4), matchbox1(2,4), matchbox1(3,4), '*', 'color', 'b');
matchbox2Point = plot3(matchbox2(1,4), matchbox2(2,4), matchbox2(3,4), '*', 'color', 'b');
matchbox3Point = plot3(matchbox3(1,4), matchbox3(2,4), matchbox3(3,4), '*', 'color', 'b');


matchboxCell = {matchbox1, matchbox2, matchbox3};


drop1 = transl(0.2, -0.2, 0.0)*trotx(pi);
drop2 = transl(0.25, -0.21, 0.040)*trotx(pi);
drop3 = transl(0.3, -0.19, 0.060)*trotx(pi);


dropCell = {drop1, drop2, drop3};

hold on
drop1Point = plot3(drop1(1,4), drop1(2,4), drop1(3,4), '*', 'color', 'r');
drop2Point = plot3(drop2(1,4), drop2(2,4), drop2(3,4), '*', 'color', 'r');
drop3Point = plot3(drop3(1,4), drop3(2,4), drop3(3,4), '*', 'color', 'r');

drop1Waypoint = drop1(1:3,4);
drop1Waypoint(3,1) = drop1Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff
drop2Waypoint = drop2(1:3,4);
drop2Waypoint(3,1) = drop2Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff
drop3Waypoint = drop3(1:3,4);
drop3Waypoint(3,1) = drop3Waypoint(3,1)+0.1;        % Create way point 100mm above dropoff

%% generate linear trajectories
steps = 50;
line1 = LinearTrajectory(homePoint', matchbox1(1:3,4)', steps);
plot3(line1(:,1),line1(:,2),line1(:,3),'b.','LineWidth',0.25)
for i = 1:1:steps
    currentPoint = line1(i,:);
    currentTR = transl(currentPoint);
    
    newQ = robot.ikcon(currentTR, qHome);
    robot.animate(newQ);
    
end


%%
% pauseAmount = 0.001;
% t = [0:0.1:3]';
%         %change the transform to the new one (add z axis offset)
%         brickViaTr = drop1;
%         brickViaTr(3,4) = brickViaTr(3,4)+0.05;
%         q_brick_via = robot.ikcon(brickViaTr, robot.getpos);
%       
%         % Creat a trajectory from the nominal position to above the brick
%         q_new = jtraj(qHome, q_brick_via, t);
%         
%         
%         DobotAnimateTraj(robot, q_new, pauseAmount);



