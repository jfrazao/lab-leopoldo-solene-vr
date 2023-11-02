
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
rootDir         = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\';
% imagefiles = {'seamless-circle-pattern-6543320.jpg','sawtooth-grating.o.jpg','d30_1923.o.jpg','30D_3500.o.jpg'};

% imagefiles = {'seamless-circle-pattern-6543320.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};
imagefiles = {'D3_c.o.jpg','sd1000_5472.o.jpg', 'poly_grad.o.jpg', 'D20_c.o.jpg'};

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
        
        subplot(Nimages,length(contrasts),iA + (iM-1)*length(alphas))
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
        alphadata = uint8(repmat(alphas(iA),Nsy,Nsx)*64);
%         alphadata(1,1) = 255;
        if ~exist(fullfile(rootDir,char(iM + 64)),'dir')
            mkdir(fullfile(rootDir,char(iM + 64)))
        end
        filename = fullfile(rootDir,char(iM + 64),sprintf('%s_%03.0f.png',char(iM + 64),iA-1));
        imwrite(imagedata,filename,'png','Alpha',alphadata);
%         imwrite(imagedata,filename,'png','Alpha',alphadata,'Background',0.5);
    end
end

