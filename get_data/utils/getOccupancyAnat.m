function [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancyAnat(synapThreshold,lost,gained,unchangedBefore,...
    unchangedAfter,allBefore,allAfter)

% Get volumes with fish contributing to each voxel
% synapThreshold = 0;
nStudies = length(lost.xyz_anat);
for iStudy = 1:nStudies
    unchangedAfter.voxel_isFishInside_anat{iStudy} = unchangedAfter.voxel_synapNumber_anat{iStudy}>synapThreshold;
    unchangedBefore.voxel_isFishInside_anat{iStudy} = unchangedBefore.voxel_synapNumber_anat{iStudy}>synapThreshold;
    gained.voxel_isFishInside_anat{iStudy} = gained.voxel_synapNumber_anat{iStudy}>synapThreshold;
    lost.voxel_isFishInside_anat{iStudy} = lost.voxel_synapNumber_anat{iStudy}>synapThreshold;
    allAfter.voxel_isFishInside_anat{iStudy} = allAfter.voxel_synapNumber_anat{iStudy}>synapThreshold;
    allBefore.voxel_isFishInside_anat{iStudy} = allBefore.voxel_synapNumber_anat{iStudy}>synapThreshold;
end