%% Subscribe to ROS topic 
rosinit; % ros initialisation 
%% Start
while 1
sub = rossubscriber('/tf');

scandata = rosmessage('tf2_msgs/TFMessage');
data_receive = receive(sub, 10);
showdetails(data_receive); %show info in message of tf 

tftree = rostf; %initiate transform tree 

tftree.AvailableFrames %print the available reference frames 

% send transform for robot base 
tfStampedMsg = rosmessage('tf2_msgs/TFMessage');

% send transform for robot base 
tfStampedMsg = rosmessage('tf2_msgs/TFMessage');




% tfStampedMsg.Transforms.Transform.ChildFrameId = 'base'
% tfStampedMsg.Transforms.Transform.Header.FrameId = 'robot_base';
% 
% tfStampedMsg.Transforms.Transform.Translation.X = 0;
% tfStampedMsg.Transforms.Transform.Translation.Y = -0.2;
% tfStampedMsg.Transforms.Transform.Translation.Z = -0.3;
% 
% tfStampedMsg.Header.Stamp = rostime('now'); %tell the point in time this tf is valid from
% sendTransform(tftree, tfStampedMsg) %send the transform





% tfStampedMsg.Transforms.Transform.ChildFrameId = 'base'
% tfStampedMsg.Transforms.Transform.Header.FrameId = 'robot_base';
% 
% tfStampedMsg.Transforms.Transform.Translation.X = 0;
% tfStampedMsg.Transforms.Transform.Translation.Y = -0.2;
% tfStampedMsg.Transforms.Transform.Translation.Z = -0.3;
% 
% tfStampedMsg.Header.Stamp = rostime('now'); %tell the point in time this tf is valid from
% sendTransform(tftree, tfStampedMsg) %send the transform







% mountToCamera = getTransform(tftree, 'camera_rgb_frame', 'camera_rgb_optical_frame')
% ountToCameraTranslation = mountToCamera.Transform.Translation
% quat = mountToCamera.Transform.Rotation
% mountToCameraRotationAngles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]))


% 
% showdetails(data_receive.Transforms.Transform.Translation);
% cellTransforms = {data_receive.Transforms}
end
%Change rotational componenets to deg
% mountToCameraRotationAngles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]))

% showdetails(data_receive.Transforms.Transform.Translation)
% data_receive.Transforms(1).Transform.Translation

% B_A =  fkine (end effector)
% 
% A_B = inv(B_A)
% 
% B_C = tR of the fixed camera 
% 
% C_D = measured camera output 
% 
% A_D =(( A_B*B_C )* C_D)

