function pyramids(img, N)
% img = im12;
% N =5
G_sigma = 2;
fil_G = fspecial('gaussian',7*G_sigma , G_sigma);

t_img = img;
figure(),
for i =1:N
    % Gaussian Pyramids
    g_img = imfilter(t_img,fil_G);
    subplot(2,N,N+i),imagesc(g_img),axis off, colormap gray, axis image, title(['N = ',num2str(i)]);
    % Laplacian Pyramids
    l_img = t_img - g_img;
    subplot(2,N,i),imagesc(l_img),axis off, colormap gray, axis image, title(['N = ',num2str(i)]);
    
    t_img = imresize(t_img,0.5);    
end