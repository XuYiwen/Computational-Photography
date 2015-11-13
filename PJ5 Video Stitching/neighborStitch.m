function output = neighborStitch(from, to,base)
    % overlapping detecting
    mask_ovlp = single((sum(from,3) & sum(to,3)) >0);
    mask_from = single(sum(from,3) > 0);
%     mask_to = single(sum(to,3) > 0);
    [ovlp_y, ovlp_x] = find(mask_ovlp);
   
    % image cut in overlapping- distance to center
    [from_ceny, from_cenx] = find_center(from);
    [to_ceny, to_cenx] = find_center(to);
    dis2_from = (ovlp_y - from_ceny).^2 + (ovlp_x - from_cenx).^2;
    dis2_to = (ovlp_y - to_ceny).^2 + (ovlp_x - to_cenx).^2;
    trans_pts= single((dis2_from - dis2_to)<0); % from =1, to = 0;
    mask_trans = ones(size(to,1),size(to,2));
    for i = 1: length(ovlp_y)
        y = ovlp_y(i);
        x = ovlp_x(i);
        mask_trans(y,x) = trans_pts(i);
    end
    mask = single(mask_from & mask_trans);   % from =1, to = 0;
    
    % simple copy blending
    mask = repmat(mask,[1,1,3]);
%     figure(3),imshow(mask);
    output = from.* mask+base.*(1-mask);
end

function [ceny, cenx] = find_center(img)
    [y,x] = find(sum(img,3)>0);
    ceny = mean(y);
    cenx = mean(x);
end
