
%% Parameters:
pixpercm        = 10;
stimlength      = 20;
stimheight      = 8;
Nsx             = stimlength * pixpercm;	% Size of image is Nsy x Nsx
Nsy             = stimheight * pixpercm;	

% Texture params:
rootDir         = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% imagefiles = {'seamless-circle-pattern-6543320.jpg','sawtooth-grating.o.jpg','d30_1923.o.jpg','30D_3500.o.jpg'};

% imagefiles = {'seamless-circle-pattern-6543320.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};
imagefiles = {'D3_c.o.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};
Nimages = length(imagefiles);

%for the transparency, value that is fully opaque:
alphamax = 128;

%% For images:
imdata = NaN(Nsy,Nsx,Nimages);
for i=1:Nimages
    im = double(imread(fullfile(rootDir,imagefiles{i})));	
    if ndims(im)==3
        im = mean(im,3);
    end
    imdata(:,:,i) = im(1:Nsy,1:Nsx);
end

for i=1:Nimages
    im = imdata(:,:,i);
    
    im = im - min(im(:)); im = (im / max(im(:)))*255; 
        
    im = im / (mean(im(:)) / 128);

    im(im>255) = 255; 

    imdata(:,:,i) = im;
end

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.6,0.15])
for i=1:Nimages
    subplot(1,Nimages,i)
    imshow(uint8(imdata(:,:,i)))
end

%% Show spectrum as well for the images: 
figure; set(gcf,'color','w','units','normalized','Position',[    0.2594    0.0898    0.4354    0.5907])
for i=1:Nimages
    subplot(3,Nimages,i)
    imshow(uint8(imdata(:,:,i)))
end
for i=1:Nimages
    subplot(3,Nimages,i+Nimages)
    
    N = 256;
    im = imdata(:,:,i);
    % It will be easiest for this exercise if the image is square, so if its not already square you should truncate the largest dimension.  Now, to compute the power spectrum of the image you use the Fourier transform, which converts a function in the space domain to a function in the frequency domain.  You can compute the Fourier transform of an image in Matlab using fft2 as follows:
    imf=fftshift(fft2(im));
    % The function fftshift is needed to put the DC component (frequency = 0) in the center.  The power spectrum is just the square of the modulus of the Fourier transform,  which is obtained as follows:
    impf=abs(imf).^2;
    % To display the power spectrum you will need to define some frequency coordinates.  If the image is of size N, then the frequencies run from -N/2 to N/2-1 (assuming N is even):
    f=-N/2:N/2-1;
    % Then display the log power spectrum using imagesc:
    % figure()
    imagesc(f,f,log10(impf)), axis xy
    % You will note that the power falls off with frequency as you move away from the center.  Ignore the vertical and horizontal streak for now - its an artifact due to the boundaries of the image.  Now, to get a better idea of how the power falls off, we can do a rotational average of the power spectrum:
    % Pf=rotavg(impf);
    set(gca,'XTick',[],'YTick',[]);

    [f1,Pf]=radial_profile(impf,2);

    subplot(3,Nimages,i+Nimages*2)

    % Now define a frequency coordinate from 0 to N/2:
    % f1=0:N/2;
    % and plot the rotationally averaged spectrum on a log-log plot:
    % figure()
%     loglog(f1,Pf)
    semilogy(f1,Pf)
end

%% Show histogram of pixel intensities:
figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.4,0.3]); hold all;
for iM=1:Nimages
    plot(0:254,histcounts(imdata(:,:,iM),0:255,'normalization','pdf'),'linewidth',2); 
    im = imdata(:,:,iM);
    plot([mean(im(:)) mean(im(:))],[0 0.25],'k','linewidth',2); 
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

%% Generate grating stimuli:

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

%% Save full contrast .jpg to compare to alpha = 100
for iOri=1:Noris
%     imagedata = uint8(imdata(:,:,iOri));
    imagedata = uint8(repmat(imdata(:,:,iOri),1,1,3));
    filename = fullfile(rootDir,sprintf('Ori%d',oris(iOri)),sprintf('Ori%d.png',oris(iOri)));
    imwrite(imagedata,filename,'jpg');
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
