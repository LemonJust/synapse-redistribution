function [totInt,totNum,intPerSyn,medianInt] = getRegionStatIndividual(whichCase,iStudy,svmModel,flip_class)

% returns: totInt,totNum,intPerSyn,medianInt
% total intensity 
% total number of synapses 
% intensity per synapse 
% median intensity 


%% get point cloud
pointCloud = whichCase.xyz_anat_mp{iStudy};
intensityCloud = whichCase.intensity_mp{iStudy};

assert(length(pointCloud(:,1))==length(intensityCloud),...
    'Coordinates and intensity arrays are different');

%% Split points 
[gaSideIdx_ab, loSideIdx_ab] = splitPoints(pointCloud,svmModel,flip_class);

%% Calculate stats 
% lateral
totInt.lat = sum(intensityCloud(gaSideIdx_ab));
totNum.lat = length(gaSideIdx_ab);
medianInt.lat = median(intensityCloud(gaSideIdx_ab));
intPerSyn.lat = totInt.lat./totNum.lat;

% medial
totInt.med = sum(intensityCloud(loSideIdx_ab));
totNum.med = length(loSideIdx_ab);
medianInt.med = median(intensityCloud(loSideIdx_ab));
intPerSyn.med = totInt.med./totNum.med;

% all
totInt.all = sum(intensityCloud);
totNum.all = length(intensityCloud);
medianInt.all = median(intensityCloud);
intPerSyn.all = totInt.all./totNum.all;
end

























