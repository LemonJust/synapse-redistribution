% 3 Point + Midplane registration
% this example shows how to get the final transformation 
% to the 25 Deg template fish. First based on the 3 points
% and then fine-tuning based on the midplane ( for a fish with a clear
% midplane)
% FinalAlignment: resulting transformation (for row - vectors)

clear all
addpath('utils');
midplanePath = 'data\midplanes\';

fishID = 'ImgZfDsy20190201B3'; 
plotting = true;

%% 3 Point registration ( 3 points are in GREEN channel )
ThreePoints = register3Points(fishID,[],plotting);

%% get Red to Green registration 
% rigid registration, done using ants registration tools
% registers red channel of the image to the green by translation

r2gTrfm = get_R2G(fishID);

%% Midplane registration ( midplane segmented in RED channel )
% template resolution
resTem = [0.52 0.52 0.4];
resImg = getResolution(fishID,[]).*[2 2 1]; % TODO: change to json path 

% be careful the template midplane is all in pixels, not physUnits!
templateMidplaneFile = [midplanePath,'Template_ImgZfDsy20180223B3_bin221.csv'];
movingMidplaneFile = [midplanePath,fishID,'_Red_bin221_midplane.csv'];

MidplaneAlignment = midplane_registrationV2(movingMidplaneFile,[1 1 resImg(3)],...
    r2gTrfm*ThreePoints,templateMidplaneFile,resTem,plotting);

%% Final registration
FinalAlignment = ThreePoints*MidplaneAlignment

