function  output = quilt_random(sample,outsize,patchsize)
    % control the random sampling range
    [imh,imw,~] = size(sample);
    r = floor (patchsize/2); 
    D = (2*r +1);
    N = ceil (outsize / D);

      
    % with no edge overlaps
    result = []; 
    for j =  1 : N % each row
        trow = [];
        for i =1 : N
                % randomly select the patch
                rx = ceil((imh - 2*r) * rand + r);
                ry = ceil((imw - 2*r) * rand + r);
            	patch = sample((rx-r):(rx+r), (ry-r):(ry+r),:);
       
                trow = cat(2,trow,patch);
        end
        result = cat(1,result,trow);
    end
    output = result(1:outsize,1:outsize,:);
end
