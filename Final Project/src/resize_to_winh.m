function resized_input = resize_to_winh(input,window)
    [inh,inw,~] = size(input);
    outh = window.h;
    outw = (outh/inh) * inw;

    resized_input = imresize(input,[outh,outw]);
end