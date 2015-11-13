function background_movie(sample_rate)
    % Load previous parameters
    reference_frame = 450;
    im = im2single(imread(sprintf('frames/f%04d.jpg',reference_frame)));
    [rec_h,rec_w,~] = size(im);
    load(sprintf('pano_movie/pano_homography_%04d.mat',sample_rate),'H_stack','H_inv_stack','frame_list');
    back_pano_img = im2single(imread(sprintf('pano_movie/back_pano_%04d.jpg',sample_rate)));
    
    disp(' --- Generating Background Movie --- ');
    for i = 1: length(frame_list)
        % get the project part of the image
        pano = im2single(imread(sprintf('pano_movie/pano_frames/f%04d.jpg',frame_list(i))));
        mask = single(sum(pano,3)>0);
        mask = repmat(mask,[1,1,3]);
        rev_frame = back_pano_img.*mask;
        
        % compute the reverse mapping
        H= H_stack(:,:,i);
        T = maketform('projective', H'); 
        T_inv = fliptform(T);
        toadd = imtransform(rev_frame, T_inv, 'XData',[1 rec_w],'YData',[1 rec_h], 'UData', [-651 980], 'VData', [-51 460]);
        imwrite(toadd,sprintf('pano_movie/back_frames/f%04d.jpg',frame_list(i)));
    end
    
    % Record to movie
    disp(' --- Video Processing  --- ');
    v = VideoWriter(sprintf('pano_movie/back_movie_%04d',sample_rate));
    open(v);
    for i = 1:length(frame_list)
        toadd = im2single(imread(sprintf('pano_movie/back_frames/f%04d.jpg',frame_list(i))));
        writeVideo(v,toadd);
    end
    close(v);
end

