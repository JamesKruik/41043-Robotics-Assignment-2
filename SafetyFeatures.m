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