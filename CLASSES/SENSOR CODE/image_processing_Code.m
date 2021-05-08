%% test Camera on Matlab
clf
%Initisalise the camera 
camList = webcamlist
try cam = webcam(1); end % 1 is the PC camera
cam.Resolution  = '1280x960';
%% Image acquisition
preview(cam); %Streams the feed

%% take a snapshot
img = snapshot(cam); %takes a photo

% Save and Display the frame in a figure(1) window.
imwrite(img,'Photo_RGB.jpg');


% Colour spaces
I =  imread('Photo_RGB.jpg');
imshow(I);

%RGB Colour space
rmat = I(:,:,1);
gmat = I(:,:,2);
bmat = I(:,:,3);



% Color Segmentation 
levelr = 0.35;
levelg = 0.25;
levelb = 0.25;

i1 = im2bw(rmat, levelr);
i2 = im2bw(gmat, levelg);
i3 = im2bw(bmat, levelb);
Isum = (i1&i2&i3);



% Complement image and fill holes 
Icomp = imcomplement(Isum);
Ifilled = imfill(Icomp, 'holes');
%figure(1), imshow(Ifilled);
% Clearing image 
se = strel('disk', 5);
Iopenned = imopen(Ifilled,se);
imshow(Iopenned);

% Extract features

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


%% Camera to world Coordinates

Dobot = transl(0,0,0)
% Dobot_h = trplot(Dobot, 'frame', 'Dobot', 'rgb','arrow','length',0.8);

Camera = transl(0,0.3,0.315)*troty(pi)*trotz(pi)
% Camera_h = trplot(Camera, 'frame', 'Camera', 'rgb','arrow','length',0.8);

% Tr_O_C = transl(0,0.278,0.315)*troty(pi)*trotz(pi)
% Tr_O_C_H = trplot(Tr_O_C,'frame', 'Tr_new', 'rgb','arrow');

Box1_x_centroid = stats.Centroid(1,1);
Box1_y_centroid = stats.Centroid(1,2);

Box2_x_centroid = stats.Centroid(2,1);
Box2_y_centroid = stats.Centroid(2,2);

Box3_x_centroid = stats.Centroid(3,1);
Box3_y_centroid = stats.Centroid(3,2);



A = [842.6237 0 459.3789; 0 788.8323 385.6290 ; 0 0 1] %INTRINSIC CAMERA PARAMS

Pp_1 = [Box1_x_centroid; Box1_y_centroid;1] % XY CENTROID from image processing
Pp_2 = [Box2_x_centroid; Box2_y_centroid;1] % XY CENTROID from image processing
Pp_3 = [Box3_x_centroid; Box3_y_centroid;1] % XY CENTROID from image processing

P_3D_1 = inv(A)*Pp_1 %REARRANGE THE EQUATION TO FIND XYZ 3D POINT
P_3D_2 = inv(A)*Pp_2 %REARRANGE THE EQUATION TO FIND XYZ 3D POINT
P_3D_3 = inv(A)*Pp_3 %REARRANGE THE EQUATION TO FIND XYZ 3D POINT

P_i_1 = Camera(1:3,4)+Camera(1:3,1:3)*P_3D_1 %EXTRACT ONLY THE XYZ AND THEN THE ROTATION FOR THE EQUATION TO TF THE POINT TO INERTIAL
P_i_2 = Camera(1:3,4)+Camera(1:3,1:3)*P_3D_2 %EXTRACT ONLY THE XYZ AND THEN THE ROTATION FOR THE EQUATION TO TF THE POINT TO INERTIAL
P_i_3 = Camera(1:3,4)+Camera(1:3,1:3)*P_3D_3 %EXTRACT ONLY THE XYZ AND THEN THE ROTATION FOR THE EQUATION TO TF THE POINT TO INERTIAL






