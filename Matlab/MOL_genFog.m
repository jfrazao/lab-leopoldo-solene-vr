%% Parameters:
pixpercm        = 10;
stimlength      = 200;
stimheight      = 8;
Nsx             = stimlength * pixpercm;	% Size of fog image is Nsy x Nsx
Nsy             = stimheight * pixpercm;	


rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\';

%% Generate gray image:: 

imagedata = uint8(repmat(128,Nsy,Nsx,3));

%% Generate noisy background image:
Nsmoothing      = 10;
Nwindow         = 50;

imagedata = randi([0,255],Nsx,Nsy+Nwindow-1);

imagedata = [imagedata(size(imagedata,1)-49:size(imagedata,1),:); imagedata; imagedata(1:50,:)];

win = fspecial('gaussian',Nwindow,Nsmoothing);
imagedata = conv2(imagedata,win,'valid');
imagedata = imagedata - min(imagedata(:)); imagedata = (imagedata / max(imagedata(:)))*255; 

imagedata = imagedata(52:end,:)';

imagedata = uint8(repmat(imagedata,1,1,3));

%% Generate transparent gradient: 

% alphadata = uint8(repmat(linspace(1,255,Nsx),Nsy,1));
alphadata = uint8(repmat(linspace(1,100,Nsx),Nsy,1));
% alphadata = repmat(linspace(0,1,Nsx),Nsy,1);

figure; set(gcf,'color','w','units','normalized','Position',[0.05,0.5,0.91,0.04])

image(imagedata,'AlphaData',alphadata)

axis off

filename = fullfile(rootDir,'fog.png');
imwrite(imagedata,filename,'png','Alpha',alphadata);

% imagedata = uint8(repmat(128,Nsy,Nsx));
% filename = fullfile(rootDir,'gray128.jpg');
% imwrite(imagedata,filename);
