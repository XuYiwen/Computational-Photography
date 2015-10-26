function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    len = length(sortexp);
    sum = zeros(size(ldrs(:,:,:,1))); 
    uni_inten = zeros(size(ldrs));
    logirr = zeros(size(ldrs));
    for i = 1:len
        % mapping into the same intensity
        uni_inten(:,:,:,i) = ldrs(:,:,:,i)/exposures(i);        
        logirr(:,:,:,i) =log(uni_inten(:,:,:,i)+0.001);
        sum = sum+logirr(:,:,:,i);
    end
    hdr =sum ./ len;
    hdr = exp(hdr);
    minlog = min(logirr(:));
    maxlog= max(logirr(:));
    
    % display 
    for i = 1: len
          % show estimated log irradiance
          figure(2),hold on;
          subplot(2,len,i),imshow(ldrs(:,:,:,i)),title(['1/',num2str(1/exposures(i))]);
          subplot(2,len,len+i),imshow((logirr(:,:,:,i)-minlog)./(maxlog-minlog) ),title(['1/',num2str(1/exposures(i))]);
    end
    % show hdr
    figure(3);
    loghdr = tonemap(hdr);
    imshow(loghdr), title('Naive HDR Output');
end