function foreground_main(fps,framNum,back_addr,out_addr,fore_addr)

%% Apply to every frame
%{
TODO: Put background frame images are in "backFrames" folder.
cat frame images are already in "catFrames" folder.
Output frame images would be saved in "outFrames" folder.
TODO: change fps and frameNum value, depending on your video.
TODO: change resize coefficient of the background frame images.
DO NOT resize the foreground cat image!
%}

%% Process every frame
for	i = 1:framNum
     backName = [back_addr, num2str(i, '%03d'), '.jpg'];
     outName = [out_addr, num2str(i, '%03d'), '.jpg'];
     backIm = imresize(im2double(imread(backName)), 1.5, 'bilinear');
     catIndex = ceil((mod(i, fps)+0.1)/(fps/10));
     catName = [fore_addr, num2str(catIndex, '%02d'), '.jpg'];
     seedIm = im2double(imread(catName));
     seedIm = flipdim(seedIm,2);
%% Source Images
 %seedMask = sum(seedIm,3)<2 & sum(seedIm,3)>1;
 seedMask = sum(seedIm,3)<2;
 
 seedMask3D = cat(3,seedMask,seedMask);
 [im_s, mask_s] = myAlign(seedIm, seedMask, backIm);
 mask_s3D = cat (3,mask_s,mask_s, mask_s);
 % result = im_s .* mask_s3D + (1-mask_s3D) .* backIm;
 
 darkGreenMask = im_s(:,:,1) == 0.2;
 lightGreenMask = im_s(:,:,1) == 0.4;
 darkGreenMask3D = cat (3, darkGreenMask, darkGreenMask, darkGreenMask);
 lightGreenMask3D = cat (3, lightGreenMask, lightGreenMask, lightGreenMask);
 catMask = mask_s3D;
 %% Get body color
[avgColor, revColor, tempColor] = getRevColor(backIm, catMask);
 
%% Change seed color
 redSrc = zeros(size(im_s));
 redSrc(:,:,2) = 1;
 redSeed = redSrc .* lightGreenMask3D + im_s .* (1-lightGreenMask3D);
 redSeed_s = redSeed .* mask_s3D + backIm .* (1 - mask_s3D);

 %% Change body color
 BlueSrc = zeros(size(im_s));
 
 BlueSrc(:,:,1) = tempColor(1);
 BlueSrc(:,:,2) = tempColor(2);
 BlueSrc(:,:,3) = tempColor(3);

 BlueSeed = BlueSrc .* darkGreenMask3D + redSeed_s .* (1-darkGreenMask3D);
 BlueBody = BlueSeed .* mask_s3D + backIm .* (1 - mask_s3D);

 %figure(1);
 %imshow(BlueBody);
 
%% Save output image
imwrite(BlueBody, outName);

end


 
 
 
 
 
 
