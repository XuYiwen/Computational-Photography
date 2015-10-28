function tonemapping()
% load image
img = im2double(imread('./images/darkroom.jpg'));
toned_imgs{1}.image = img;
toned_imgs{1}.method = 'Original image';

% simple rescaling
toned_imgs{2}.image = simple_rescale(img);
toned_imgs{2}.method = 'Simple Rescale';

% Gamma correction
output = simple_rescale(img);
output = gamma_correction(output,0.5);
toned_imgs{3}.image = output;
toned_imgs{3}.method = 'Rescale + Gamma';

% Reinhart operation
output = simple_rescale(img);
output = reinhart_operation(output);
toned_imgs{4}.image = output;
toned_imgs{4}.method = 'Rescale + Reinhart';

% local tonemapping

len = length(toned_imgs);
row =2;
figure(1),
for i = 1:len
    subplot(row,ceil(len/row),i),imshow(toned_imgs{i}.image),title(toned_imgs{i}.method);
end



end
function output = simple_rescale(img)
    % change color space
    hsv = rgb2hsv(img);
    imgv = hsv(:,:,3);
    % rescale
    maxi = max(imgv(:));
    mini = min(imgv(:));
    imgv = (imgv-mini)./(maxi-mini);
    % recover colorspace
    hsv(:,:,3) = imgv;
    output = hsv2rgb(hsv);
end
function output = gamma_correction(img,gamma)
    % change color space
    hsv = rgb2hsv(img);
    imgv = hsv(:,:,3);
    % gamma correction
    imgv = imgv.^gamma;
    % recover colorspace
    hsv(:,:,3) = imgv;
    output = hsv2rgb(hsv);
end
function output = reinhart_operation(img)
        % change color space
    hsv = rgb2hsv(img);
    imgv = hsv(:,:,3);
    % gamma correction
    imgv = (imgv./(1+imgv)).*2;
    % recover colorspace
    hsv(:,:,3) = imgv;
    output = hsv2rgb(hsv);
end