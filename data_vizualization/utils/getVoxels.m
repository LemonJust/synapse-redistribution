function stat = getVoxels(MicronStep,xyz,data)
% Sums provoded data into voxels, based on corresponding positions in xyz
% MicronStep : box size in microns ( makes boxes MicronStep-MicronStep-MicronStep)
% xyz : coordinates in 3D in microns
% data : what to sum up

% voxelRange (x,y,z) - image to overlay over in microns 
imageFile = 'D:\TR01\Synapses\ImgZfDsy20180223D3_bin221.tif';
resolution = [0.52 0.52 0.4];
Img = getTiffInfo(imageFile);
% Voxelize to image
xyzMicronRange = [Img.width Img.height Img.nFrame].*resolution;
voxelRange = floor(xyzMicronRange/MicronStep)+1;

stat.xyz = xyz;
stat.data = data;

stat.voxel_xyz_cnt = zeros(voxelRange);
stat.voxel_data_sum = zeros(voxelRange);

for iSynapse = 1:length(stat.xyz)
    % which voxel does it belong
    iVoxel = floor(stat.xyz(iSynapse,:)/MicronStep)  + 1;
    % increase number of synapses in that voxel
    stat.voxel_xyz_cnt(iVoxel(1),iVoxel(2),...
        iVoxel(3)) = stat.voxel_xyz_cnt(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
    % add intensity to that voxel
    stat.voxel_data_sum(iVoxel(1),iVoxel(2),...
        iVoxel(3)) = stat.voxel_data_sum(iVoxel(1),iVoxel(2),iVoxel(3))...
        + stat.data(iSynapse);
end

end