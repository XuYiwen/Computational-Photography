close all;
im = im2double(imread('.\images\01.jpg'));
% 01-skydeck* | 02 - museum | 03 - church | 04 - stockholm | 05 - abisko*

% original image
hsv = rgb2hsv(im);
h = hsv(:, :, 1); s = hsv(:, :, 2); v =hsv (:, :, 3);
hh = hist(h(:), 0:1/255:1); hs = hist(s(:), 0:1/255:1); hv = hist(v(:), 0:1/255:1);
figure(),
subplot(121),imshow(im);
subplot(122),plot(hv, 'k'), title('histogram of intensity');
 
% Reinhart operation
v_rh = (v./(1+v)).*2; hv_rh = hist(v_rh(:), 0:1/255:1);
hsv_rh = cat(3,h,s,v_rh);
im_rh = hsv2rgb(hsv_rh);
% figure(), imshow(im_rh);
% figure(10),hold on, plot(hv_rh,'g');

% gamma correction
v_gamma = v.^0.5; hv_gamma = hist(v_gamma(:), 0:1/255:1);
hsv_gamma = cat(3,h,s,v_gamma);
im_gamma = hsv2rgb(hsv_gamma);
% figure(),imshow(im_gamma);
% figure(10),hold on, plot(hv_gamma, 'b');

% histogram equalization
cum = cumsum(hv);
v_hiseql = cum(uint16(v*255)+1)/numel(v);    % original hist-equal
hv_hiseql = hist(v_hiseql(:), 0:1/255:1);

% alpha = 0.2; % mixed hist-equal
% v_temp = cum(uint16(v*255)+1)/numel(v);
% v_hiseql = v* alpha + v_temp*(1-alpha); 
% hv_hiseql = hist(v_hiseql(:), 0:1/255:1);

hsv_hiseql = cat(3,h,s,v_hiseql);
im_hiseql = hsv2rgb(hsv_hiseql);
% figure(), imshow(im_hiseql);
% figure(10),hold on, plot(hv_hiseql,'r');

% display comparison
figure(),
subplot(221), imshow(im), title('Original Image');
subplot(222), imshow(im_rh), title('Reinhart Operation');
subplot(223), imshow(im_gamma), title('Gamma Correction of 0.5');
subplot(224), imshow(im_hiseql), title('Histogram Equalization');
figure(),
subplot(221), plot(hv, 'k'), title('Histogram of Original');
subplot(222), plot(hv_rh,'g'), title('Histogram of Reinhart');
subplot(223), plot(hv_gamma, 'b'), title('Histogram of Gamma');
subplot(224), plot(hv_hiseql,'r'), title('Histogram with Equalization');


