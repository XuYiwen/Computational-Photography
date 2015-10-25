clear; clc; close all;

% LDR merging
% 1- naive LDR | 2- under/over | 3 - response function
method = 2;
scene_num = 1;
exp_time = [20,40,80,160,250,320,640,1250,2000,3200,4000];
cp_size = 500;
img_stack = zeros(cp_size,cp_size,3,length(exp_time));

% loading image with different exposure time into stack
for i = 1: length(exp_time)
    impath = ['.\images\scene0', num2str(scene_num), '\cp_t', num2str(exp_time(i)),'.jpg'];
    toadd = im2double(imread(impath));
    toadd = imresize(toadd, [cp_size, cp_size],'bilinear');
    img_stack(:,:,:,i) = toadd;    
end

% apply hdr transform
exp_time = 1./exp_time;
if method == 1 % naive LDR
    hdr_naive = makehdr_naive(img_stack, exp_time);
    hdrwrite(hdr_naive,'.\hdr_images\HDR_naive.hdr');
    rgb = tonemap(hdr_naive);
    figure(1); imshow(rgb);
elseif method == 2 % under/over
    hdr_ovud = makehdr_overunder(img_stack, exp_time,0.02);
    hdrwrite(hdr_ovud,'.\hdr_images\HDR_overunder.hdr');
    rgb = tonemap(hdr_ovud);
    figure(1); imshow(rgb);
elseif method == 3 % response function
end


