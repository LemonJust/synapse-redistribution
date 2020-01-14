function syn = removewrongside(syn,midplaneX)
% gets rid of the synapses on the wrong side of the midplane. Unchanged
% synapses are removed in pair even if one of them was on the right side. 

nStudies = length(syn.allBefore.xyz);
for iStudy = 1:nStudies
    
    synToKeep = isrightside(syn.lost.xyz_anat{iStudy},midplaneX);
    syn.lost.xyz_anat_mp{iStudy} = syn.lost.xyz_anat{iStudy}(synToKeep,:);
    syn.lost.intensity_mp{iStudy} = syn.lost.intensity{iStudy}(synToKeep);
    
    synToKeep = isrightside(syn.gained.xyz_anat{iStudy},midplaneX);
    syn.gained.xyz_anat_mp{iStudy} = syn.gained.xyz_anat{iStudy}(synToKeep,:);
    syn.gained.intensity_mp{iStudy} = syn.gained.intensity{iStudy}(synToKeep);
    
    % when deleting these - get rid of the pair
    synToKeepBefore = isrightside(syn.unchangedBefore.xyz_anat{iStudy},midplaneX);
    synToKeepAfter = isrightside(syn.unchangedAfter.xyz_anat{iStudy},midplaneX);
    synToKeep = logical(synToKeepBefore.*synToKeepAfter);
    
    syn.unchangedBefore.xyz_anat_mp{iStudy} = syn.unchangedBefore.xyz_anat{iStudy}(synToKeep,:);
    syn.unchangedBefore.intensity_mp{iStudy} = syn.unchangedBefore.intensity{iStudy}(synToKeep);
    
    syn.unchangedAfter.xyz_anat_mp{iStudy} = syn.unchangedAfter.xyz_anat{iStudy}(synToKeep,:);
    syn.unchangedAfter.intensity_mp{iStudy} = syn.unchangedAfter.intensity{iStudy}(synToKeep);
    
    
    syn.allBefore.xyz_anat_mp{iStudy} = [syn.lost.xyz_anat_mp{iStudy};syn.unchangedBefore.xyz_anat_mp{iStudy}];
    syn.allBefore.intensity_mp{iStudy} = [syn.lost.intensity_mp{iStudy};syn.unchangedBefore.intensity_mp{iStudy}];
    
    syn.allAfter.xyz_anat_mp{iStudy} = [syn.gained.xyz_anat_mp{iStudy};syn.unchangedAfter.xyz_anat_mp{iStudy}];
    syn.allAfter.intensity_mp{iStudy} = [syn.gained.intensity_mp{iStudy};syn.unchangedAfter.intensity_mp{iStudy}];
    
end
end

function synToKeep = isrightside(pointCloud,midplaneX)
synToKeep = pointCloud(:,1)>midplaneX;
end