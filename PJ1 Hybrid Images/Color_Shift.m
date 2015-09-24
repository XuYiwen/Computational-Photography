close all;
im = im2double(imread('.\images\01.jpg'));
% 01 - skydeck | 07 - sail

% cast into CIE-lab color space
lab = rgb2lab(im);
l = lab(:,:,1); a = lab(:,:,2); b = lab(:,:,3);

% get more red in a- channel
mr_a = a+25;
lab_mr = cat(3,l,mr_a,b);
im_mr = lab2rgb(lab_mr);

% get less yellow in b-channel
ly_b = b - 25;
lab_ly = cat(3,l,a,ly_b);
im_ly = lab2rgb(lab_ly);

% color shifted versions
figure(),
subplot(131),imshow(im),title('Original Image');
subplot(132),imshow(im_mr),title('More Red');
subplot(133),imshow(im_ly),title('Less Yellow');
