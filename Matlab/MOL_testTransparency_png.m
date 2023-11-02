[catimage,xx,catalpha] = imread('C:\Users\Admin\Downloads\alphademo\5a37f4c7817733.6274047015136165835303.png');

figure(); 
image(catimage,'AlphaData',catalpha)

figure(); 
image(catimage,'AlphaData',catalpha/2)

catalphahalf = catalpha/2;
filename = 'C:\Users\Admin\Downloads\alphademo\cathalf.png';
imwrite(catimage,filename,'png','Alpha',catalphahalf);

catalphahalf = catalpha/2;
filename = 'C:\Users\Admin\Downloads\alphademo\cathalf.png';
imwrite(catimage,filename,'png','Alpha',uint8(catalphahalf);

catalpha01 = double(catalpha)/255;
filename = 'C:\Users\Admin\Downloads\alphademo\cat01.png';
imwrite(catimage,filename,'png','Alpha',catalpha01);


[textureimage,xx,texturealpha] = imread('C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Textures\detection_stim\A\A_100.png');

texturealpha = uint8(repmat(linspace(0,255,192),128,1));

figure(); set(gca,'color','k')
image(textureimage,'AlphaData',texturealpha)

filename = 'C:\Users\Admin\Downloads\alphacorridor\texturegradient256.png';
imwrite(textureimage,filename,'png','Alpha',texturealpha);

texturealpha = uint8(repmat(linspace(0,64,192),128,1));

filename = 'C:\Users\Admin\Downloads\alphacorridor\texturegradient64.png';
imwrite(textureimage,filename,'png','Alpha',texturealpha);
