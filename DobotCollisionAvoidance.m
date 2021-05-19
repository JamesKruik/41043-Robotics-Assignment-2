clc
clf

% Based on Collision Detection Module provided by UTS, by Gavin Paul

L1 = Link('d',0.1,      'a',0,      'alpha', pi/2,   'offset',pi,   'qlim', [deg2rad(-135), deg2rad(135)]);
L2 = Link('d',0.0,      'a',-0.135,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(5), deg2rad(80)]);
L3 = Link('d',0.0,      'a',-0.147,    'alpha',0,    'offset',0,   'qlim', [deg2rad(15), deg2rad(170)]);
L4 = Link('d',0.0,      'a',-0.05254,    'alpha',-pi/2,    'offset',0,   'qlim', [deg2rad(-90), deg2rad(90)]);
L5 = Link('d',-0.08,      'a',0,    'alpha',0,    'offset',0,   'qlim', [deg2rad(-85), deg2rad(85)]);

robot = SerialLink([L1 L2 L3 L4 L5],'name','DobotMagician');
qHome = [0    0.5978    1.0463   -0.5524   -0.8901];
qHome(1,4) = pi/2 - qHome(1,2) -qHome(1,3);

% Get position of 'home' configuration homeTr = p560.fkine(qHome);
homePoint = (homeTr(1:3,4));
robot.plot(qHome);
hold on

%% Set up collision avoidance surface at table height
[X,Y] = meshgrid(-0.5:0.05:0.5,-0.5:0.05:0.5);
sizeMat = size(Y);
Z = repmat(0,sizeMat(1),sizeMat(2));
oneSideOfCube_h = surf(X,Y,Z);

% Combine one surface as a point cloud
planePoints = [X(:),Y(:),Z(:)];
%% Create link ellipsoids
centerPoint = [0,0,0];
radii = [0.05,0.05,0.05];
[X,Y,Z] = ellipsoid( centerPoint(1), centerPoint(2), centerPoint(3), radii(1), radii(2), radii(3) );
for i = 1:6
    robot.points{i} = [X(:),Y(:),Z(:)];
    warning off
    robot.faces{i} = delaunay(robot.points{i});    %type of triangulation to joint the dots
    warning on;
end

robot.plot3d([qHome]);
axis equal
camlight
robot.teach

% 2.4
algebraicDist = GetAlgebraicDist(planePoints, centerPoint, radii);
pointsInside = find(algebraicDist < 1);
display(['There are ', num2str(size(pointsInside,1)),' points inside']);



function algebraicDist = GetAlgebraicDist(points, centerPoint, radii)

algebraicDist = ((points(:,1)-centerPoint(1))/radii(1)).^2 ...
              + ((points(:,2)-centerPoint(2))/radii(2)).^2 ...
              + ((points(:,3)-centerPoint(3))/radii(3)).^2;
end


