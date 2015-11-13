

addpath vlfeat-0.9.19/
addpath vlfeat-0.9.19/toolbox/
vl_setup;


master_frames=[90   270   450   630   810];
reference_frame=450;

%%
I=imread(sprintf('frames/f%04d.jpg',reference_frame));
[f,d] = vl_sift(single(rgb2gray(I)));
sel  = randperm(size(f,2),50);

figure(1); clf ;
imshow(I)
h1   = vl_plotframe(f(:,sel)) ; set(h1,'color','k','linewidth',4) ;
h2   = vl_plotframe(f(:,sel)) ; set(h2,'color','y','linewidth',2) ;


%%
Ia=imread(sprintf('frames/f%04d.jpg',master_frames(1)));
Ib=imread(sprintf('frames/f%04d.jpg',master_frames(2)));


[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;

[matches, scores] = vl_ubcmatch(da,db) ;

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

figure(2) ; clf ;
imagesc(cat(2, Ia, Ib)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa(1:50) ; xb(1:50)], [ya(1:50) ; yb(1:50)]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,1:50))) ;
fb2=fb;
fb2(1,:) = fb2(1,:) + size(Ia,2) ;
vl_plotframe(fb2(:,matches(2,1:50))) ;
axis image off ;