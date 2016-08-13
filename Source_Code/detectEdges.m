function edgeImage = detectEdges(imgMatrix, edgeKernal,threshold_value, thinning_value, median_value, displayImage, writeImage, writeName)
% @param imgMatrix     Image matrix to detect edges on.
% @param edgeKernal    NxN matrix used as gradient operator. 
% @param threshold     Value between 0 - 255 used after gradient operator.
% @param thinning      Value between 0 - inf, representing how 
% @param displayImage  Boolean flag, 1 to display images 0 to not.
% @param writeImage    Boolean flag, 1 to write images 0 to not.
%
% @result edgeImage    2D binary Matrix Represneting edges.

% Sobel Example : 
% detectEdges(imgIn.png,imgIdeal.png,[1 0 -1; 2 0 -2; 1 0 -1]*100,230,0.8,0) 

%Convert Image to Greyscale.
grayImage=rgb2gray(im2double(imgMatrix(:,:,1:3)));

%Invert Image - Sometimes Required Depending on input image.
grayImage = imcomplement(grayImage);

%Compute Image Size.
image_size = size(grayImage);
rows=image_size(1);
cols=image_size(2);

%Convolve kernal with image in both directions.
edgeImage_x=conv2(rot90(edgeKernal') ,grayImage);             
edgeImage_y=conv2(edgeKernal,grayImage);

%Cut down size of image (Due to extentions from kernal).
edgeImage_x = edgeImage_x(1+2:rows-2,1+2:cols-2);
edgeImage_y = edgeImage_y(1+2:rows-2,1+2:cols-2);

%Combine the two direcitonal gradient images.
edgeImage_x_y=(edgeImage_x.^2+edgeImage_y.^2).^(0.5);

%Threshold the reusltant gradient image.
edgeImage_x_y_BW = im2bw(edgeImage_x_y, threshold_value/255);

%Median Filter
edgeImage_x_y_BW=medfilt2(edgeImage_x_y_BW,[median_value median_value]);

%Carry out thinning on the threholded image.
edgeImage_x_y_BW_thinned=bwmorph(edgeImage_x_y_BW,'thin',thinning_value);

%Set to output return fucntion.
edgeImage=edgeImage_x_y_BW_thinned;

%Display Images
if(displayImage==1)
    imshow(edgeImage);
end

%Write Image
if(writeImage==1)
    imwrite(edgeImage, writeName);
end


end

