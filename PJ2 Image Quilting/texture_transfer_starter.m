%% texture transfer
clear; clc; close all;
% Loading image
num = 1;
size = [31,11,11,21];
sam = im2double(imread(['.\images\sam_',num2str(num),'.jpg']));
tar = im2double(imread(['.\images\tar_',num2str(num),'.jpg']));

% Setting parameters
patchsize = size(num);
overlap = floor(patchsize / 5);
tol = 0.1;
alpha = 0.3;
iter = true;
iter_num = 3;

% Texture transfering
if iter
    tex_trans = iter_tex_transfer(sam,tar, patchsize,overlap,tol,iter_num);
    % Display settings
    figure(5),
    subplot(121),imshow(sam),title('The original texture image');
    subplot(122),imshow(tar),title('The original target image');
    print(5,'-djpeg',['.\results\',num2str(num),'_itorg_img.jpg']);
else
    tex_trans = texture_transfer(sam,tar, patchsize,overlap,tol,alpha);
    % Display settings
    figure(5),
    subplot(121),imshow(sam),title('The original texture image');
    subplot(122),imshow(tar),title('The original target image');
    print(5,'-djpeg',['.\results\',num2str(num),'_org_img.jpg']);
    figure(6),imshow(tex_trans),title('The texture transfer result');
    print(6,'-djpeg',['.\results\',num2str(num),'_tx_transf.jpg']);
end
