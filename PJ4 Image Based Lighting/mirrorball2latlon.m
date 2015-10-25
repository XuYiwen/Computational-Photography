function latlon = mirrorball2latlon( mirrorball_hdr )
    [h,w,d] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    
    %Create equirectangular (latitude-longitude) image here
end