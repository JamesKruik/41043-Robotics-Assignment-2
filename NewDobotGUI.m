function varargout = NewDobotGUI(varargin)
% NEWDOBOTGUI MATLAB code for NewDobotGUI.fig
%      NEWDOBOTGUI, by itself, creates a new NEWDOBOTGUI or raises the existing
%      singleton*.
%
%      H = NEWDOBOTGUI returns the handle to a new NEWDOBOTGUI or the handle to
%      the existing singleton*.
%
%      NEWDOBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWDOBOTGUI.M with the given input arguments.
%
%      NEWDOBOTGUI('Property','Value',...) creates a new NEWDOBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewDobotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewDobotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewDobotGUI

% Last Modified by GUIDE v2.5 10-May-2021 12:19:39

% This function generates a GUI to control the stick model of the Dobot

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewDobotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NewDobotGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before NewDobotGUI is made visible.
function NewDobotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewDobotGUI (see VARARGIN)

% Choose default command line output for NewDobotGUI
handles.output = hObject;

%disp('setting flag to 0')
handles.EStopFlag = 0;
handles.strq1Value = rad2deg(0);
handles.strq2Value = rad2deg(0.7854);
handles.strq3Value = rad2deg(1.3090);
handles.strq4Value = rad2deg(0.2618);
handles.strq5Value = rad2deg(-0.8727);


% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using DobotGUI.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes NewDobotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = NewDobotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in pushbutton1asdas. ("Load Dobot")
function pushbutton1asdas_Callback(hObject, eventdata, handles)
cla
axes(handles.axes1);





L1 = Link('d',0.1,      'a',0,      'alpha', pi/2,   'offset',0.0,   'qlim', [deg2rad(-135), deg2rad(135)]);
L2 = Link('d',0.0,      'a',-0.135,    'alpha',0,    'offset',-pi/2,   'qlim', [deg2rad(5), deg2rad(80)]);
L3 = Link('d',0.0,      'a',-0.147,    'alpha',0,    'offset',0,   'qlim', [deg2rad(15), deg2rad(170)]);
L4 = Link('d',0.0,      'a',-0.05245,    'alpha',-pi/2,    'offset',0,   'qlim', [deg2rad(-90), deg2rad(90)]);
L5 = Link('d',-0.08,      'a',0,    'alpha',0,    'offset',0,   'qlim', [deg2rad(-85), deg2rad(85)]);

model = SerialLink([L1 L2 L3 L4 L5],'name','DobotMagician');
qHome = [0 0.7854 1.3090 0.2618 -0.8727];
qHome(1,4) = pi/2 - qHome(1,2) -qHome(1,3);
model.plot(qHome);
disp('Loaded Dobot')
%disp(handles.EStopFlag)

% for linkIndex = 0:model.n
%     [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['UR5Link',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>        
%     model.faces{linkIndex+1} = faceData;
%     model.points{linkIndex+1} = vertexData;
% end

% Display robot
workspace = [-2 2 -2 2 -0.1 2];   
%model.plot(zeros(1,model.n),'noarrow','workspace',workspace);
if isempty(findobj(get(gca,'Children'),'Type','Light'))
    camlight
    
end  
model.delay = 0;

% Try to correctly colour the arm (if colours are in ply file data)
for linkIndex = 0:model.n
    handles = findobj('Tag', model.name);
    h = get(handles,'UserData');
end
view(3)
    
data = guidata(hObject);
data.model = model;

guidata(hObject,data);


% --- Executes on button press in pushbutton2. (q1 -)
function pushbutton2_Callback(hObject, eventdata, handles)

%disp(handles.EStopFlag)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end
% Get current joint configuration
q = handles.model.getpos;

% Vary the value of the target joint by a small amount
q(1,1) = q(1,1) - deg2rad(5);

% Check that the is still within joint limits
if q(1,1) < handles.model.qlim(1,1)
    disp('Exceeding Joint Limit');
    q(1,1) = handles.model.qlim(1,1);
end

%update q config to reflect the relationship to the endeffector
q(1,4) = pi/2 - q(1,2) -q(1,3);

% update the robot with the newly updated config
handles.model.animate(q);

%update the associated textbox
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton3. (q1 +)
function pushbutton3_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,1) = q(1,1) + deg2rad(5);
if q(1,1) > handles.model.qlim(1,2)
    disp('Exceeding Joint Limit');
    q(1,1) = handles.model.qlim(1,2);
end

q(1,4) = pi/2 - q(1,2) - q(1,3);
handles.model.animate(q);
%disp('q1 +')

set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton4. (q2 -)
function pushbutton4_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,2) = q(1,2) - deg2rad(5);
if q(1,2) < handles.model.qlim(2,1)
    disp('Exceeding Joint Limit');
    q(1,2) = handles.model.qlim(2,1);
end

q(1,4) = pi/2 - q(1,2) -q(1,3);

handles.model.animate(q);
%disp('q2 -')
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton5. (q2 +)
function pushbutton5_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,2) = q(1,2) + deg2rad(5);
if q(1,2) > handles.model.qlim(2,2)
    disp('Exceeding Joint Limit');
    q(1,2) = handles.model.qlim(2,2);
end

q(1,4) = pi/2 - q(1,2) -q(1,3);

handles.model.animate(q);
%disp('q2 +')
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);



% --- Executes on button press in pushbutton6. (q3 -)
function pushbutton6_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,3) = q(1,3) - deg2rad(5);
if q(1,3) < handles.model.qlim(3,1)
    disp('Exceeding Joint Limit');
    q(1,3) = handles.model.qlim(3,1);
end

q(1,4) = pi/2 - q(1,2) -q(1,3);

handles.model.animate(q);
%disp('q3 -')
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton7. (q3 +)
function pushbutton7_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,3) = q(1,3) + deg2rad(5);
if q(1,3) > handles.model.qlim(3,2)
    disp('Exceeding Joint Limit');
    q(1,3) = handles.model.qlim(3,2);
end

q(1,4) = pi/2 - q(1,2) -q(1,3);

handles.model.animate(q);
%disp('q3 +')
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);



% --- Executes on button press in pushbutton8. (q4 -)
function pushbutton8_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
%q(1,4) = q(1,4) - 0.1;
%handles.model.animate(q);
disp('q4 is defined by q2 and q3')
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton9. (q4 +)
function pushbutton9_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
%q(1,4) = q(1,4) + 0.1;
%handles.model.animate(q);
disp('q4 is defined by q2 and q3')
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton10. (q5 -)
function pushbutton10_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,5) = q(1,5) - deg2rad(5);
if q(1,5) < handles.model.qlim(5,1)
    disp('Exceeding Joint Limit');
    q(1,5) = handles.model.qlim(5,1);
end
handles.model.animate(q);
%disp('q5 -')
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));
guidata(hObject, handles);


% --- Executes on button press in pushbutton11. (q5 +)
function pushbutton11_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
q(1,5) = q(1,5) + deg2rad(5);
if q(1,5) > handles.model.qlim(5,2)
    disp('Exceeding Joint Limit');
    q(1,5) = handles.model.qlim(5,2);
end
handles.model.animate(q);
%disp('q5 +')
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));

set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));

guidata(hObject, handles);


% --- Executes on button press in pushbutton12. (X +)
function pushbutton12_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;   %current q (safe)
tr = handles.model.fkine(q); %current TR

tr(1,4) = tr(1,4) + 0.01;
newQ = handles.model.ikcon(tr,q); %updated q (need to check)
% testQ = handles.model.ikcon(tr,handles.model.fkine(q));
% for i = 1:5
%     if testQ(1,i) > handles.model.qlim(i,2)
%         testQ(1,i) = handles.model.qlim(i,2);
%         tr(1,4) = tr(1,4) - 0.05;
%     end
%     if testQ(1,i) < handles.model.qlim(i,1)
%         testQ(1,i) = handles.model.qlim(i,1);
%         tr(1,4) = tr(1,4) - 0.05;
%     end
% end
        
handles.model.animate(newQ);
%disp('X +')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));


% --- Executes on button press in pushbutton13. (Y +)
function pushbutton13_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
tr = handles.model.fkine(q);
tr(2,4) = tr(2,4) + 0.01;
newQ = handles.model.ikcon(tr,q);
handles.model.animate(newQ);
%disp('Y +')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));

% --- Executes on button press in pushbutton14. (Z +)
function pushbutton14_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
tr = handles.model.fkine(q);
tr(3,4) = tr(3,4) + 0.01;
newQ = handles.model.ikcon(tr,q);
handles.model.animate(newQ);
%disp('Z +')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));


% --- Executes on button press in pushbutton15. (X -)
function pushbutton15_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
tr = handles.model.fkine(q);
tr(1,4) = tr(1,4) - 0.01;
newQ = handles.model.ikcon(tr,q);
handles.model.animate(newQ);
%disp('X -')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));

% --- Executes on button press in pushbutton16. (Y -)
function pushbutton16_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
tr = handles.model.fkine(q);
tr(2,4) = tr(2,4) - 0.01;
newQ = handles.model.ikcon(tr,q);
handles.model.animate(newQ);
%disp('Y -')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));


% --- Executes on button press in pushbutton17 (Z -)
function pushbutton17_Callback(hObject, eventdata, handles)

if handles.EStopFlag == 1
    disp('Press continue when safe');
    return
end

q = handles.model.getpos;
tr = handles.model.fkine(q);
tr(3,4) = tr(3,4) - 0.01;
newQ = handles.model.ikcon(tr,q);
handles.model.animate(newQ);
%disp('Z -')
set(handles.edit2, 'String', int2str(rad2deg(q(1,1))));
set(handles.edit3, 'String', int2str(rad2deg(q(1,2))));
set(handles.edit4, 'String', int2str(rad2deg(q(1,3))));
set(handles.edit5, 'String', int2str(rad2deg(q(1,4))));
set(handles.edit6, 'String', int2str(rad2deg(q(1,5))));


% --- Executes on button press in pushbutton18. ("E-Stop")
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp(handles.EStopFlag)
if handles.EStopFlag == 1
    disp('System already stopped - press continue when safe')
    return
else
handles.EStopFlag = 1;
guidata(hObject, handles);

disp('STOP')
end


% --- Executes on button press in pushbutton19. ("Continue")
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.EStopFlag == 1
    disp('System back online');
    handles.EStopFlag = 0;
    guidata(hObject, handles);
else
    disp('System already online')
    %disp(handles.EStopFlag);
end


 % (q1 display value)
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
set(handles.edit2, 'String', strq1Value);
guidata(hObject, handles);
disp('in the q1 display callback');
% strFreq = num2str(freq);
% set(handles.STFreqValue, 'String', strFreq);



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%disp('in the q1 display callback');


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
set(handles.stringq1Value) = handles.q1Value;
%set(handles.STFreqValue, 'String', strFreq);



% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
