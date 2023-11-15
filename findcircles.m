% function gets the double image and returns coordinates of circles
function[circleCoordinates]=findcircles(image)
    % convert RGB into Gray space
    I = im2gray(image);
    % morphological operation
    im1=imdilate(I,ones(1));
    im2=imerode(im1,ones(15)); 
    % binarize the image
    bw = imbinarize(im2,0.1);
    % manually set paramaters for finding circle
    radiusRange=[16,40];
    sensitivity=0.78;
    edgeThreshold = 0.1;
    [centers,~]=  imfindcircles(bw,radiusRange,'ObjectPolarity','dark','sensitivity',sensitivity,'edgeThreshold',edgeThreshold,'Method', 'TwoStage');    
    % sort the coordinates of circles 
    centers = sortrows(centers,1);
    x = centers(1:2,:);
    x = sortrows(x,2);
    y = centers(3:4,:);
    y = sortrows(y,2);
    centers(1:2,:) = x;
    centers(3:4,:) = y;
    circleCoordinates=centers;
end
 


