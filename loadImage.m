% function loads the image and converts it into double
function image = loadImage(filename)
    % load an image
    image=imread(filename);
    %segment the image into RGB canal
    red_canal = image(:, :, 1);
    green_canal = image(:, :, 2);
    blue_canal = image(:, :, 3);
    % apply a filter to each canal
    red_filter = medfilt2(red_canal, [3 3]);
    green_filter = medfilt2(green_canal, [3 3]);
    blue_filter = medfilt2(blue_canal, [3 3]);
    % concatenate the canals
    filtered = cat(3, red_filter, green_filter, blue_filter);

    %change image type into double
    if isa(filtered,"uint8")
        image= double(filtered) / 255;
       
    else
        error('wrong')
    end

    end