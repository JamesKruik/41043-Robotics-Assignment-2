%% Camera calibration algorithm 

%Initisalise the camera 
camList = webcamlist
try cam = webcam(2); end % 1 is the PC camera
cam.Resolution  = '960x720';
%% Image acquisition
preview(cam); %Streams the feed

%% Take 20 photos in sequence to use for the calibration 
Calib_No = 40;
for i = 1: Calib_No
    
    image = snapshot(cam); %take photo with webcam toolbox
    file_name = ['Image_' num2str(i),'.jpg']; %chose file name and type
    imwrite(image,file_name,'jpg'); %save file
    
    pause(0.5);
    
end


