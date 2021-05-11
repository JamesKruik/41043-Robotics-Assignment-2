function [matchBox3_Poses] = FindTag3(allowedTime)
% rosinit;
%%
Target_Time = allowedTime;
currentTime = 0;
Tr_Base_Cam = transl(0.255,0,0.3780)*troty(pi); %tf from the base of the robot to the camera

marker3_flag = 0;
matchBox3_Poses = {(0) (0) (0)};
while currentTime < Target_Time
    
    Start_timer = tic;
    
    
    subscribe_ros = rossubscriber('/tf');
    scan_data = rosmessage('tf2_msgs/TFMessage');
    data_receive = receive(subscribe_ros, 10);
    Marker_no = data_receive.Transforms.ChildFrameId;
    
    
    if Marker_no == 'ar_marker_3'
        disp('inside marker3')
        if marker3_flag == 0;
            
            for i = 1:3
                
                Marker_3 = data_receive.Transforms.Transform.Translation;
                Marker3_transl = [Marker_3.X,Marker_3.Y,Marker_3.Z,1]';
                Marker3_pickUp_location = Tr_Base_Cam*Marker3_transl; % transforming the target from camera frame to robot base
                
                matchBox3_Poses{i} = [Marker3_pickUp_location(i,:) + Marker3_pickUp_location(i,:)+ Marker3_pickUp_location(i,:)]
                
            end
            
          Marker3_pose = [matchBox3_Poses{1,1} , matchBox3_Poses{1,2} , matchBox3_Poses{1,3}]/3;

        end
        marker3_flag = 1;
    end
    
    
    time_End = toc(Start_timer);
    
    currentTime = currentTime + time_End;
    %         disp(currentTime);
    
end

end