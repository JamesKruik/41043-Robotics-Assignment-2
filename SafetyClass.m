% This code was an attempt to put all the safety features together into one
% class so that they would be easier to use throughout our code.

classdef SafetyClass
    %SAFETYCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        port = '/dev/ttyUSB0';
        board = 'Uno';
        a = arduino(port, board);
        distaneGoal;
        
        
    end
    
    methods
        
        function SetGoalDistance = SafetyClass()
            
            irReadings = zeros(1,initialIRreadings);
            
            for i = 1:initialIRreadings
                irReadings(1,i) = readVoltage(a, 'A1')
            end
            
            distanceGoal = mean(irReadings)
            
            function [bool] IsSafe = SafetyClass()
                irRaw = readVoltage(a, 'A1');           % Analog pin 1 on arduino Uno
                eStopRaw = readVoltage(a, 'A5');        % Analog pin 5 on arduino Uno
                
                if abs(distanceGoal-irRaw) > irThreshold
                    curtainFlag = 1;        %something has crossed
                end
                
                if eStopRaw >= 4 && curtainFlag == 0
                    
                    bool = True;

                else
                    bool = False;
                end
            end
            
        end
    end
end

