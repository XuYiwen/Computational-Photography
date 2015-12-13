function [im_s, mask_s] = myAlign(im_object, objmask, im_background)
    mask_s = false(size(im_background, 1), size(im_background, 2));
    %figure(102);
    %imshow(mask_s);
    im_s = zeros(size(im_background, 1), size(im_background, 2),3);
    h = size(objmask, 1);
    Hb = size(im_background, 1);
    w = size(objmask, 2);
    Wb = size(im_background, 2);    
    %mask_s(Hb-(2+ h): Hb-3, Wb-(2+ w): Wb-3) = objmask;
    %im_s(Hb-(2+ h):Hb-3, Wb-(2+ w) : Wb-3,:) = im_object;
    mask_s(Hb-(2+ h): Hb-3, 3: 2+ w) = objmask;
    im_s(Hb-(2+ h):Hb-3, 3:2+ w,:) = im_object;
end
    
