close all;
im = im2double(imread('.\images\07.jpg'));
% 01-skydeck | 02 - museum | 07 - sail

% original image
hsv = rgb2hsv(im);
h = hsv(:, :, 1); s = hsv(:, :, 2); v =hsv (:, :, 3);
hh = hist(h(:), 0:1/255:1); hs = hist(s(:), 0:1/255:1); hv = hist(v(:), 0:1/255:1);
% figure(),imshow(im);
% figure(10),hold off, plot(hs, 'k'), title('histogram of saturation');

% histogram equalization
cum = cumsum(hs);

s_hiseql = cum(uint16(s*255)+1)/numel(s);    % original hist-equal
hs_hiseql = hist(s_hiseql(:), 0:1/255:1);

% alpha = 0.6; % mixed hist-equal
% s_temp = cum(uint16(s*255)+1)/numel(s);
% s_hiseql = s* alpha + s_temp*(1-alpha); 
% hs_hiseql = hist(s_hiseql(:), 0:1/255:1);

hsv_hiseql = cat(3,h,s_hiseql,v);
im_hiseql = hsv2rgb(hsv_hiseql);
% figure(), imshow(im_hiseql);
% figure(10),hold on, plot(hs_hiseql,'r');

figure(),
subplot(121), imshow(im), title('Original Image');
subplot(122), imshow(im_hiseql), title('Histogram Equalization');
figure(),
subplot(121), plot(hs, 'k'), title('Histogram of Original');
subplot(122), plot(hs_hiseql,'r'), title('Histogram with Equalization');
