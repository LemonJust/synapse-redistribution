function res = getResolution(fishID,jPath)
% gets the 3 points in physical space from the json file
% returns points AS ROWS !
% Input example: fishID = 'ImgZfDsy20190118B7';

if (isempty(jPath))
    jPath = 'D:\Code\TR01\Data\ImagesInfo.json'; % TODO : change to not have default 
end
fishInfo = jsondecode(fileread(jPath));
%% get info for the fish
id = {fishInfo(:).ID};
fishN  = find(contains(id,fishID,'IgnoreCase',true));
if isempty(fishN)
    disp(['No fish with ID: ',fishID,' found! ']);
    res = [];
else
    % get resolution
    res = [fishInfo(fishN).ZYXSpacing.x,...
        fishInfo(fishN).ZYXSpacing.y,...
        fishInfo(fishN).ZYXSpacing.z];
end
end
