
% imA = pgmRead('nuts.pgm');	% Warning: im0 is a double float matrix!
% imB = pgmRead('reptil_skin.pgm');	% Warning: im0 is a double float matrix!

% imA = double(imread('T:\PostDoc\Textures\checkerboard.o.jpg'));	%Square, large scale
% imB = double(imread('T:\PostDoc\Textures\sd1000_5472.o.jpg'));	%square, small scale
% imC = double(imread('T:\PostDoc\Textures\seamless-circle-pattern-6543320.jpg'));	%round, large scale
% imD = double(imread('T:\PostDoc\Textures\D75_s.o.jpg'));        %round small scale	

rootDir = 'T:\PostDoc\Textures';

imA = double(imread('T:\PostDoc\Textures\sd1000_5472.o.jpg'));	
imB = double(imread('T:\PostDoc\Textures\sawtooth-grating.o.jpg'));	
imC = double(imread('T:\PostDoc\Textures\seamless-circle-pattern-6543320.jpg'));	
imD = double(imread('T:\PostDoc\Textures\disc-lattice.o.jpg'));       

imA = squeeze(imA(:,:,1));
imB = squeeze(imB(:,:,1));
imC = squeeze(imC(:,:,1));
imD = squeeze(imD(:,:,1));

Nsc = 4; % Number of scales
Nor = 4; % Number of orientations
Na  = 7;  % Spatial neighborhood is Na x Na coefficients
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

%% Figure:
close all
figure; set(gcf,'units','normalized','Position',[0.1 0.3 0.3 0.55],'color','w')
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
%         subplot(Nparamresol,Nparamresol,(iY-1)*Nparamresol+iX)
        subplot('Position',[(iX-1)/(Nparamresol)+0.01 (iY-1)/(Nparamresol)+0.01 0.9/Nparamresol 0.9/Nparamresol])
%         showIm(squeeze(imBase(iX,iY,:,:)), 'auto', 1, 'Synthesized texture');
%         showIm(squeeze(imBase(iX,iY,:,:)));

        imshow(squeeze(imBase(iX,iY,:,:)),[]);
    end
end

%% Upsample figures:
% [Xq,Yq] = meshgrid(linspace(1,size(imA,1),1000),linspace(1,size(imA,1),1000));
% imA = interp2(imA,Xq,Yq);
% [Xq,Yq] = meshgrid(linspace(1,size(imB,1),1000),linspace(1,size(imB,1),1000));
% imB = interp2(imB,Xq,Yq);
% [Xq,Yq] = meshgrid(linspace(1,size(imC,1),1000),linspace(1,size(imC,1),1000));
% imC = interp2(imC,Xq,Yq);
% [Xq,Yq] = meshgrid(linspace(1,size(imD,1),1000),linspace(1,size(imD,1),1000));
% imD = interp2(imD,Xq,Yq);

%% Save figures: 
for iX = 1:Nparamresol
    for iY = 1:Nparamresol
        filename = fullfile(rootDir,'stimspace_rect',sprintf('stim_parametric_%d_%d.png',iX,iY));
        imwrite(uint8(squeeze(imBase(iX,iY,:,:))),filename);
    end
end

%% Save contrast versions: 
for iX = [1 Nparamresol]
    for iY = [1 Nparamresol]
        for iC = [25 50 75 100]
            filename = fullfile(rootDir,'stimspace_contr',sprintf('stim_%d_%d_%d.png',iX,iY,iC));
            temp = squeeze(imBase(iX,iY,:,:));
            temp = (temp - 128)*(iC/100)+128;
            imwrite(uint8(temp),filename);
        end
    end
end

%% Compute perceptual similarity matrix: 

net_params = load('weights/net_param.mat');

weights = load('weights/alpha_beta.mat');
resize_img = 1; 
use_gpu = 0;

simmat = NaN(4,4);

for iX = 1:4
    for iY = 1:4
        eval(sprintf('ref = im%d;',iX));
        eval(sprintf('dist = im%d;',iY)); 
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


