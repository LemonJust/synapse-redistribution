function points = getThreePoints(fishID,jPath,make4D)
% gets the 3 points in physical space from the json file
% returns points AS ROWS ! 
% Input example: fishID = 'ImgZfDsy20190118B7';

if (isempty(jPath))
    jPath = 'D:\Code\TR01\Data\ImagesInfo.json';
end
fishInfo = jsondecode(fileread(jPath));
%% get info for the fish 
id = {fishInfo(:).ID};
fishN  = find(contains(id,fishID,'IgnoreCase',true));
% get resolution
res = [fishInfo(fishN).ZYXSpacing.x,...
        fishInfo(fishN).ZYXSpacing.y,...
        fishInfo(fishN).ZYXSpacing.z];
% get points in pixels
P0 = fishInfo(fishN).AlignP0ZYX;
P1 = fishInfo(fishN).AlignP1ZYX;
P2 = fishInfo(fishN).AlignP2ZYX;
% to physical units
physP0 = [P0.x P0.y P0.z].*res;
physP1 = [P1.x P1.y P1.z].*res;
physP2 = [P2.x P2.y P2.z].*res;
% compose output
if make4D
% if 4D: add 1 to the end of the points
    points = [physP0,1;physP1,1;physP2,1];
else
    points = [physP0;physP1;physP2];
end

end
