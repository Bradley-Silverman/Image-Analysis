function formatImage(filename,lengthScaleBar)
% This function takes in a .czi file and outputs a .tiff file with scale
% bar and red channel switched to magenta
% Open file do a maximum z projection
[img metadata] = openCZIFile(filename);
img = maxProjectZ(img);

% Replace the red channel with magenta
 img(:,:,3) = img(:,:,1);

% Now make a scale bar
% Extract scaling from metadata
xScaling = double(metadata.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROM));
numPixels = round(lengthScaleBar./xScaling);

[rows cols junk] = size(img);

rightSide = cols-80;
leftSide = cols-80-numPixels;
bottom = rows-40;
top = rows-55;
img(top:bottom,leftSide:rightSide,:) = max(max(max(img)));
newfilename = [filename(1:end-3) 'tiff'];
imwrite(img,newfilename);
imshow(img)
text(leftSide,top-30,'100 \mum','fontSize',16,'Color',[1 1 1],'fontWeight','bold')

