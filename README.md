# Genetic Algorithm Edge Detector

Signal processing project to implement a genetic algorithm approach to realizing edge detection matrices for noisy images. More about genetic algorihms can be found at https://en.wikipedia.org/wiki/Genetic_algorithm. Information about edge detection can be found at https://en.wikipedia.org/wiki/Edge_detection.

## User Interface

The MATLAB code provides a GUI interface to tweak convergence parameters as shown below.

<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/UserInterface.png" width="720">

## Training Images

The code uses a series of predfined training images in the "Source_Code/img/" directory. A few of these trainging pairs are as follows:

<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/img1In.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/Img1OutIdeal.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/img2In.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/Img2OutIdeal.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/img3In.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/Img3OutIdeal.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/img4In.png" width="180">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/img/Img4OutIdeal.png" width="180">

## Results

While some results converged on well known edge detection matrices, in more noisey scenarios, unique matrices of arbitarty size have been found to produce robust edge detection images like the following:

<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/Source_Code/BF3_StagingArea_GDC.jpg" width="360">
<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/bestResult1.621.png" width="360">

## Genetic Algorithm Structure

The following diagram illustrates how each matlab function is used to mutate one edge detector into another. 

<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/gene_structure_1.png" width="720">

The following diagram illsutrates how the pool of candidate edge detectors evolve with each iteration. 

<img src="https://github.com/mkokshoorn/Genetic_Algorithm_Edge_Detector/blob/master/mutation_structure_1.png" width="720">
