function [stu,syn] = getSynapticDataNewCohort(xyzMicronStep)
% xyzMicronStep is voxel size in microns: 10 micron^3 = 10*10*10 micron

addpath('D:\Code\TR01\SynapticStats\Utils');
addpath('D:\Code\TR01\Utils');
addpath('C:\Users\nadtochi\Documents\MATLAB\DataDensity');
%% load data

% Path = ['D:\TR01\1640Cohort\1640-YEY.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_0pt85Thresh.csv'];
% Path = ['D:\TR01\1640Cohort\1640-YEY-naive-contrast-25.csv'];
% Path = ['D:\TR01\1640Cohort\1640-YEY-naive-all.csv'];
% Path = ['D:\TR01\1640Cohort\1640-YEY-human-intersected.csv'];
% Path = ['D:\TR01\1640Cohort\1640-YEY-human-intersected-mk3.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_thr0p6_rgInt.csv']; % THIS IS BAD !!!
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_thr0p6_BeforeAlignmentChange.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_0p85Thr_BeforeAlignmentChange.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_0p99Thr_BeforeAlignmentChange_4umRadius.csv'];
% Path = ['D:\TR01\1640Cohort\1BZW-YEY_0p85Thr_rgInt_3D_BeforeAlignmentChange_4umRadius.csv'];
% Path = ['D:\TR01\1640Cohort\1640-YEY-4umRadius_AfterQC.csv'];
% Path = ['C:\Users\nadtochi\Dropbox\2019_LearningPaper\',...
%     'Cohort_data\1DCP-YEY_Full_4umRadius.csv'];
% Path = ['C:\Users\nadtochi\Dropbox\2019_LearningPaper\Cohort_data\',...
%     '1DCP-YEY_Full_4umRadius_AFewNewAlignmentMatrices.csv'];

Path = ['C:\Users\nadtochi\Dropbox\2019_LearningPaper\Cohort_data\',...
    '1-1EWW-YEY_4umRadius_FullCohort.csv'];

PathKey = 'C:\Users\nadtochi\Dropbox\2019_LearningPaper\Cohort_data\1DCP_CohortKey.xlsx';
table = readtable(Path);

%% Which studiesn Learners/Nonlearners etc
% get indices in the table corresponding to different fish
studyName = strtrim(unique(table.subject));
nStudies = length(studyName);
%%
stu = getHowSmartIdV2(PathKey,studyName);

%% Which synapses (lost/gained/unchanged) for each study
[unchangedId,lostId,gainedId] = getStudiesV2(table,studyName);

%% Separate studies (fish)
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = getxyz(table,...
    nStudies,lostId,gainedId,unchangedId);

%% Nearest Neighbor
% [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
%     allAfter] = getNN(nStudies,lost,gained,unchangedBefore,...
%     unchangedAfter,allBefore,allAfter);
%% Voxels
% Get image info
imageFile = 'D:\TR01\Synapses\ImgZfDsy20180223D3_bin221.tif';
resolution = [0.52 0.52 0.4];
Img = getTiffInfo(imageFile);
% Voxelize to image
xyzMicronRange = [Img.width Img.height Img.nFrame].*resolution;

voxelRange = floor(xyzMicronRange/xyzMicronStep)+1;

% Here is where the error was happening
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelData(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);
%%  apply midplane transform
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = ...
    getxyzAnat(lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter);
%% voxel data anat
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getVoxelDataAnat(voxelRange,xyzMicronStep,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);

%% Nearest Neighbor anat
% [lost,gained,unchangedBefore,unchangedAfter,allBefore,...
%     allAfter] = getNNAnat(nStudies,lost,gained,unchangedBefore,...
%     unchangedAfter,allBefore,allAfter);
%% get n fish in each volume
[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancy(0,lost,gained,...
    unchangedBefore,unchangedAfter,allBefore,allAfter);

[lost,gained,unchangedBefore,unchangedAfter,allBefore,...
    allAfter] = getOccupancyAnat(0,lost,gained,unchangedBefore,...
    unchangedAfter,allBefore,allAfter);


syn.lost = lost;
syn.gained = gained;
syn.unchangedBefore = unchangedBefore;
syn.unchangedAfter = unchangedAfter;
syn.allBefore = allBefore;
syn.allAfter = allAfter;

%% Show midplane, get rid of the points on the other side of the midplane
% Midplane YZ *************************************************
res = [0.52 0.52 0.4];
midplanePoints = readtable('D:\TR01\RealData_All\Template\planeYZ.csv');
midplaneX = midplanePoints.X(1)*res(1);
% syn = cutOutWrongMpSide(syn,midplaneX);
syn = removewrongside(syn,midplaneX);

end