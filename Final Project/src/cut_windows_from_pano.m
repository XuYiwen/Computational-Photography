function [remainder,frame_id] = cut_windows_from_pano(cur_pano,back_addr,window,frame_id,end_sgn)
    [panoh,panow,~] = size(cur_pano);
    spt = 1;
    ept = window.w;
    max_nonlap = panow - window.w * 0.5;
    if (end_sgn == 1) 
        max_nonlap = panow;
    end
    while(ept < max_nonlap)
        cut = cur_pano(:, spt:ept,:);
        imwrite(cut,[back_addr,sprintf('%03d',frame_id),'.jpg']);
%         figure(2),imshow(cut);
        % next loop
        spt = spt + window.speed;
        ept = ept + window.speed;
        frame_id = frame_id + 1;
    end
    remainder = cur_pano(:,spt+window.speed:end,:);    
end