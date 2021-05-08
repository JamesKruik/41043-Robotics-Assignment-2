%% Subscribe to ROS topic
rosinit; % ros initialisation
%% Start
Target_Time = 5;
currentTime = 0;
while  currentTime < Target_Time
    
    Start_timer = tic;
    
    sub = rossubscriber('/tf');
    scan_data = rosmessage('tf2_msgs/TFMessage');
    data_receive = receive(sub, 10);
    pause(2)
    Marker_no = data_receive.Transforms.ChildFrameId;
    %showdetails(data_receive); %show info in message of tf
    
         if Marker_no == 'ar_marker_0'
        
            Marker_0 = data_receive.Transforms.Transform.Translation;
            Marker0_transl = [Marker_0.X,Marker_0.Y,Marker_0.Z,1]';
        
         else if Marker_no == 'ar_marker_3'
            
            Marker_3  = data_receive.Transforms.Transform.Translation;
            Marker3_transl = [Marker_3.X,Marker_3.Y,Marker_3.Z, 1]';
            
        end
        
    end
    
    Tr_Base_Cam = transl(0.2625,0,0.335)*troty(pi); %tf from the base of the robot to the camera
    Marker0_pickUp_location = Tr_Base_Cam*Marker0_transl; % transforming the target from camera frame to robot base 
    Marker3_pickUp_location = Tr_Base_Cam*Marker3_transl;
   
    tEnd = toc(Start_timer);
    
 
   currentTime = currentTime + tEnd;
   disp(currentTime);
   
end
