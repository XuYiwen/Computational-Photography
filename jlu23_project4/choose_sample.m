function [x_index y_index] = choose_sample(cost,tol)

[imx imy] = size(cost);
rank = zeros(imx*imy,1);
for i=1:1:imx
    for j=1:1:imy
        rank((i-1)*imy+j,1) = cost(i,j);
    end
end
rank = sort(rank);
tol = rank(tol);
judge = cost < tol;
rand_max = sum(sum(judge));
myrand = ceil(rand()*rand_max);
count = 0;
for i=1:1:imx
    for j=1:1:imy
        if judge(i,j)
            count = count + 1;
            if count == myrand
                x_index = i;
                y_index = j;
            end
        end
    end
end

end


