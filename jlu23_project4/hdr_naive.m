function hdr = hdr_naive()

    %% load images 
    ldr_norm = im2double(imread('./location/sphere_normal.png'));
    [imh, imw, nb] = size(ldr_norm); 
    
    %%resize images using the width of normal exposure image
    ldr_norm = imresize(ldr_norm,[imw,imw],'bilinear');
    ldr_low = imresize(im2double(imread('./location/sphere_low.png')),[imw,imw],'bilinear');
    ldr_high = imresize(im2double(imread('./location/sphere_high.png')),[imw,imw],'bilinear');
    
    %% the exposure imfomation is entered here
    exposures = [1/125,1/30,1/8];
    
    %% concatenate images to form ldrs
    ldrs = cat(4, ldr_low, ldr_norm, ldr_high);
    
    %% Sort exposures from dark to light
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); 
    
    for exposure = 1:3
    log_irradiance = log(ldrs(:,:,:,exposure)+0.001);
    subplot(1,3,exposure),imshow((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))));
    end
    pause;
    
    %% putting images in the same intensity domain
    for idx=1:3
        ldrs(:,:,:,idx)=ldrs(:,:,:,idx)/exposures(idx);
    end 
    
    for exposure = 1:3
    log_irradiance = log(ldrs(:,:,:,exposure)+0.001);
    subplot(1,3,exposure),imshow((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))));
    end
    pause;
    
    %% averaging the ldrs
    hdr_naive = (ldrs(:,:,:,1)+ldrs(:,:,:,2)+ldrs(:,:,:,3))/3;
    
    log_irradiance = log(hdr_naive+0.001);
    close all;
    imshow((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))));
    
    hdrwrite(hdr_naive, 'naive.hdr');
    imwrite((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))),'hdr_naive.png');
end
