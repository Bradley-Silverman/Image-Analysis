function out = maxProjectZ(img)
% Function takes in a file [rows cols Z channels], and returns 3D [rows
% cols channels] representing the max z projection

% Extract the red and green layers
redLayers = img(:,:,:,1);
greenLayers = img(:,:,:,2);
% Take the maximum value across the 3rd dimension. This results in a
% reduction of dimensionality to 2D
redLayerMax = max(redLayers,[],3);
greenLayersMax = max(greenLayers,[],3);
blueLayerMax = zeros(size(redLayerMax));
% For now, take a null blue layer
out = cat(3,redLayerMax,greenLayersMax,blueLayerMax);
end