function hdr = makehdr_overunder(ldrs, exposures,cut_expo)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create weighted HDR here
    len = length(sortexp);
    sum = zeros(size(ldrs(:,:,:,1))); 
    wt = zeros(size(ldrs(:,:,:,1))); 
    uni_inten = zeros(size(ldrs));
    logirr = zeros(size(ldrs));
    pre_over = ones(size(ldrs,1),size(ldrs,2));
    pre_under = ones(size(ldrs,1),size(ldrs,2));
    for i = 1:len
        % generate proper exposed mask
        gray = rgb2gray(ldrs(:,:,:,i));
        over = gray>(1-cut_expo);
        under = gray<cut_expo;
        pre_over = pre_over & over;
        pre_under = pre_under & under;
        mask = double(~(over | under));
        mask = repmat(mask,[1,1,3]);
        
        % mapping into the same intensity
        uni_inten(:,:,:,i) = ldrs(:,:,:,i)/exposures(i);        
        logirr(:,:,:,i) =log(uni_inten(:,:,:,i)+0.001);
        sum = sum+logirr(:,:,:,i).*mask;
        wt = wt +mask;
    end
    % elimated never properly exposed
    extreme = 0;
    for i =1:len
        extreme = 1./exposures(i) +extreme;
    end
    extreme = log(extreme+0.001);
% 
%     figure();
%     subplot(1,3,1),imshow(wt);
%     subplot(1,3,2),imshow(pre_over);
%     subplot(1,3,3),imshow(pre_under);
    
    pre_over = repmat(pre_over,[1,1,3]);
    pre_under = repmat(pre_under,[1,1,3]);
    sum = sum+double(pre_over)*extreme+0;
    wt = wt+1*double(pre_over)+1*double(pre_under);

    hdr =sum ./ wt;
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
    imshow(loghdr), title('Weighted HDR Output');
end