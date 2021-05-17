function DobotAnimateLinearTraj(robot, qMatrix, pauseValue)
%ANIMATETRAJ Summary of this function goes here
%   Detailed explanation goes here
    % Flag True means new message to write.
    % Flag false means clear the message.
matrixSize = size(qMatrix);

    for i = 1:1: matrixSize(1,1)
        q0 = 
        qNew = robot.ikcon(qMatrix(i,:));
            robot.animate(qNew)
            
            pause(pauseValue);
        
    end
end

%execute - update one step, send one movement to the real robot, check
    %   safety state