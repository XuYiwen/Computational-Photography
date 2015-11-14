function panorama_stitching(check_pano,master_frames,reference_frame,Xdata,Ydata)
  
    R=im2single(imread(sprintf('frames/f%04d.jpg',reference_frame)));
        Ho = auto_homography(R,R);

    % Compute the homography
    S_frames = master_frames(1:end-1);
    R_frames = master_frames(2:end);
    H_stack = zeros(3,3,length(S_frames));
    for i = 1: length(S_frames)
        S=im2single(imread(sprintf('frames/f%04d.jpg',S_frames(i))));
        R=im2single(imread(sprintf('frames/f%04d.jpg',R_frames(i))));
        H = auto_homography(R,S);
            H_stack(:,:,i) = H;
    end
    
    % Source to Reference homography
    pt_ref = find(master_frames == reference_frame);
    H_stack_master = zeros(3,3,length(master_frames));
    img_stack = {};
    for i = 1:length(master_frames)
        if i<pt_ref
            H = eye(3);
            for j = i: pt_ref-1
                temp = H_stack(:,:,j);
                H = temp*H;
            end
        elseif i == pt_ref
            H = Ho;
        elseif i >pt_ref
            H = eye(3);
            for j = pt_ref:(i-1)
                temp = H_stack(:,:,j)\eye(3);
                H = H*temp;            
            end
        end
        H_stack_master(:,:,i) = H; 
        im=im2single(imread(sprintf('frames/f%04d.jpg',master_frames(i))));
        T = maketform('projective', H'); 
        toadd = imtransform(im, T, 'XData',Xdata,'YData',Ydata);
        img{i} = toadd; 
    end
    save('pano_movie/master_homo.mat','master_frames','H_stack_master');

    % Stitch to panorama
    base = img{pt_ref};
    base = neighborStitch(img{4},img{3},base);
    base = neighborStitch(img{5},img{4},base);
    base = neighborStitch(img{2},img{3},base);
    output = neighborStitch(img{1},img{2},base);

    % Visualize panorama
    if (check_pano)
        figure(3),imshow(output),title('Output Panorama');
    end
end