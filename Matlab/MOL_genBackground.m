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

lowcutoff_cpd   = 0.04;
highcutoff_cpd  = 0.32;

% lowcutoff       = 1/highcutoff_cpd * pixperdeg;
% highcutoff      = 1/lowcutoff_cpd * pixperdeg;

lowcutoff       = lowcutoff_cpd * pixperdeg;
highcutoff      = highcutoff_cpd * pixperdeg;

%% Bandpassed noise:
IM = randi([0,255],Nsx+Nwindow-1,Nsy+Nwindow-1);
win = fspecial('gaussian',Nwindow,Nsmoothing); %some initial gaussian smoothing
IM = conv2(IM,win,'valid');
IM = IM - min(IM(:)); IM = (IM / max(IM(:)))*255; 

% Pad with end of image at start and vice versa to have circular BG
IM = [IM(size(IM,1)-24:size(IM,1),:); IM; IM(1:24,:)];

IM = imbandpass(IM,lowcutoff, highcutoff, filter='butterworth',stripes='horizontal');

IM = IM(25:end-25,:); %remove padding

IM = IM - min(IM(:)); IM = (IM / max(IM(:)))*255; %scale again

%Show bg figure:
figure; imshow(uint8([IM; IM])')
set(gca, 'OuterPosition', [0,0,1,1])
set(gca, 'Position', [0,0,1,1])

%% Save:
filename = fullfile(rootDir,sprintf('BG_%1.2f_%1.2f.png',lowcutoff_cpd,highcutoff_cpd));
imwrite(uint8(IM)',filename);
    
%% Save contrast versions:
for iC = [0 25 50 75 100]
    filename = fullfile(rootDir,sprintf('BG_%1.2f_%1.2f_%d.png',lowcutoff_cpd,highcutoff_cpd,iC));
    temp = (IM' - 128)*(iC/100)+128;
    imwrite(uint8(temp),filename);
end

%% 


