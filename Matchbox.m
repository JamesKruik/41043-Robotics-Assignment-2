classdef Matchbox
    %MMatchbox class should populate the 'children'(?) as there are matchboxes recognised in the camera field of view 
    
    
    properties (Constant)
        %54 x 38 x 15 mm
        width = 0.038;
        length = 0.054;
        height = 0.015;
        
    end
    
    properties
        
        matchboxCount = 2;  %defaul number?
        
    end
    
    
    methods (Static)
        %% GetMatchboxModel (Need to get the initial number and position from the camera class)
        function model = GetMatchboxModel(name)
            if nargin < 1
                name = 'Matchbox';
            end
            [faceData,vertexData] = plyread('matchbox.ply','tri');
            L1 = Link('alpha',-pi/2,'a',0,'d',0.3,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2) + 0.4;
            model.points = {vertexData * rotx(-pi/2),[]};
        end
    end
    
        methods
        function obj = Matchbox(inputArg1,inputArg2)
            %MATCHBOX Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of  9this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
            
            
        end
    end
end



