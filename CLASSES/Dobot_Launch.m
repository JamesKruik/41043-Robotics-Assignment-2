classdef Dobot_Launch < handle
    % I have created this class to launch and move the UR3
    
    properties
        Dobot;
        %Arm Lengths
        L1 = Link('d',0.100,      'a',0,      'alpha',pi/2,   'offset',0.0,   'qlim', [deg2rad(-90), deg2rad(90)]);
        L2 = Link('d',0.0,      'a',0.135,    'alpha',0,    'offset',0.0,   'qlim', [deg2rad(0), deg2rad(85)]);
        L3 = Link('d',0.0,      'a',0.147,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(-10), deg2rad(95)]);
        L4 = Link('d',0,      'a',0,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(-90), deg2rad(95)]);
        workspace = [-1 1 -1 1 -1 1];
        scale = 0.3;
        name = 'name';
        botID = 'Dobot';
        fixedBase = transl(1,1,1.2);
        
        %Creates a Log file Called 'logFileName_My_UR3_Move.log' in the
        %current folder path
        Log_Dobot = log4matlab('logFileName_Dobot.log');
        
    end
    
    methods
        function obj = Dobot_Launch(~,~)
            %          %this is the Class constructor name of function is the same as the name of Class
            obj.Dobot = SerialLink([obj.L1 obj.L2 obj.L3 obj.L4], obj.name, obj.botID);
            
%                         obj.Dobot.base = obj.fixedBase;
                          
            
        end
        
        
        
        function PlotAndColourRobot(obj)
            
            %PLEASE NOTE: the ply files have been modelled by our team
            
            
            
            for linkIndex = 0:obj.Dobot.n
                %Read .ply files and populates the face data and points
                %The ply files at present are not my own, i might change
                %this if i have time
                [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['Joint',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                
                obj.Dobot.faces{linkIndex+1} = faceData;
                obj.Dobot.points{linkIndex+1} = vertexData;
                
                
            end
            % Display robot
            obj.Dobot.plot3d(zeros(1,obj.Dobot.n),'noarrow','workspace',obj.workspace); %plot robot
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight % coloring/lighting can be changed
            end
            obj.Dobot.delay = 0;  %its to support plot method, as stated in the read me file
            
            
            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:obj.Dobot.n %for loop for 6 joints 'n' is a property of SerialLink
                handles = findobj('Tag', obj.Dobot.name);
                h = get(handles,'UserData');
                try
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                        , plyData{linkIndex+1}.vertex.green ...
                        , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
    end
end








