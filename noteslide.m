function varargout = noteslide(varargin)
% NOTESLIDE MATLAB code for noteslide.fig
%      NOTESLIDE, by itself, creates a new NOTESLIDE or raises the existing
%      singleton*.
%
%      H = NOTESLIDE returns the handle to a new NOTESLIDE or the handle to
%      the existing singleton*.
%
%      NOTESLIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOTESLIDE.M with the given input arguments.
%
%      NOTESLIDE('Property','Value',...) creates a new NOTESLIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before noteslide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to noteslide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help noteslide

% Last Modified by GUIDE v2.5 24-Feb-2011 23:15:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @noteslide_OpeningFcn, ...
                   'gui_OutputFcn',  @noteslide_OutputFcn, ...
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


% --- Executes just before noteslide is made visible.
function noteslide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to noteslide (see VARARGIN)

% Choose default command line output for noteslide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% gui file chooser
wavfile = uigetfile(('*.wav'), 'Choose a sound file to autotune');
setappdata(0,'wavfile', wavfile);
% enable play button if file is chosen
if(wavfile) 
    set(handles.pushbutton1, 'Enable', 'on');
end;
% set initial shift value
initval = 12;
set(handles.slider1,'Value',initval);
set(handles.sliderValue_editText,'String', num2str(initval));

% store initial shift value
setappdata(0,'num', initval);

% UIWAIT makes noteslide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = noteslide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function sliderValue_editText_Callback(hObject, eventdata, handles)
% hObject    handle to sliderValue_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% str2double(get(hObject,'String')) returns contents of sliderValue_editText as a double
% get the string for the editText component
sliderValue = get(handles.slider_editText,'String');
 
% convert from string to number if possible, otherwise returns empty
sliderValue = str2num(sliderValue);
 
% if user inputs something is not a number, or if the input is less than 0
% or greater than 24, then the slider value defaults to 12
if (isempty(sliderValue) || sliderValue < 12 || sliderValue > 24)
    set(handles.slider1,'Value',12);
    set(handles.slider_editText,'String','12');
else
    set(handles.slider1,'Value',sliderValue);
end

% --- Executes during object creation, after setting all properties.
function sliderValue_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderValue_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%obtains the slider value from the slider component

%sliderValue = get(handles.slider1,'Value');
sliderValue = floor(get(hObject,'Value'));

%puts the slider value into the edit text component
%set(handles.sliderValue_editText,'String', num2str(sliderValue));
%just get integers
set(handles.sliderValue_editText, 'String', sliderValue);
setappdata(0,'num', sliderValue);
 
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% shift the pitch when the slider is moved
pitchshift;

% update variables
shifted = getappdata(0, 'shifted');
fs = getappdata(0, 'fs');

% play the sound
sound(shifted,fs);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% gui file chooser
wavfile = uigetfile(('*.wav'), 'Choose a sound file to autotune');
setappdata(0,'wavfile', wavfile);
% disable play button
set(handles.pushbutton1, 'Enable', 'off');
% enable play button if file is chosen
if(wavfile) 
    set(handles.pushbutton1, 'Enable', 'on');
end;
