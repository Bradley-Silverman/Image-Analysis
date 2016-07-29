function out = convertCZIToJPEG(filename)
img4D = openCZIFile(filename);
img3D = maxProjectZ(img4D);
newFilename = [filename(1:end-3) 'tiff'];
imwrite(img3D ,newFilename);