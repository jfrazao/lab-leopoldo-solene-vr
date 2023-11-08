%% Parameters:
pixpercm        = 10;
stimlength      = 200;
stimheight      = 8;
Nsx             = stimlength * pixpercm;	% Size of background image is Nsy x Nsx
Nsy             = stimheight * pixpercm;	

Nsmoothing      = 10;
Nwindow         = 50;
rootDir         = 'T:\OneDrive\PostDoc\Textures';
rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\background';

%%
IM = randi([0,255],Nsx,Nsy+Nwindow-1);

IM = [IM(size(IM,1)-49:size(IM,1),:); IM; IM(1:50,:)];

% IM = [IM(size(IM,1)-99:size(IM,1),:); IM; IM(1:100,:)];

win = fspecial('gaussian',Nwindow,Nsmoothing);
IM = conv2(IM,win,'valid');
IM = IM - min(IM(:)); IM = (IM / max(IM(:)))*255; 

IM = IM(52:end,:);

figure; imshow(uint8([IM; IM])')

%% Save contrast versions:
for iC = 0:100
    filename = fullfile(rootDir,sprintf('BG_%d.png',iC));
    temp = (IM' - 128)*(iC/100)+128;
    imwrite(uint8(temp),filename);
    
end

%% 


