function [stu,syn] = getCohortData(in)
%% get input
cohort_path = in.cohort_path;
cohort_key = in.key_path;
image_file = in.image_file;
image_res = in.image_res;
xyzMicronStep = in.voxel_side;
template_midplane = in.template_midplane;
yzplane_points = in.yzplane_points;
template_midplane_res = in.template_midplane_res;
yzplane_res = in.yzplane_res;
%% read cohort
table = readtable(cohort_path);
%% sort studies into Learners/Nonlearners/CStim/NStim/UStim
unique_id = strtrim(unique(table.study_id));
nStudies = length(unique_id);

stu = getHowSmartIdV2(cohort_key,unique_id);

%% get indices of lost/gained/unchanged synapses for each study 
[unchangedId,lostId,gainedId] = getStudiesV2(table,unique_id);

%% get xyz coordinates for all the synapses in the Standart Fish Space
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = getxyz(table,...
    nStudies,lostId,gainedId,unchangedId);

%%
Img = getTiffInfo(image_file);
% Voxelize to image
xyzMicronRange = [Img.width Img.height Img.nFrame].*image_res;
voxelRange = floor(xyzMicronRange/xyzMicronStep)+1;

[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelData(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);
%% get xyz coordinates for all the synapses in the Dorsal space 
% apply midplane transform : 
% dorsalize by setting midplane of the fish to be Oyz
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = ...
    getxyzAnat(lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter,...
    template_midplane,yzplane_points,...
    template_midplane_res,yzplane_res);
%% get Voxel information in the Dorsal space 
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelDataAnat(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);

%% get number of fish in each voxel (occupancy)
% calculates how many different FISH contribute their synapses to 
% a particular voxel 

% in the Standart Fish Space
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancy(0,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);
% in the Dorsal space 
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancyAnat(0,lost,gained,unchangedBefore,...
    unchangedAfter,allBefore,allAfter);

%% form a structure 
syn.lost = lost;
syn.gained = gained;
syn.unchangedBefore = unchangedBefore;
syn.unchangedAfter = unchangedAfter;
syn.allBefore = allBefore;
syn.allAfter = allAfter;

%% remove synapses on the other side of the midplane 
% plane YZ coordinates 
midplanePoints = readtable(in.yzplane_points);
midplaneX = midplanePoints.X(1)*in.yzplane_res(1);
syn = removewrongside(syn,midplaneX);

end