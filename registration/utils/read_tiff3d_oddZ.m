function Img = read_tiff3d_oddZ(ProcessFile,PixelRegion,scaleXY)
%%
%read_tiff3d(ProcessFile,flipZ,PixelRegion,scaleXY)
%Format for PixelRegion : [y1,y2;x1,x2]
%PixelRegion and scaleXY can be left empty ( [] ) if you don't need them

tiffInfo = imfinfo(ProcessFile); %# Get the TIFF file information
Img.nFrame = numel(tiffInfo);    %# Get the number of z slices
Img.width = tiffInfo(1).Width;
Img.height = tiffInfo(1).Height;
if isempty(PixelRegion)
    PixelRegion = [1,Img.height;1,Img.width];
else
    Img.width = PixelRegion(2,2)-PixelRegion(2,1)+1;
    Img.height = PixelRegion(1,2)-PixelRegion(1,1)+1;
    Img.img = zeros(Img.height,Img.width);
    
end

z = 0;
for i_frame = 1:2:Img.nFrame
    z = z + 1;
    Img.img(:,:,z) = imread(ProcessFile,...
        'Index',i_frame,'Info',tiffInfo,'PixelRegion',...
        {[PixelRegion(1,1),PixelRegion(1,2)],...
        [PixelRegion(2,1),PixelRegion(2,2)]});
end

if ~isempty(scaleXY)
    Img.img = imresize(Img.img,scaleXY);
    [Img.height,Img.width,~] = size(Img.img);
end
end