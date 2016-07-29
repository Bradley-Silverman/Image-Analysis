
This repository contains code used for image analysis in Obana, Maiko; Silverman, Bradley; Tirrell, David. Insert Journal Here (2016)

All code was written and tested in Matlab 2015a, but likely works in more recent/less recent versions as well. 

Installation Instructions:
In order to run programs .m files should be placed in the current folder and run from the command window. Functions in the "Utility_Functions" folder should be added to the Matlab path.
All functions will prompt for inputs from the command line.
In addition, the BioFormats toolbox for Matlab (https://www.openmicroscopy.org/site/support/bio-formats5.1/users/matlab/) should be downloaded and added to the current path.

Program Descriptions:
analyzeParticleAggregateSizes
Program takes in a .czi file (or with modifications any image format) displaying a fluorescent image (with one or more channels and/or z-stacks).
Program will prompt for filename, threshold value, and pixel scaling.
Program returns:
buckets: a vector of heights for a histogram of aggregate sizes. Each bar will represent (in order) the height of a bar for aggregates of size 2^n (i.e. 1,2,4,8,16...um^2)
firstQuarter: The size of the aggregates of the first quartile (um^2)
thirdQuarter: The size of the aggregates of the third quartile (um^2)
median: The size of the median aggregate (um^2)
PDI: The polydispersity of the distribution
Program creates:
A basic histogram displaying the data from buckets

analyzeColocalization
Program takes in a .czi file displaying a fluorscent image with two channels, and one or more z-stacks.
Program will prompt for filename and threshold value.
Program returns:
pearsonCorr: The Pearson's correlation coefficient between the two channels.
Program creates:
Colocalization plot

Core_Shell_Line_Analysis
makeLineProfilePartial3D: 
Program takes in a .czi file displaying a fluorescent image with two channels and several z-stacks
Program prompts for filename and threshold
Program creates:
Line plot showing intensities of the two channels as a function of normalized distance from the centroid.
