classdef EdgeDetector < handle
    %EdgeDetector provides functions to modify genetic information of an
    %edge detecter instance.
    
    %   Class properties:
    %
    %       matrix - Edge detector matrix.
    %       threshold - Edge detector threshold value, 0-255.
    %       thinning - Edge detector thinning value, 0-Inf.
    %       gene - Current gene string.
    %       size - Current matrix size.
    %       fitness - Current matrix fitness value.
    %
    %   Class methods:
    %
    %       convertToGene - takes the current matrix, threshold and
    %                   thinning and converts this to a gene string.
    %
    %       convertFromGene - takes the current gene and uses this to
    %                   populate the matrix, threshold and thinning.
    %
    %       normaliseMatrix - takes the current matrix and normalises it.
    %                   Normalisation here ensures the sum of negative or
    %                   positive values never exceeds a magnitude of one.
    %
    %       getFitness - takes the current matrix and determines its
    %                   fitness. The fitness is stored in the class
    %                   property, ED.fitness.
    %                   @param images - Locations of images in memory. 
    %                   Allows choice of weight preferences.
    %
    %       getMutations - Carries out mutations of genes. Imposes limits
    %                   for genes which have maximum values. 
    %
    %       mutateNormGene - Carries out mutation of a chosen section of a
    %                   genetic string. This mutation is given a scale and
    %                   is limited to the range.
    %       
    
    properties
        matrix;
        threshold;
        thinning;
        median_value;
        gene;
        size;
        fitness;
        binary;
        processing;
        mutateGains;
    end
    
    methods
        function ED = EdgeDetector (gene)
            if nargin == 0;
                % Initialise if provided no values:
                % Scales chosen from experience of likely final values.
                ED.size = floor(abs(randn(1)*3)+3);
                if ED.size > 10
                    ED.size = 10;
                end
                ED.matrix = randn(ED.size)*0.3;
                ED.threshold = floor(rand(1)*256);
                ED.thinning = floor(rand(1));
                ED.median_value =floor(rand(1)*9)+1;
            else
                ED.gene = gene;
            end
        end
        
        function convertToGene(ED)
            ED.gene = [reshape(ED.matrix', 1, ED.size^2), ...
                        ED.threshold, ...
                        ED.thinning, ...
                        ED.size, ...
                        ED.median_value];
        end
        
        function geneToBinary(ED)
            n = 16; % number bits for integer part of number      
            m = 25; % number bits for fraction part of number
            for I=1:length(ED.gene)
                a = ED.gene(I);
                d2b(I,:) = fix(rem(a*pow2(-(n-1):m),2));
            end
            ED.binary = d2b;
        end
        
        function imposeGeneConstraints(ED)
            ED.gene(1,ED.size^2+3) = floor(ED.gene(1,ED.size^2+3));
            
            ED.gene(1,ED.size^2+4) = floor(ED.gene(1,ED.size^2+4));
            
            if ED.gene(1,ED.size^2+1) > 255
                ED.gene(1,ED.size^2+1) = 255;
            elseif ED.gene(1,ED.size^2+1) < 5
                ED.gene(1,ED.size^2+1) = 5;
            end
            if ED.gene(1,ED.size^2+2) < 0
                ED.gene(1,ED.size^2+2) = 0;
            end
            if ED.gene(1,ED.size^2+3) < 3
                ED.gene(1,ED.size^2+3) = 3+(3-ED.gene(1,ED.size^2+3));
            end
            if ED.gene(1,ED.size^2+3) > 10
                ED.gene(1,ED.size^2+3) = 10;
            end
            
            if ED.gene(1,ED.size^2+4) > 9
                ED.gene(1,ED.size^2+4) = 9;
            end     
            if ED.gene(1,ED.size^2+4) < 2
                ED.gene(1,ED.size^2+4) = 2;
            end                  
            
        end
        
        function binaryToGene(ED)
            n = 16; % number bits for integer part of number      
            m = 25; % number bits for fraction part of number
            for I=1:length(ED.gene)
                a = ED.gene(I);
                b2d(I) = ED.binary(I,:)*pow2(n-1:-1:-m).';
            end
            ED.gene = b2d;
            
            ED.imposeGeneConstraints();
        end
        
        function convertFromGene(ED)
            ED.size = sqrt(length(ED.gene)-4);
            ED.matrix = reshape(ED.gene(1:ED.size^2), ...
                        ED.size, ...
                        ED.size)';
            ED.threshold = ED.gene(ED.size^2+1);
            ED.thinning = ED.gene(ED.size^2+2);
            ED.median_value = ED.gene(ED.size^2+4);
            ED.size = ED.gene(ED.size^2+3);
            
        end
        
        function updateSize(ED)
            ED.makeSize(ED.size);
        end
        
        function makeSize(ED, newSize)
            currentSize = length(ED.matrix);
            ED.matrix = imresize(ED.matrix,newSize/currentSize,'triangle');
        end
        
        function normaliseMatrix(ED)
            totPos = sum(sum(dot(((sign(ED.matrix)+1)./2),ED.matrix, 3)));
            totNeg = sum(sum(dot(((sign(ED.matrix)-1)./2),ED.matrix, 3)));
            maxTot = max([totPos, totNeg]);
            
            ED.matrix=ED.matrix./maxTot;
            ED.convertToGene();
        end
        
        function getFitness(ED, images, noiseWeights)
            ED.normaliseMatrix();
            ED.fitness = 0;
            ED.processing = 0;
            
            for i = 1:length(images)
                [fit, proc] = getEdgeDetectorFitness(images(i), ...
                        ED.matrix, ED.threshold, ED.thinning, ...
                        ED.median_value,noiseWeights, 0, 0);
                ED.fitness = ED.fitness+fit*images(i).weighting;
                ED.processing = ED.processing+proc;
            end
            
            ED.fitness = ED.fitness; %+ 1/ED.processing;
            
            if isnan([ED.fitness])
                ED.fitness = 0;
            end
            
            ED.fitness = ED.fitness/sum([images.weighting]);
        end
        
        function getMutations(ED)
           
            ED.size = sqrt(length(ED.gene)-4);
            ED.mutateNormGene(1, ED.size^2, ED.mutateGains(1));
            ED.mutateNormGene(ED.size^2+1,ED.size^2+1,ED.mutateGains(2));
            ED.mutateNormGene(ED.size^2+2,ED.size^2+2,ED.mutateGains(3));
            ED.mutateNormGene(ED.size^2+3,ED.size^2+3,ED.mutateGains(4));
            ED.mutateNormGene(ED.size^2+4,ED.size^2+4,ED.mutateGains(5));
            
            ED.imposeGeneConstraints();
        end
        
        function mutateNormGene(ED, start, finish, scale)
            modSize = finish-start+1;
            addMutation = 0.1*randn(1,modSize)*scale;
            multMutation = 0.01*randn(1,modSize)*scale + ones(1,modSize);
            ED.gene(start:finish) = addMutation + dot(multMutation, ...
                        ED.gene(start:finish),1);
        end
        
    end
end
