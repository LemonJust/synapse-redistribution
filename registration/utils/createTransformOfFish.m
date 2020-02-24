function createTransformOfFish(fishID,describtion,matrix)
% load transform file
fileName = 'D:\Code\TR01\Data\Transforms.mat';
transforms = load(fileName);
ToTemplateYZ = transforms.ToTemplateYZ;
clear transforms
% check that the fish is not here 
id = {ToTemplateYZ(:).ID};
fishN  = find(contains(id,fishID,'IgnoreCase',true)); 
if isempty(fishN) 
    ToTemplateYZ(end+1) = struct('ID',{fishID},'transforms',...
        {struct('info',{describtion},'matrix',{matrix})});
    save (fileName,'ToTemplateYZ');
    disp('_________________________________________');
    disp('Entry added:');
    ToTemplateYZ.ID
else
disp('_________________________________________');
disp('There is already an entry for this fishID,');
ToTemplateYZ(fishN).ID
disp('use addTransformToFish to add a transform');
end

end