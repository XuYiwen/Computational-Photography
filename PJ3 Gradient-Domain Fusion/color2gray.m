function gray = color2gray(im)
[imh, imw, ch] = size(im); 
im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw; 

e = 1; 
A = sparse(imh*imw*2+1, imh*imw);
b = sparse(imh*imw*2+1, 1);
for y = 1:imh-1
    for x = 1:imw-1
        % down
        A(e, im2var(y,x)) = 1; 
        A(e, im2var(y+1,x)) = -1;
        b(e) = mixedColor(im(y,x,:),im(y+1,x,:));
        e = e+1;
        % right
        A(e, im2var(y,x)) = 1; 
        A(e, im2var(y,x+1)) = -1;
        b(e) = mixedColor(im(y,x,:),im(y,x+1,:));
        e = e+1;
    end
end
A(e,im2var(1,1)) = 1;
b(e) = im(1,1);

% Compute the pixels
v = A\b;
maxv = max(v);
v = v./maxv;
gray = full(reshape(v,[imh,imw]));
