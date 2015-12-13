function output = laplacianBlend(fore,back,objmask,N,width,sigma)
fil = fspecial('gaussian',7*sigma , sigma);

% original image
tL = fore;
tR = back;
tM = double(objmask);
for i = 1 : N
    % construct and pad to left mask
    f = fspecial('disk',width);
    mask = imfilter(tM,f,'replicate');
%     figure(5),imagesc(mask);

    % Subsample down
    gauL = []; gauR = [];
    lapL = []; lapR = [];
    bLap = []; bGau = [];
    for c = 1:3
        % gaussian image
        gauL(:,:,c) = imfilter(tL(:,:,c),fil);
        gauR(:,:,c) = imfilter(tR(:,:,c),fil);
        % laplacian image
        lapL(:,:,c) = tL(:,:,c) - gauL(:,:,c);
        lapR(:,:,c) = tR(:,:,c) - gauR(:,:,c);
        % blended image
        bLap(:,:,c) = lapR(:,:,c).*(1-mask) + lapL(:,:,c).*mask;
        bGau(:,:,c) = gauR(:,:,c).*(1-mask) + gauL(:,:,c).*mask;
    end
    % visualize
%     figure(2),
%     subplot(N,3,(i-1)*3+1),imshow(lapL),title(['The Laplacian of Left image at N = ',num2str(i)]);
%     subplot(N,3,(i-1)*3+2),imshow(lapR),title(['The Laplacian of Right image at N = ',num2str(i)]);
%     subplot(N,3,(i-1)*3+3),imshow(bLap),title(['The Laplacian of Blended image at N = ',num2str(i)]);
    
    Lap{i} = bLap;
    Gau{i} = bGau;
    pysize{i} = [size(tL,1),size(tL,2)];
    tL = imresize(tL,0.5);
    tR = imresize(tR,0.5);
    tM = imresize(tM,0.5);
end

% Upsample recover
mix = Lap{N}+Gau{N};
% figure(3),
% subplot(1,N,1),imshow(mix),title(['N = ',num2str(N)]);
for j = N-1 :-1: 1
    mix = imresize(mix,pysize{j});
    mix = mix+Lap{j};
%     figure(3),
%     subplot(1,N,N-j+1),imshow(mix),title(['N = ',num2str(j)]);
end
% figure(9),imshow(mix);
output = mix;