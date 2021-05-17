function [jointConfig] = DobotIkine(desiredPoint)
%DOBOTIKINE Summary of this function goes here
%   Detailed explanation goes here

%add offsets for the end effector (from joint 4 to end-effector)

x = desiredPoint(1,1);
y = desiredPoint(1,2);
z = desiredPoint(1,3);

a2 = 0.135;
a3 = 0.147;

l = sqrt(x^2 + y^2);
D = sqrt(l^2 + z^2);

t1 = atan(z/l);
t2 = acos((a2^2 + D^2 - a3^2)/2*a2*D);

alpha = t1 + t2;
beta = acos((a2^2 + a3^2 - D^2)/2*a2*a3);
theta = atan(y/x);

q1 = theta;
q2 = pi/2 - alpha;
q3 = pi - beta - alpha;
q4 = pi/2 - q2 - q3;

jointConfig = [q1 q2 q3 q4];
end

