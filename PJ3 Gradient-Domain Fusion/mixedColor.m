function mix = mixedColor(pi,pj)
% pi = reshape(pi,1,3);
% pj = reshape(pj,1,3);
% grad = pi-pj;
gma = 0.5; 
color1 = (pi(1).^gma)+(pi(2).^gma)+(pi(3).^gma);
% color1 = color1/3;
color2 = (pj(1).^gma)+(pj(2).^gma)+(pj(3).^gma);
% color2 = color2/3;
mix = color1-color2;
% color_df = grad;

% [~, ind] = max(abs(color_df));
% mix = grad(ind);

