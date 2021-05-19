function [linearTraj] = LinearTrajectory(point1, point2, steps)
%LINEARTRAJECTORY
%   Function that takes two arbitrary points and a number of steps and
%   generates a linear trajectory between them
% adapted from code found here: https://au.mathworks.com/matlabcentral/answers/259773-linear-interpolation-in-3d-space

% start(1) and end(2) points
P1 = [point1];
P2 = [point2];

%number of steps
n = steps;

% Choose between LSPB or linspace
%t = linspace(0,1,n)';
t = lspb(0,1,n);


% Generate linear trajectory based on spacing
linearTraj = (1-t)*P1 + t*P2;

end

