function  output = quilt_simple(sample,outsize,patchsize,overlap,tol)
    % control the random sampling range
    r = floor (patchsize/2); 
    D = (2*r +1);
    N = ceil (outsize/ (D-overlap));

    result = zeros(N*(D-overlap)+overlap,N*(D-overlap)+overlap,3);
    for j = 1 : N
        for i = 1 : N
            % mask overlap window
            [mask, wx, wy] = mask_win(i, j, overlap, D);
            temp = result((wy+1):(wy+D),(wx+1):(wx+D),:);

            % calculate the ssd of the sample image
            cost_img = ssd_patch(sample,temp,mask);
      
            % Find the minimum cost and position within tolarence
            cost_edge = cost_img(r+1: end-r,r+1:end-r); % avoid reach boundary
            minc = min(min(cost_edge));
            minc = max(minc, 1e-10); % avoid initially all zero in min
           
            [y,x] = find(cost_edge<minc*(1+tol)); 
            rand_no = randi(size(y,1));
            ry = y(rand_no)+r;
            rx = x(rand_no)+r;

            patch = sample((ry-r):(ry+r), (rx-r):(rx+r),:);
            result((wy+1):(wy+D),(wx+1):(wx+D),:) = patch;
            
            % test display  
 %             win_mask = temp.*mask;  
 %             figure(4),imshow(win_mask);  
 %             figure(5),imagesc(cost_edge),colormap('jet'),colorbar;  
 %             figure(6),imshow(patch);  
 %             figure(7),imshow(result);
        end
    end
    output = result(1:outsize,1:outsize,:);
end

