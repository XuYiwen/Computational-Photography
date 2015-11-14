function output = background_panorama(display,sample_rate,reference_frame)
    % Input frames and settings
    load(sprintf('pano_movie/pano_homography_%04d.mat',sample_rate),'frame_list');

    ref = im2single(imread(sprintf('pano_movie/pano_frames/f%04d.jpg',reference_frame)));
    [h,w,~] = size(ref);
    
    disp(' --- Compute Background Panorama --- ');
    count = zeros(h,w);
    total = zeros(h,w,3);
    for i = 1:length(frame_list)
        img = im2single(imread(sprintf('pano_movie/pano_frames/f%04d.jpg',frame_list(i))));
        mask = single(sum(img,3)>0);
        count = count+mask;
        for ch =1:3
            total(:,:,ch) = total(:,:,ch)+img(:,:,ch).*mask;
        end
        
        % Status update
        if (mod(i,50) ==0)
            disp([num2str(i),'/',num2str(length(frame_list))]);
        end
    end
    
    output = zeros(h,w,3);
    for ch=1:3
        output(:,:,ch) = total(:,:,ch)./count;
    end
    imwrite(output,sprintf('pano_movie/back_pano_%04d.jpg',sample_rate));
    
    if display
        figure(4),imshow(output),title('Background Panorama with Mean Method');
    end
end