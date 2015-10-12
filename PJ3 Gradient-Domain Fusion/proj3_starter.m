clear; clc; close all;
% starter script for project 3
DO_TOY = false;
DO_BLEND = false;
DO_MIXED  = false;
DO_COLOR2GRAY = false;
DO_LAPLACIAN = true;

if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    figure(1), 
    subplot(121),imshow(toyim), title('Original toy image');
    subplot(122),imshow(im_out), title('Output of the toy reconstruction');
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

if DO_BLEND
    % do a small one first, while debugging
    im_background = imresize(im2double(imread('./samples/im2.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./samples/penguin-chick.jpeg')), 0.25, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend)
end

if DO_MIXED
    % read images
    im_background = imresize(im2double(imread('./samples/im2.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./samples/penguin-chick.jpeg')), 0.25, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend);
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = im2double(imread('./samples/cb1.jpg'));
    im_gr = color2gray(im_rgb);
    figure(1),
    subplot(131),imshow(im_rgb(:,:,1));
    subplot(132),imshow(im_rgb(:,:,2));
    subplot(133),imshow(im_rgb(:,:,3));

    figure(4), 
    subplot(131), imshow(im_rgb),title('the RGB image');
    subplot(132), imshow(rgb2gray(im_rgb)),title('The rgb2gray image');
    subplot(133), imshow(im_gr),title('The color2gray image'),axis off;
end

if DO_LAPLACIAN
    fore = im2double(imread('./samples/right1.jpg'));
    back = im2double(imread('./samples/left1.jpg'));
    [fore,back,mask] = freeAlign(fore,back);
    output = laplacianBlend(fore,back,mask,4,10,2);
    
    figure(1),
    subplot(131),imshow(fore), title('foreground image');
    subplot(132),imshow(back), title('background image');
    subplot(133),imshow(output), title('The blended image');
    
end