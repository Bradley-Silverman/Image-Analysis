clear
clc
close all
% Read in image and do a first pass to find aggregates
img4D = openCZIFile('02_rTagrCat aggregate gCat 30uL after centrifuge tween 3 z.czi');
imgMaxZ = maxProjectZ(img4D);
imshow(imgMaxZ);
redData = [];
greenData = [];
newImg = imgMaxZ;
img = imgMaxZ;
% Ask user to give a good threshld
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
% Find the large aggregates
L = bwlabel(imgMaxZ(:,:,1));
stats = regionprops(L);
goodStats = stats([stats.Area]>1000);

% Now we want to segment each aggregate separately in 3-space
% Find the z planes where we get decent fluorescence in the centroid.
for k = 1:length(goodStats);
centroid1 = round(goodStats(k).Centroid);
goodPlanes = [];
[r c z c] = size(img4D);

for i = 1:z
    if img4D(centroid1(2),centroid1(1),i,1)>=threshold || img4D(centroid1(2),centroid1(1),i,2)> threshold
        goodPlanes = [goodPlanes i];
    end
end

% Now max project this on only the relevant z planes
imgMaxZPartial = meanProjectZ(img4D(:,:,goodPlanes,:));
oldImg = imgMaxZPartial;
centroid1 = round(goodStats(k).Centroid);
thetas = linspace(0,2*pi,10);
    if oldImg(centroid1(2),centroid1(1),1)>threshold
        for j = 1:length(thetas)
        % Generate points that could potentially be in the aggregate
            maxR = 100;
            rs = 0:maxR;
            theta = thetas(j);
            xs = round(centroid1(1) + rs.*cos(theta));
            ys = round(centroid1(2) + rs.*sin(theta));
            % Find where aggregate ends
            for i = 1:length(xs)
                if oldImg(ys(i),xs(i),1) < threshold && oldImg(ys(i),xs(i),2)<threshold
                    break
                end
            end
            xs(i-2:end) = [];
            ys(i-2:end) = [];
            redProfile = zeros(1,length(xs));
            greenProfile = zeros(1,length(xs));
            for i = 1:length(xs)
                 redProfile(i) = oldImg(ys(i),xs(i),1);
                 greenProfile(i) = oldImg(ys(i),xs(i),2);


            end
            % Now scale:
            oldX = linspace(0,1,length(redProfile));
            newX= linspace(0,1,100);
            interpolatedRed = interp1(oldX,redProfile,newX);
            interpolatedGreen = interp1(oldX,greenProfile,newX);
            firstRed = interpolatedRed(1);
            interpolatedRed = interpolatedRed/interpolatedRed(1);
            interpolatedGreen = interpolatedGreen/interpolatedGreen(1);
            redData = [redData; interpolatedRed];
            greenData = [greenData;interpolatedGreen];
        end
    end    
end
figure
% Plot the line profile
hold on
plot(newX,mean(redData),'r');
plot(newX,mean(greenData)/max(mean(greenData)),'g');
legend({'Red Channel (core)','Green Channel (shell)'})
xlabel('Normalized Distance from Centroid');
ylabel('Normalized Fluorescence')