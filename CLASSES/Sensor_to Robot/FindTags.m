
function [matchBox_Poses] = FindTags(allowedTime)

Target_Time = allowedTime;
currentTime = 0;
Tr_Base_Cam = transl(0.255,0,0.3780)*troty(pi); %tf from the base of the robot to the camera

marker5_flag = 0;
marker2_flag = 0;
marker3_flag = 0;

while  currentTime < Target_Time
    
    Start_timer = tic;
    
    subscribe_ros = rossubscriber('/tf');
    scan_data = rosmessage('tf2_msgs/TFMessage');
    data_receive = receive(subscribe_ros, 10);
    
    Marker_no = data_receive.Transforms.ChildFrameId;
    %showdetails(data_receive); %show info in message of tf
    
    if Marker_no == 'ar_marker_5'
        if marker5_flag == 0
            Marker_5 = data_receive.Transforms.Transform.Translation;
            Marker5_transl = [Marker_5.X,Marker_5.Y,Marker_5.Z,1]';
            Marker5_pickUp_location = Tr_Base_Cam*Marker5_transl; % transforming the target from camera frame to robot base
            
            matchBox_Poses{1,1} = Marker5_pickUp_location(1:3,:);
            marker5_flag = 1;
        end
        
        
        
    else if Marker_no == 'ar_marker_2'
            if marker2_flag == 0
                Marker_2  = data_receive.Transforms.Transform.Translation;
                Marker2_transl = [Marker_2.X,Marker_2.Y,Marker_2.Z, 1]';
                Marker2_pickUp_location = Tr_Base_Cam*Marker2_transl;
                
                matchBox_Poses{1,2} = Marker2_pickUp_location(1:3,:);
                marker2_flag = 1;
            end
            
        else if Marker_no == 'ar_marker_3'
                if marker3_flag == 0
                Marker_3  = data_receive.Transforms.Transform.Translation;
                Marker3_transl = [Marker_3.X,Marker_3.Y,Marker_3.Z, 1]';
                Marker3_pickUp_location = Tr_Base_Cam*Marker3_transl;
                
                matchBox_Poses{1,3} = Marker3_pickUp_location(1:3,:);
                
                marker3_flag = 1;
                end
            end
            
        end
        
        time_End = toc(Start_timer);
        
        currentTime = currentTime + time_End;
        disp(currentTime);
        
    end
    
    
    
end
