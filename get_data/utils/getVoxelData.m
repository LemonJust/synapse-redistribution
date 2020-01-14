function [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelData(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter)

    %% Calculate voxels occupansy
    % Voxel density calculation
    nStudies = length(lost.xyz);
    % calculate # of synapses in volume, for each study
    for iStudy = 1:nStudies
        lost.voxel_synapNumber{iStudy} = zeros(voxelRange);
        lost.voxel_intensitySum{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(lost.xyz{iStudy})
            iVoxel = floor(lost.xyz{iStudy}(iSynapse,:)/xyzMicronStep) + 1;
            lost.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = lost.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            
            lost.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = lost.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + lost.intensity{iStudy}(iSynapse);
        end

        gained.voxel_synapNumber{iStudy} = zeros(voxelRange);
        gained.voxel_intensitySum{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(gained.xyz{iStudy}) 
            % Here is where the error is happening
%             iStudy
%             iSynapse
            gained.xyz{iStudy}(iSynapse,:)
            iVoxel = floor(gained.xyz{iStudy}(iSynapse,:)/xyzMicronStep) + 1;
            
            
            gained.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = gained.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            
            gained.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = gained.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + gained.intensity{iStudy}(iSynapse);
        end

        unchangedBefore.voxel_synapNumber{iStudy} = zeros(voxelRange);
        unchangedBefore.voxel_intensitySum{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(unchangedBefore.xyz{iStudy})
            iVoxel = floor(unchangedBefore.xyz{iStudy}(iSynapse,:)/xyzMicronStep) + 1;
            unchangedBefore.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedBefore.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            unchangedBefore.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedBefore.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + unchangedBefore.intensity{iStudy}(iSynapse);
        end
        
        unchangedAfter.voxel_synapNumber{iStudy} = zeros(voxelRange);
        unchangedAfter.voxel_intensitySum{iStudy} = zeros(voxelRange);
        for iSynapse = 1:length(unchangedAfter.xyz{iStudy})
            iVoxel = floor(unchangedAfter.xyz{iStudy}(iSynapse,:)/xyzMicronStep) + 1;
            unchangedAfter.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedAfter.voxel_synapNumber{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3)) + 1;
            unchangedAfter.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),...
                iVoxel(3)) = unchangedAfter.voxel_intensitySum{iStudy}(iVoxel(1),iVoxel(2),iVoxel(3))...
                + unchangedAfter.intensity{iStudy}(iSynapse);
        end

        allBefore.voxel_synapNumber{iStudy} = lost.voxel_synapNumber{iStudy}...
            + unchangedBefore.voxel_synapNumber{iStudy};
        allBefore.voxel_intensitySum{iStudy} = lost.voxel_intensitySum{iStudy}...
            + unchangedBefore.voxel_intensitySum{iStudy};
        
        allAfter.voxel_synapNumber{iStudy} = gained.voxel_synapNumber{iStudy}...
            + unchangedAfter.voxel_synapNumber{iStudy};
        allAfter.voxel_intensitySum{iStudy} = gained.voxel_intensitySum{iStudy}...
            + unchangedAfter.voxel_intensitySum{iStudy};

    end      
end