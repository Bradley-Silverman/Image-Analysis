% Version 1.1.
% Updates: 
% Analyzes .czi files


clear
clc
close all
% Get list of czi files
filenames = dir('*.czi*');
% List .czi files in console
fprintf('Choose Image File\n')
for i = 1:length(filenames)
    fprintf('%d: %s\n',i,filenames(i).name);
end
% Get user to choose filename
while true
    in = input('Enter Number of Choice\n');
    if in<=length(filenames)
        break
    else
        fprintf('Invalid Input!\n Try Again\n');
    end
end
% Open .czi file and take a maximum z projection for ease in analysis
img = openCZIFile(filenames(in).name);
img = maxProjectZ(img);
% Call the analyzeFile subroutine
analyzeFile;
% Ask if the user wants to do another image, if so, call analyzeFile again
while true
in = input('Another field? 1 for yes');
if in==1
    filenames = dir('*.czi*');
    fprintf('Choose Image File\n')
    for i = 1:length(filenames)
        fprintf('%d: %s\n',i,filenames(i).name);
    end

    while true
        in = input('Enter Number of Choice\n');
        if in<=length(filenames)
            break
        else
            fprintf('Invalid Input!\n Try Again\n');
        end
    end
img = openCZIFile(filenames(in).name);
img = maxProjectZ(img);
% Call the analyzeFile subroutine
analyzeFile;

else
    break
end
end
% Ignore salt and pepper noise
A(A<2) = []
% Ask for the pixel scaling
in = input('Enter Pixel scaling (um/pixel)');
scalingFactor = in^2;
% Rescale the areas in terms of square microns
A = ceil(A*in);

% Tabulate the number of aggregates of each size
table = tabulate(A);
table = table(:,1:2);
% Weight these values appropriately and normalize
particleWeighted = table(:,1).*table(:,2);
normalized = particleWeighted./sum(particleWeighted);
% Remove zeros from the array
normalized(normalized==0) = [];
numParts = table(:,1);
numParts(table(:,2)==0) = [];
% Find the largest aggregate, and set size of bins accordingly (log_2)
maxNum = numParts(end);
lastPower = 2^(ceil(log(maxNum)/log(2)));
vec = [1];
% Make a vector of the bin edges (just the powers of two)
for i = 1:ceil(log(maxNum)/log(2))
    vec = [vec 2^i];
end
% Go through the list of areas, and place those in the appropariate bins
buckets = zeros(1,length(vec)-1);
for i = 1:length(normalized)
    for j = 1:length(vec)-1
        if numParts(i)>=vec(j) && numParts(i)<vec(j+1)
            buckets(j)= buckets(j)+normalized(i);
        end
    end
end
% Make a quick bar plot
bar(log(vec(1:end-1))/log(2),buckets,'stacked')
xlabel('Number of Particles')
ylabel('Weight weighted molecular weight distribution')
set(gca,'Xtick',0:(log(vec(end))/log(2))); %// adjust manually; values in log scale
set(gca,'Xticklabel',2.^get(gca,'Xtick')); %// use labels with linear values
% Save the data in a .mat file for later use
in = input('Enter Sample Name')
save(sprintf('%s',in))
titleStr = sprintf('%s based on %d observations',in,length(A));
title(titleStr)
