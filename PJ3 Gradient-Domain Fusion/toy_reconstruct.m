function output = toy_reconstruct(im)
[imh, imw, ~] = size(im); 
im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw; 

e = 1; 
A = zeros(imh*imw*2+2, imh*imw);
b = zeros(imh*imw*2+2, 1);
for y = 1:imh-1
    for x = 1:imw-1
        % Objective 1
        A(e, im2var(y,x+1)) = 1;
        A(e, im2var(y,x)) = -1; 
        b(e) = im(y,x+1)-im(y,x); 
        e = e+1;
        % Objective 2
        A(e, im2var(y+1,x)) = 1;
        A(e, im2var(y,x)) = -1; 
        b(e) = im(y+1,x)-im(y,x); 
        e = e+1;
    end
end
% Objective 3
A(e, im2var(1,1)) = 1;
b(e) = im(1,1);

% Compute the pixel
A = sparse(A);
v = A\b;
% v(end) = im(imh,imw);
output = reshape(v,[imh, imw]);





