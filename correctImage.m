function [correctedImage]=correctImage(image, circleCord)
% set coordinates of an image as reference 
img = loadImage('org_1.png');
% find current image circles coordinates
orgCord = findcircles(img);
% align the images
tform=fitgeotrans(circleCord,orgCord,'affine');
correctedImage = imwarp(image,tform);
end



