function box_hdr = mirrorball2verticalcross2( mirrorball_hdr )
    [imh,imw,~] = size(mirrorball_hdr);
    assert(imh==imw,'Mirror ball image must be square!');
    display = true;

% Create Vertical Cross image
% Image coordinates[u, v] - u/x : right | v/y : up
% Space coordinates[x; y; z] - x : right | y : up | z : out
r = imh /2;
img_nor = zeros(imh,imw,3);
img_ref = zeros(imh,imw,3);
img_map = zeros(imh,imw,3);
count = 0;
ball_map = zeros(imh*imw,2);
ball_hdr = zeros(imh*imw,3);
for j = 1: imh
    for i = 1: imw
        x = (i-r) /r;
        y = -(j-r) /r;
        if (x^2+y^2) <=1 % if in the mirror ball area
            z = - real(sqrt(1 -x^2 -y^2));
            % get normal and  reflection direction
            N = [x; y; z];
            V = [0; 0; 1];
            R = V - 2 .* dot(V,N) .* N;
            img_nor(j,i,:) = reshape(N,1,1,3);
            img_ref(j,i,:) = reshape(R,1,1,3); 
            % compute the mapping coordinates
            img_map(j,i,1) = atan2(x,z);
            img_map(j,i,2) = atan2(y,z);
            if j>=r
                img_map(j,i,2) = img_map(j,i,2)+2*pi;
            end
            if i<=r
                img_map(j,i,1) = img_map(j,i,1)+2*pi;
            end
            % record ball area hdr
            count = count+1;
            ball_map(count,1) = img_map(j,i,1);
            ball_map(count,2) = img_map(j,i,2);
            ball_hdr(count,:) = reshape(mirrorball_hdr(j,i,:),1,3);
        end
    end
end
ball_map = ball_map(1:count,:);
ball_hdr = ball_hdr(1:count,:);

% remapping into Boxes coordinates
[box_rows,box_cols] = box_coordinates();
box_hdr = zeros(size(box_rows,1),size(box_rows,2),3);
for ch = 1:3
    interp = scatteredInterpolant(ball_map(:,1),ball_map(:,2),ball_hdr(:,ch));
    int_val = interp(box_rows,box_cols);
    [nanX,nanY] = find(isnan(int_val));
    for k = 1:length(nanX)
        int_val(nanX(k),nanY(k)) = 0;
    end
    box_hdr(:,:,ch) =  real(int_val);
end

if (display)
    figure(5), % show hdr
    loghdr = tonemap(box_hdr);
    imshow(loghdr), title('Vertical Cross HDR Output');
end

end

function [rows,cols] = box_coordinates()
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
end