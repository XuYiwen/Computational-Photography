function ang_hdr = mirrorball2angular( mirrorball_hdr )
    [imh,imw,~] = size(mirrorball_hdr);
    assert(imh==imw,'Mirror ball image must be square!');
    display = true;

% Create Angular image
% Image coordinates[u, v] - u/x : right | v/y : up
% Space coordinates[x; y; z] - x : right | y : up | z : out
r = imh /2;
img_nor = zeros(imh,imw,3);
img_ref = zeros(imh,imw,3);
img_map = zeros(imh,imw,3);
count = 0;
ball_map = zeros(imh*imw,2);
ball_hdr = zeros(imh*imw,3);
mesh_r = ones(imh,imw).*NaN;
mesh_phi = ones(imh,imw).*NaN;
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
            % compute the mapping phi and r
            radius = atan2(real(sqrt(x^2+y^2)),z)/pi*2;
            phi = atan2(y,x);
            img_map(j,i,1) = radius;
            img_map(j,i,2) = phi;
            % record ball area hdr
            count = count+1;
            ball_map(count,1) = radius;
            ball_map(count,2) = phi;
            ball_hdr(count,:) = reshape(mirrorball_hdr(j,i,:),1,3);
            % remapping corrdinates in angular coordinates
            mesh_r(j,i) = real(sqrt(x^2 + y^2));
            mesh_phi(j,i) = atan2(y,x);
        end
    end
end
ball_map = ball_map(1:count,:);
ball_hdr = ball_hdr(1:count,:);

% remapping into Angular coordinates
[inball_y, inball_x] = find(~isnan(mesh_r));
inball_r = zeros(1,count);
inball_phi = zeros(1,count);
for pt =1:length(inball_x)
    inball_r(pt) = mesh_r(inball_y(pt),inball_x(pt));
    inball_phi(pt) = mesh_phi(inball_y(pt),inball_x(pt));
end
ang_hdr = zeros(imh,imw,3);
for ch = 1:3
    interp = scatteredInterpolant(ball_map(:,1),ball_map(:,2),ball_hdr(:,ch));
    int_val = interp(inball_r,inball_phi);
    [nanX,nanY] = find(int_val<0);
    for k = 1:length(nanX)
        int_val(nanX(k),nanY(k)) = 0;
    end
    % write in texture if is in the ball
    for pt =1:length(inball_x)
        y = inball_y(pt);
        x = inball_x(pt);
        ang_hdr(y,x,ch) = int_val(pt);
    end
end

if (display)
    
    figure(5), % show hdr
    loghdr = tonemap(ang_hdr);
    imshow(loghdr), title('Angular transformed HDR Output');
end

end
