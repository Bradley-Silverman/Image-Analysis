
This repository contains code used for image analysis in Obana, Maiko; Silverman, Bradley; Tirrell, David. Insert Journal Here (2016)

All code was written and tested in Matlab 2015a, but likely works in more recent/less recent versions as well. All images for testing were taken with an LSM 800 confocal microscope from Zeiss, but differences between microscopes should be minor.

Installation Instructions:
In order to run programs .m files should be placed in the current folder and run from the command window. Functions in the "Utility_Functions" folder should be added to the Matlab path.
All functions will prompt for inputs from the command line.
In addition, the BioFormats toolbox for Matlab (https://www.openmicroscopy.org/site/support/bio-formats5.1/users/matlab/) should be downloaded and added to the current path.

Program Descriptions:
analyzeParticleAggregateSizes.m
Program takes in a .czi file (or with modifications any image format) displaying a fluorescent image (with one or more channels and/or z-stacks).
Program will prompt for filename, and pixel value for thresholding value.
Program returns:
buckets: a vector of heights for a histogram of aggregate sizes. Each bar will represent (in order) the height of a bar for aggregates of size 2^n (i.e. 1,2,4,8,16...um^2)
firstQuarter: The size of the aggregates of the first quartile (um^2)
thirdQuarter: The size of the aggregates of the third quartile (um^2)
median: The size of the median aggregate (um^2)
PDI: The polydispersity of the distribution
Program creates:
A basic histogram displaying the data from buckets

analyzeFile.m
Utility script that does thresholding and labeling of fluorescent images for analyzeParticleAggregateSizes.m

analyzeColocalization.m
Program takes in a .czi file displaying a fluorscent image with two channels, and one or more z-stacks.
Program will prompt for filename and threshold value.
Program returns:
pearsonCorr: The Pearson's correlation coefficient between the two channels.
Program creates:
Colocalization plot

Core_Shell_Line_Analysis
makeLineProfilePartial3D.m: 
Program takes in a .czi file displaying a fluorescent image with two channels and several z-stacks
Program prompts for filename and threshold
Program creates:
Line plot showing intensities of the two channels as a function of normalized distance from the centroid.

meanProjectZ.m:
Program performs a mean-projection over the z-stacks. Input is a 4D array of the form [rows, cols, zStacks, channels].
Outputs 3D array [rows, cols, channels], where the pixels are averaged over the z-dimension.

openCZIFile.m
Wrapper function for opening up .czi files using the Bioformats toolbox. 
Program returns:
4D array containing the image data from the .czi file. Array is of size [rows, cols, ZStacks, channels]. If there is only one z-stack, it will instead return a 3D array [rows, cols, channels]
Metadata object: For details see documentation for BioFormats

maxProjectZ.m
Returns a maximum z-projection for use in visualizing images and cluster size analysis.
Input is a 4D array of the form [rows, cols, zStacks, channels].
Outputs 3D array [rows, cols channels], where the pixels are maximixzed over the z-dimension.

convertCZIToTIFF.m
Utility function, converts a .czi file to a .TIFF file for vizualization, with the only modification being a maximum z-projection.

formatImage.m
Utility function, converts a .czi file to a .TIFF file with the following modifications:
1. For accessilibity to red/green color blind individuals, red pixels are changed to magenta (by copying the red channel into the blue channel)
2. A maximum z-projection is performed
3. A scale bar with length (in microns) given in the second input to the function is burned into the image.

