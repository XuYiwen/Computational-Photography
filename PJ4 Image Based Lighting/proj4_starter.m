clear; clc; close all;

%% LDR merging into HDR
% 1- naive LDR | 2- under/over | 3 - response function
method = 3;
scene_num = 3;
exp{1} =  [40,160,640,2000];
exp{2} = [5,20,40,80,320];
exp{3} = [40,160,640];
exp{4} = [25,60,125,200,500];
exp_time = exp{scene_num};
cp_size = 500;
img_stack = zeros(cp_size,cp_size,3,length(exp_time));

% loading image with different exposure time into stack
for i = 1: length(exp_time)
    cp_path = ['.\images\scene0', num2str(scene_num), '\cp_t', num2str(exp_time(i)),'.jpg'];
    toadd = im2double(imread(cp_path));
    toadd = imresize(toadd, [cp_size, cp_size],'bilinear');
    img_stack(:,:,:,i) = toadd;    
end

% apply hdr transform
exp_time = 1./exp_time;
if method == 1 % naive LDR
    hdr_naive = makehdr_naive(img_stack, exp_time);
    hdrwrite(hdr_naive,'.\hdr_images\HDR_naive.hdr');
    rgb = tonemap(hdr_naive);
    imwrite(rgb,'.\hdr_images\HDR_naive.jpg');
    ball_hdr = hdr_naive;
    
elseif method == 2 % under/over
    hdr_ovud = makehdr_overunder(img_stack, exp_time,0.02);
    hdrwrite(hdr_ovud,'.\hdr_images\HDR_weighted.hdr');
    rgb = tonemap(hdr_ovud);
    imwrite(rgb,'.\hdr_images\HDR_weighted.jpg');
    ball_hdr = hdr_ovud;
    
elseif method == 3 % response function
    hdr_rfunc = makehdr_respfunc(img_stack,exp_time,150);
    hdrwrite(hdr_rfunc,'.\hdr_images\HDR_rfunc.hdr');
    rgb = tonemap(hdr_rfunc);
    imwrite(rgb,'.\hdr_images\HDR_rfunc.jpg');
    ball_hdr = hdr_rfunc;
end

%% Panoramic transformations
pano_hdr = mirrorball2latlon(ball_hdr);  % Sphere to Equirectangular
% pano_hdr= mirrorball2angular(ball_hdr); % Sphere to Angular 
hdrwrite(pano_hdr, '.\hdr_images\latlon.hdr');

%% Compositing image 
setting = 2;
scene_num =2;
c = 2;
render_path = ['.\render\setting', num2str(setting), '\'];
scene_path = ['.\images\scene0', num2str(scene_num), '\'];
% Read images
R = im2double(imread([render_path,'withobj.png'])) ;
E = im2double(imread([render_path,'withoutobj.png'])) ;
M = im2double(imread([render_path,'mask.png'])) ;
I = im2double(imread([scene_path,'empty.jpg']));
I = imresize(I,[size(R,1),size(R,2)]);

% Mix image
mix = M.*R + (1-M).*I + (1-M).*(R-E).*c ;
imwrite(mix,[render_path,'mixed.png'])
figure(5),title('Composed image');
imshow(mix);
