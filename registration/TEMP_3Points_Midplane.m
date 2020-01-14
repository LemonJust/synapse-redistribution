clear all
addpath('D:\Code\TR01\Utils');
%% Input: Image with two channels
Path = 'D:\TR01\1640Cohort\R2G_Images\';
fishID = 'ImgZfZdu20180123A3'; 

% NOW GO AND SEGMENT THE MIDPLANE IN FIJI
% *****************************************
disp('________________________________________');
disp('Save midplane points to: ');
midplanePath = 'D:\Code\TR01\Data\Midplanes\';
midplaneFile = [fishID,'_midplane'];
disp(midplanePath);
disp(midplaneFile);
% *****************************************
% Red Image Info (binned)
image = [Path,fishID,'_r2g.tif'];
resImg = getResolution(fishID,[]).*[2 2 1]; % TODO: change to json path 
%% OPTIONAL: Add previous transforms to registery
% priviousTransform = [Path,'\Transforms\MidplaneAlignment_ImgZfCDS20181110A3.mat'];
% midplaneYZfull=load(priviousTransform);
% %% save transform
% createTransformOfFish(fishID,...
%     'Full(same as tight) transform to YZ Plane from original image',...
%     midplaneYZfull.MidplaneAlignmentTight);

%% 3 Point registration
ThreePoints = register3Points(fishID,[]);
% Output = [Path,fishID,'_reg\',fishID,'_3Points.tif'];
% apply_transform(imageRed,resRed,templateFile,resTem,ThreePoints,Output);
% save transform
% addTransformToFish(fishID,...
%% '3 Points freeP2 from YZPlane to Template 
% (the3Points*MidplaneAlignmentTight before this 3 Point alignment)',ThreePoints)
addTransformToFish(fishID,...
    '3 Points freeP2 from original image to Template (nothing before this 3 Point alignment)',...
    ThreePoints)

%% Midplane registration
% enter template Info
% template info
templateFile = 'D:\TR01\RealData_All\Template\TEMPLATE_ImgZfDsy20180223B3_1_MMStack_Pos0_bin221.tif';
resTem = [0.52 0.52 0.4];
% be careful the template midplane is all in pixels, not physUnits!
templateMidplaneFile = [midplanePath,'Template_ImgZfDsy20180223B3_bin221.csv'];

movingMidplaneFile = [midplanePath,midplaneFile,'.csv'];
MidplaneAlignment = midplane_registrationV2(movingMidplaneFile,[1 1 resImg(3)],...
    ThreePoints,templateMidplaneFile,resTem,1);

Output = [Path,fishID,'_3Points_Midplane.tif'];
apply_transform(image,resImg,templateFile,resTem,...
    ThreePoints*MidplaneAlignment,Output);
% save transform
addTransformToFish(fishID,...
    'Midplane alignment to Template, 3 Points freeP2 before this. ',...
    MidplaneAlignment);
