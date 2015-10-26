function angular = mirrorball2angular(mirrorball_hdr)
    [h,w,~] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    r=h/2;
    N=zeros(3,1);
    V=zeros(3,1);
    map=zeros(h,w,2);
    record=zeros(h,w,10);
    V(3)=1;
    count=0;
    for i=1:1:h
        for j=1:1:w
            N(1)=(j-r)/r;
            N(2)=-(i-r)/r;
            if N(1)^2+N(2)^2<=1
                count=count+1;
                N(3)=-sqrt(1-N(1)^2-N(2)^2);
                record(i,j,1)=N(1);
                record(i,j,2)=N(2); 
                record(i,j,3)=N(3);
                R=V-2.*dot(V,N).*N;
                R=R/norm(R);
                record(i,j,4:6)=R;
                map(i,j,1)=(1-atan2(sqrt(R(1)^2+R(2)^2),R(3))/pi)*R(1)/sqrt(R(1)^2+R(2)^2);
                map(i,j,2)=(1-atan2(sqrt(R(1)^2+R(2)^2),R(3))/pi)*R(2)/sqrt(R(1)^2+R(2)^2);
                record(i,j,7)=(1-atan2(sqrt(R(1)^2+R(2)^2),R(3))/pi);
                record(i,j,8)=(1-atan2(sqrt(R(1)^2+R(2)^2),R(3))/pi);
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
    rows=zeros(h,w);
    cols=zeros(h,w);
    for i=1:1:h
        for j=1:1:w
            rows(i,j)=(j-r)/r;
            cols(i,j)=-(i-r)/r;
        end
    end
    [imx,imy]=size(rows);
    angular1=inter1(rows,cols);
    angular2=inter2(rows,cols);
    angular3=inter3(rows,cols);
    angular=zeros(imx,imy,3);
    angular(:,:,1)=angular1;
    angular(:,:,2)=angular2;
    angular(:,:,3)=angular3;
    for i=1:1:imx
        for j=1:1:imy
            for k=1:1:3
                if isnan(angular(i,j,k))
                    angular(i,j,k)=0;
                end
            end
        end
    end
end
