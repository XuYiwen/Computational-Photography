function output = foreground_movie(sample_rate)
    % Load previous parameters
    load(sprintf('pano_movie/pano_homography_%04d.mat',sample_rate),'H_stack','H_inv_stack','frame_list');
    im = im2single(imread(sprintf('frames/f%04d.jpg',1)));
    [rec_h,rec_w,~] = size(im);
    
    disp(' --- Compute Foreground Panorama --- ');
    back_pano = im2single(imread(sprintf('pano_movie/back_pano_%04d.jpg',sample_rate)));
    for i = 1:length(frame_list)
        % get the background and full panorama image
        full = im2single(imread(sprintf('pano_movie/pano_frames/f%04d.jpg',frame_list(i))));
        pos_mask = repmat(single(sum(full,3)>0),[1,1,3]);
        back = pos_mask.*back_pano;
        diff = sum((abs(full - back)),3);
        diff_mask = single(diff>0.4); % change it
         
        diff_mask = repmat(diff_mask,[1,1,3]);
        fore = full.*diff_mask+(100/255).*(1-diff_mask);
        
        % compute the reverse mapping
        H= H_stack(:,:,i);
        T = maketform('projective', H'); 
        T_inv = fliptform(T);
        toadd = imtransform(fore, T_inv, 'XData',[1 rec_w],'YData',[1 rec_h], 'UData', [-651 980], 'VData', [-51 460]);
        imwrite(toadd,sprintf('pano_movie/fore_frames/f%04d.jpg',frame_list(i)));
        
        % Status update
        if (mod(i,50) ==0)
            disp([num2str(i),'/',num2str(length(frame_list))]);
        end
    end
    
    % Record to movie
    disp(' --- Video Processing  --- ');
    v = VideoWriter(sprintf('pano_movie/fore_movie_%04d',sample_rate));
    open(v);
    for i = 1:length(frame_list)
        toadd = im2single(imread(sprintf('pano_movie/fore_frames/f%04d.jpg',frame_list(i))));
        writeVideo(v,toadd);
    end
    close(v);       
end