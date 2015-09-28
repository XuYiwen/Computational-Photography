function  output = quilt_seam(sample,outsize,patchsize,overlap,tol)
    % control the random sampling range
    r = floor (patchsize/2); 
    D = (2*r +1);
    N = ceil (outsize/ (D-overlap));

    result = zeros(N*(D-overlap)+overlap,N*(D-overlap)+overlap,3);
    for j = 1 : N
        for i = 1 : N
            % mask overlap window
            [ovlp_mask, wx, wy] = mask_win(i, j, overlap, D);
            temp = result((wy+1):(wy+D),(wx+1):(wx+D),:);

            % calculate the ssd of the sample image
            cost_img = ssd_patch(sample,temp,ovlp_mask);

            % Find the minimum cost without exceeding boundary
            cost_edge = cost_img(r+1: end-r,r+1:end-r); 
            minc = min(min(cost_edge));
            minc = max(minc, 1e-10); % avoid initially all zero in min
            
            % Random selected patches within tolarance
            [y,x] = find(cost_edge<minc*(1+tol)); 
            rand_no = randi(size(y,1));
            ry = y(rand_no)+r;
            rx = x(rand_no)+r;
            addin = sample((ry-r):(ry+r), (rx-r):(rx+r),:);
            cost_pch = cost_img((ry-r):(ry+r), (rx-r):(rx+r),:);
            
            % Seam cutting the ovelapping area
            cut_up = cut(cost_pch(1:overlap,:));
            cut_left = cut(cost_pch(:,1:overlap)')';
            cut_mask = zeros(D);
            cut_mask(1:overlap,:) = cut_mask(1:overlap,:) + cut_up;
            cut_mask(:,1:overlap) = cut_mask(:,1:overlap) + cut_left;
            cut_mask = cut_mask.*ovlp_mask(:,:,1);
                        
            % Combine the mixture
            mix = mix_cut(temp,addin,cut_mask);
            result((wy+1):(wy+D),(wx+1):(wx+D),:) = mix;
            
            % Test display  
%              win_mask = temp.*ovlp_mask;  
%              figure(4),imshow(win_mask);  
%              figure(5),imagesc(cost_edge),colormap('jet'),colorbar;  
%              figure(6),imshow(addin);  
%              figure(7),imshow(result);
%             figure(8), imshow(cut_up);
%             figure(9), imshow(cut_left);
%             figure(10),imshow(cut_mask);
%             figure(11),imshow(mix);
        end
    end
    output = result(1:outsize,1:outsize,:);
end

