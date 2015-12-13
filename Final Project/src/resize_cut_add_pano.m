function outpano = resize_cut_add_pano(inpano,overlap_size,remainder,window)
    
    % resize the input panorama to be same size of window.h
    inpano = resize_to_winh(inpano,window);
    
    % cut out the overlapped area, which already processed
    if overlap_size ~= 0 
        inpano = inpano(:,overlap_size+1:end,:);
    end
    
    % add the remainder at front
    outpano = cat(2,remainder,inpano);
end

