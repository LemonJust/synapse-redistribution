function Img = getTiffInfo(imageFileName)
tiffInfo = imfinfo(imageFileName); %# Get the TIFF file information

Img.nFrame = numel(tiffInfo);    %# Get the number of z slices
Img.width = tiffInfo(1).Width;
Img.height = tiffInfo(1).Height;

end