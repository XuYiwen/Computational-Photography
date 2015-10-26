function [cost] = ssd_patch(image, patch, mask, index)

[imx imy ~] = size(patch);
image_chosen = image(index(1):index(1)+imx-1,index(2):index(2)+imy-1,:);
diff = image_chosen - patch;
cost = sum(sum(sum(diff.^2,3).*mask));

end
