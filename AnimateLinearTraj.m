function AnimateLinearTraj(robot, qMatrix, pauseValue)
%ANIMATETRAJ Summary of this function goes here
%   Simple function to animate the robot movements
%   Iterates through a qMatrix, updating the current plot

matrixSize = size(qMatrix);

    for i = 1:1: matrixSize(1,1) 
            robot.animate(qMatrix(i,:))
            
            pause(pauseValue);
        
    end
end