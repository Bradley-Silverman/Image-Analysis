clear
clc
close all
% Generate list of .czi files
filenames = dir('*.czi*');
fprintf('Choose Image File\n')
for i = 1:length(filenames)
    fprintf('%d: %s\n',i,filenames(i).name);
end
% Ask user to input the desired file
while true
    in = input('Enter Number of Choice\n');
    if in<=length(filenames)
        break
    else
        fprintf('Invalid Input!\n Try Again\n');
    end
end
% Open and do initial processing on file
filename = filenames(in).name;
img = openCZIFile(filename);
img = maxProjectZ(img);

% Apply a blur to the image
h = fspecial('disk', 5);
layer1 = uint16(filter2(h,img(:,:,1)));
layer2 = uint16(filter2(h,img(:,:,2)));
layer3 = uint16(filter2(h,img(:,:,3)));
newImg = cat(3,layer1,layer2,layer3);
redLayer = layer1(:);
greenLayer = layer2(:);
% Determine the threshold below which numbers are not counted
while true
    in = input('Enter Threshold Value\n');
    oldImg = newImg;
    maxValue = 2^16-1;
    % Get a mask for the image based on threshold, and show it
    mask = img(:,:,1)>=in | img(:,:,2)>=in | img(:,:,3)>=in;
    subplot(1,2,1)
    imshow(oldImg)
    subplot(1,2,2)
    imshow(mask)
    % Ask if this is a good threshold, otherwise retry
    in = input('Good Threshold?, 1 if yes');
    if in==1
        break
    else
        img = oldImg;
    end
end
figure
% Remove dark pixels
redLayer = redLayer(mask);
greenLayer = greenLayer(mask);
% Generate scatter plot
colormap jet
scatplot(double(redLayer),double(greenLayer),'voroni',10,10,5,3,7)

xlabel('Red Pixel Value')
ylabel('Green Pixel Value')
set(gca,'Color',[0 0 0])
% Determine Pearson correlation coefficent
 r = corr([double(redLayer),double(greenLayer)]);
 pearsonCorr = r(1,2);