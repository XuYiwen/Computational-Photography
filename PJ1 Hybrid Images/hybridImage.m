function im_hybrid = hybridImage(im1, im2, G1_sigma, G2_sigma, display)
% This function generate hybrid image.

% construct filters
fil_G1 = fspecial('gaussian',7*G1_sigma , G1_sigma);
fil_G2 = fspecial('gaussian',7*G2_sigma , G2_sigma);

% filtered image
low_im = imfilter(im1,fil_G1);
high_im = im2 - imfilter(im2,fil_G2);

% hybrid image
im_hybrid = low_im*0.5 + high_im*0.5; 
figure(), hold off, imagesc(im_hybrid), axis off, colormap gray, axis image, title ('hybrid image');

% display
if display
    % original image
    figure(), hold off, imshow(im1), axis off, colormap gray, axis image, title ('original image 1');
    figure(), hold off, imshow(im2), axis off, colormap gray, axis image, title ('original image 2');
    % fft_display(im1,'image 1');
    % fft_display(im2,'image 2');

    % filter
    figure(), hold off, imagesc(fil_G1), axis off, colormap gray, axis image, title ('low pass filter');
    figure(), hold off, imagesc(fil_G2), axis off, colormap gray, axis image, title ('high pass filter');
    fft_display(fil_G1,'low pass filter');
    fft_display(fil_G2,'high pass filter');

    % filtered
    figure(), hold off, imagesc(low_im), axis off, colormap gray, axis image, title ('low pass filtered image 1');
    figure(), hold off, imagesc(high_im), axis off, colormap gray, axis image, title ('high pass filtered image 1');
    fft_display(low_im,'low pass filtered image 1');
    fft_display(high_im,'high pass filtered image 2');
end
