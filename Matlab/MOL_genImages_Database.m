
load('T:\Bonsai\lab-leopoldo-solene-vr\Matlab\images_natimg2800_all.mat');

targetdir = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\ImageDatabase';

for i = 1:size(imgs,3)
    imwrite(imgs(:,:,i),fullfile(targetdir,sprintf('Img%04.0f.jpg',i)))
end

