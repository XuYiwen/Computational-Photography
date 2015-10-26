clear;
close all;

patchsize = 8;
tol = 3;
im = im2single(imread('.\website\results\hdr_response_function.png'));
figure(1), imagesc(im), title('im');
[imx1, imx2] = ginput(2);
[imx imy imz] = size(im);
image_mask = ones(imx,imy,imz);
image_mask(ceil(imx2(1)):ceil(imx2(2)), ceil(imx1(1)):ceil(imx1(2)), :) = 0;
figure(9), imagesc(im.*image_mask), title('before fill');
[result_fillhole] = fill_hole(im, image_mask, patchsize, tol);
figure(10), imagesc(result_fillhole), title('result fillhole');
