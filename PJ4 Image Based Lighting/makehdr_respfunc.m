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
            sampledPixel(p,:,ch) = reshape(ldrs(y(p),x(p),ch,:),[1,len]).*255;
        end
    end
    sampledPixel = floor(sampledPixel)+1;
    
    % weight function
    w = @(z) double(128-abs(z-128));
    
    % compute response function
    lambda = 100;
    [gr,~] = gsolve(sampledPixel(:,:,1),log(exposures),lambda,w);
    [gg,~] = gsolve(sampledPixel(:,:,2),log(exposures),lambda,w);
    [gb,~] = gsolve(sampledPixel(:,:,3),log(exposures),lambda,w);
    
    % plot response
    x  = 1:255;
    figure(2), title('The response function');
    plot(x,gr(x),'r'),hold on;
    plot(x,gg(x),'g'),hold on;
    plot(x,gb(x),'c'),hold off;
    
    % Create HDR
    hdr = zeros(size(ldrs,1),size(ldrs,2),3);   
    hdr(:,:,1)= hdr_singel_channel(1,gr,ldrs,exposures,w);
    hdr(:,:,2)= hdr_singel_channel(2,gg,ldrs,exposures,w);
    hdr(:,:,3)= hdr_singel_channel(3,gb,ldrs,exposures,w);
   
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
        z = floor(ldrs(:,:,ch,j).*255)+1;
        Ei = Ei+w(z).*(gfunc(z)-log(exposures(j)));
        Wi = Wi +w(z);
    end

    single_ch = exp(Ei./Wi);
end
