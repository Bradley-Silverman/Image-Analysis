function [out metadata] = openCZIFile(filename)

% Version 3.1, can deal with either single z or single color stacks 
% Additionally returns .czi metadata

% This file takes in a filename, and using the openOME toolbox reorganizes
% it to a 4D array [x y z C] For example a 1024x1024x10 z stacks x 2
% channels would be [1024 1024 10 2]

% Open file using the OME toolbox
data = bfopen(filename);
% Extract cell array of image stacks (Z/C)
metadata = data{4};
data = data{1};

% Now parse strings of labels: Format is ...Z=x/N;C=y/N...
string = data{1,2};
% Find location in string of Z
x = strfind(string,'Z=');
% Find location in string of C
y = strfind(string,'C=');
% Trigger this condition if there are multiple C and Z stacks
if ~isempty(x)&& ~isempty(y)
    % Parse strings between slash and semicolon to get the denominators
    substring = string(x:end);
    semiInd = strfind(substring,';');
    slashInd = strfind(substring,'/');
    numZs = str2num(substring(slashInd(1)+1:semiInd-1));
    numCs = str2num(substring(slashInd(2)+1:end));
    % Get the first layer to determine the x and y dimesions
    firstLayer = data{1};
    [rows cols] = size(firstLayer);
    % Initialize the final data struction, a 4D uint16 structure
    out = uint16(zeros(rows,cols,numZs,numCs));
    k= 1
    % Loop through stacks, putting them in the final data structure
    for i = 1:numZs
        for j = 1:numCs
            %data{k,2}
            out(:,:,i,j) = data{k,1};
            k=k+1;
        end
    end
% Trigger this if there is only 1 z stack, but multiple colors
elseif ~isempty(y)
    % Find the number of channels
    slashInd = strfind(string,'/');
    numCs = str2num(string(slashInd(end)+1:end));
    % Add the stacks to the final data structure
    for i = 1:numCs
        out(:,:,i) = data{i,1};
    end
        out(:,:,3) = 0;
% Trigger this if there are multiple z stacks and only one channel
else
    % Get the number of z stacks
    slashInd = strfind(string,'/');
    numZs = str2num(string(slashInd(end)+1:end));
    % Add data to the final data structure
    for i = 1:numZs
        out(:,:,i,1) = data{i,1};
        out(:,:,i,2) = 0;
        out(:,:,i,3) = 0;
    end
end

end
