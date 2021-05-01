%% Camera calibration algorithm 
clf
%Initisalise the camera 
camList = webcamlist
try cam = webcam(2); end % 1 is the PC camera
%% Image acquisition
preview(cam); %Streams the feed

%% Take 20 photos in sequence to use for the calibration 
Calib_No = 20;
for i = 1: Calib_No
    image = snapshot(cam);
    file_name = ['Image_' num2str(i),'.png']; %chose file name and type
    
    imwrite(image,file_name,'png'); %save file
    pause(1);
    
end


