function [avgColor, revColor, tempColor] = getRevColor(backIm, catMask)

tempIm = im2double(imread('colorBar.png'));
h = size(tempIm,1);
w = size(tempIm,2);
oneMask = single(catMask);
catMaskR = catMask(:, :, 1);
numPixel = sum(sum(oneMask(:,:,1)));

sumColorR = sum(sum(backIm(:,:,1) .* catMaskR));
sumColorG = sum(sum(backIm(:,:,2) .* catMaskR));
sumColorB = sum(sum(backIm(:,:,3) .* catMaskR));

avgR = sumColorR / numPixel;
avgG = sumColorG / numPixel;
avgB = sumColorB / numPixel;

avgColor = [avgR, avgG, avgB];
revColor = [1-avgR, 1-avgG, 1-avgB];

temp = avgR /(avgR + avgB);
product = temp * w;
dist = floor(product);

tempR = tempIm(50, dist,1);
tempG = tempIm(50, dist,2);
tempB = tempIm(50, dist,3);

tempColor = [tempR, tempG, tempB];

%{
testIm = zeros(300,300,0);
testIm(:,:,1) = tempR;
testIm(:,:,2) = tempG;
testIm(:,:,3) = tempB;

testAvg = zeros(300,300,0);
testAvg(:,:,1) = avgR;
testAvg(:,:,2) = avgG;
testAvg(:,:,3) = avgB;

figure(99);
imshow(testIm);
figure(100);
imshow(testAvg);
%}
end