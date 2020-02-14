function [stu,syn] = getSynapticDataNewCohort(xyzMicronStep)
% xyzMicronStep is voxel size in microns: 10 micron^3 = 10*10*10 micron

addpath('utils');

%% load data
% syn coordinates and studies
Path = ['C:\Users\nadtochi\Dropbox\2019_LearningPaper\Cohort_data\',...
    '1-1EWW-YEY_4umRadius_FullCohort.csv'];

% table that tell which study is a Learners/Nonlearners/CStim/NStim/UStim
PathKey = 'C:\Users\nadtochi\Dropbox\2019_LearningPaper\Cohort_data\1DCP_CohortKey.xlsx';
table = readtable(Path);

%% sort studies into Learners/Nonlearners/CStim/NStim/UStim

studyName = strtrim(unique(table.subject));
nStudies = length(studyName);

stu = getHowSmartIdV2(PathKey,studyName);

%% get indices of lost/gained/unchanged synapses for each study 
[unchangedId,lostId,gainedId] = getStudiesV2(table,studyName);

%% get xyz coordinates for all the synapses in the Standart Fish Space
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = getxyz(table,...
    nStudies,lostId,gainedId,unchangedId);

%% get Voxel information in Standart Fish Space
% Get image info to know how to break the space into voxels
imageFile = 'D:\TR01\Synapses\ImgZfDsy20180223D3_bin221.tif';
resolution = [0.52 0.52 0.4];
Img = getTiffInfo(imageFile);
% Voxelize to image
xyzMicronRange = [Img.width Img.height Img.nFrame].*resolution;
voxelRange = floor(xyzMicronRange/xyzMicronStep)+1;

[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelData(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);
%% get xyz coordinates for all the synapses in the Dorsal space 
% apply midplane transform : 
% dorsalize by setting midplane of the fish to be Oyz
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = ...
    getxyzAnat(lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter);
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
res = [0.52 0.52 0.4];
midplanePoints = readtable('D:\TR01\RealData_All\Template\planeYZ.csv');
midplaneX = midplanePoints.X(1)*res(1);

syn = removewrongside(syn,midplaneX);

end