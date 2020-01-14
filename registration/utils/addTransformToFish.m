function addTransformToFish(fishID,describtion,matrix)
% load transform file
fileName = 'D:\Code\TR01\Data\Transforms.mat';
transforms = load(fileName);
ToTemplateYZ = transforms.ToTemplateYZ;
clear transforms
% find transforms of the fish you need
id = {ToTemplateYZ(:).ID};
fishN  = find(contains(id,fishID,'IgnoreCase',true));
if (length(fishN) > 1)
    disp('_________________________________________');
    disp('There is more then one entry for this fishID,');
    disp('use a more specific fishID');
    ToTemplateYZ(fishN).ID
else
    if isempty(fishN)
        disp('_________________________________________');
        disp('There is no entry for this fishID,');
        disp('use createTransformOfFish to add a new fishID');
        ToTemplateYZ.ID
    else
        % add one more transform
        ToTemplateYZ(fishN).transforms(end+1) = struct('info',{describtion},...
            'matrix',{matrix});
        disp('_________________________________________');
        disp('Transform added:');
        % show all the transforms for the fish
        ToTemplateYZ(fishN).transforms.info
        % save
        save (fileName,'ToTemplateYZ');
    end
end
end