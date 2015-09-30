function output = iter_tex_transfer(sample,target, patchsize,overlap,tol,iter_num)
    r = floor (patchsize/2); 
    last = zeros(size(target));
    
    for layer = 1 : iter_num
        % control the random sampling range
        D = (2*r +1);
        alpha = 0.8*(layer-1)/(iter_num-1);
        Ni = floor((size(last,2)-overlap)/(D-overlap));
        Nj = floor((size(last,1)-overlap)/(D-overlap));
        
        result = zeros(Nj*(D-overlap)+overlap,Ni*(D-overlap)+overlap,3);  
        for j = 1 : Nj
            for i = 1 : Ni
                % Mask overlap window
                [ovlp_mask, wx, wy] = mask_win(i, j, overlap, D);
                corr = target((wy+1):(wy+D),(wx+1):(wx+D),:);
                ovlp = result((wy+1):(wy+D),(wx+1):(wx+D),:);
                prev = last((wy+1):(wy+D),(wx+1):(wx+D),:);
                
                % The correspondence map cost and ovelap cost
                corr_cost = ssd_patch(sample,corr,ones(D,D,3));
                ovlp_cost =  ssd_patch(sample,ovlp,ovlp_mask);
                prev_cost = ssd_patch(sample,prev,ones(D,D,3));
                cost = alpha * (ovlp_cost+prev_cost) + (1-alpha) * corr_cost ;

                % Find the minimum cost cut without exceeding boundary
                cost_edge = cost(r+1: end-r,r+1:end-r); 
                minc = min(min(cost_edge));
                minc = max(minc, 1e-10); % avoid initially all zero in min

                % Random selected patches within tolarance
                [y,x] = find(cost_edge<minc*(1+tol)); 
                rand_no = randi(size(y,1));
                ry = y(rand_no)+r;
                rx = x(rand_no)+r;
                addin = sample((ry-r):(ry+r), (rx-r):(rx+r),:);
                cost_pch = cost((ry-r):(ry+r), (rx-r):(rx+r),:);

                % Seam cutting the ovelapping area
                cut_up = cut(cost_pch(1:overlap,:));
                cut_left = cut(cost_pch(:,1:overlap)')';
                cut_mask = ones(D).*ovlp_mask(:,:,1);
                cut_mask(1:overlap,:) = cut_mask(1:overlap,:) .* cut_up;
                cut_mask(:,1:overlap) = cut_mask(:,1:overlap) .* cut_left;

                % Combine the mixture
                mix = mix_cut(ovlp,addin,cut_mask);
                result((wy+1):(wy+D),(wx+1):(wx+D),:) = mix;
%                 figure(10),imshow(result);
            end
        end
        r = floor(r*2/3);
        r = max(3,r);
        overlap = floor(overlap*2/3);
        overlap = max(1,overlap);
        figure(layer),imshow(result),title(['Iteration (',num2str(layer),')']);
        print(layer,'-djpeg',['.\results\',num2str(layer),'_ittx_transf.jpg']);
        last = result;
    end
    output =result;
end
