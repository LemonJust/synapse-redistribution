function [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelDataAnat(voxelRange,xyz_anatMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter)

    % Calculate voxels occupansy
    % Voxel density calculation
    nStudies = length(lost.xyz_anat);
    % calculate # of synapses in volume, for each study
    for iStudy = 1:nStudies
        lost.voxel_synapNumber_anat{iStudy} = zeros(voxelRange);
        lost.voxel_intensitySum_anat{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(lost.xyz_anat{iStudy})
            iVoxel = floor(lost.xyz_anat{iStudy}(iSynapse,:)/xyz_anatMicronStep)  + 1;
            
            lost.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = lost.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            
            lost.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = lost.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + lost.intensity{iStudy}(iSynapse);
        end

        gained.voxel_synapNumber_anat{iStudy} = zeros(voxelRange);
        gained.voxel_intensitySum_anat{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(gained.xyz_anat{iStudy})
            iVoxel = floor(gained.xyz_anat{iStudy}(iSynapse,:)/xyz_anatMicronStep)  + 1;
            gained.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = gained.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            
            gained.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = gained.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + gained.intensity{iStudy}(iSynapse);
        end

        unchangedBefore.voxel_synapNumber_anat{iStudy} = zeros(voxelRange);
        unchangedBefore.voxel_intensitySum_anat{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(unchangedBefore.xyz_anat{iStudy})
            iVoxel = floor(unchangedBefore.xyz_anat{iStudy}(iSynapse,:)/xyz_anatMicronStep)  + 1;
            unchangedBefore.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedBefore.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            unchangedBefore.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedBefore.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + unchangedBefore.intensity{iStudy}(iSynapse);
        end
        
        unchangedAfter.voxel_synapNumber_anat{iStudy} = zeros(voxelRange);
        unchangedAfter.voxel_intensitySum_anat{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(unchangedAfter.xyz_anat{iStudy})
            iVoxel = floor(unchangedAfter.xyz_anat{iStudy}(iSynapse,:)/xyz_anatMicronStep)  + 1;
            unchangedAfter.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedAfter.voxel_synapNumber_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            unchangedAfter.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedAfter.voxel_intensitySum_anat{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + unchangedAfter.intensity{iStudy}(iSynapse);
        end

        allBefore.voxel_synapNumber_anat{iStudy} = lost.voxel_synapNumber_anat{iStudy}...
            + unchangedBefore.voxel_synapNumber_anat{iStudy};
        allBefore.voxel_intensitySum_anat{iStudy} = lost.voxel_intensitySum_anat{iStudy}...
            + unchangedBefore.voxel_intensitySum_anat{iStudy};
        
        allAfter.voxel_synapNumber_anat{iStudy} = gained.voxel_synapNumber_anat{iStudy}...
            + unchangedAfter.voxel_synapNumber_anat{iStudy};
        allAfter.voxel_intensitySum_anat{iStudy} = gained.voxel_intensitySum_anat{iStudy}...
            + unchangedAfter.voxel_intensitySum_anat{iStudy};

    end      
end