%% Read Markers Data With Kinect
rosinit;
%%
matchBox_Poses = FindTags(5)
%% Fill array
Marker1Pos = matchBox_Poses{1,1}'
Marker2Pos = matchBox_Poses{1,2}'
Marker3Pos = matchBox_Poses{1,3}'


    