function [safetyState] = CheckSafetyState(distanceGoal, IRthreshold)
%CHECKSAFETYSTATE checks the state of both the IR and the e-stop
%   returns the state of the safety features, 1 for safe, 0 for unsafe


% Set IR and eStop flags initially to zero
irCurtainFlag = 0;
eStopFlag = 0;

% Read the voltages on the pins related to IR and e-stop
irRaw = readVoltage(a, 'A1');           % Analog pin 1 on arduino Uno
eStopRaw = readVoltage(a, 'A5');        % Analog pin 5 on arduino Uno

    if abs(distanceGoal-irRaw) < IRthreshold
        irCurtainFlag = 1;  % if threshold not reached, make safe  
    end

    if eStopRaw >= 4  
            eStopFlag = 1;  % If eStop not pushed, make the flag safe
    end

    if irCurtainFlag && eStopFlag == 1
        safetyState = 1;
    else
        safetyState = 0;
    end
    
end

