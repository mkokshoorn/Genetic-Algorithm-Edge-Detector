function breedEdgeDetectors( mother, father )
%breedEdgeDetectors Summary of this function goes here
%   Detailed explanation goes here

mother.geneToBinary;
% Father size conversion
tempED = EdgeDetector;
tempED.size = mother.size;
tempED.gene = father.gene;
tempED.matrix = father.matrix;
tempED.updateSize();
tempED.convertToGene;
tempED.geneToBinary;

arraySize = size(mother.binary);
outArray = zeros(arraySize(1), arraySize(2));
randArray = rand(arraySize(1), arraySize(2));
for I = 1:arraySize(1)
    for II = 1:arraySize(2)
        if randArray(I,II) > 0.5
            outArray(I,II) = tempED.binary(I,II);
        else
            outArray(I,II) = mother.binary(I,II);
        end
    end
end

mother.binary=outArray;
mother.binaryToGene;

end

