function ExecuteTrajectory(robot, qMatrix, pauseValue, planePoints)
%ANIMATETRAJ Summary of this function goes here
%   This function was written as a framework for how to animate the robot,
%   whilst performing collision avoidance, and the necessary safety checks
%   simultaneously.
    
matrixSize = size(qMatrix);

    for i = 1:1: matrixSize(1,1) 
        % Update the next step in the traj
        
        
        % Check the safety state
        if CheckSafetyState == 1
            disp('Safe to execute command');
        else
            disp('Unsafe to execute command - Check E-stop and Light Curtrain');
        end
        
        
        % Check collision avoidance using "planePoints" variable
        if IsCollision == 0
            disp('Safe - No collisions detected');
        else
            disp('Unsafe! Potential collision detected');
            break
        end
        
        
        % If safe, send one step command to the robot

        
        robot.animate(qMatrix(i,:))
            
            pause(pauseValue);
        
    end
end

%execute - update one step, send one movement to the real robot, check
    %   safety state