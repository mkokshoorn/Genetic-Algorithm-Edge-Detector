function conditionIdealEdgeImage(imageLocations, threshold_value)
% @param imageLocations Object holding direcotry locations of images.
% @param  threshold_value      ____


%Read ideal output image and convert to greyscale
rawImage_ideal=imread(imageLocations.outImgIdeal);
grayImage_ideal=rgb2gray(im2double(rawImage_ideal(:,:,1:3)));              

%calcualte image sizes.
image_size = size(grayImage_ideal);  
rows=image_size(1);
cols=image_size(2);

%Threholding.
grayImage_ideal_BW = im2bw(grayImage_ideal, threshold_value/255);

%Resize Image.
grayImage_ideal_BW = grayImage_ideal_BW(2:rows-3,2:cols-3);

%Write image.
imwrite(grayImage_ideal_BW, imageLocations.outImg);
end
