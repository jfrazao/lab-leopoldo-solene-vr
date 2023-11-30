%% Parameters:
pixpercm        = 20;

stimlength      = 200;
stimheight      = 8;
deg_per_cm      = 60 / 8;
pixperdeg       = pixpercm * deg_per_cm;

Nsx             = stimlength * pixpercm;	% Size of background image is Nsy x Nsx
Nsy             = stimheight * pixpercm;	

Nsmoothing      = 5;
Nwindow         = 50;
rootDir         = 'T:\OneDrive\PostDoc\Textures';
rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\background';

lowcutoff_cpd   = 0.01;
highcutoff_cpd  = 0.5;

lowcutoff       = 1/highcutoff_cpd * pixperdeg;
highcutoff      = 1/lowcutoff_cpd * pixperdeg;

lowcutoff       = lowcutoff_cpd * pixperdeg;
highcutoff      = highcutoff_cpd * pixperdeg;

%%
IM = randi([0,255],Nsx,Nsy+Nwindow-1);

% IM = randn(Nsx,Nsy+Nwindow-1)+1000;

IM = [IM(size(IM,1)-49:size(IM,1),:); IM; IM(1:50,:)];

win = fspecial('gaussian',Nwindow,Nsmoothing);
IM = conv2(IM,win,'valid');
IM = IM - min(IM(:)); IM = (IM / max(IM(:)))*255; 

% IM = [IM(size(IM,1)-99:size(IM,1),:); IM; IM(1:100,:)];


IM = imbandpass(IM,lowcutoff, highcutoff);
% IM = imbandpass(IM,5, 200);

IM = double(IM);


IM = IM - min(IM(:)); IM = (IM / max(IM(:)))*255; 

IM = IM(52:end,:);

figure; imshow(uint8([IM; IM])')

%% Save:

filename = fullfile(rootDir,sprintf('BG_%1.2f_%1.2f.png',lowcutoff_cpd,highcutoff_cpd));
imwrite(uint8(IM)',filename);
    
%% Save contrast versions:
for iC = 0:100
    filename = fullfile(rootDir,sprintf('BG_%d.png',iC));
    temp = (IM' - 128)*(iC/100)+128;
    imwrite(uint8(temp),filename);
    
end

%% 


