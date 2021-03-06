clearvars;
clc;
close all;


I = imread('fissure1.jpg');
img = double(I);

tic;
%% reducing specularity can producde color artifcats !!
%img = reduce_specularity(img,0.01);



%% normalizing step
img = img/255;

%% if you want toe reduce the size of the input image
% scale = 0.75;
% I = imresize(I,scale);
% img = imresize(img, scale);

%load('poids.mat');

%%
[n,p,c] = size(img);
if c==3
    [w, sc, dir] = FrangiFilter2D(rgb2gray(I));
else
    if c==1
        [w, sc, dir] = FrangiFilter2D(I);
    else
        error('Incorrect number of channels');
    end
end


%% Potts restoration
gamma = 16;% you may have to play with this parameter (usually between 10 and 20)

u = minL2Potts2DADMM(img, gamma, 'verbose', true,'weights',100-100*w);


%% denoising step
lambda = 0.06;%you may have to play with this paramter
v = chambolle(1-abs(img-u),lambda,0.01);

toc
%%
subplot(1,2,1)
imshow(img)
energyImg = energyL2Potts(img, img, gamma);
title(sprintf('Original (Potts energy: %.1f)', energyImg));

%%
subplot(1,2,2)
imshow(u)
energyU = energyL2Potts(u, img, gamma);
title(sprintf('Potts segmentation (Potts energy: %.1f)', energyU));



%%% my display
figure
subplot(2,2,1);
imshow(img);
title('Image originale');

subplot(2,2,2)
imshow(u);
title('Potts result');

subplot(2,2,3)
imshow(1-abs(img-u));
title('Difference');

subplot(2,2,4)
imshow(v);
title('Denoised diff');



%% 2nd Potts
gamma2 = 1.1;%you may have to play with this parameter
uu = rgb2gray(1-abs(img-u));
[w2,~] = FrangiFilter2D(uu);
vv = minL2Potts2DADMM(uu,gamma2,'verbose',true,'weights',100-100*w2);

%% median filtering
neiSize = 2;
vvv = medianfilt(vv,neiSize);

%% display
figure
subplot(2,1,1);
imshow(vv);
title('2nd Potts');
subplot(2,1,2);
imshow(vvv);
title('2nd Potts + median filter');