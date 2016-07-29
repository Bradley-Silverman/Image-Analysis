function out = meanProjectZ(img)
% Function takes in a file [rows cols Z channels], and returns 3D [rows
% cols channels] representing the mean z projection

redLayers = img(:,:,:,1);
greenLayers = img(:,:,:,2);

redLayerMax = mean(redLayers,3);
greenLayersMax = mean(greenLayers,3);
blueLayerMax = zeros(size(redLayerMax));
% For now, take a null blue layer
out = cat(3,redLayerMax,greenLayersMax,blueLayerMax);
end