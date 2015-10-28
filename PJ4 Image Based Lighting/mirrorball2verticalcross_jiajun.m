function verticalcross = mirrorball2verticalcross(mirrorball_hdr)
    [imh,imw,~] = size(mirrorball_hdr);
    assert(imh==imw,'Mirror ball image must be square!');
    
    r=imh/2;
    N=zeros(3,1);
    V=zeros(3,1);
    map=zeros(imh,imw,2);
    record=zeros(imh,imw,10);
    V(3)=1;
    count=0;
    for i=1:1:imh
        for j=1:1:imw
            N(1)=(j-r)/r;
            N(2)=-(i-r)/r;
            if N(1)^2+N(2)^2<=1
                count=count+1;
                N(3)=-real(sqrt(1-N(1)^2-N(2)^2));
                record(i,j,1)=N(1);
                record(i,j,2)=N(2);
                record(i,j,3)=N(3);
                R=V-2.*dot(V,N).*N;
                R=R/norm(R);
                record(i,j,4:6)=R;
                map(i,j,1)=atan2(R(1),R(3));
                map(i,j,2)=atan2(R(2),R(3));
                if i>=r
                    map(i,j,2)=map(i,j,2)+2*pi;
                end
                if j<=r
                    map(i,j,1)=map(i,j,1)+2*pi;
                end
            end
        end
    end
    X=zeros(count,2);
    V=zeros(count,3);
    current=0;
    for i=1:1:imh
        for j=1:1:imw
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
    rows=zeros(360,270);
    cols=zeros(360,270);
    [imx,imy]=size(rows);
    for i=imx/4+1:1:imx/4*2
        for j=imy/3+1:1:imy/3*2
            x=(j-imy/2)/(imy/3)*sqrt(2);
            y=-(i-imx/4*1.5)/(imx/4)*sqrt(2);
            rows(i,j)=(pi-atan(2*x/sqrt(2)));
            cols(i,j)=(pi-atan(2*y/sqrt(2)));
        end
    end
    for i=imx/4+1:1:imx/4*2
        for j=1:1:imy/3*1
            x=(j-imy/6*1)/(imy/3)*sqrt(2);
            y=-(i-imx/4*1.5)/(imx/4)*sqrt(2);
            rows(i,j)=(3*pi/2-atan(2*x/sqrt(2)));
            if x>0
                cols(i,j)=(pi-atan(2*y/sqrt(2)));
            elseif y>0
                cols(i,j)=atan(2*y/sqrt(2));
            else
                cols(i,j)=2*pi+atan(2*y/sqrt(2));
            end
        end
    end
    for i=imx/4+1:1:imx/4*2
        for j=imy/3*2+1:1:imy/3*3
            x=(j-imy/6*5)/(imy/3)*sqrt(2);
            y=-(i-imx/4*1.5)/(imx/4)*sqrt(2);
            rows(i,j)=(pi/2-atan(2*x/sqrt(2)));
            if x<0
            cols(i,j)=(pi-atan(2*y/sqrt(2)));
            elseif y>0
                cols(i,j)=atan(2*y/sqrt(2));
            else
                cols(i,j)=2*pi+atan(2*y/sqrt(2));
            end
        end
    end
    for i=1:1:imx/4
        for j=imy/3+1:1:imy/3*2
            x=(j-imy/2)/(imy/3)*sqrt(2);
            y=-(i-imx/4*0.5)/(imx/4)*sqrt(2);
            if y<0
                rows(i,j)=(pi-atan(2*x/sqrt(2)));
            elseif x>0
                rows(i,j)=(atan(2*x/sqrt(2)));
            else
                rows(i,j)=(2*pi+atan(2*x/sqrt(2)));
            end
            cols(i,j)=(pi/2-atan(2*y/sqrt(2)));
        end
    end
    for i=imx/4*2+1:1:imx/4*3
        for j=imy/3+1:1:imy/3*2
            x=(j-imy/2)/(imy/3)*sqrt(2);
            y=-(i-imx/4*2.5)/(imx/4)*sqrt(2);
            if y>0
                rows(i,j)=(pi-atan(2*x/sqrt(2)));
            elseif x>0
                rows(i,j)=(atan(2*x/sqrt(2)));
            else
                rows(i,j)=(2*pi+atan(2*x/sqrt(2)));
            end
            cols(i,j)=(3*pi/2-atan(2*y/sqrt(2)));
        end
    end
    for i=imx/4*3+1:1:imx/4*4
        for j=imy/3+1:1:imy/3*2
            x=(j-imy/2)/(imy/3)*sqrt(2);
            y=-(i-imx/4*3.5)/(imx/4)*sqrt(2);
            if x>0&&y>0
                rows(i,j)=atan(2*x/sqrt(2));
                cols(i,j)=(2*pi-atan(2*y/sqrt(2)));
            elseif x>0
                rows(i,j)=atan(2*x/sqrt(2));
                cols(i,j)=(-atan(2*y/sqrt(2)));
            elseif y>0
                rows(i,j)=2*pi+atan(2*x/sqrt(2));
                cols(i,j)=(2*pi-atan(2*y/sqrt(2)));
            else
                rows(i,j)=2*pi+atan(2*x/sqrt(2));
                cols(i,j)=(-atan(2*y/sqrt(2)));
            end
        end
    end
    verticalcross1=inter1(rows,cols);
    verticalcross2=inter2(rows,cols);
    verticalcross3=inter3(rows,cols);
    verticalcross=zeros(imx,imy,3);
    verticalcross(:,:,1)=verticalcross1;
    verticalcross(:,:,2)=verticalcross2;
    verticalcross(:,:,3)=verticalcross3;
    for i=1:1:imx
        for j=1:1:imy
            for k=1:1:3
                if isnan(verticalcross(i,j,k))
                    verticalcross(i,j,k)=0;
                end
            end
        end
    end
end
