%% test Camera on Matlab
clf
%Initisalise the camera 
camList = webcamlist
try cam = webcam(2); end % 1 is the PC camera
%% Image acquisition
preview(cam); %Streams the feed

%% take a snapshot
img = snapshot(cam); %takes a photo

% Save and Display the frame in a figure(1) window.
imwrite(img,'Photo_RGB.jpg');


%% Colour spaces
I =  imread('Photo_RGB.jpg');
imshow(I);

%RGB Colour space
rmat = I(:,:,1);
gmat = I(:,:,2);
bmat = I(:,:,3);

% figure(1);
% subplot(2,2,1), imshow(rmat);
% title('Red Plane');
% subplot(2,2,2), imshow(gmat);
% title('Green Plane');
% subplot(2,2,3), imshow(bmat);
% title('Blue Plane');
% subplot(2,2,4), imshow(I);
% title('Original image');

%% Color Segmentation 
levelr = 0.35;
levelg = 0.25;
levelb = 0.25;

i1 = im2bw(rmat, levelr);
i2 = im2bw(gmat, levelg);
i3 = im2bw(bmat, levelb);
Isum = (i1&i2&i3);

%Plot the Area

% figure(1);
% subplot(2,2,1), imshow(i1);
% title('Red Plane');
% subplot(2,2,2), imshow(i2);
% title('Green Plane');
% subplot(2,2,3), imshow(i3);
% title('Blue Plane');
% subplot(2,2,4), imshow(Isum);
% title('Sum of the planes');

%% Complement image and fill holes 
Icomp = imcomplement(Isum);
Ifilled = imfill(Icomp, 'holes');
%figure(1), imshow(Ifilled);
%% Clearing image 
se = strel('disk', 5);
Iopenned = imopen(Ifilled,se);
imshow(Iopenned);

%% Extract features

Iregion = regionprops(Iopenned, 'centroid');
[labeled, numObjects] = bwlabel(Iopenned,4);
stats = regionprops(labeled, 'Eccentricity', 'Area', 'BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity]

% Use feature analysis to count objects in frame
idxOfMatchboxes = find(eccentricities);
statsDefects = stats(idxOfMatchboxes);


hold on;
index = size(idxOfMatchboxes)
for idx = 1:1:index(1,2)
    h = rectangle('Position', stats(idx).BoundingBox, ...
     'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '-');
end


stats = regionprops('table',Iopenned,'Centroid','Orientation')
Objects_detected = size(stats,1);

% take a look at the results
head(stats) %first few objects
% Continuing with the figure(1) created above, add the center points
hold on;

ph1 = plot(stats.Centroid(:,1),stats.Centroid(:,2) , 'rs'); 

