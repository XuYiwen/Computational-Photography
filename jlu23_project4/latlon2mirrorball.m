function mirrorball_hdr = latlon2mirrorball(latlon)
    mirrorball_hdr = zeros(181,181,3);
    [h,w,~] = size(mirrorball_hdr);
    r=h/2;
    N=zeros(3,1);
    V=zeros(3,1);
    map=zeros(h,w,2);
    V(3)=1;
    for i=1:1:h
        for j=1:1:w
            N(1)=(j-r)/r;
            N(2)=-(i-r)/r;
            if N(1)^2+N(2)^2<=1
                N(3)=-sqrt(1-N(1)^2-N(2)^2);
                R=V-2.*dot(V,N).*N;
                R=R/norm(R);
                map(i,j,1)=acos(R(2));
                map(i,j,2)=pi-atan2(R(1),R(3));
                if map(i,j,2) > pi
                    map(i,j,2) = map(i,j,2) - 2 * pi;
                end
            end
        end
    end
    
    [hh,ww,~] = size(latlon);
    X=zeros(hh*ww,2);
    V=zeros(hh*ww,3);
    current=0;
    for i=1:1:hh
        for j=1:1:ww
            current=current+1;
            X(current,1)=i/hh*pi;
            X(current,2)=(j-ww/2)/(ww/2)*pi;
            V(current,:)=latlon(i,j,:);
        end
    end
    inter1 = TriScatteredInterp(X,V(:,1));
    inter2 = TriScatteredInterp(X,V(:,2));
    inter3 = TriScatteredInterp(X,V(:,3));
    mirrorball_hdr(:,:,1) = inter1(map(:,:,1),map(:,:,2));
    mirrorball_hdr(:,:,2) = inter2(map(:,:,1),map(:,:,2));
    mirrorball_hdr(:,:,3) = inter3(map(:,:,1),map(:,:,2));
    figure;imshow(mirrorball_hdr);
end
