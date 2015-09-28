function [mask, wx, wy] = mask_win(i, j, overlap, D)
    if (i~=1 && j~=1)    
        mask = [ ones(overlap,overlap), ones(overlap,D-overlap);
                       ones(D-overlap, overlap), zeros(D-overlap,D-overlap)];
    elseif (i==1 && j~=1) 
        mask = [ones(overlap,D);zeros(D-overlap,D)]; 
    elseif (i~=1 && j==1)
        mask = [ones(D,overlap),zeros(D,D-overlap)];
    elseif (i==1 && j ==1)
        mask = zeros(D,D);
    end

    wx = (i-1)*(D-overlap);
    if (wx < 0)
        wx = 0;
    end
    wy = (j-1)*(D-overlap);
    if (wy < 0)
        wy = 0;
    end
    mask = repmat(mask,1,1,3);
end