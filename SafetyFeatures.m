% Functional Estop
% IR sensor to act as a light curtain example
% Hand detection if time allows

%Physical e-stop connected to an arduino, which is connected to laptop.

% When e-stop is triggered, the system should pause and must not continue
% until the e-stop has been reset, and the gui has been also adressed.

% IR sensor should have a fixed object in it's path - this will allow it to
% initialize with a set distance on start up.

% Once this distance varies (for more than a threshold, and by more than
% some other threshold) than the robot's speed will be halved (or reduced
% by some scalar)

% The sensor will need to read the nominal distance && be set to full speed
% manually in the GUI before the robot returns to full speed.


%Matlab code to be compiled and executed on Arduino
clear
clc
close all

% get some user settings
ledPin = 'D13';

deltaT_blink = 0.5;

% USe matlab support package to instantiate and arduino object that will be
% used to communicate with the arduino board

port = '/dev/ttyUSB0';

board = 'Uno';

a = arduino(port, board);


%% Write a small for loop which blinks the LED to test

% for i = 1:20
%     %turn led off
%     a.writeDigitalPin(ledPin, 0);
%     pause(deltaT_blink/2);
%     
%     
%     %turn led on
%     a.writeDigitalPin(ledPin, 1);
%     pause(deltaT_blink/2);
%     disp('LED on');
%     
% end

%% IR sensor test

irReadings = zeros(1,5);
irThreshold = 0.7;
curtainFlag = 0;
initialIRreadings = 5;

% takes initial readings on boot and averages them, to give baseline 
irReadings = zeros(1,initialIRreadings);
for i = 1:initialIRreadings
    irReadings(1,i) = readVoltage(a, 'A1')
end

distanceGoal = mean(irReadings)     


for i = 1:500
%disp('------------- New reading -------------');

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

pause(0.01);
end



    
