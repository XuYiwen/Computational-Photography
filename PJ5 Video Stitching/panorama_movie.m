function panorama_movie(recompute,sample_rate)
    % Input frames and settings
    start_frame = 1;
    end_frame = 900;
    
    % get the frame list with subsampling
    reference_frame = 450;
    frame_list = [start_frame: sample_rate: end_frame];
        num_ref = find(frame_list == reference_frame);
        if isempty(num_ref)
            frame_list = [frame_list, reference_frame];
            frame_list = sort(frame_list);
        end
    R=im2single(imread(sprintf('frames/f%04d.jpg',reference_frame)));
        Ho = auto_homography(R,R);
        
    % get the master frames and its homography
    load('pano_movie/master_homo.mat','master_frames','H_stack_master');
    
    % Compute the homography
    if recompute
        disp(' --- Homography Computing  --- ');
        H_stack = zeros(3,3,length(frame_list));
        H_inv_stack = zeros(3,3,length(frame_list));
        for i = 1:length(frame_list)
            % Computing the homography matrix
            S = im2single(imread(sprintf('frames/f%04d.jpg',frame_list(i))));
            ind = nearMaster(frame_list(i),master_frames);
            R = im2single(imread(sprintf('frames/f%04d.jpg',master_frames(ind))));
            H_cur2mst = auto_homography(R,S);
            H = H_stack_master(:,:,ind)*H_cur2mst;
                H_stack(:,:,i) = H;
                H_inv_stack(:,:,i) = H\eye(3);
                
           % Panorama image projection
            im=im2single(imread(sprintf('frames/f%04d.jpg',frame_list(i))));
            T = maketform('projective', H'); 
            toadd = imtransform(im, T, 'XData',[-651 980],'YData',[-51 460]);
            imwrite(toadd,sprintf('pano_movie/pano_frames/f%04d.jpg',frame_list(i)));
            
            % Status update
            if (mod(i,20) ==0)
                disp([num2str(i),'/',num2str(length(frame_list))]);
            end
        end
        save(sprintf('pano_movie/pano_homography_%04d.mat',sample_rate),'H_stack','H_inv_stack','frame_list');
    else
        load(sprintf('pano_movie/pano_homography_%04d.mat',sample_rate),'H_stack','H_inv_stack','frame_list');
    end

    % Record to movie
    disp(' --- Video Processing  --- ');
    v = VideoWriter(sprintf('pano_movie/pano_movie_%04d',sample_rate));
    open(v);
    for i = 1:length(frame_list)
        toadd = im2single(imread(sprintf('pano_movie/pano_frames/f%04d.jpg',frame_list(i))));
        writeVideo(v,toadd);
    end
    close(v);
end

function ind = nearMaster(current_frame,master_frames)
    diff = abs(master_frames-current_frame);
    [~,ind] = min(diff);
end