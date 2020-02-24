% Midplane registration 
% this example shows how to get a transformation that aligns the fish 
% midplane with the template midplane
% MidplaneAlignment: resulting transformation (for row - vectors)

fishID = 'ImgZfDsy20190201B3'; 
midplanePath = 'data\Midplanes\';
% template & moving resolution
resTem = [0.52 0.52 0.4];
resImg = getResolution(fishID,[]).*[2 2 1]; % TODO: change to json path 

% be careful the template midplane is all in pixels, not physUnits!
templateMidplaneFile = [midplanePath,'Template_ImgZfDsy20180223B3_bin221.csv'];
movingMidplaneFile = [midplanePath,fishID,'_midplane','.csv'];

plotting = true;
MidplaneAlignment = midplane_registrationV2(movingMidplaneFile,[1 1 resImg(3)],...
    ThreePoints,templateMidplaneFile,resTem,plotting);