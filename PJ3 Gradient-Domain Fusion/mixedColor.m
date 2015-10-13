function mix = mixedColor(pi,pj)
gma(1) = 2.5; 
gma(2) = 2.5;
gma(3) = 2.5;
color1 = (pi(1).^gma(1))+(pi(2).^gma(2))+(pi(3).^gma(3));
color2 = (pj(1).^gma(1))+(pj(2).^gma(2))+(pj(3).^gma(3));

mix = color1-color2;
