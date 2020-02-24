% This code produces the final alignment for the 1DCP cohort 

%% Make sure you have all the transforms
clear all
addpath('D:\Code\TR01\Utils');
%% load cohort table
tableKey = readtable('D:\TR01\1DCP_CohortKey.xlsx');

%% calculate how many R2G transforms we already have, how many are missing
% load('D:\Code\TR01\Data\G2R.mat');
load('D:\Code\TR01\Data\R2G.mat')
%%
nTransforms = howManyTransforms(tableKey,R2G)

%% how many 3 Points do we have
jPath = 'D:\Code\TR01\Data\ImagesInfo_cohort1DCP.json';
fishInfo = jsondecode(fileread(jPath));
%%
nPoints = howManyPoints(tableKey,fishInfo)

%% how many midplanes do we have

midplanes = dir('D:\TR01\1DCPCohort\midplanes');
nMplanes = howManyMidplanes(tableKey,midplanes)

%% how many red images do we have

redImg = dir('D:\TR01\1640Cohort\RedBin_Images');
nReds = howManyImages(tableKey,redImg)

%% Segment midplanes
% helps manually segment and keep track of what you've done

% iMp = iMp + 1;
% midplaneDone(iMp) = 0;
% midplaneDone
% tableKey.ID{iMp + 1}

% IMAGE J PLUGIN:
% FishID = "ImgZf"+"Dsy20190531A"+"3_Red_bin221";
% open("D:/TR01/1640Cohort/RedBin_Images/"+FishID+".nii");
%
% waitForUser("Select midplane");
%
% run("Measure");
% saveAs("Results", "D:/TR01/1DCPCohort/midplanes/"+FishID+"_midplane.csv");
% close();


%% Get the ones that are ready for getting the transforms
isReady = (nMplanes==1&nPoints==2&nTransforms>=1)
nFish = 1:length(tableKey.ID);
fishReady = nFish(isReady);
missingMP = nFish(~nMplanes);
fishHaveRed = nFish(nReds>=1);
% be careful the template midplane is all in pixels, not physUnits!
templateMidplaneFile = 'D:\Code\TR01\Data\Midplanes\Template_ImgZfDsy20180223B3_bin221.csv';

%% Get transforms for the ones that are ready

for iFish = fishReady(50:51)
    tic
    fishID = [tableKey.ID{iFish},'3'];
    
    r2gTrfm = getTransformR2G(fishID,R2G);
    
    ThreePoints = register3Points(fishID,[]);
    
    resImg = getResolution(fishID,[]).*[2 2 1];
    MidplaneAlignment = midplane_registrationV2(getMpFile(iFish,tableKey),[1 1 resImg(3)],...
        r2gTrfm*ThreePoints,templateMidplaneFile,[0.52 0.52 0.4],1);
    
    if (mod(iFish,5)==0)&&(nReds(iFish)>=1)
        movImage = ['D:\TR01\1640Cohort\RedBin_Images\',...
            'ImgZf',fishID,'_Red_bin221.nii'];
        Output = ['D:\TR01\1DCPCohort\RedBin_Images_toTem\',...
            'ImgZf',fishID,'_Red_toTem.tif'];
        transformImage(r2gTrfm*ThreePoints*MidplaneAlignment,movImage,resImg,Output,[],[])
    end
    if iFish==fishReady(1)
        TRF = createAndAddTrf(fishID,r2gTrfm,ThreePoints,MidplaneAlignment);
    else
        TRF = addTrf(TRF,fishID,r2gTrfm,ThreePoints,MidplaneAlignment);     
    end
    toc
      
end

%% Get transforms for the ones that ARE MISSING MIDPLANE 
MidplaneAlignment = eye(4);

for iFish = missingMP(2:4)
    
    tic
    fishID = [tableKey.ID{iFish},'3'];
    
    r2gTrfm = getTransformR2G(fishID,R2G);
    
    ThreePoints = register3Points(fishID,[]);
    
    resImg = getResolution(fishID,[]).*[2 2 1];

    movImage = ['D:\TR01\1640Cohort\RedBin_Images\',...
        'ImgZf',fishID,'_Red_bin221.nii'];
    Output = ['D:\TR01\1DCPCohort\RedBin_Images_toTem\',...
        'ImgZf',fishID,'_Red_toTem.tif'];
    transformImage(r2gTrfm*ThreePoints*MidplaneAlignment,movImage,resImg,Output,[],[])
    
    if ~exist('TRF','var')
        TRF = createAndAddTrf(fishID,r2gTrfm,ThreePoints,MidplaneAlignment);
    else
        TRF = addTrf(TRF,fishID,r2gTrfm,ThreePoints,MidplaneAlignment);
    end
    toc
    
end

%% write down transform into xls
xlFile = 'D:\TR01\1DCPCohort\transforms_1DCPCohort_V2.xls';
for iFish = 1:length(fishReady)
fishID = {TRF(iFish).ID};
myString = {transformToText(TRF(iFish).transforms(5).matrix)};

xlRange = ['A',num2str(iFish),':A',num2str(iFish)];
xlswrite(xlFile,fishID,xlRange)
xlRange = ['B',num2str(iFish),':B',num2str(iFish)];
xlswrite(xlFile,myString,xlRange)
end
%% write down transforms into xls NO MIDPLANE 
xlFile = 'D:\TR01\1DCPCohort\transforms_1DCPCohort_NoMidplane.xls';
for iFish = 1:3
fishID = {TRF(iFish).ID};
myString = {transformToText(TRF(iFish).transforms(5).matrix)};

xlRange = ['A',num2str(iFish),':A',num2str(iFish)];
xlswrite(xlFile,fishID,xlRange)
xlRange = ['B',num2str(iFish),':B',num2str(iFish)];
xlswrite(xlFile,myString,xlRange)
end
%%
notDoneFish = tableKey.ID(isReady==0);
for iF = 1:7
xlRange = ['A',num2str(iF+47),':A',num2str(iF+47)];
xlswrite(xlFile,notDoneFish(iF),xlRange)
end


%% HELPER FUNCTIONS

function myString = transformToText(Minv)
    myString = (['[[',num2str(Minv(1,1)),',',num2str(Minv(1,2)),',',num2str(Minv(1,3)),',',num2str(Minv(1,4)),'],'...
         '[',num2str(Minv(2,1)),',',num2str(Minv(2,2)),',',num2str(Minv(2,3)),',',num2str(Minv(2,4)),'],'...
         '[',num2str(Minv(3,1)),',',num2str(Minv(3,2)),',',num2str(Minv(3,3)),',',num2str(Minv(3,4)),'],'...
        '[',num2str(Minv(4,1)),',',num2str(Minv(4,2)),',',num2str(Minv(4,3)),',',num2str(Minv(4,4)),']]']);
end

function TRF = createAndAddTrf(fishID,r2gTrfm,ThreePoints,MidplaneAlignment)
TRF = struct('ID',{fishID},'transforms',...
    {struct('info',{'red to green'},'matrix',{r2gTrfm})});

TRF.transforms(end+1) = struct('info',{'three points (from green to Template, not YZ)'},...
    'matrix',{ThreePoints});

TRF.transforms(end+1) = struct('info',{'midplane alignment, using midplane points after r2g and three points'},...
    'matrix',{MidplaneAlignment});

TRF.transforms(end+1) = struct('info',{'total red to tem transform: r2g*ThreePoints*MidplaneAlignment'},...
    'matrix',{r2gTrfm*ThreePoints*MidplaneAlignment});

TRF.transforms(end+1) = struct('info',{'total green to tem transform: ThreePoints*MidplaneAlignment'},...
    'matrix',{ThreePoints*MidplaneAlignment});
end

function TRF = addTrf(TRF,fishID,r2gTrfm,ThreePoints,MidplaneAlignment)
iTrf = length(TRF)+1;
TRF(iTrf) = struct('ID',{fishID},'transforms',...
    {struct('info',{'red to green'},'matrix',{r2gTrfm})});
% 
% TRF(end+1).transforms(end+1) = struct('info',{'red to green'},...
%     'matrix',{r2gTrfm});

TRF(iTrf).transforms(end+1) = struct('info',{'three points (from green to Template, not YZ)'},...
    'matrix',{ThreePoints});

TRF(iTrf).transforms(end+1) = struct('info',{'midplane alignment, using midplane points after r2g and three points'},...
    'matrix',{MidplaneAlignment});

TRF(iTrf).transforms(end+1) = struct('info',{'total red to tem transform: r2g*ThreePoints*MidplaneAlignment'},...
    'matrix',{r2gTrfm*ThreePoints*MidplaneAlignment});

TRF(iTrf).transforms(end+1) = struct('info',{'total green to tem transform: ThreePoints*MidplaneAlignment'},...
    'matrix',{ThreePoints*MidplaneAlignment});
end

function r2gTrfm = getTransformR2G(fishID,R2G)
for iTrfm = 2:length(R2G)
    if string(fishID)==string(R2G(iTrfm).ID(6:18))
        r2gTrfm = R2G(iTrfm).transforms(2).matrix;
        r2gTrfm(:,4) = [0 0 0 1];
    end
end
end

function movingMidplaneFile = getMpFile(iFish,tableKey)
fishID = tableKey.ID{iFish};
movingMidplaneFile = ['D:\TR01\1DCPCohort\midplanes\ImgZf',fishID,'3_Red_bin221_midplane.csv'];
end

function transformImage(theTransform,movImage,resImg,Output,fixedImage,resFixed)

templateFile = 'D:\TR01\RealData_All\Template\TEMPLATE_ImgZfDsy20180223B3_1_MMStack_Pos0_bin221.tif';
resTem = [0.52 0.52 0.4];
if isempty(fixedImage)
    fixedImage = templateFile;
    resFixed = resTem;
end

apply_transform(movImage,resImg,fixedImage,resFixed,...
    theTransform,Output);

end


function nTransforms = howManyTransforms(tableKey,G2R)
nTransforms = zeros(length(tableKey.ID),1);
for iFish = 1:length(tableKey.ID)
    for iTrfm = 2:length(G2R)
        if string(tableKey.ID{iFish})==string(G2R(iTrfm).ID(6:17))
            nTransforms(iFish) = nTransforms(iFish)+1;
        end
    end
end
disp(['Total Fish: ',num2str(length(tableKey.ID))]);
disp(['Fish with 2 transforms: ',num2str(sum(nTransforms==2)),', 1 transform: ',...
    num2str(sum(nTransforms==1))]);
disp('Fish with 0 transforms: ');
if sum(nTransforms==0)>0
tableKey.ID{nTransforms==0}
end
end

function nPoints = howManyPoints(tableKey,fishInfo)
id = {fishInfo(:).ID};
nPoints = zeros(length(tableKey.ID),1);
for iFish = 1:length(tableKey.ID)
    %     nPoints(iFish) = sum(contains(id,tableKey.ID{iFish},'IgnoreCase',true));
    fishN  = find(contains(id,tableKey.ID{iFish},'IgnoreCase',true));
    if ~isempty(fishN)
        for iP = 1:length(fishN)
            P0 = fishInfo(fishN(1)).AlignP0ZYX;
            if ~isempty(P0)
                nPoints(iFish) = nPoints(iFish)+1;
            end
        end
    end
end

disp(['Total Fish: ',num2str(length(tableKey.ID))]);
disp(['Fish with 2 points: ',num2str(sum(nPoints==2)),', 1 points: ',...
    num2str(sum(nPoints==1))]);
disp('Fish with 0 points: ');
if sum(nPoints==0)>0
tableKey.ID{nPoints==0}
end
end

function nMplanes = howManyMidplanes(tableKey,midplanes)

mp = {midplanes(:).name};

nMplanes = zeros(length(tableKey.ID),1);
for iFish = 1:length(tableKey.ID)
    nMplanes(iFish) = sum(contains(mp,tableKey.ID{iFish},'IgnoreCase',true));
end

disp(['Total Fish: ',num2str(length(tableKey.ID))]);
disp(['Fish with segmented midplane : ',num2str(sum(nMplanes==1)),...
    ' , missing midplane : ',num2str(sum(nMplanes==0))]);
disp('Fish with a missing midplane: ');
if sum(nMplanes==0)>0
tableKey.ID{nMplanes==0}
end
end

function nReds = howManyImages(tableKey,redImg)
ri = {redImg(:).name};

nReds = zeros(length(tableKey.ID),1);
for iFish = 1:length(tableKey.ID)
    nReds(iFish) = sum(contains(ri,tableKey.ID{iFish},'IgnoreCase',true));
end

disp(['Total Fish: ',num2str(length(tableKey.ID))]);
disp(['Fish with red image : ',num2str(sum(nReds==1)),...
    ' , missing red image : ',num2str(sum(nReds==0))]);
disp('Fish with a missing red image: ');
tableKey.ID{nReds==0}


end









































































