function fft_display(im, titles)
% This is a function adjust Fourier transformed image to proper display
% under imagesc function. It includes the fft shifting and frequency range

fft_im = fft2(im);
fftimpow = log(abs(fftshift(fft_im)+eps));
sv = sort(fftimpow(:));  
minv = sv(1); maxv = sv(end);
minv = sv(round(0.005*numel(sv)));  %maxv = sv(round(0.999*numel(sv)));

figure(), hold off, imagesc(fftimpow, [minv maxv]), axis off,  colormap jet, axis image, colorbar
title(['log fft magnitude of ', titles]);