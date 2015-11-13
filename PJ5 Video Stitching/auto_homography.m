function H = auto_homography(img_r,img_s)
% Computes a homography that maps points from img_s to img_r
% Input: img_r and img_s are images
% Output: H is the homography
%
% Note: to use H in maketform, use maketform('projective', H')

    % Detect keypoints
    [keypt_R,des_R] = vl_sift(im2single(rgb2gray(img_r))) ;
    [keypt_S,des_S] = vl_sift(im2single(rgb2gray(img_s))) ;
    matches = vl_ubcmatch(des_R,des_S) ;
    total_matches = size(matches,2) ;

    % Matching points for each image
    pos_R = keypt_R(1:2,matches(1,:)) ; pos_R(3,:) = 1 ;
    pos_S = keypt_S(1:2,matches(2,:)) ; pos_S(3,:) = 1 ;

    % Automatic homography estimation with RANSAC
    iter = 1000;
    best_score = 0;
    for t = 1: iter
        % estimate homograpyh
        subset = vl_colsubset(1:total_matches, 4);
        pts_R = pos_R(:, subset);
        pts_S = pos_S(:, subset);
        Htemp = computeHomography(pts_R, pts_S); 

        % score homography
        pos_R_ = Htemp * pos_S ; % project points from first image to second using H
        du = pos_R_(1,:)./pos_R_(3,:) - pos_R(1,:)./pos_R(3,:) ;
        dv = pos_R_(2,:)./pos_R_(3,:) - pos_R(2,:)./pos_R(3,:) ;
        ok_t = sqrt(du.*du + dv.*dv) < 1;  % you may need to play with this threshold
        score_t = sum(ok_t) ;

        if score_t > best_score
            best_score = score_t;
            H = Htemp;
        end
    end
    disp(['[Best Score]: ',num2str(round(best_score*100/size(pos_R,2))),'%']);
end

function H = computeHomography(pts_R, pts_S)
% Compute homography that maps from pts_S to pts_R using least squares solver
% Input: pts_R and pts_S are 3xN matrices for N points in homogeneous
% coordinates. 
%
% Output: H is a 3x3 matrix, such that pts2~=H*pts1

    % Normalize homogeneous coordinates
    T_ = normalizeTransform(pts_R);
    T = normalizeTransform(pts_S);
    X_ = T_ * pts_R;
    X = T * pts_S;

    % Construct A and compute H
    len = size(X_,2);
    A = zeros(2*len,9);
    for i = 1: len
        u = X(1,i);
        v = X(2,i);
        u_ = X_(1,i);
        v_ = X_(2,i);

        A(2*i-1,:) =    [-u, -v, -1,    0,  0,  0,      u*u_, v*u_, u_];
        A(2*i,:) =        [ 0,  0,   0,  -u, -v, -1,      u*v_, v*v_, v_];
    end
    [~, ~, V] = svd(A);
    Hn = V(:,end);
    Hn = reshape(Hn,[3,3])';
    % Unnormalize
    T_inv = T_\eye(3);
    H = T_inv * Hn * T;
end

function T = normalizeTransform(pts)
    u = pts(1,:);
    v = pts(2,:);
    n = numel(u);

    aver_u = mean(u);
    aver_v = mean(v);
    den = real(sqrt((u-aver_u).^2 + (v-aver_v).^2));
    den = sum(den);
    sigma = sqrt(2)*n /den;

    T = sigma.*[1,0,-aver_u;
                        0,1,-aver_v;
                        0,0,1/sigma];
end