%% the ultimate plotting 
function plotPlain2Voxel(xyzMicronStep,midplaneX,gainedVol,gainedThr,lostVol,lostThr)

V{1} = gainedVol;
V{2} = lostVol;


color{1} = [1 1 0];
color{2} = [0 1 1];

thr(1) = floor(gainedThr);
thr(2) = floor(lostThr);

%% plot
    for iv = 1:2
        %% calculate stuff
        volume = V{iv}; % used to have floor here
        thresholdNumber = thr(iv);
        % make coordinate grid the size of the volume
        [X,Y,Z] = meshgrid(1:size(volume,1),1:size(volume,2),1:size(volume,3));
        xyz=[X(:) Y(:) Z(:)];
        permuted = permute(volume,[2 1 3]);
        voxelCenter = (xyz(permuted>thresholdNumber,:)-0.5)*xyzMicronStep;
        vertices = zeros(8,3);
        %% plot voxels
        nVoxel = length(voxelCenter(:,1));      
        for iVoxel = 1:nVoxel
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
                    'EdgeColor','none','Facecolor',color{iv},...
                    'FaceAlpha',0.3);
            end
        end
        hold on
    end
end

