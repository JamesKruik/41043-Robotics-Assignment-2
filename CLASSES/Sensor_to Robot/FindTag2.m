function [matchBox2_Poses] = FindTag2(allowedTime)
% rosinit;
%%
Target_Time = allowedTime;
currentTime = 0;
Tr_Base_Cam = transl(0.255,0,0.3780)*troty(pi); %tf from the base of the robot to the camera


marker2_flag = 0;

matchBox2_Poses = {(0) (0) (0)};


while currentTime < Target_Time
    
    Start_timer = tic;
    
    
    subscribe_ros = rossubscriber('/tf');
    scan_data = rosmessage('tf2_msgs/TFMessage');
    data_receive = receive(subscribe_ros, 10);
    Marker_no = data_receive.Transforms.ChildFrameId;
    
    
    if Marker_no == 'ar_marker_2'
        disp('inside marker2')
        if marker2_flag == 0
            
            for i = 1:3
                
                Marker_2 = data_receive.Transforms.Transform.Translation;
                Marker2_transl = [Marker_2.X,Marker_2.Y,Marker_2.Z,1]';
                Marker2_pickUp_location = Tr_Base_Cam*Marker2_transl; % transforming the target from camera frame to robot base
                
                matchBox2_Poses{i} = [Marker2_pickUp_location(i,:) + Marker2_pickUp_location(i,:)+ Marker2_pickUp_location(i,:)];
                
            end
            
            Marker2_pose = [matchBox2_Poses{1,1} , matchBox2_Poses{1,2} , matchBox2_Poses{1,3}]/3;
        end
        marker2_flag = 1;
    end
    
    
    time_End = toc(Start_timer);
    
    currentTime = currentTime + time_End;
    %        disp(currentTime);
    %
end

end