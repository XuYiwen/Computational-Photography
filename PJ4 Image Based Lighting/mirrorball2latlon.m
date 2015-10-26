function equi_hdr = mirrorball2latlon( mirrorball_hdr )
    [imh,imw,~] = size(mirrorball_hdr);
    assert(imh==imw,'Mirror ball image must be square!');
    display = true;

% Create equirectangular (latitude-longitude) image
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
            z = real(sqrt(1 -x^2 -y^2));
            % get normal and  reflection direction
            N = [x; y; z];
            V = [0; 0; -1];
            R = V - 2 .* dot(V,N) .* N;
            img_nor(j,i,:) = reshape(N,1,1,3);
            img_ref(j,i,:) = reshape(R,1,1,3); 
            % compute the mapping phi and theta
            phi = acos(R(2));
            atan = atan2(R(1),R(3));
            if (atan>= 0)
                theta = 2*pi -atan;
            else
                theta = - atan;
            end
            img_map(j,i,1) = theta;
            img_map(j,i,2) = phi;
            % record ball area hdr
            count = count+1;
            ball_map(count,1) = theta;
            ball_map(count,2) = phi;
            ball_hdr(count,:) = reshape(mirrorball_hdr(j,i,:),1,3);
        end
    end
end
ball_map = ball_map(1:count,:);
ball_hdr = ball_hdr(1:count,:);

% remapping into Equirectangular coordinates
[thetas,phis] = meshgrid(0:pi/360:2*pi, 0:pi/360:pi);
equi_hdr = zeros(size(phis,1),size(phis,2),3);
for ch = 1:3
    interp = scatteredInterpolant(ball_map(:,1),ball_map(:,2),ball_hdr(:,ch));
    int_val = interp(thetas,phis);
    [nanX,nanY] = find(isnan(int_val));
    for k = 1:length(nanX)
        int_val(nanX(k),nanY(k)) = 0;
    end
    equi_hdr(:,:,ch) = int_val;
end

if (display)
    figure(4), % Vector direction transform
    img_nor = (img_nor+1)./2;
    img_ref = (img_ref+1)./2;
    img_map(:,:,1) = img_map(:,:,1)./(2*pi);
    img_map(:,:,2) = img_map(:,:,2)./(pi);
    subplot(131),imshow(img_nor),title('Normal Direction');
    subplot(132),imshow(img_ref),title('Reflection Direction');
    subplot(133),imshow(img_map),title('Mapping Phi/Theta');
      
    figure(5), % show hdr
    loghdr = tonemap(equi_hdr);
    imshow(loghdr), title('Equirectangular transformed HDR Output');
end

end
