function [bool] = IsSafe()
%ISSAFE: Function to check if the robot is safe to proceed
%   Detailed explanation goes here

%Instantiate the arduino object
port = '/dev/ttyUSB0';
board = 'Uno';
a = arduino(port, board);

irReadings = zeros(1,5);
irThreshold = 0.7;
curtainFlag = 0;


% takes initial readings on boot and averages them, to give baseline 

for i = 1:size(irReadings)
    irReadings(1,i) = readVoltage(a, 'A1');
end

distanceGoal = mean(irReadings);     

irRaw = readVoltage(a, 'A1');           % Analog pin 1 on arduino Uno
eStopRaw = readVoltage(a, 'A5');        % Analog pin 5 on arduino Uno
    
if abs(distanceGoal-irRaw) > irThreshold
        curtainFlag = 1;    
    end

if eStopRaw >= 4 && curtainFlag == 1 
        disp('Safe, full speed');
        
elseif eStopRaw >= 4 && curtainFlag == 1
        disp('Safe, half speed');
    
    else
        disp('Stopped');
    end

end

