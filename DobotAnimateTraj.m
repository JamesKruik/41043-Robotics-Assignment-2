function DobotAnimateTraj(robot, qMatrix, pauseValue)
%ANIMATETRAJ Summary of this function goes here
%   Detailed explanation goes here
    % Flag True means new message to write.
    % Flag false means clear the message.
matrixSize = size(qMatrix);

    for i = 1:1: matrixSize(1,1)       
            robot.animate(qMatrix(i,:))
            pause(pauseValue);
    end
end

