function [next_cursor,next_header] = find_next_pano(remainder,undo_lib,pano_addr,window)

    % features in remainder
    [F1,D1] = vl_sift((rgb2gray(remainder)));
    [rem_h,rem_w,~] = size(remainder);
    
    display(sprintf('----- Comparing image with unpaired panorama -----'));
    max_pairnum = 0;
    max_matchid = 0;
    record_matches = [];
    record_features = [];
    for idx = 1: size(undo_lib)
        % read and resize the pano to compare
        curr_pano = im2single(imread([pano_addr,sprintf('%03d',undo_lib(idx)),'.jpg']));
        curr_pano = resize_to_winh(curr_pano,window);
        curr_header = curr_pano(:,1:rem_w,:);
        
        % features in current header, compute the scores
        [F2,D2] = vl_sift(rgb2gray(curr_header));
        [matches, score] = vl_ubcmatch(D1,D2);
        number_of_matches = size(matches,2);
%         display(sprintf('Comparing with No.%d, matches %d pairs', undo_lib(idx),number_of_matches));        
        
        % update the best match in record
        if (number_of_matches >= max_pairnum)
            max_pairnum = number_of_matches;
            max_matchid = undo_lib(idx);
            record_matches = matches;
            record_features = F2;
        end
    end
    % best match has most pair of matches
    next_cursor = max_matchid;
    display(sprintf('Next panorama will be No.%d, shares %d matches',next_cursor,max_pairnum));
    
    % recover next_header
    next_pano = im2single(imread([pano_addr,sprintf('%03d',next_cursor),'.jpg']));
    next_pano = resize_to_winh(next_pano,window);
    next_header = next_pano(:,1:rem_w,:);
    
    % plot the matches
    if (false)
        plot_matches(remainder,next_header,F1,record_features,record_matches);
    end

end

function plot_matches(Ia,Ib,fa,fb,matches)
    figure() ; clf ;
    imagesc(cat(2, Ia, Ib)) ;

    xa = fa(1,matches(1,:)) ;
    xb = fb(1,matches(2,:)) + size(Ia,2) ;
    ya = fa(2,matches(1,:)) ;
    yb = fb(2,matches(2,:)) ;

    hold on ;
    h = line([xa ; xb], [ya ; yb]) ;
    set(h,'linewidth', 1, 'color', 'b') ;

    vl_plotframe(fa(:,matches(1,:))) ;
    fb(1,:) = fb(1,:) + size(Ia,2) ;
    vl_plotframe(fb(:,matches(2,:))) ;
    axis image off ;
end