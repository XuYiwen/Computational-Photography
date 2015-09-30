clc; clear; close all;
% load image
f_img = im2double(imread('.\images\face.jpg'));
t_img = im2double(imread('.\images\toast.jpg'));
[fh,fw,~] = size(f_img);
[th,tw,~] = size(t_img);
    figure(1),
    subplot(121),imshow(t_img),title('The original texture image');
    subplot(122),imshow(f_img),title('The original target image');

% texture transfer
patchsize = 35;
overlap = floor(patchsize / 5);
tol = 0.1;
iter_num = 3;
off_h = round((th-fh)/2); off_w = round((tw-fw)/2);
toast = t_img( off_h : off_h+fh , off_w : off_w+fw, :);
face_tr = iter_tex_transfer(toast,f_img, patchsize,overlap,tol,iter_num);
    save('face.mat','face_tr');
    % load('face.mat');

[ftrh,ftrw,~]=size(face_tr);
upsize = round((th-size(face_tr,1))/2);
leftsize =round((tw-size(face_tr,2))/2);
face = zeros(th,tw,3);
face(upsize+1:upsize+ftrh,leftsize+1:leftsize+ftrw,:)=face_tr;
figure(2),imshow(face_tr),title('Transfered face');

% Mask construction
width = 30;
L = round(width/2);
per = 0.5/L;
mask = ones(ftrh-4*L,ftrw-4*L);
corner = 1;
while corner > 0
    up = ones(1,size(mask,2))*(corner-per);
    mask =[up; mask; up];
    left =  ones(size(mask,1),1)*(corner-per);
    mask = [left,mask,left];
    corner = mask(1,1);
end
upsize = round((th-size(mask,1))/2);
leftsize =round((tw-size(mask,2))/2);
    up = zeros(upsize,size(mask,2));
    down = zeros((th-size(mask,1))-upsize,size(mask,2));
    mask = [up; mask; down];
    left = zeros(size(mask,1),leftsize);
    right = zeros(size(mask,1),(tw-size(mask,2))-leftsize);
    mask = [left,mask,right];
mask = repmat(mask,1,1,3);
figure(3),imshow(mask),title('Feather mask');

% Feathering and blending
face_on_toast = face.*mask + t_img.*(1-mask);
figure(4),imshow(face_on_toast),title('The face on toast result');