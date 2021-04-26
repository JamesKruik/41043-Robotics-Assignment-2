% Workflow
%Access (acquiring the date)
% -> Explore and discover (Algorithm development etc)
% -> Share (Useful outputs for design)

%initialize the camera

% decide how frequently to take snapshots (fps) - might not need to be high

% detect the matchboxes (take an image)

% clean up the image and remove any noise. Could just be a manner of
%   reducing each to a binary image with the rectangles visible

% assign a number/name to each (determine the number of boxes in the scene)

% determine the pose of each (the z-component should already be known)
%   (We want the point of contact, so the top, and the centre, as well as
%   how much the end-effector must rotate to stack the box properly)

% store the poses in a cell array in a similar manner to assignment 1
    % initialize matchbox TRs
    
    for 1: number of matchboxes available
        matchbox{i} = homogeneous TR of the current matchbox
    end
    
        
    % Place all brick poses into a cell array
    matchboxCell = {matchbox1, matchbox2, matchbox3, matchbox4, matchbox5};