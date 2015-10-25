function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    len = length(sortexp);
    sum = zeros(size(ldrs(:,:,:,1)));
    for i = 1:len
            sum = sum+log(ldrs(:,:,:,i)./exposures(i));            
    end
    hdr =sum ./ len;
    hdr = exp(hdr);
end