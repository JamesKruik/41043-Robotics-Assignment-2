clear all
clc
clf


L1 = Link('d',0.1,      'a',0,      'alpha', pi/2,   'offset',pi,   'qlim', [deg2rad(-135), deg2rad(135)]);
L2 = Link('d',0.0,      'a',-0.135,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(5), deg2rad(80)]);
L3 = Link('d',0.0,      'a',-0.147,    'alpha',0,    'offset',0,   'qlim', [deg2rad(15), deg2rad(170)]);
L4 = Link('d',0.0,      'a',-0.05254,    'alpha',-pi/2,    'offset',0,   'qlim', [deg2rad(-90), deg2rad(90)]);
L5 = Link('d',-0.08,      'a',0,    'alpha',0,    'offset',0,   'qlim', [deg2rad(-85), deg2rad(85)]);


robot = SerialLink([L1 L2 L3 L4 L5],'name','DobotMagician');
qHome = [0    0.5978    1.0463   -0.5524   -0.8901];
qHome(1,4) = pi/2 - qHome(1,2) -qHome(1,3);
robot.plot(qHome);
robot.teach;
desiredPoint = [0.25 0 0.1];

newJointConfig = DobotIkine(desiredPoint);
newJointConfig = [newJointConfig(1,:) 0]

robot.plot(newJointConfig);

