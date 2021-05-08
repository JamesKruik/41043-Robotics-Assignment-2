
%% Start Dobot Magician Node
rosinit;
% 
% %% Start Dobot ROS
dobot = DobotMagician();
% 
% %% Check the safety status and then publish that it is safe to proceed
% dobot.safetyStateMsg;
% 
% %% To initialise the robot (or reintialise), publish a safety state message with the value of 2
% [safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
% safetyStateMsg.Data = 2;
% send(safetyStatePublisher,safetyStateMsg);
% pause(5) % pause to let the robot initialize without sending any further commands to it


%% (Check home position)

matchboxPoses = FindTags(15)

% Publish custom end effector pose
% dobot.PublishToolState(false);
% end_effector_position = [0,0.0,0.1];        
% end_effector_rotation = [0,0,0];
% dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
% pause(2)
% pauseAmount = 2;
% homePosition = [0.2,0.0,0.1];
% brick1Pos = [0.3,0.1,-0.04];

brick1Pos = matchboxPoses{1,1}'
brick2Pos = matchboxPoses{1,2}'
brick3Pos = matchboxPoses{1,3}'

wayPointOffsetDist = 0.1;
dropOffPosition = [0.3,-0.05,-0.04]
matchboxHeight = 0.015;



%% Brick 1
%% (Check home position)
% Publish custom end effector pose
dropOffPosition = [0.3,-0.05,-0.04];
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

%% (1)
% Publish custom end effector pose
end_effector_position = brick1Pos(:,1:3);
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

%% (2)
% Publish custom end effector pose
end_effector_position = brick1Pos;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)
% tool on
dobot.PublishToolState(true); %pump
pause(3)


% (3)
% Publish custom end effector pose
end_effector_position = brick1Pos;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

%%
% (4)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (5)
% Publish custom end effector pose
end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(3)
% tool off
dobot.PublishToolState(false);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (7)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(3)




% Brick 2
% (Check home position)
%change drop off height since second brick
dropOffPosition(1,3) = dropOffPosition(1,3)+matchboxHeight

% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (1)
% Publish custom end effector pose
end_effector_position = brick2Pos;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (2)
% Publish custom end effector pose
end_effector_position = brick2Pos;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)
% tool on
dobot.PublishToolState(true);
pause(3)


% (3)
% Publish custom end effector pose
end_effector_position = brick2Pos;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (4)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (5)
% Publish custom end effector pose

end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(3)
% tool off
dobot.PublishToolState(false);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (7)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(3)

% Brick 3
% (Check home position)
%change drop off height since third brick
dropOffPosition(1,3) = dropOffPosition(1,3)+matchboxHeight


% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (1)
% Publish custom end effector pose
end_effector_position = brick3Pos;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (2)
% Publish custom end effector pose
end_effector_position = brick3Pos;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)
% tool on
dobot.PublishToolState(true);
pause(3)


% (3)
% Publish custom end effector pose
end_effector_position = brick3Pos;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (4)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (5)
% Publish custom end effector pose
end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;        
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(3)
% tool off
dobot.PublishToolState(false);
pause(pauseAmount)

% (6)
% Publish custom end effector pose
end_effector_position = dropOffPosition;
end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;       
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)

% (7)
% Publish custom end effector pose
end_effector_position = homePosition;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(1)
dropOffPosition = [0.3,-0.05,-0.04]




%% Test ESTOP 
% Send this first

point1 = homePosition;
point2 = brick1Pos;
newQ = LinearTrajectory(point1, point2, 100);

% Set robot to first point in the traj
end_effector_position = point1;        
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(pauseAmount)
%

for j = 1:1:length(newQ)-1
    j
    end_effector_position = newQ(j,:);        
    end_effector_rotation = [0,0,0];
    dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
    pause(0.5)
    
end




% for i = 0.1:0.025:1.0
%     
%     joint_target = [0.0,i,0.3,0.0];
%     dobot.PublishTargetJoint(joint_target)
%     pause(0.1);
% end

%% When the robot is in motion, send this
dobot.EStopRobot();

%% Reinitilise Robot
dobot.InitaliseRobot();

%% End effector

%% Tool On
dobot.PublishToolState(true);

%% Tool Off
dobot.PublishToolState(false);

%% Send the first wayPoint end-effector position
% Publish custom end effector pose
end_effector_position = [0,0,0];
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);

%% Send the first desired pickUp end-effector position, pause, turn on gripper
% Publish custom end effector pose
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);
% turn on gripper
dobot.PublishToolState(true);
pause(1);

%% Send the home position command
% Publish custom end effector pose
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);

%
%% Send the desired dropOff waypoint position of the end effector, once there, turn off gripper
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);

%% Send position of the dropOff location
% Publish custom end effector pose
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);
% turn off gripper
dobot.PublishToolState(false);
pause(1);

%% Send Command to return to wayPoint
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);

%% Send Command to return to homePoint
end_effector_position = [0.2,0,0.1];
end_effector_rotation = [0,0,-1];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);




