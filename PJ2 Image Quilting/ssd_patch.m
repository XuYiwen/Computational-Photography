% This funtion generates the ssd results image of a given template
% 
% I - sample texture input image
% T - the template to fill in current result image
% M - mask indicates the overlapping area

function cost = ssd_patch(I,T,M)
    P = T.*M;
    cons = sum(sum(P.^2));

    ssd = zeros(size(I,1),size(I,2),3);
    for i = 1:3
        ssd(:,:,i) = imfilter(I(:,:,i).^2, M(:,:,i)) - 2*imfilter(I(:,:,i), P(:,:,i))+ cons(:,:,i);
    end
    cost = sum(ssd,3);
end