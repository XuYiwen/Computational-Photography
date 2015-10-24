function [outfore, outback, mask] = freeAlign(fore,back)

disp('>>> Align two source images >>>');
[fore,back] = align_images(fore,back);
disp('>>> Edit mask of foreground image >>>');
objmask = getMask(fore);
objCopy(:,:,1) = fore(:,:,1).*objmask+back(:,:,1).*(1-objmask);
objCopy(:,:,2) = fore(:,:,2).*objmask+back(:,:,2).*(1-objmask);
objCopy(:,:,3) = fore(:,:,3).*objmask+back(:,:,3).*(1-objmask);
<<<<<<< HEAD
figure(1), hold off,imshow(objCopy);
=======
figure(2), hold off,imshow(objCopy);
>>>>>>> d8d085fb5048bb2109ead1c276253f0581a4bc70
disp('>>> Crop images and mask >>>');
[x,y] = ginput(2);
x = round(x);
y = round(y);
outfore = fore(y(1):y(2),x(1):x(2),:);
outback = back(y(1):y(2),x(1):x(2),:);
mask = objmask(y(1):y(2),x(1):x(2),:);
objCopy = objCopy(y(1):y(2),x(1):x(2),:);
<<<<<<< HEAD
figure(1), hold off, imshow(objCopy);
=======
figure(2), hold off, imshow(objCopy),title('Copy and Paste Image');
>>>>>>> d8d085fb5048bb2109ead1c276253f0581a4bc70
disp('>>> Free align finished >>>');

