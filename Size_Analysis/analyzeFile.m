% Get user to choose threshold value. For .czi files, this is generally
% O(10^4)
while true
    in = input('Enter Threshold Value\n');
    oldImg = img;
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
    
% Label contiguous blobs and extract relevant parameters 
L = bwlabel(mask);
stats = regionprops(L);
% If this isn't the first image in this set, add the areas to the list of
% areas, otherwise start a new list
if exist('A')
A = [A stats.Area];
else
A = [stats.Area];
end