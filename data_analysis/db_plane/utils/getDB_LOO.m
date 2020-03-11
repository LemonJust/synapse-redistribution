function db = getDB_LOO(fishID,stu,syn)
% Get Decision boundary Leave one out: 
% returns decision boundaries fron LOO subsets (db.data)
% and ten DB defined on bootstrap samples (db.bs) from LOO subset

% fishID - set of fish 
% Ex. : fishID = stu.Learners
%       nBootstrapSamples = 10;

nFish = length(fishID);
for iFish = 1:nFish
    
    disp(['Fish ',num2str(iFish),' out of ',num2str(nFish)]);
    
    smartID = get_subset(fishID,iFish);
    
    [pointCloud_ga, pointCloud_lo] = getPointClouds(smartID,stu,syn);

    nLost = size(pointCloud_lo,1);
    nGain = size(pointCloud_ga,1);
    nSamples = min(nLost,nGain);
    
    % based on data 
    cl = getDecisionBoundaryFromPointCloud(pointCloud_ga,pointCloud_lo,nSamples);
    db.cl{iFish} = cl; 
    db.Bias{iFish} = cl.Bias;
    db.Beta{iFish} = cl.Beta;
    db.Scale{iFish} = cl.KernelParameters.Scale;

end
% average plane 
db.mean.Beta = mean(cat(2,db.Beta{:}),2);
db.mean.Bias = mean(cat(1,db.Bias{:}));



function [pointCloud_ga, pointCloud_lo] = getPointClouds(smartID,stu,syn)
synID = "ga";
pointCloud_ga = getPointCloud_midplaneFixed(smartID, stu, synID, syn);
synID = "lo";
pointCloud_lo = getPointCloud_midplaneFixed(smartID, stu, synID, syn);
end

end

