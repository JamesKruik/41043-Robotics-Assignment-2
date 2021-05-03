%% test Camera on Matlab
%Initisalise the camera 
camList = webcamlist
cam = webcam(2) % 1 is the PC camera
%% Image acquisition
preview(cam); %Streams the feed

%% take a snapshot
img = snapshot(cam); %takes a photo

% Save and Display the frame in a figure window.
imwrite(img,'Photo_RGB.png'); 
% my_image = image(img); %this could help finding total xy coordinate of image 

% Read the new image and convert to black and white 

Current_photo = imread('Photo_RGB.png');
 
Conversion_rgb2gray = rgb2gray(Current_photo); %convert to 1 channel unint8 (0-255)
Conversion_gray2bw  = im2bw(Conversion_rgb2gray,0.25); %converts to binary image or BW

Invert_BW = imcomplement(Conversion_gray2bw) %inverts the 1 and 0 or bw


Filled_image = imfill(Invert_BW,'holes');



%morphological structural element Synatax: SE = strel('rectangle', MN),
%cleans the image further 
% Stucturing_Element = strel('rectangle', [1.6 1.14]);
% iopenned = imopen(Filled_image,Stucturing_Element);
% imshow(iopenned);

stats = regionprops('table',Filled_image,'Centroid','Orientation')
Objects_detected = size(stats,1)
imshow(Filled_image);
% take a look at the results
head(stats) %first few objects
% Continuing with the figure created above, add the center points
hold on
ph1 = plot(stats.Centroid(:,1),stats.Centroid(:,2) , 'rs'); 


axis on

stats = [regionprops(Conversion_gray2bw); regionprops(not(Conversion_gray2bw))]; %stats is a 95x1 struct with fields Area, Centroid, Bounding box 


s = regionprops(Conversion_gray2bw,'centroid');

%Bounds the edges with red lines
for i = 1:numel(stats)
    Perimeter_red = rectangle('Position', stats(i).BoundingBox, ...
    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '-');
end

%%video code idea
% photo = videoinput('winvideo', 1);
% for i = 1:30
%         my_image = getsnapshot(photo);
%         file_name = ['Image' num2str(i)];
%         imwrite(my_image,file_name,'png');
%         pause(2);    
%         imshow(my_image(i));
% end