function [distanceGoal] = InitializeIR(numReadings)
%INITIALIZEIR: Sets up serial connection to the arduino board, and sets and
%then returns the goal distance for the IR "light curtain"
%   Should only have to be run once at the start of the program.
port = '/dev/ttyUSB0';

board = 'Uno';

a = arduino(port, board);

irReadings = zeros(1,numReadings);

for i = 1:numReadings
    irReadings(1,i) = readVoltage(a, 'A1')
end

distanceGoal = mean(irReadings) 

end

