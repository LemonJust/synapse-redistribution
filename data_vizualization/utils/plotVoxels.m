function c = plotVoxels(volume,pointCloud,xyzMicronStep,thresholdNumber,colorCase,plotCenter)
%% This is temporary! 
midplaneX = 267;
disp(['midplaneX : ',num2str(midplaneX)]);
%%
% Input example:
%
%  thresholdNumber = 1;
%  volume = getnFishInVoxel(lost.fishInside,Nonlearners)/2;
%  plotCenter = 0;
%  colorCase = 1;
%
if ~isempty(pointCloud)
    plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'.','Color',[0 0 0],'MarkerSize',4);
    hold on
end
if isempty(thresholdNumber)
    thresholdNumber = min(volume(:));
end

thresholdNumber = floor(thresholdNumber)

volume = floor(volume);
% make coordinate grid the size of voxel volume
[X,Y,Z] = meshgrid(1:size(volume,1),1:size(volume,2),1:size(volume,3));
% move to xyz format
xyz=[X(:) Y(:) Z(:)];

% show points which are not free and where group values are used as color (scaled by to current colormap)
permuted = permute(volume,[2 1 3]);
voxelCenter = (xyz(permuted>thresholdNumber,:)-0.5)*xyzMicronStep;
% substract to get value in the the numberRange
voxelNumber = permuted(permuted>thresholdNumber)-thresholdNumber;

if plotCenter == 1
    scatter3(voxelCenter(:,1),voxelCenter(:,2),voxelCenter(:,3),...
        50*xyzMicronStep,voxelNumber,'s','filled');
    alpha(0.5);
    hold on
end

synapseNumberMax = max(volume(:));
numberRange = synapseNumberMax-thresholdNumber;
if colorCase == 1
    colorMap = autumn(numberRange); %parula
end
if colorCase == 2
    colorMap = winter(numberRange);
end
if colorCase == 3
    colorMap = winter(numberRange);
end

alphaMap = (1/(numberRange)):(1/(numberRange)):1; % adjust alpha for better showing

vertices = zeros(8,3);
for iVoxel = 1:length(voxelCenter(:,1))
    k = 0;
    if(voxelCenter(iVoxel,1)>midplaneX)
        for ix = [-1,1]*0.5
            for iy = [-1,1]*0.5
                for iz = [-1,1]*0.5
                    k = k + 1;
                    vertices(k,:) = voxelCenter(iVoxel,:)+[ix*xyzMicronStep,iy*xyzMicronStep,iz*xyzMicronStep];
                end
            end
        end
        if colorCase == 2
            vertices = vertices - [0.05 0.05 0.05]*xyzMicronStep;
        end
        voxelSurf = boundary(vertices);
        hold on
        % Bad coding : use patch instead !!!
        
        trisurf(voxelSurf,vertices(:,1),vertices(:,2),vertices(:,3),...
            'EdgeColor','none','Facecolor',colorMap(voxelNumber(iVoxel),:),...
            'FaceAlpha',alphaMap(voxelNumber(iVoxel)));
    end
end
colormap(gca,colorMap)
[thresholdNumber+1 synapseNumberMax];
caxis([thresholdNumber+1 synapseNumberMax]);
c = colorbar; %('Ticks',thresholdNumber+1:synapseNumberMax,...
%'TickLabels',strsplit(num2str(thresholdNumber+1:synapseNumberMax)))

%% axes
xlabel('X, um');
ylabel('Y, um');
zlabel('Z, um');
%% set aspect ratio
xl = xlim;
yl = ylim;
zl = zlim;
pbaspect([(xl(2)-xl(1)) (yl(2)-yl(1)) (zl(2)-zl(1))]);
end