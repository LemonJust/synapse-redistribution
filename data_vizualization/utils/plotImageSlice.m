function plotImageSlice(Img,res,direction,slice)
% plots an image slice in XY , at z position (in microns)

%% Image settings
alp = 0.9;
thr = 0;
multiplier = 10000;
gamma = 0.7;

switch direction
    case "xy"
        %% position
        z = slice;
        zSlice = floor(z/res(3)); % z comes in um
        xRange = floor([1:Img.width]);
        yRange = floor([1:Img.height]);
        %% plot
        maxInt = double(max(Img.img(:)));
        minInt = double(min(Img.img(:)))/maxInt;
        I = double(Img.img(yRange,xRange,zSlice));
        if ~isempty(gamma)
            I = I/maxInt;
            I = imadjust(I,[minInt 1],[0 1],gamma);
        end
        I(I<thr) = nan;
        I = I*multiplier;
        [Y,X] = meshgrid((xRange(1) + (1:size(I,2))-1),(yRange(1) + (1:size(I,1))-1));
        Z = ones(size(I))*zSlice*res(3);
        surf((Y-0.5)*res(2),(X-0.5)*res(1),Z,I,'EdgeColor','none');
    case "xz"
        %% position
        y = slice;
        ySlice = floor(y/res(1)); % in um
        zRange = floor([1:Img.nFrame]);
        xRange = floor([1:Img.width]);
        %% plot
        maxInt = double(max(Img.img(:)));
        minInt = double(min(Img.img(:)))/maxInt;
        I = double(squeeze(Img.img(ySlice,xRange,zRange)));
        if ~isempty(gamma)
            I = I/maxInt;
            I = imadjust(I,[minInt 1],[0 1],gamma);
        end
        I(I<thr) = nan;
        % to try keep the contrast the same
        I(1,1) = 0;
        I(1,2) = 1;
        
        I = I*multiplier;
        [X,Z] = meshgrid((xRange(1) + (1:size(I,1))),(zRange(1) + (1:size(I,2))));
        Y = (ones(size(I))*ySlice -0.5)*res(1);
        surf((X-0.5)*res(1), Y', (Z-0.5)*res(3), I','EdgeColor','none');
        otherwise 
            error('Error. \nDirection should be "xy" or "xz", not a %s',direction);
end

alpha(alp);
colormap(gray)
daspect([1 1 1])
xlabel('X')
ylabel('Y')
zlabel('Z')

end