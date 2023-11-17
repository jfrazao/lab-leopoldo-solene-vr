
%% Parameters:
% Nsx             = 192;	% Size of background image is Nsy x Nsx
% Nsy             = 128;	

pixpercm        = 10;
stimlength      = 25;
stimheight      = 8;
Nsx             = stimlength * pixpercm;	% Size of fog image is Nsy x Nsx
Nsy             = stimheight * pixpercm;	


% Nsx             = 192;	% Size of synthetic image is Nsy x Nsx
% Nsy             = 64;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

% noise params:
Nsmoothing      = 10;
Nwindow         = 50;

% Texture params:
rootDir         = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% imagefiles = {'seamless-circle-pattern-6543320.jpg','sawtooth-grating.o.jpg','d30_1923.o.jpg','30D_3500.o.jpg'};

% imagefiles = {'seamless-circle-pattern-6543320.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};
imagefiles = {'D3_c.o.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};

alphamax = 128;
Nimages = length(imagefiles);

%% for images:
imdata = NaN(Nsy,Nsx,Nimages);
for i=1:Nimages
    im = double(imread(fullfile(rootDir,imagefiles{i})));	
    if ndims(im)==3
        im = mean(im,3);
    end
    im = im - min(im(:)); im = (im / max(im(:)))*255; 

    imdata(:,:,i) = im(1:Nsy,1:Nsx);
end

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.6,0.15])
for i=1:Nimages
    subplot(1,Nimages,i)
    imshow(uint8(imdata(:,:,i)))
end

%% Show histogram of pixel intensities:
figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.4,0.3]); hold all;
for iM=1:Nimages
    plot(0:254,histcounts(imdata(:,:,iM),0:255,'normalization','pdf'),'linewidth',2); 
end
title('Pixel intensities','fontsize',15)

%% Generate stimuli as transparency levels:: 
figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.46,0.35])
alphas = [0,0.02,0.05,0.1,0.25,0.5,1];

for iA = 1:length(alphas)
    for iM=1:Nimages
        imagedata = uint8(repmat(imdata(:,:,iM),1,1,3));
        alphadata = repmat(alphas(iA),Nsy,Nsx);
        
        subplot(Nimages,length(alphas),iA + (iM-1)*length(alphas))
        image(imagedata,'AlphaData',alphadata)

        title(alphas(iA),'fontsize',10)
        axis off
    end
end
% tightfig

%% Save transparency versions:

alphas = [0.01 0.01:0.01:1];
for iA = 1:length(alphas)
    for iM=1:Nimages
%         imagedata = uint8(imdata(:,:,iM));
        imagedata = uint8(repmat(imdata(:,:,iM),1,1,3));
        alphadata = uint8(repmat(alphas(iA),Nsy,Nsx)*alphamax);
%         alphadata(1,1) = 255;
        if ~exist(fullfile(rootDir,char(iM + 64)),'dir')
            mkdir(fullfile(rootDir,char(iM + 64)))
        end
        filename = fullfile(rootDir,char(iM + 64),sprintf('%s_%03.0f.png',char(iM + 64),iA-1));
        imwrite(imagedata,filename,'png','Alpha',alphadata);
%         imwrite(imagedata,filename,'png','Alpha',alphadata,'Background',0.5);
    end
end

%% 

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


imdata = NaN(Nsy,Nsx,Noris);
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

    imdata(:,:,iOri) = thisFrameGrat;
end

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.6,0.15])
for iOri=1:Noris
    subplot(1,Noris,iOri)
    imshow(uint8(imdata(:,:,iOri)))
end

%%


alphas = [0.01 0.01:0.01:1];
for iA = 1:length(alphas)
    for iOri=1:Noris
%         imagedata = uint8(imdata(:,:,iM));
        imagedata = uint8(repmat(imdata(:,:,iOri),1,1,3));
        alphadata = uint8(repmat(alphas(iA),Nsy,Nsx)*alphamax);
%         alphadata(1,1) = 255;
        if ~exist(fullfile(rootDir,sprintf('Ori%d',oris(iOri))),'dir')
            mkdir(fullfile(rootDir,sprintf('Ori%d',oris(iOri))))
        end
        filename = fullfile(rootDir,sprintf('Ori%d',oris(iOri)),sprintf('Ori%d_%03.0f.png',oris(iOri),iA-1));
        imwrite(imagedata,filename,'png','Alpha',alphadata);
%         imwrite(imagedata,filename,'png','Alpha',alphadata,'Background',0.5);
    end
end


% contrasts = 0:0.01:1;
% 
% for iC = 1:length(contrasts)
%     for iOri=1:Noris
%         iMerge = uint8(contrasts(iC) * double(imdata(:,:,iOri)) + (1-contrasts(iC)) * double(BGnoise));
% %         iMerge = uint8(iC * double(imdata(:,:,iM)) + (1-iC) * double(BGnoise));
%         
%         if ~exist(fullfile(rootDir,sprintf('Ori%d',oris(iOri))),'dir')
%             mkdir(fullfile(rootDir,sprintf('Ori%d',oris(iOri))))
%         end
%         filename = fullfile(rootDir,sprintf('Ori%d',oris(iOri)),sprintf('Ori%d_%03.0f.jpg',oris(iOri),iC-1));
%         imwrite(uint8(iMerge)',filename);
%     end
% end
