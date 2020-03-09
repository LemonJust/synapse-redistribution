function pointCloud = getPointCloud_midplaneFixed(smartID, stu, synID, syn) 

if isstring(smartID)
    [howSmart,~] = chooseHowSmart(smartID, stu);
end
if isnumeric(smartID)
    howSmart = smartID;
end
[whichCase,~,~] = chooseCase(synID, syn);
pointCloud = cat(1,whichCase.xyz_anat_mp{howSmart});

end