function  output = quilt_random(sample,outsize,patchsize)
    % control the random sampling range
    [imh,imw,~] = size(sample);
    r = floor (patchsize/2); 
    D = (2*r +1);
    N = floor (outsize / D);

      
    % with no edge overlaps
    temp = []; 
    for j =  1 : N % each row
        trow = [];
        for i =1 : N
                % randomly select the patch
                rx = ceil((imh - 2*r) * rand + r);
                ry = ceil((imw - 2*r) * rand + r);
            	patch = sample((rx-r):(rx+r), (ry-r):(ry+r),:);
       
                trow = cat(2,trow,patch);
        end
        temp = cat(1,temp,trow);
    end
    output = temp;
end
