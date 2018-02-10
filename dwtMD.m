%%***********************************************************************%%
%%***********************************************************************%%
%                           3D DWT Motion Detector                       %%
%                            Author: sahar yousefi                       %%
%                           Time-stamp:  2017-03-06                      %%
%                         Email: syousefi@ce.sharif.edu                  %%
%%***********************************************************************%%
%%***********************************************************************%%
function [mask, ratioo,w,h]=dwtMD(maxT,img_path,handles,hObject,e,r,gray_imgs)



set(handles.listbox2, 'String', '');
cla(handles.axes2,'reset');
drawnow
addtolistbox(handles.listbox2,'Starting....','g')
addtolistbox(handles.listbox2,'Motion detection process is running, Please wait!...','g')


ratioo=1;
[gray_imgs1,w,h]=resize_images(gray_imgs,ratioo);


    
 if maxT<10
    nnnmmm=['00',num2str(maxT)];
elseif maxT<100
    nnnmmm=['0',num2str(maxT)];
elseif maxT<1000
    nnnmmm=['',num2str(maxT)];
elseif maxT<10000
    nnnmmm=['00',num2str(maxT)];
elseif maxT<100000
    nnnmmm=['0',num2str(maxT)];
end

    e=int32(e);
    r=str2double(r);
    w=int32(w);
    h=int32(h);
    

    [features,im]=read_data1_mex(e,r,gray_imgs1,w,h); 
    y=(features);
    %---------------
    try
        contents= get(handles.popupmenu5,'String'); 
        clustering_method = contents{get(handles.popupmenu5,'Value')};
        if strcmp(clustering_method,'GMM')
            [~,mask]=clustering(y,2);
        elseif strcmp(clustering_method,'Kmeans')
            mask=kmeans(y,2);
        end
        maxT=maxT+1;
        disp(maxT);
        imwrite(mat2gray(reshape(mask,w,h)),[img_path 'kmeans',nnnmmm '.png'])
        zhat=mask;
        lbls=unique(zhat);
        if (length(lbls) ==2)
            ind0= (zhat==lbls(1));
            ind1= (zhat==lbls(2));
            im0=im;   im1=im;
            im1(ind0)=0;im0(ind1)=0;
            rgbim(:,:,1)=im0;
            rgbim(:,:,3)=im1;
            rgbim(:,:,2)=mat2gray(im);
            set(handles.axes2,'Units','pixels');
            resizePos = get(handles.axes2,'Position');
            rgbim= imresize(rgbim, [resizePos(3) resizePos(3)]);
            axes(handles.axes2);
            imshow(rgbim);
            set(handles.axes2,'Units','normalized');
            guidata(hObject, handles);
        end
    catch 
        addtolistbox(handles.listbox2,'Problem in Kmeans clustring. The result can not be clustered in to two classes.','r')
        addtolistbox(handles.listbox2,'Maybe the frames have low resolution or do not contain motion!','r')
        addtolistbox(handles.listbox2,'Please select another video sequences contain motion and try again.','r')
    end
end

function [gray_imgs1,w,h]=resize_images(gray_imgs,ratioo)
for i=1:size(gray_imgs,3)
    gray_imgs1(:,:,i)=double((imresize( gray_imgs(:,:,i),ratioo)));
    [w , h]=size(gray_imgs1(:,:,i));
end
end