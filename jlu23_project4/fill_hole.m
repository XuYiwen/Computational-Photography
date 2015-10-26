function [result] = fill_hole(image, image_mask, patchsize, tol)

[imx imy imz] = size(image);
image_gray = rgb2gray(image);
confidence = image_mask(:,:,1);
patchsize = 2 * floor(patchsize/2) + 1;
while sum(sum(sum(image_mask))) ~= imx * imy * imz
    image_mask_extend = image_mask;
    image_mask_shrink = image_mask;
    for i=1:1:imx
        for j=1:1:imy
            if (image_mask(i,j,1) == 1)
                if i>1
                    image_mask_extend(i-1,j,:) = 1;
                end
                if j>1
                    image_mask_extend(i,j-1,:) = 1;
                end
                if i<imx
                    image_mask_extend(i+1,j,:) = 1;
                end
                if j<imy
                    image_mask_extend(i,j+1,:) = 1;
                end
                if i>1&&j>1
                    image_mask_extend(i-1,j-1,:) = 1;
                end
                if i>1&&j<imy
                    image_mask_extend(i-1,j+1,:) = 1;
                end
                if i<imx&&j>1
                    image_mask_extend(i+1,j-1,:) = 1;
                end
                if i<imx&&j<imy
                    image_mask_extend(i+1,j+1,:) = 1;
                end
            end
            if (image_mask(i,j,1) == 0)
                if i>1
                    image_mask_shrink(i-1,j,:) = 0;
                end
                if j>1
                    image_mask_shrink(i,j-1,:) = 0;
                end
                if i<imx
                    image_mask_shrink(i+1,j,:) = 0;
                end
                if j<imy
                    image_mask_shrink(i,j+1,:) = 0;
                end
                if i>1&&j>1
                    image_mask_shrink(i-1,j-1,:) = 0;
                end
                if i>1&&j<imy
                    image_mask_shrink(i-1,j+1,:) = 0;
                end
                if i<imx&&j>1
                    image_mask_shrink(i+1,j-1,:) = 0;
                end
                if i<imx&&j<imy
                    image_mask_shrink(i+1,j+1,:) = 0;
                end
            end
        end
    end
    edge_mask = (1-image_mask(:,:,1)).*image_mask_extend(:,:,1);
    x_filter = [-1 0 1];
    y_filter = [-1; 0; 1];
    pre_gradient_x = imfilter(image_gray, x_filter);
    pre_gradient_y = imfilter(image_gray, y_filter);
    pre_gradient = sqrt(pre_gradient_x.^2+pre_gradient_y.^2) .* image_mask_shrink(:,:,1);
    normal_x = zeros(imx, imy);
    normal_y = zeros(imx, imy);
    gradient_x = zeros(imx, imy);
    gradient_y = zeros(imx, imy);
    for i=1:1:imx
        for j=1:1:imy
            if (edge_mask(i,j) == 1)
                count_pos = 0;
                count_neg = 0;
                for ii=i-(patchsize-1)/2:1:i+(patchsize-1)/2
                    for jj=j-(patchsize-1)/2:1:j+(patchsize-1)/2
                        if (image_mask(ii,jj,1)==1)
                            count_pos = count_pos + 1;
                            mean_pos(count_pos,1) = ii;
                            mean_pos(count_pos,2) = jj;
                        else
                            count_neg = count_neg + 1;
                            mean_neg(count_neg,1) = ii;
                            mean_neg(count_neg,2) = jj;
                        end
                    end
                end
                pos = mean(mean_pos);
                neg = mean(mean_neg);
                normal_x(i,j) = neg(1)-pos(1) / norm(neg-pos);
                normal_y(i,j) = neg(2)-pos(2) / norm(neg-pos);
                if isnan(normal_x(i,j)) || isnan(normal_y(i,j))
                    normal_x(i,j) = 0;
                    normal_y(i,j) = 0;
                end
                [xx,yy] = find(pre_gradient(i-(patchsize-1)/2:i+(patchsize-1)/2,j-(patchsize-1)/2:j+(patchsize-1)/2)==max(max(pre_gradient(i-(patchsize-1)/2:i+(patchsize-1)/2,j-(patchsize-1)/2:j+(patchsize-1)/2))));
                xx=xx(1);
                yy=yy(1);
                gradient_x(i,j) = pre_gradient_x(xx+i-(patchsize-1)/2-1,yy+j-(patchsize-1)/2-1);
                gradient_y(i,j) = pre_gradient_y(xx+i-(patchsize-1)/2-1,yy+j-(patchsize-1)/2-1);
            end
        end
    end
    filter = ones(patchsize,patchsize);
    neighor_confidence = imfilter(confidence,filter)/(patchsize*patchsize);
    neighor_confidence = neighor_confidence.*edge_mask;
    prob = abs(normal_x.*gradient_x+normal_y.*gradient_y).*neighor_confidence;
    [x_index y_index] = find(prob==max(max(prob)));
    max_confidence = neighor_confidence(x_index, y_index);
    x_index = x_index(1);
    y_index = y_index(1);
    neighor_mask = image_mask(x_index-(patchsize-1)/2:x_index+(patchsize-1)/2, y_index-(patchsize-1)/2:y_index+(patchsize-1)/2, 1);
    neighor_mask_full = image_mask(x_index-(patchsize-1)/2:x_index+(patchsize-1)/2, y_index-(patchsize-1)/2:y_index+(patchsize-1)/2, :);
    neighor_image = image(x_index-(patchsize-1)/2:x_index+(patchsize-1)/2, y_index-(patchsize-1)/2:y_index+(patchsize-1)/2, :);
    cost = zeros(imx-patchsize, imy-patchsize);
    for i=1:1:imx-patchsize
        for j=1:1:imy-patchsize
            if sum(sum(image_mask(i:i+patchsize-1,j:j+patchsize-1,1))) < patchsize * patchsize
                cost(i,j) = Inf;
            else
                index(1) = i;
                index(2) = j;
                cost(i,j) = ssd_patch(image, neighor_image, neighor_mask, index);
            end
        end
    end
    [x_chose y_chose] = choose_sample(cost,tol);
    image(x_index-(patchsize-1)/2:x_index+(patchsize-1)/2, y_index-(patchsize-1)/2:y_index+(patchsize-1)/2, :) = neighor_image.*neighor_mask_full + image(x_chose:x_chose+patchsize-1, y_chose:y_chose+patchsize-1,:).*(image_mask(x_chose:x_chose+patchsize-1, y_chose:y_chose+patchsize-1,:)-neighor_mask_full);
    image_mask(x_index-(patchsize-1)/2:x_index+(patchsize-1)/2, y_index-(patchsize-1)/2:y_index+(patchsize-1)/2, :) = image_mask(x_chose:x_chose+patchsize-1, y_chose:y_chose+patchsize-1,:);
    for i=x_index-(patchsize-1)/2:1:x_index+(patchsize-1)/2
        for j=y_index-(patchsize-1)/2:1:y_index+(patchsize-1)/2
            confidence(i,j)=max(confidence(i,j),max_confidence);
        end
    end
end
result = image .* image_mask;

end
