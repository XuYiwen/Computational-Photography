function hdr = hdr_response_function()

    %% load images 
    ldr_norm = im2double(im2double(imread('./location/sphere_normal.png')));
    [imh, imw, nb] = size(ldr_norm); 
    
    %%resize images using the width of normal exposure image
    ldr_norm = imresize(ldr_norm,[imw,imw],'bilinear');
    ldr_low = imresize(im2double(imread('./location/sphere_low.png')),[imw,imw],'bilinear');
    ldr_high = imresize(im2double(imread('./location/sphere_high.png')),[imw,imw],'bilinear');
    
    %% the exposure imfomation is entered here
    exposures = [1/125,1/30,1/8];
    
    %% concatenate images to form ldrs
    ldrs = cat(4, ldr_low, ldr_norm, ldr_high);
    
    %%Sort exposures from dark to light
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); 
    
    %%chosing random 100 pixels to figure out g() function
    random_pixels = zeros(100,3,3);   

    for index = 1:100
                
            rand_y = randi(imh);
            rand_x = randi(imw);
 
            for ch = 1:3
                random_pixels(index,1,ch) = round(225*ldrs(rand_y,rand_x,ch,1))+1;
                random_pixels(index,2,ch) = round(225*ldrs(rand_y,rand_x,ch,2))+1;
                random_pixels(index,3,ch) = round(225*ldrs(rand_y,rand_x,ch,3))+1;
            end
    end
    
    
    
    w = @(z) double(128-abs(z-128));
    
    [gr,lEr]=gsolve(random_pixels(:,:,1),log(exposures),500,w);
    [gg,lEg]=gsolve(random_pixels(:,:,2),log(exposures),500,w);
    [gb,lEb]=gsolve(random_pixels(:,:,3),log(exposures),500,w);

      x= 1:226;
      y= gr(x);
      plot(y,x);
      pause;


    %%

    hdr = zeros(imw,imw,3);
    hdr(:,:,1) = calc_hdr(imw,exposures,ldrs,gr,w,1);
    hdr(:,:,2) = calc_hdr(imw,exposures,ldrs,gg,w,2);
    hdr(:,:,3) = calc_hdr(imw,exposures,ldrs,gb,w,3);

    hdr = exp(hdr);
    
    log_irradiance = log(hdr+0.001);
    close all;
    imshow((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))));
    
    hdrwrite(hdr, 'hdr_response_function.hdr');
    imwrite((log_irradiance-min(log_irradiance(:))) ./ (max(log_irradiance(:))-min(log_irradiance(:))),'hdr_response_function.png');
    
end


function hdr_single_channel = calc_hdr(imw,exposures,ldrs,g,w,ch)

   hdr_single_channel = zeros(imw,imw);

    for y = 1:imw
        for x = 1:imw
            Ei = 0;
            w_sum = 0;
            for exposure = 1:3
                Z = round(225*ldrs(y,x,ch,exposure))+1;
                Ei = Ei + w(Z)*(g(Z)-log(exposures(exposure)));
                w_sum = w_sum + w(Z); 
            end
            hdr_single_channel(y,x) = Ei/w_sum;
        end
    end
        
    
end



