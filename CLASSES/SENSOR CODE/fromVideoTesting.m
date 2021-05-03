%% Video TESTING
%% test Camera on Matlab
%Initisalise the camera 
camList = webcamlist
cam = webcam(2) % 1 is the PC camera
%% Image acquisition
preview(cam); %Streams the feed

%% take a snapshot
img = snapshot(cam); %takes a photo

% Save and Display the frame in a figure window.
imwrite(img,'Photo_RGB.jpg'); 
% my_image = image(img); %this could help finding total xy coordinate of image 
 
Current_photo = imread('Photo_RGB.jpg');
% imshow(Current_photo);

Grey_Scale = rgb2gray(Current_photo);
% imshow(Grey_Scale);

threshhold = 0.37;
Binary_Image = im2bw(Grey_Scale,threshhold);
imshowpair(Grey_Scale,Binary_Image, 'montage');

InvertBW = imcomplement(Binary_Image);



