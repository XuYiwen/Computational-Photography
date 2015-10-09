function output = poissonBlend(source, mask, target)


% find
% [imh, imw, imch] = size(source); 
% im2var = zeros(imh, imw); 
% im2var(1:imh*imw) = 1:imh*imw; 
% 
% for ch = 1: imch
%     e = 1; 
%     A = sparse(imh*imw*4+1, imh*imw);
%     b = zeros(imh*imw*4+1, 1);
%     for y = i : imh
%         for x = i : imw
%             % for pixels in the patch
%             if mask(y,x) == 1
%                 % four surrounding pixels
%                 for 
%                 A(e, im2var(y,x+1)) = 1;
%                 A(e, im2var(y,x)) = -1; 
%                 b(e) = im(y,x+1)-im(y,x); 
%                 e = e+1;
%             end
%         end 
%     end
%     patch(:,:,ch) = mix;
% end
% output  = patch.*mask+target.*(1-mask);