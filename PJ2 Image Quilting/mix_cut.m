function mix = mix_cut(temp,addin,cut_mask)
    old_remain = cut_mask;
    new_addin = ~cut_mask;
    for i=1:3
        old(:,:,i) = temp(:,:,i).*old_remain;
        new(:,:,i) = addin(:,:,i).*new_addin;
        mix(:,:,i) = old(:,:,i)+new(:,:,i);
    end
    % test
    figure(1),imshow(~cut_mask);
    figure(2),imshow(old);
    figure(3),imshow(new);
    figure(4),imshow(mix);
end