clc; clear; close all;
% img = im2single(imread(['.\images\',num2str(pair_num),'.jpg']));

%% image quilting
% load image
num = 4;
img = im2double(imread(['.\images\tx_',num2str(num),'.jpg']));
figure(1),imshow(img),title('The original image');
imwrite(img,['.\results\org_img_',num2str(num),'.jpg']);

% parameter settings
sample = img;
outsize = 400;
patchsize = 21;

% image quilting method selection
rand_sample = true;
overlap_patches = true;
seam_finding = true;

if (rand_sample) 
    % Random sample image
    out_rand = quilt_random(sample, outsize, patchsize);
    figure(2),imshow(out_rand),title('The random sampled image');
    imwrite(out_rand,['.\results\rdm_sp_',num2str(num),'.jpg']);
end

if (overlap_patches)
    % Overlapping patches
    overlap = floor(patchsize / 6);
    tol = 0.01;
    out_over = quilt_simple(sample,outsize,patchsize,overlap,tol);
    
    figure(3),imshow(out_over),title('The overlapped image');
    imwrite(out_over,['.\results\ovlp_pch_',num2str(num),'.jpg']);
end
%% texture transfer
