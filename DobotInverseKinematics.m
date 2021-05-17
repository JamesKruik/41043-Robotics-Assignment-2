a2 = 0.135;
a3 = 0.147;
c = 0.05;

% Ikine f(θ,l,h)={𝒒𝟏,𝒒𝟐,𝒒𝟑,𝐫𝐞𝐚𝐥} 
%l = a2*sin(q2)+a3*cos(q3);
%h = a2*cos(q2)-a3*sin(q3);

%Ikine f(x,y,z)={θ,l h}
%l = sqrt(x^2 + y^2);
%theta = atan(y/x);
%h = z;

%Ikinef(x,y,z)={𝒒𝟏,𝒒𝟐,𝒒𝟑}
%a2*sin(q2) + a3*cos(q3real) = sqrt(x^2 + y^2);
%a2*cos(q2) - a3*sin(q3real) = z;

syms x y z q2 q3 a2 a3

f1 = a2*sin(q2) + a3*cos(q3) == sqrt(x^2 + y^2)
f2 = a2*cos(q2) - a3*sin(q3) == z

solution = solve([f1,f2],[q2,q3]);
solution.q2
solution.q3

ans1 = subs(solution.q3(2),{x,y,z,a2,a3},{1,1,1,1,1})
val = vpa(ans1, 5)  %change it to a decimal, 5 digits long


link4 = pi/2 - link2 - link3; %to make EE always vertical wrt other two link

%use that as guess pose for invers kine (ikine or ikcon)

%check result of ikine or ikcon

%Change model angles to real angles

% only change 3 -> changes to arm link 2, (model3 + model2 - pi/2) 

 