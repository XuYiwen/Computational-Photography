close all; % closes all figures

% read image pairs and convert to single format
pair_num = 7; % there is totally pairs of hybrid images
im1 = im2single(imread(['.\images\fix',num2str(pair_num),'1.jpg'])); % background
im2 = im2single(imread(['.\images\fix',num2str(pair_num),'2.jpg'])); % upper details
im1 = rgb2gray(im1); % convert to grayscale
im2 = rgb2gray(im2);
% figure(),imshow(im1);
% figure(),imshow(im2);

need_align = input('Do you need align agian? Y - enter align mode :','s');
if strcmp(need_align, 'Y')
    % use this if you want to align the two images (e.g., by the eyes) and crop them to be of same size
    [im2, im1] = align_images(im2, im1);
    save(['.\settings\align_fix_',num2str(pair_num),'.mat'], 'im1', 'im2');
else
    load(['.\settings\align_fix_',num2str(pair_num),'.mat'], 'im1', 'im2');
end

%% Choose the cutoff frequencies and compute the hybrid image (you supply this code)
need_test = input('Do you need to test cut-off frequency? Y - enter test mode : ','s');
if strcmp(need_test,'Y');
    cutoff_low = 4; cutoff_high = 8; test_done = false;
    while ~test_done
        im12 = hybridImage(im1, im2, cutoff_low, cutoff_high,false);
        disp(['current cutoff frequency | low - ',num2str(cutoff_low),'; high - ',num2str(cutoff_high)]);
        adj = input('Enter cutoff_low and cutoff_high: [format : low-high] ','s');
       
        if isempty(adj)
                test_done = true; 
                disp(['current saved frequency | low - ',num2str(cutoff_low),'; high - ',num2str(cutoff_high)]);
        else
            [tlow,thigh] = strtok(adj, '-');
            if ~isempty(cutoff_high)
                cutoff_low = str2num(tlow);
                cutoff_high = str2num(thigh(2:end));
            end
        end
    end    
    save(['.\settings\cutoff_fix_',num2str(pair_num),'.mat'],'cutoff_low','cutoff_high');
else
    load(['.\settings\cutoff_fix_',num2str(pair_num),'.mat'],'cutoff_low','cutoff_high');
    im12 = hybridImage(im1, im2, cutoff_low, cutoff_high,false);
end

%% Crop resulting image
need_crop = input('Do you need crop agian? Y - enter crop mode:','s');
if strcmp(need_crop, 'Y')
    figure(1), hold off, imagesc(im12), axis off, axis image, colormap gray
    disp('input crop points');
    [x, y] = ginput(2);  x = round(x); y = round(y);
    save(['.\settings\crop_fix_',num2str(pair_num),'.mat'], 'x', 'y');
else
    load(['.\settings\crop_fix_',num2str(pair_num),'.mat'], 'x', 'y');
end
% crop all images
im1 = im1(min(y):max(y), min(x):max(x), :);
im2 = im2(min(y):max(y), min(x):max(x), :);
im12 = im12(min(y):max(y), min(x):max(x), :);
imwrite(im12, ['.\results\fix_',num2str(pair_num),'.jpg']);


%% Results display
figure(), % original images
subplot(121),imagesc(im1), axis off, axis image, colormap gray, title('Original image 1')
subplot(122),imagesc(im2), axis off, axis image, colormap gray, title('Original image 2')
% fft_display(im1,'image 1');
% fft_display(im2,'image 2');

fil_G1 = fspecial('gaussian',7*cutoff_low , cutoff_low);
fil_G2 = fspecial('gaussian',7*cutoff_high , cutoff_high);
low_im = imfilter(im1,fil_G1);
high_im = im2 - imfilter(im2,fil_G2);
figure(), % filtered images
subplot(121),imagesc(low_im), axis off, axis image, colormap gray, title('Filtered image 1')
subplot(122),imagesc(high_im), axis off, axis image, colormap gray, title('Filtered image 2')
% fft_display(low_im,'filtered image 1');
% fft_display(high_im,'filtered image 2');

figure(),% hybrid image
imagesc(im12), axis off, axis image, colormap gray,, title('Hybrid image')
% fft_display(im12,'hybrid image');

%% Compute and display Gaussian and Laplacian Pyramids
N = 5; % number of pyramid levels (you may use more or fewer, as needed)
pyramids(im12, N);
