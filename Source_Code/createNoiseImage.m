function createNoiseImage(imageLocations, noiseArray, noise_type)
% @param imageLocations Object holding direcotry locations of images.
% @param  threshold_value      ____

%Get number of images to generate.
numImages = length(noiseArray);

%Read ideal output image and convert to greyscale.
cleanImg=imread(imageLocations.inImg);

%Generate and write Noise Images.
for I=1:numImages
    noiseImg=imnoise(cleanImg, noise_type, noiseArray(I));
    imwrite(noiseImg, char(imageLocations.inNoise(I+1,:)));
end 
end
