
%% Parameters:
Nsx             = 192;	% Size of background image is Nsy x Nsx
Nsy             = 128;	

% noise params:
Nsmoothing      = 10;
Nwindow         = 50;

% Texture params:
rootDir         = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
rootDir         = 'E:\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
rootDir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';

oris            = [45 135];

Noris = length(oris);

Par.dblScreenWidth_cm = 20;
Par.dblScreenHeight_cm = 9;
Par.dblScreenDistance_cm = 10;
Par.intScreenHeight_pix = Nsy;
Par.intScreenWidth_pix = Nsx;
Par.dblSpatFreq = 0.08;

dblScreenWidth_deg      = atand((Par.dblScreenWidth_cm / 2) / Par.dblScreenDistance_cm) * 2; 
dblScreenHeight_deg     = atand((Par.dblScreenHeight_cm / 2) / Par.dblScreenDistance_cm) * 2;
pixPerDeg               = Par.intScreenHeight_pix / dblScreenHeight_deg; %number of pixels in single retinal degree
degreesPerCycle         = 1/Par.dblSpatFreq; %number of degrees in a single cycle (black-white block)
pixPerCycle             = degreesPerCycle * pixPerDeg; %number of pixels in such a cycle


%% create gratings:


imdata = NaN(Nsx,Nsy,Noris);
for iOri=1:Noris

    dblRotAngle = oris(iOri);
    dblPhase = 0;

    imSize      = max([Par.intScreenWidth_pix,Par.intScreenHeight_pix]);
    X           = 1:imSize;                     % X is a vector from 1 to imageSize
    X0          = (X / imSize) - .5;            % rescale X -> -.5 to .5
    freq        = imSize/pixPerCycle;           % compute frequency from wavelength
    [Xm,Ym]     = meshgrid(X0, X0);             % 2D matrices
    thetaRad    = (dblRotAngle / 360)*2*pi;     % convert theta (orientation) to radians
    Xt          = Xm * cos(thetaRad);           % compute proportion of Xm for given orientation
    Yt          = Ym * sin(thetaRad);           % compute proportion of Ym for given orientation
    XYt         = Xt + Yt;                      % sum X and Y components
    XYf         = XYt * freq * 2*pi;            % convert to radians and scale by frequency
    thisFrameGrat = sin(XYf + dblPhase);        % make 2D sinewave

    thisFrameGrat(thisFrameGrat>0) = 255;   % Convert into squared waves: white
    thisFrameGrat(thisFrameGrat<0) = 0;   % Convert into squared waves: black
    thisFrameGrat = thisFrameGrat(1:Par.intScreenHeight_pix,1:Par.intScreenWidth_pix); % Cut only screen portion of sq grat


    
    
    imdata(:,:,iOri) = thisFrameGrat';
end

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.6,0.15])
for iOri=1:Noris
    subplot(1,Noris,iOri)
    imshow(uint8(imdata(:,:,iOri))')
end

%% Generate the noise background:
BGnoise = randi([0,255],Nsx,Nsy+Nwindow-1);

BGnoise = [BGnoise(size(BGnoise,1)-49:size(BGnoise,1),:); BGnoise; BGnoise(1:50,:)];

win = fspecial('gaussian',Nwindow,Nsmoothing);
BGnoise = conv2(BGnoise,win,'valid');
BGnoise = BGnoise - min(BGnoise(:)); BGnoise = (BGnoise / max(BGnoise(:)))*255; 

BGnoise = BGnoise(52:end,:);

% figure; imshow(uint8([BGnoise; BGnoise])')
figure; imshow(uint8(BGnoise)')

%% Show histogram of pixel intensities:

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.4,0.3]); hold all;
for iOri=1:Noris
    plot(0:254,histcounts(imdata(:,:,iOri),0:255,'normalization','pdf'),'linewidth',2); 
end
plot(0:254,histcounts(BGnoise,0:255,'normalization','pdf'),'linewidth',2,'color','k'); 
title('Pixel intensities','fontsize',15)


%% Generate stimuli as merge between background and stim: 
figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.46,0.35])
contrasts = [0,0.02,0.05,0.1,0.25,0.5,1];

for iC = 1:length(contrasts)
    for iOri=1:Noris
        iMerge = uint8(contrasts(iC) * double(imdata(:,:,iOri)) + (1-contrasts(iC)) * double(BGnoise));

        subplot(Noris,length(contrasts),iC + (iOri-1)*length(contrasts))
        imshow(uint8(iMerge)')
        title(contrasts(iC),'fontsize',10)
    end
end
tightfig

%% Save contrast versions:

contrasts = 0:0.01:1;

for iC = 1:length(contrasts)
    for iOri=1:Noris
        iMerge = uint8(contrasts(iC) * double(imdata(:,:,iOri)) + (1-contrasts(iC)) * double(BGnoise));
%         iMerge = uint8(iC * double(imdata(:,:,iM)) + (1-iC) * double(BGnoise));
        
        if ~exist(fullfile(rootDir,sprintf('Ori%d',oris(iOri))),'dir')
            mkdir(fullfile(rootDir,sprintf('Ori%d',oris(iOri))))
        end
        filename = fullfile(rootDir,sprintf('Ori%d',oris(iOri)),sprintf('Ori%d_%03.0f.jpg',oris(iOri),iC-1));
        imwrite(uint8(iMerge)',filename);
    end
end

%% Save background:
iMerge = uint8(0 * double(imdata(:,:,iOri)) + 1 * double(BGnoise));
filename = fullfile(rootDir,'BG_gratings.jpg');
imwrite(uint8(iMerge)',filename);


