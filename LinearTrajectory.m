function [linearTraj] = LinearTrajectory(point1, point2, steps)
%LINEARTRAJECTORY
%   Function that takes two arbitrary points and a number of steps and
%   generates a linear trajectory between them
% adapted from code found here: https://au.mathworks.com/matlabcentral/answers/259773-linear-interpolation-in-3d-space

P1 = [point1];
P2 = [point2];
n = steps;
t = linspace(0,1,n)';
linearTraj = (1-t)*P1 + t*P2;

end

