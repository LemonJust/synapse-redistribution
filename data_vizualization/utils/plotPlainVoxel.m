function plotPlainVoxel(xyzMicronStep,midplaneX,Vol,thr,color,transparency,edgColor)
% if transparency is -1, then does a heatmap by transparancy
%% plot
if isempty(edgColor)
    edgColor = 'none';
end
%% calculate stuff

if length(size(Vol))==3
volume = floor(Vol);
% make coordinate grid the size of the volume
[X,Y,Z] = meshgrid(1:size(volume,1),1:size(volume,2),1:size(volume,3));
xyz=[X(:) Y(:) Z(:)];
permuted = permute(volume,[2 1 3]);
% need maxVol for normalisation
maxVol = max(permuted,[],'all');
voxelCenter = (xyz(permuted>thr,:)-0.5)*xyzMicronStep;

elseif length(size(Vol))==2
    voxelCenter = Vol;
    
else
    disp('Error: length(size(Vol)) should be 2 or 3');
end

vertices = zeros(8,3);
%% plot voxels
nVoxel = length(voxelCenter(:,1));
for iVoxel = 1:nVoxel
    % trancparency based on value or set
    if transparency == -1
        alpha = permuted(iVoxel)/maxVol;
    else
        alpha = transparency;
    end
    
    if(voxelCenter(iVoxel,1)>midplaneX)
        k = 0;
        for ix = [-1,1]*0.5
            for iy = [-1,1]*0.5
                for iz = [-1,1]*0.5
                    k = k + 1;
                    vertices(k,:) = voxelCenter(iVoxel,:)+...
                        [ix*xyzMicronStep,iy*xyzMicronStep,iz*xyzMicronStep];
                end
            end
        end
        voxelSurf = boundary(vertices);
        hold on
        % Anna, listen..it's bad coding : use patch instead !!!
        % Best, Anna
        trisurf(voxelSurf,vertices(:,1),vertices(:,2),vertices(:,3),...
            'EdgeColor',edgColor,'Facecolor',color,...
            'FaceAlpha',alpha);
    end
end
hold on
end


