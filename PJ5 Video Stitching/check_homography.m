function check_homography(H,R,S)
    % set 4 corners
    [h,w,~] = size(R);
    hh = 0.2*h;
    ww = 0.6*w;
    d = 180;
    pos_S = [ww,hh,1;   (ww+d),hh,1;   (ww+d),(hh+d),1;   ww,(hh+d),1]';
    
    % transform
    pos_R = H * pos_S;
    pos_R = pos_R./pos_R(3);
    
    % display
    figure(1),
    subplot(1,2,1);
    imshow(S),title('Source Frame'),hold on;
    draw_frame(pos_S);
    
    subplot(1,2,2);
    imshow(R),title('Reference Frame'),hold on;
    draw_frame(pos_R);
end

function draw_frame(pos)
    from = [1,1,1,1];
    to = [2,3,4,1];
    fromX = pos(1,from)';
    toX = pos(1,to)';
    fromY = pos(2,from)';
    toY = pos(2,to)';
    
    h = line([fromX; toX], [fromY; toY]);
    set(h,'linewidth', 2, 'color', 'r') ;
end
