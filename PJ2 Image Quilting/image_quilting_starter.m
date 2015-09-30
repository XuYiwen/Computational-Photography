%% image quilting
clc; clear; close all;
% load image
num = 11;
size = [45,45,41,15,21,  51,37,25,25,21,  41];
img = im2double(imread(['.\images\tx_',num2str(num),'.jpg']));

% parameter settings
sample = img;
outsize = 300;
patchsize = size(num);
overlap = floor(patchsize / 3);
tol = 0.1;

% Random sample image
[out_rand,first] = quilt_random(sample, outsize, patchsize);

% Overlapping patches
[out_over,first] = quilt_simple(sample,outsize,patchsize,overlap,tol,first);

% Seam finding cut
[out_seam,first] = quilt_seam(sample,outsize,patchsize,overlap,tol,first);

% Plot Print
figure(1),set(1,'position',[1200 1200 200 200]);
imshow(img),title('The original image');

figure(2),set(2,'position',[50 50 1500 500]);
subplot(131),imshow(out_rand),title('(a) The Random Sampled Image');
subplot(132),imshow(out_over),title('(b) The Overlapped Image');
subplot(133),imshow(out_seam),title('(c) The Seam Finding Image');

print(1,'-djpeg',['.\results\',num2str(num),'_org_tex.jpg']);
print(2,'-djpeg',['.\results\',num2str(num),'_compare.jpg']);
