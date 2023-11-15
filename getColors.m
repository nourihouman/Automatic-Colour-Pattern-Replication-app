function [colours] =  getColors(image)
     
    %convert RGB to gray space
    grayimg=rgb2gray(image);

    % morphological operation
    mask = imbinarize(grayimg,0.1);
    se = strel('square',1);
    a1 = imdilate(mask, se);
    % Detect shapes, compute circularity 
    stats = regionprops(~a1,{'Circularity','SubarrayIdx'});

    circleThreshold = 0.90; % circularity values greater than this are cirlces 
    % Copy the colored image twice; eliminate circles and squares
    separatedcircles = image; 
    separatesquares = image; 
    for i = 1:numel(stats)
        circularity = stats(i).Circularity; 
        if circularity <= circleThreshold
            % remove object if it's not a circle
            separatedcircles(stats(i).SubarrayIdx{1}, stats(i).SubarrayIdx{2},:) = uint8(255); 
        elseif circularity > circleThreshold
            % remove object if it's a circle
            separatesquares(stats(i).SubarrayIdx{1}, stats(i).SubarrayIdx{2},:) = uint8(255); 
        end
    end
    


    % applying operation on a new rgb image which does not have any circles
    grayimg1 = rgb2gray(separatesquares);
    binary = imbinarize(grayimg1,0.1);
    se1 = strel('square',1);
    a2 = imdilate(binary, se1);
    

    stats =regionprops('table',a2,'BoundingBox','Perimeter');
        
    %just keep rows with below condition in the table
    idx = stats.Perimeter < 500 & stats.Perimeter>100;
    stats(~idx,:) =[];
    
    % defining a new box in each row based on sorted coordiates
    new_boundingbox = stats.BoundingBox;
    col_1 = new_boundingbox (1:4,:);
    col_1= sortrows(col_1 ,2);

    col_2 = new_boundingbox (5:8,:);
    col_2  = sortrows(col_2 ,2);
    
    col_3 = new_boundingbox (9:12,:);
    col_3 = sortrows(col_3,2);
 
    col_4 = new_boundingbox (13:16,:);
    col_4 = sortrows(col_4, 2);
    
    stats.BoundingBox(1:4,:) = col_1;
    stats.BoundingBox(5:8,:)= col_2;
    stats.BoundingBox(9:12,:) = col_3;
    stats.BoundingBox(13:16,:) = col_4;


    
    %hold on
    %for kk = 1: 16
     %   rectangle('Position', stats.BoundingBox(kk,:) ,EdgeColor='g',LineStyle='--');
    %end

    centroids = cat(1,stats.BoundingBox);
    red_thresh = 0.4;
    green_thresh = 0.5;
    blue_thresh = 0.6;
    

    colors={'','','','';
            '','','','';
            '','','','';
            '','','',''};
    
    for i = 1:16
        x = round(centroids(i,1));
        y = round(centroids(i,2));
        width = round(centroids(i,3));
        height = round(centroids(i,4));
    
        % Define the bounding box coordinates
        boxCoords = [x, y, width, height];
  

        % Crop the region of interest
        boxImg = imcrop(separatesquares,boxCoords);
    
        % Calculate the average RGB color value for the region of interest
        avg_red = mean(mean(boxImg(:,:,1)));
        avg_green = mean(mean(boxImg(:,:,2)));
        avg_blue = mean(mean(boxImg(:,:,3)));

         if  avg_red > red_thresh && avg_green > green_thresh && avg_blue > blue_thresh
            colors{i} = 'white';
        elseif avg_red< red_thresh && avg_green >green_thresh && avg_blue < blue_thresh
            colors{i} = 'green';
        elseif avg_red < red_thresh && avg_green < green_thresh && avg_blue > blue_thresh
            colors{i} = 'blue';
        elseif avg_red > red_thresh && avg_green < green_thresh && avg_blue > blue_thresh
            colors{i} = 'blue';
        elseif  avg_red > red_thresh && avg_green < green_thresh && avg_blue < blue_thresh
            colors{i} = 'red';
        elseif avg_red > red_thresh && avg_green > green_thresh && avg_blue < blue_thresh 
            colors{i} = 'yellow';
        else
            colors{i} = 'unknown';
        end                               
    end
% Print the estimated colors
colours = colors;
end