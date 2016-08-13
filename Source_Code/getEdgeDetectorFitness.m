function [ fitness, process_t ] = getEdgeDetectorFitness(imageLocations, edgeKernal,threshold_value,thinning_value,median_value,noiseWeights,displayImage,writeImage)
% @param imageLocations Object holding direcotry locations of images.
% @param edgeKernal     NxN matrix used as gradient operator. 
% @param threshold      Value between 0 - 255 used after gradient operator.
% @param thinning       Value between 0 - inf, representing how 
% @param displayImage   Boolean flag, 1 to display images 0 to not.
% @param writeImage     Boolean flag, 1 to write images 0 to not.
%
% @result fitness       A fitness level between 0 and 1.

% Sobel Example : 
% getEdgeDetectorFitness('imgIn.png','imgIdeal.png',...
%                       [1 0 -1; 2 0 -2; 1 0 -1]*100,230,0.8,0,0) 

%Define Weightings.
correlation_W=0.5;
SAD_W=0.5;

%Initiliase fitness values to zero.
fitness_correlation=0;
fitness_SAD=0;

start_t = clock;
%Read image for edge detection and convert to greyscale.
edgeImage = detectEdges(imread(imageLocations.inImg), edgeKernal, threshold_value, ...
                        thinning_value, median_value,displayImage, writeImage, '');

end_t = clock;
process_t = (etime(end_t, start_t)*1000);

%Read ideal edge image.
edgeImage_ideal=imread(imageLocations.outImg);
im_size=size(edgeImage_ideal);

%Calculate Fitness by Correlation or SAD.
if(correlation_W>0)
    fitness_correlation = corr2(im2double(edgeImage),  ...
                          im2double(edgeImage_ideal))*noiseWeights(1);
end
if(SAD_W>0)
    fitness_SAD =  noiseWeights(1)*((1 - sum(sum(imabsdiff(edgeImage,edgeImage_ideal)))/(im_size(1)*im_size(2))));
end

for I = 1:length(imageLocations(1).inNoise)-1
    %Read image for edge detection and convert to greyscale.
    edgeImage = detectEdges(imread(char(imageLocations.inNoise(I+1))), edgeKernal, threshold_value, ...
                            thinning_value,median_value, displayImage, writeImage, '');
    if(correlation_W>0)
        fitness_correlation = fitness_correlation + corr2(im2double(edgeImage),  ...
                              im2double(edgeImage_ideal))*noiseWeights(I+1);
    end
    if(SAD_W>0)
        fitness_SAD = fitness_SAD + noiseWeights(I+1)*((1 - sum(sum(imabsdiff(edgeImage,edgeImage_ideal)))/(im_size(1)*im_size(2) )));
    end
end


fitness = (fitness_correlation*correlation_W+fitness_SAD*SAD_W)/sum(noiseWeights);


end

