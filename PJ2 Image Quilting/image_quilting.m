close all;
% img = im2single(imread(['.\images\',num2str(pair_num),'.jpg']));

%% image quilting
% load image
num = 1;
img = im2single(imread(['.\images\tx_',num2str(num),'.jpg']));
figure(1),imshow(img),title('The original image');
imwrite(img,['.\results\org_img_',num2str(num),'.jpg']);
% image quilting method selection
rand_sample = true;
overlap_patches = true;
seam_finding = true;

if (rand_sample) 
    sample = img;
    outsize = 420;
    patchsize = 25;
    
    % random sample image
    out_rand = quilt_random(sample, outsize, patchsize);
    figure(2),imshow(out_rand),title('The random sampled image');
    imwrite(out_rand,['.\results\rdm_sp_',num2str(num),'.jpg']);
end
%% texture transfer
