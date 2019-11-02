%%***********************************************************************%%
%%***********************************************************************%%
%                           3D DWT Motion Detector                       %%
%                            Author: sahar yousefi                       %%
%                           Time-stamp:  2017-03-06                      %%
%                         Email: syousefi@ce.sharif.edu                  %%
%%***********************************************************************%%
%%***********************************************************************%%
function varargout = motion_detector(varargin)

% MOTION_DETECTOR MATLAB code for motion_detector.fig
%      MOTION_DETECTOR, by itself, creates a new MOTION_DETECTOR or raises the existing
%      singleton*.
%
%      H = MOTION_DETECTOR returns the handle to a new MOTION_DETECTOR or the handle to
%      the existing singleton*.
%
%      MOTION_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTION_DETECTOR.M with the given input arguments.
%
%      MOTION_DETECTOR('Property','Value',...) creates a new MOTION_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motion_detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motion_detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motion_detector

% Last Modified by GUIDE v2.5 17-Apr-2017 11:10:18

% Begin initialization code - DO NOT EDIT

% close all
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motion_detector_OpeningFcn, ...
                   'gui_OutputFcn',  @motion_detector_OutputFcn, ...
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


% --- Executes just before motion_detector is made visible.
function motion_detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motion_detector (see VARARGIN)

% Choose default command line output for motion_detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes motion_detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function loadButtonCallback(src,evt)    
% --- Outputs from this function are returned to the command line.
function varargout = motion_detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile(fullfile('./input/' ,'*.png'),'Select the image sequence',...
    'MultiSelect', 'on');
imgno=length(FileName);
if(mod(imgno,2) ||imgno>8)%ind-floor(e/2) <0 || ind+floor(e/2) >len 
    addtolistbox(handles.listbox2,'Select even number of images between [2-8]!','r')
elseif(iscell(FileName)&&imgno>1) 
    f=is_filenames_valid(FileName);
    if ~f
        addtolistbox(handles.listbox2,'Problem in file selection: the file formats do not match!','r')
        return
    end
    set(handles.popupmenu3,'String',num2str(imgno));
    set(handles.pushbutton4,'Enable','off')
    myImage=imread(fullfile(PathName,FileName{ceil(length(FileName)/2)}) );
    %   = imread('as.jpg');
    set(handles.axes1,'Units','pixels');
    resizePos = get(handles.axes1,'Position');
    myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
    axes(handles.axes1);
    imshow(myImage);
    set(handles.axes1,'Units','normalized');
    % imshow(axes1,));
    dd={FileName,PathName};
    handles.data=dd;
    guidata(hObject, handles);
    set(handles.text3,'string',FileName{ceil(length(FileName)/2)})
    set(handles.pushbutton2,'Enable','on')
elseif ischar(FileName)
    addtolistbox(handles.listbox2,'Invalid number of image selection!','r')
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton2,'Enable','off')
data=handles.data;



imgno=length(data{1});
e=imgno;
if(mod(imgno,2) ||imgno>8)%ind-floor(e/2) <0 || ind+floor(e/2) >len 
    addtolistbox(handles.listbox2,'Select even number of images between [2-8]!','r')
    
else
    set(handles.pushbutton1,'Enable','off')
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    
    handles.data{3}= e;
    guidata(hObject, handles);
    contents = get(handles.popupmenu4,'String'); 
    r = contents{get(handles.popupmenu4,'Value')};
    r=r(1);
%     if(length(r)>3)
%         r=16;
%     else
%         r=r(1);
%     end
    FileName=cell2mat(data{1}');
    gray_imgs=rgB2Gray(FileName,data{2});
    tic
    [mask,ratioo,w,h]=dwtMD(ceil(e/2),data{2},handles,hObject,e,r,gray_imgs);
    toc
    handles.data{4}=mask;
    guidata(hObject, handles);
    handles.data{5}=ratioo;
    guidata(hObject, handles);
    handles.data{6}=w;
    guidata(hObject, handles);
    handles.data{7}=h;
    guidata(hObject, handles);
    
    set(handles.figure1, 'pointer', 'arrow')
    if ~isempty(mask)
        set(handles.pushbutton4,'Enable','on')
    end
    addtolistbox(handles.listbox2,'Process is ened!','g')
    set(handles.pushbutton1,'Enable','on')
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
img_name=cell2mat(data{1}');
for i=1:length(data{1})
    myImage=imresize(imread([data{2},img_name(i,:)] ),data{5});
    if length(myImage)>2
        myImage=myImage(:,:,1);
    end
   
    zhat=data{4};
    lbls=unique(zhat);
    ind0= find(zhat(:)==lbls(1));
    ind1= find(zhat(:)==lbls(2));
    im0=myImage(:);   im1=myImage(:);
    im1(ind0)=0;
    im0(ind1)=0;
    rgbim=[];
    rgbim(:,:,1)=reshape( im0,data{6},data{7});
    rgbim(:,:,3)=reshape(im1,data{6},data{7});
    rgbim(:,:,2)=mat2gray(myImage);
    
    set(handles.axes2,'Units','pixels');
    resizePos = get(handles.axes2,'Position');
    rgbim= imresize(rgbim, [resizePos(3) resizePos(3)]);
    axes(handles.axes2);
    imshow(rgbim);
    
    set(handles.axes1,'Units','pixels');
    resizePos = get(handles.axes1,'Position');
    myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
    axes(handles.axes1);
    imshow(myImage);
    
    set(handles.axes2,'Units','normalized');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f=is_filenames_valid(FileName)
f=1;
for i=1:length(FileName)
    C1 = strsplit('.',FileName{i});
    for j=i+1:length(FileName)
        C2 = strsplit('.',FileName{j});
        if length(C1{2})~=length(C2{2})
            f=0;
            return
        else
            if sum(C1{2}==C2{2})~=length(C1{2})
                f=0;
                return
            end
        end
    end
end

function gray_imgs=rgB2Gray(FileName,PathName)
gray_imgs=[];
for i=1:size(FileName,1)
    im= imread([PathName ,FileName(i,:)]);
    if length( size(im))>2
        gray_imgs(:,:,i)=im(:,:,1);% + .587*im(:,:,2) + .114*im(:,:,3);
    else
        gray_imgs(:,:,i)=im;
    end
end


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function veiw_menu_Callback(hObject, eventdata, handles)
% hObject    handle to veiw_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('man.pdf')

% --------------------------------------------------------------------
function about_menu_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enableDisableFig(hObject,'off')
h=about();
uiwait(h)
enableDisableFig(hObject,'on')


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
