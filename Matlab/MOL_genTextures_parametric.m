
% imA = pgmRead('nuts.pgm');	% Warning: im0 is a double float matrix!
% imB = pgmRead('reptil_skin.pgm');	% Warning: im0 is a double float matrix!

rootDir = 'T:\OneDrive\PostDoc\Textures';

%Image set from Jun 2022 to Mar 2023:
% imA = double(imread('T:\OneDrive\PostDoc\Textures\seamless-circle-pattern-6543320.jpg'));	
% imB = double(imread('T:\OneDrive\PostDoc\Textures\sawtooth-grating.o.jpg'));	
% imC = double(imread('T:\OneDrive\PostDoc\Textures\d30_1923.o.jpg'));	
% imD = double(imread('T:\OneDrive\PostDoc\Textures\quilt_s.o.jpg'));  

%Image set from Mar 2023 to ???:
imA = double(imread('T:\OneDrive\PostDoc\Textures\seamless-circle-pattern-6543320.jpg'));	
imB = double(imread('T:\OneDrive\PostDoc\Textures\sawtooth-grating.o.jpg'));	
imC = double(imread('T:\OneDrive\PostDoc\Textures\d30_1923.o.jpg'));	
imD = double(imread('T:\OneDrive\PostDoc\Textures\30D_3500.o.jpg')); 

imA = squeeze(imA(:,:,1));
imB = squeeze(imB(:,:,1));
imC = squeeze(imC(:,:,1));
imD = squeeze(imD(:,:,1));

Nsc = 4; % Number of scales
Nor = 4; % Number of orientations
Na  = 9;  % Spatial neighborhood is Na x Na coefficients
	 % It must be an odd number!

params1 = textureAnalysis(imA, Nsc, Nor, Na);
params2 = textureAnalysis(imB, Nsc, Nor, Na);
params3 = textureAnalysis(imC, Nsc, Nor, Na);
params4 = textureAnalysis(imD, Nsc, Nor, Na);

close all


%% Parameters:
Niter           = 25;	% Number of iterations of synthesis loop
Nsx             = 192;	% Size of synthetic image is Nsy x Nsx
Nsy             = 64;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

Nparamresol     = 5;

imBase          = NaN(Nparamresol,Nparamresol,Nsy,Nsx);

%% Loop:
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        fprintf('%d/%d\n',(iX-1)*Nparamresol+iY,Nparamresol^2)
        params = struct;
        
        w1 = (1-(iX-1)/(Nparamresol-1)) * (1-(iY-1)/(Nparamresol-1));
        w2 = ((iX-1)/(Nparamresol-1)) * (1-(iY-1)/(Nparamresol-1));
        w3 = (1-(iX-1)/(Nparamresol-1)) * ((iY-1)/(Nparamresol-1));
        w4 = ((iX-1)/(Nparamresol-1)) * ((iY-1)/(Nparamresol-1));
        
        fields = fieldnames(params1);
        nFields = length(fields);
        for iField = 1:nFields
            params.(fields{iField}) = params1.(fields{iField})*w1 + params2.(fields{iField})*w2 + params3.(fields{iField})*w3 + params4.(fields{iField})*w4;
        end
        
        % params = params1;
        
        imBase(iX,iY,:,:)       = textureSynthesis_noshow(params, [Nsy Nsx], Niter);
        
    end
end


%% Upsample figures:
imBase_up       = NaN(Nparamresol,Nparamresol,2*Nsy,2*Nsx);
[Xq,Yq]         = meshgrid(linspace(1,Nsx,Nsx*2),linspace(1,Nsy,Nsy*2));

for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        imBase_up(iX,iY,:,:) = interp2(squeeze(imBase(iX,iY,:,:)),Xq,Yq);
    end
end

imBase = imBase_up;

%% Scale figures by black and white:

for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        temp = squeeze(imBase(iX,iY,:,:));
        imBase(iX,iY,:,:) = normalize(temp,'range',[0 255]);
    end
end

%% Figure:
close all
figure; set(gcf,'units','normalized','Position',[0.1 0.25 0.8 0.56],'color','w')
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        subplot('Position',[(iX-1)/(Nparamresol)+0.01 (iY-1)/(Nparamresol)+0.01 0.9/Nparamresol 0.9/Nparamresol])
%         showIm(squeeze(imBase(iX,iY,:,:)), 'auto', 1, 'Synthesized texture');
%         showIm(squeeze(imBase(iX,iY,:,:)));

        imshow(squeeze(imBase(iX,iY,:,:)),[]);
    end
end

%% Take four proto stimuli;
im_VR(1,:,:) = squeeze(imBase(1,1,:,:)); %A
im_VR(2,:,:) = squeeze(imBase(5,1,:,:)); %B
im_VR(3,:,:) = squeeze(imBase(1,5,:,:)); %C
im_VR(4,:,:) = squeeze(imBase(5,5,:,:)); %D

%% Save figures:
for i=1:4
    filename = fullfile(rootDir,'stim',sprintf('stim%s.png',char(64+i)));
    imwrite(uint8(squeeze(im_VR(i,:,:))),filename);
end


%% Save figures: 
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        filename = fullfile(rootDir,'stimspace_rect',sprintf('stim_parametric_%d_%d.png',iX,iY));
        imwrite(uint8(squeeze(imBase(iX,iY,:,:))),filename);
    end
end

%% Save contrast versions:
for i=4
    for iC = [25 50 75 100]
        filename = fullfile(rootDir,'stimspace_contr',sprintf('stim%s_%d.png',char(64+i),iC));
        temp = squeeze(im_VR(i,:,:));
        temp = (temp - 128)*(iC/100)+128;
        imwrite(uint8(temp),filename);
    end
end

%% Compute perceptual similarity matrix: 

net_params = load('weights/net_param.mat');

weights = load('weights/alpha_beta.mat');
resize_img = 1; 
use_gpu = 0;

simmat = NaN(4,4);

%license problem: %execute on Matlab installation with neural network license
for iX = 1:4
    for iY = 1:4
%         eval(sprintf('ref = im%d;',iX));
%         eval(sprintf('dist = im%d;',iY));
        ref = im_VR(iX,:,:);
        dist = im_VR(iY,:,:);
        simmat(iX,iY) = DISTS(ref, dist,net_params,weights, resize_img, use_gpu);
    end
end

%%
figure; 
simmat(eye(4)==1) = NaN;
imagesc(simmat)
caxis([0 1])
colorbar;

%%
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        mean(reshape(imBase(iX,iY,:,:),Nsy*Nsx,1))
    end
end
