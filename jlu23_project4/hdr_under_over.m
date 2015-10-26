function hdr = hdr_under_over()

    %% load images 
    ldr_norm = im2double(imread('./location/sphere_normal.png'));
    [imh, imw, nb] = size(ldr_norm); 
    
    %% resize images using the width of normal exposure image
    ldr_norm = imresize(ldr_norm,[imw,imw],'bilinear');
    ldr_low = imresize(im2double(imread('./location/sphere_low.png')),[imw,imw],'bilinear');
    ldr_high = imresize(im2double(imread('./location/sphere_high.png')),[imw,imw],'bilinear');
    
    %%  the exposure imfomation is entered here
    exposures = [1/125,1/30,1/8];
    
    %%  concatenate images to form ldrs
    ldrs = cat(4, ldr_low, ldr_norm, ldr_high);
    
    %% Sort exposures from dark to light
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); 
    

    %% keep track of the original values
    z_low = ldrs(:,:,:,1);
    z_normal = ldrs(:,:,:,2);
    z_high = ldrs(:,:,:,3);
    

    %% use the weighing function to calculate the output value
    w = @(z) double(0.5-abs(z-0.5));
    
    
    w_low = w(z_low);
    w_normal = w(z_normal);
    w_high = w(z_high);
    

    
    % if all are under/over exposed, set to max or min value
    for y = 1:imw
        for x = 1:imw
                if ((w_low(y,x,1)<0.02) && (w_normal(y,x,1)<0.02) && (w_high(y,x,1)<0.02))

                    if(z_normal(y,x,:)>0.5)
                       w_low(y,x,:)=1;
                 
                   else
                       w_high(y,x,:)=1;
 
                    end

                end
        end
    end
    
    %% putting images in the same intensity domain
    for idx=1:3
        ldrs(:,:,:,idx)=ldrs(:,:,:,idx)/exposures(idx);
    end 
    
    
    
    hdr = (w_low.*ldrs(:,:,:,1) + w_normal.*ldrs(:,:,:,2) + w_high.*ldrs(:,:,:,3))./(w_low+w_normal+w_high);
      
    log_irradiance = log(hdr+0.001);
    close all;
    imshow((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))));
    
    hdrwrite(hdr, 'under_over.hdr');
    imwrite((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))),'hdr_under_over.png');
    
end




