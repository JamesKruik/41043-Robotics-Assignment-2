% %% Start Dobot Magician Node
% rosinit;
% %% Instantiate Dobot Class
dobot = DobotMagician();
% 
% %% Initialise Robot Initial Position
% % Publish custom end effector pose
dobot.PublishToolState(false);
end_effector_position = [0,0.0,0.1];
end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(2)
pauseAmount = 2;
homePosition = [0.2,0.0,0.1];

wayPointOffsetDist = 0.1;
dropOffPosition_5 = [0.3,0.10,-0.04]
dropOffPosition_2 = [0.3,0.10,-0.04]
dropOffPosition_3 = [0.3,0.10,-0.04]
matchboxHeight = 0.015;

%% Read Markers Data With Kinect
matchBox5_Poses = FindTag5(2);
Marker5_pose = [matchBox5_Poses{1,1} , matchBox5_Poses{1,2} , matchBox5_Poses{1,3}]/3
%

matchBox2_Poses = FindTag2(2);
Marker2_pose = [matchBox2_Poses{1,1} , matchBox2_Poses{1,2} , matchBox2_Poses{1,3}]/3
%%

matchBox3_Poses = FindTag3(2);
Marker3_pose = [matchBox3_Poses{1,1} , matchBox3_Poses{1,2} , matchBox3_Poses{1,3}]/3


%% Markers Positions

 Marker1Pos = matchBox_Poses{1,1}'
 Marker2Pos = matchBox_Poses{1,2}' 
 Marker3Pos = matchBox_Poses{1,3}'


%% MARKER 1 Pick up drop Off Algorithm

        % Publish custom end effector pose
        end_effector_position = Marker5Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        %Go to pick up location
        end_effector_position = Marker5Pos(:,1:3);
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        % Switch tool on
        dobot.PublishToolState(true); %pump
        pause(3)
        
        % Publish custom end effector pose
        end_effector_position = Marker5Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Home Pose
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Waypoint to Drop off Position
        end_effector_position = dropOffPosition_5;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Drop Off
        end_effector_position = dropOffPosition_5;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)
        % Drop Parcel >> tool off
        dobot.PublishToolState(false);
        pause(pauseAmount)
        
        % Return to waypoint
        end_effector_position = dropOffPosition_5;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Return to Home Position
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)
%         
%         
%        
% %     case 2
% %         disp('case 2')
% %         
% %     case 3
% %         disp('case 3')
% %         
% % end

%% MARKER 2 Pick up drop Off Algorithm
% for i = 1:3
%     
% 
% 

% switch Target_Marker
%     case 1
        disp('case 1')
        % Publish custom end effector pose
        end_effector_position = Marker2Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        %Go to pick up location
        end_effector_position = Marker2Pos(:,1:3);
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        % Switch tool on
        dobot.PublishToolState(true); %pump
        pause(3)
        
        % Publish custom end effector pose
        end_effector_position = Marker2Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Home Pose
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Waypoint to Drop off Position
        end_effector_position = dropOffPosition_2;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Drop Off
        end_effector_position = dropOffPosition_2;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)
        % Drop Parcel >> tool off
        dobot.PublishToolState(false);
        pause(pauseAmount)
        
        % Return to waypoint
        end_effector_position = dropOffPosition_2;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Return to Home Position
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)

        
        %% MARKER 3 Pick up drop Off Algorithm
% for i = 1:3
%     
% 
% 

% switch Target_Marker
%     case 1
        disp('case 1')
        % Publish custom end effector pose
        end_effector_position = Marker3Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        %Go to pick up location
        end_effector_position = Marker3Pos(:,1:3);
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        % Switch tool on
        dobot.PublishToolState(true); %pump
        pause(3)
        
        % Publish custom end effector pose
        end_effector_position = Marker3Pos(:,1:3);
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Home Pose
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Publish Waypoint to Drop off Position
        end_effector_position = dropOffPosition_3;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Drop Off
        end_effector_position = dropOffPosition_3;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)
        % Drop Parcel >> tool off
        dobot.PublishToolState(false);
        pause(pauseAmount)
        
        % Return to waypoint
        end_effector_position = dropOffPosition_3;
        end_effector_position(1,3) = end_effector_position(1,3) + wayPointOffsetDist;
        end_effector_rotation = [0,0,-1];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(pauseAmount)
        
        % Return to Home Position
        end_effector_position = homePosition;
        end_effector_rotation = [0,0,0];
        dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
        pause(3)