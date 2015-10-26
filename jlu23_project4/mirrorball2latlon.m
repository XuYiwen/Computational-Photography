function latlon = mirrorball2latlon(mirrorball_hdr)
    [h,w,~] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    r=h/2;
    N=zeros(3,1);
    V=zeros(3,1);
    map=zeros(h,w,2);
    V(3)=1;
    count=0;
    for i=1:1:h
        for j=1:1:w
            N(1)=(j-r)/r;
            N(2)=-(i-r)/r;
            if N(1)^2+N(2)^2<=1
                count=count+1;
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
    X=zeros(count,2);
    V=zeros(count,3);
    current=0;
    for i=1:1:h
        for j=1:1:w
            if ((j-r)/r)^2+((i-r)/r)^2<=1
                current=current+1;
                X(current,1)=map(i,j,1);
                X(current,2)=map(i,j,2);
                V(current,:)=mirrorball_hdr(i,j,:);
            end
        end
    end
    inter1 = TriScatteredInterp(X,V(:,1));
    inter2 = TriScatteredInterp(X,V(:,2));
    inter3 = TriScatteredInterp(X,V(:,3));
    [phis, thetas] = meshgrid(-pi:pi/360:pi, 0:pi/360:pi);
    [imx,imy]=size(phis);
    latlon1=inter1(thetas,phis);
    latlon2=inter2(thetas,phis);
    latlon3=inter3(thetas,phis);
    latlon=zeros(imx,imy,3);
    latlon(:,:,1)=latlon1;
    latlon(:,:,2)=latlon2;
    latlon(:,:,3)=latlon3;
    for i=1:1:imx
        for j=1:1:imy
            for k=1:1:3
                if isnan(latlon(i,j,k))
                    latlon(i,j,k)=0;
                end
            end
        end
    end
end
