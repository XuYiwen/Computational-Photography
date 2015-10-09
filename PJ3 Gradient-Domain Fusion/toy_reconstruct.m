function output = toy_reconstruct(im)
[imh, imw, nb] = size(im); 
im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw; 

% the objective 1: minimize (v(x+1,y)-v(x,y) - (s(x+1,y)-s(x,y)))^2 
e=e+1; 
A(e, im2var(y,x+1))=1; 
A(e, im2var(y,x))=-1; 
b(e) = s(y,x+1)-s(y,x); 
