function overlap_pano = blend_overlap(remainder,next_header,window)
    % mirror the images 
    [h,w,~] = size(remainder);
    left = mirror(remainder,0); %0 - left, 1 - right
    right = mirror(next_header,1);
%     figure(2),
%     subplot(121),imshow(left),title('Mirrored remainder image');
%     subplot(122),imshow(right),title('Mirrored next header image');
    
    % Laplacian pyramid blending
    mask = cat(2,ones(h,w),zeros(h,w));
    overlap_pano = laplacianBlend(left,right,mask,4,window.w * 0.05,1);
    figure(4),imshow(overlap_pano),title('Laplacian Blending Result');
    

end

function output = mirror(img,original_pos)
    mirr = flip(img,2);
    if (original_pos == 0)
        output = cat(2,img,mirr);
    else
        output = cat(2,mirr,img);
    end
    
end