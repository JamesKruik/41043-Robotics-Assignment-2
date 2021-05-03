function [] = AR_tag_recognition()
clc;
clear all;

%% detecting reference image, SURF of the tag, extracting descriptors of the tag

%load in the reference image - AR-tag from file
tagImage = imread('ar_marker1.jpg');

%detecting the features of the ar-tag as a surface
tagImageGray = rgb2gray(tagImage);
tagPoints = detectSURFFeatures(tagImageGray);

tagFeatures = extractFeatures(tagImageGray, tagPoints);

%% Display SURF of tag for a reference

figure(1);
imshow(tagImage);
hold on;
plot(tagPoints.selectStrongest(50)); %finding points of the image to reference for tracking

%% initialiase replacement image for AR tag


%% input feed from webcam

camera = webcam('/dev/video0');
set(camera, 'Resolution', '640x480');

%% detecting SURF in Webcam

webcamFrame = snapshot(camera);

webcamFrameGray = rgb2gray(webcamFrame);
webcamPoints = detectSURFFeatures(webcamFrameGray);

figure(2);
imshow(webcamFrame);
hold on;
plot(webcamPoints.selectStrongest(50));

%% trying to match the reference frames between the image input and the webcam image

deviceFeatures = extractFeatures(webcamFrameGray, webcamPoints);

%need to use matrix as pairs of indexs of another matrix
%this is finding the matrix pairs of the reference image and the webcam
%image matricies

idxImages = matchFeatures(deviceFeatures, tagFeatures);

%the SURF features that match need to be stored to determine the ARtag
%location
matchedDevicePoints = webcamPoints(idxImages(:,1));
matchedTagPoints = tagPoints(idxImages(:,2));

figure(3)
showMatchedFeatures     (webcamFrame,           tagImage,           ...
                         matchedDevicePoints,   matchedTagPoints,   'Montage');

%% Determining transforms/rotation of the image in the space in respect to the webcam
%https://www.mathworks.com/help/vision/ref/estimategeometrictransform.html

[tagTransform, inliertagPoints, inlierwebcamPoints] ... 
    = estimateGeometricTransform( ...
                  matchedTagPoints, matchedDevicePoints, 'Similarity');
      % similarity = geometric tranform type
      %https://www.mathworks.com/help/images/geometric-transformation-types-for-control-point-registration.html

% displaying the inliers of the estimated geomet. transform
figure(4)
showMatchedFeatures     (webcamFrame,            tagImage,                ...
                         inlierwebcamPoints,     inliertagPoints,         'Montage');
%% insert scaled image here
%------------------------------------------



%------------------------------------------

                     
%% insert transfromed image overlay here
%------------------------------------------



%------------------------------------------

%% ============================================================================================================
                     
%% Point Tracking

% initialise tracking
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
initialize(pointTracker, inlierwebcamPoints.Location, webcamFrame);

%Displaying the points being tracked
trackingMarkers = insertMarker(webcamFrame, inlierwebcamPoints.Location, ...
                                'size', 7, 'color', 'green');
                           
figure(5)
imshow(trackingMarkers);

%% tracking points between frames
%storing the previous frame for a visual comparison between frames
previousWebcamFrame = webcamFrame;

%get next frame
webcamFrame = snapshot(camera);

%new points tracking
[trackedPoints, isValid] = step(pointTracker, webcamFrame);

%filter out bad points, setting threshold of good quality points collected
currentAccuratePoints = trackedPoints(isValid,:);
previousAccuratePoints = inlierwebcamPoints.Location(isValid,:);

%% estimating geo trans. between 2 frames

if (nnz(isValid) >=2) %returning the number of non zero elements in the matrix (with at least 2 tracked points in the frames is present)
    [trackingTransform, previousInlierPoints, currentInlierPoints] = ...
            estimateGeometricTransform( ...
                            previousAccuratePoints, currentAccuratePoints, 'Similarity');
end

%indicate the 'valid' geo. trans.
figure(6)
showMatchedFeatures(previousWebcamFrame, webcamFrame, ...
                    previousInlierPoints, currentInlierPoints, 'Montage');

%resetting the point tracker to count the next frame

setPoints(pointTracker, currentAccuratePoints);

