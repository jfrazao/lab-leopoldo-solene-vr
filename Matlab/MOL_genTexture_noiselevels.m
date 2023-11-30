
%% Parameters:
Nsx             = 192;	% Size of background image is Nsy x Nsx
Nsy             = 128;	

% Nsx             = 192;	% Size of synthetic image is Nsy x Nsx
% Nsy             = 64;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

% noise params:
Nsmoothing      = 10;
Nwindow         = 50;

% Texture params:
rootDir         = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% imagefiles = {'seamless-circle-pattern-6543320.jpg','sawtooth-grating.o.jpg','d30_1923.o.jpg','30D_3500.o.jpg'};

% imagefiles = {'seamless-circle-pattern-6543320.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};
imagefiles = {'D3_c.o.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};

Nimages = length(imagefiles);


%% for images:
imdata = NaN(Nsx,Nsy,Nimages);
for i=1:Nimages
    im = double(imread(fullfile(rootDir,imagefiles{i})));	
    if ndims(im)==3
        im = mean(im,3);
    end
    im = im - min(im(:)); im = (im / max(im(:)))*255; 

    imdata(:,:,i) = im(1:Nsx,1:Nsy);
end

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.6,0.15])
for i=1:Nimages
    subplot(1,Nimages,i)
    imshow(uint8(imdata(:,:,i)'))
end

%% Show spectrum as well for the images: 
figure; set(gcf,'color','w','units','normalized','Position',[    0.2594    0.0898    0.4354    0.5907])
for i=1:Nimages
    subplot(3,Nimages,i)
    imshow(uint8(imdata(:,:,i)'))
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

    [f1,Pf]=radial_profile(impf,1);

    subplot(3,Nimages,i+Nimages*2)

    % Now define a frequency coordinate from 0 to N/2:
    % f1=0:N/2;
    % and plot the rotationally averaged spectrum on a log-log plot:
    % figure()
%     loglog(f1,Pf)
    semilogy(f1,Pf)
end


%% Generate the noise background:
BGnoise = randi([0,255],Nsx,Nsy+Nwindow-1);

BGnoise = [BGnoise(size(BGnoise,1)-49:size(BGnoise,1),:); BGnoise; BGnoise(1:50,:)];

win = fspecial('gaussian',Nwindow,Nsmoothing);
BGnoise = conv2(BGnoise,win,'valid');

BGnoise = BGnoise - min(BGnoise(:)); BGnoise = (BGnoise / max(BGnoise(:)))*255; 

BGnoise = BGnoise(52:end,:);

figure; imshow(uint8([BGnoise; BGnoise])')
save(fullfile(rootDir,'BG.mat'),'BGnoise');

%% load background image:

load(fullfile(rootDir,'BG.mat'),'BGnoise');

%% Show histogram of pixel intensities:

figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.4,0.3]); hold all;
for iM=1:Nimages
    plot(0:254,histcounts(imdata(:,:,iM),0:255,'normalization','pdf'),'linewidth',2); 
end
plot(0:254,histcounts(BGnoise,0:255,'normalization','pdf'),'linewidth',2,'color','k'); 
title('Pixel intensities','fontsize',15)

%% Generate stimuli as merge between background and stim: 
figure; set(gcf,'color','w','units','normalized','Position',[0.2,0.5,0.46,0.35])
contrasts = [0,0.02,0.05,0.1,0.25,0.5,1];

for iC = 1:length(contrasts)
    for iM=1:Nimages
        iMerge = uint8(contrasts(iC) * double(imdata(:,:,iM)) + (1-contrasts(iC)) * double(BGnoise));

        subplot(Nimages,length(contrasts),iC + (iM-1)*length(contrasts))
        imshow(uint8(iMerge)')
        title(contrasts(iC),'fontsize',10)
    end
end
tightfig

%% Save contrast versions:

contrasts = 0:0.01:1;

for iC = 1:length(contrasts)
    for iM=1:Nimages
        iMerge = uint8(contrasts(iC) * double(imdata(:,:,iM)) + (1-contrasts(iC)) * double(BGnoise));
%         iMerge = uint8(iC * double(imdata(:,:,iM)) + (1-iC) * double(BGnoise));
        
        if ~exist(fullfile(rootDir,char(iM + 64)),'dir')
            mkdir(fullfile(rootDir,char(iM + 64)))
        end
        filename = fullfile(rootDir,char(iM + 64),sprintf('%s_%03.0f.jpg',char(iM + 64),iC-1));
        imwrite(uint8(iMerge)',filename);
    end
end

%% Save background:
% figure; imshow(uint8([BGnoise; BGnoise])')
nreps = 8;

BG_Textures = uint8(repmat(BGnoise,nreps,1))' ;
% iMerge = uint8(0 * double(imdata(:,:,iOri)) + 1 * double(BGnoise));
filename = fullfile(rootDir,'BG_Textures.jpg');
imwrite(BG_Textures,filename);

% iMerge = uint8(0 * double(imdata(:,:,iM)) + 1 * double(BGnoise));
% filename = fullfile(rootDir,'BG_Textures.jpg');
% imwrite(uint8(iMerge)',filename);


