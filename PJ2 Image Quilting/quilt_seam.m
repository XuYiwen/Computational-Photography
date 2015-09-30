function  [output,first] = quilt_seam(sample,outsize,patchsize,overlap,tol,startat)
    % control the random sampling range
    r = floor (patchsize/2); 
    D = (2*r +1);
    N = ceil (outsize/ (D-overlap));
    first = [];
    display =false;

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
            if isempty(first)
                addin = startat;
                first = startat;
            else
                addin = sample((ry-r):(ry+r), (rx-r):(rx+r),:);
            end
            cost_pch = cost_img((ry-r):(ry+r), (rx-r):(rx+r),:);
            
            % Seam cutting the ovelapping area
            [cut_up, up_path] = cut(cost_pch(1:overlap,:));
            [cut_left,left_path] = cut(cost_pch(:,1:overlap)');
            cut_left = cut_left'; left_path = left_path';
            cut_mask = ones(D).*ovlp_mask(:,:,1);
            cut_mask(1:overlap,:) = cut_mask(1:overlap,:) .* cut_up;
            cut_mask(:,1:overlap) = cut_mask(:,1:overlap) .* cut_left;
            mix = mix_cut(temp,addin,cut_mask);
            
            % Seam finding illustration
            if (display)
                ovlp1 = temp(:,1:overlap,:);
                ovlp2 = addin(:,1:overlap,:);
                cost = cost_pch(:,1:overlap);
                path = left_path;
                figure(3),
                subplot(141), imshow(ovlp1),title('The current result');
                subplot(142),imshow(ovlp2),title('The addin patch');
                subplot(143),imshow(cut_left),title('The mask');
                subplot(144),imshow(mix(:,1:overlap,:)),title('The mixed result');
                figure(4),
                imagesc(cost),title('The cost image'),colorbar,hold on, plot(path,[1:size(path)]','-r'),hold off;
                
            end
                        
            % Combine the mixture
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

