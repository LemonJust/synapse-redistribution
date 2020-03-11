function [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancy(synapThreshold,lost,gained,unchangedBefore,...
    unchangedAfter,allBefore,allAfter)

% Get volumes with fish contributing to each voxel
% synapThreshold = 0;
nStudies = length(lost.xyz);
for iStudy = 1:nStudies
    unchangedAfter.voxel_isFishInside{iStudy} = unchangedAfter.voxel_synapNumber{iStudy}>synapThreshold;
    unchangedBefore.voxel_isFishInside{iStudy} = unchangedBefore.voxel_synapNumber{iStudy}>synapThreshold;
    gained.voxel_isFishInside{iStudy} = gained.voxel_synapNumber{iStudy}>synapThreshold;
    lost.voxel_isFishInside{iStudy} = lost.voxel_synapNumber{iStudy}>synapThreshold;
    allAfter.voxel_isFishInside{iStudy} = allAfter.voxel_synapNumber{iStudy}>synapThreshold;
    allBefore.voxel_isFishInside{iStudy} = allBefore.voxel_synapNumber{iStudy}>synapThreshold;
end