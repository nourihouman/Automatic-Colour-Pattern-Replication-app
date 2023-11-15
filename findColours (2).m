% function gets image file as an input and returns an array of colours in
% form of matrix
function colour_result = findColours(filename)
    
    disp(filename)
    image=loadImage(filename);
    circleCord= findcircles(image);
    undistortImage = correctImage(image,circleCord);
    colour_result = getColors(undistortImage);
