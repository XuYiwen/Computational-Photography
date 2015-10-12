function [outfore, outback, mask] = freeAlign(fore,back)

disp('>>> Align two source images >>>');
[fore,back] = align_images(fore,back);
disp('>>> Edit mask of foreground image >>>');
objmask = getMask(fore);
objCopy(:,:,1) = fore(:,:,1).*objmask+back(:,:,1).*(1-objmask);
objCopy(:,:,2) = fore(:,:,2).*objmask+back(:,:,2).*(1-objmask);
objCopy(:,:,3) = fore(:,:,3).*objmask+back(:,:,3).*(1-objmask);
figure(1), hold off,imshow(objCopy);
disp('>>> Crop images and mask >>>');
[x,y] = ginput(2);
x = round(x);
y = round(y);
outfore = fore(y(1):y(2),x(1):x(2),:);
outback = back(y(1):y(2),x(1):x(2),:);
mask = objmask(y(1):y(2),x(1):x(2),:);
objCopy = objCopy(y(1):y(2),x(1):x(2),:);
figure(1), hold off, imshow(objCopy);
disp('>>> Free align finished >>>');

