function hdr = makehdr_respfunc(ldrs, exposures,pts)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    
    % Solving for response function
    len = length(sortexp);
    % sample pixel value for each channel
    [imh,imw,~,~] = size(ldrs);
    sample = randperm(imh*imw);
    sample = sample(1:pts);
    [y, x] = getPos(sample,imw);
    for ch = 1:3
        for p = 1 :length(y)
            sampledPixel(p,:,ch) = reshape(ldrs(y(p),x(p),ch,:)+0.000001,[1,len]).*250;
        end
    end
    sampledPixel = ceil(sampledPixel);
    
    % weight function
    w = @(z) double(128-abs(z-128));
    
    % compute response function
    lambda = 100;
    [gr,~] = gsolve(sampledPixel(:,:,1),log(exposures),lambda,w);
    [gg,~] = gsolve(sampledPixel(:,:,2),log(exposures),lambda,w);
    [gb,~] = gsolve(sampledPixel(:,:,3),log(exposures),lambda,w);
    
    % plot response
    x  = 1:255;
    figure(2);
    plot(x,gr(x),'r'),hold on;
    plot(x,gg(x),'g'),hold on;
    plot(x,gb(x),'c'),hold off;
    title('The response function');
    
    % Create HDR
    hdr = zeros(size(ldrs,1),size(ldrs,2),3);
        hdr(:,:,1)= hdr_singel_channel(1,gr,ldrs,exposures,w);
        hdr(:,:,2)= hdr_singel_channel(2,gg,ldrs,exposures,w);
        hdr(:,:,3)= hdr_singel_channel(3,gb,ldrs,exposures,w);

    % adject over exposed area;
%     maxi = zeros(1,3);
%     mask = zeros(size(ldrs,1),size(ldrs,2));
%     for ch = 1: 3
%         sch_hdr = hdr(:,:,ch);
%         maxi(1,ch) = max(sch_hdr(:));
%         [xx,yy] = find(isnan(sch_hdr));
%         mask(xx,yy) =mask(xx,yy)+1; 
%     end
%     mask = double(logical(mask));
%     [xx,yy] = find(mask);
%     for k = 1:length(xx)
%         hdr(xx(k),yy(k),:) = reshape(maxi,[1,1,3]);
%     end
    
    % show hdr
    figure(3);
    loghdr = tonemap(hdr);
    imshow(loghdr), title('Response Function HDR Output');
end

function [y,x] = getPos(N,imw)
    y = ceil(N./imw);
    x = N - (y-1).*imw;
end

function single_ch = hdr_singel_channel(ch,gfunc,ldrs,exposures,w)
    Ei = zeros(size(ldrs,1),size(ldrs,2));    
    Wi= zeros(size(ldrs,1),size(ldrs,2));
    for j = 1: length(exposures)
        z = ceil((ldrs(:,:,ch,j)+0.000001).*250);
        Ei = Ei+w(z).*(gfunc(z)-log(exposures(j)));
        Wi = Wi +w(z);
    end
    % if over exposed, max it
%     single_ch = exp(Ei./Wi);
%     [nanY,nanX] = find(Ei == 0);
%     for k = 1:length(nanY)
%         single_ch(nanY,nanX) = max(single_ch(:));
%     end

    single_ch = exp(Ei./Wi);
end
