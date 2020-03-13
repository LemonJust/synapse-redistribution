function db = getIntensityDB_LOO(fishID,stu,syn)

% Get Decision boundary Leave one out based on intensity: 
% returns decision boundaries fron LOO subsets (db.data)

% fishID - set of fish 
% Ex. : fishID = stu.Learners
%       nBootstrapSamples = 10;

% (1) find the average value of intensity change for a given fish
% (2) Subtract that value from the intensity difference for each pair,
% which will shift things that are more positive to being more negative
% and vice versa
% --> the point here is that it's possible that we aren't seeing 
% regional differences in loss of intensity or gain of intensity but maybe 
% an area of less loss with an area of more loss
% (3) calculate the weighted DB plane after the subtraction

nFish = length(fishID);
for iFish = 1:nFish
    
    disp(['Fish ',num2str(iFish),' out of ',num2str(nFish)]);
    %disp(['Fish ID ',num2str(fishID(iFish))]);
    %disp('Using fish : ');
    smartID = get_subset(fishID,iFish);
    %smartID
    cl = getDBfromInt(smartID,stu,syn);
    db.cl{iFish} = cl;
    db.Bias{iFish} = cl.Bias;
    db.Beta{iFish} = cl.Beta;
    
end
db.mean.Beta = mean(cat(2,db.Beta{:}),2);
db.mean.Bias = mean(cat(1,db.Bias{:}));

end

%% HELPER FUNCTIONS
function [pointCloud_ub, pointCloud_ua] = getPointClouds(smartID,stu,syn)
synID = "ub";
pointCloud_ub = getPointCloud_midplaneFixed(smartID, stu, synID, syn);
synID = "ua";
pointCloud_ua = getPointCloud_midplaneFixed(smartID, stu, synID, syn);
end

function [pointCloud_ub, pointCloud_ua] = getIntensityClouds(smartID,stu,syn)
% returns normalised intenseties


if isstring(smartID)
    [howSmart,~] = chooseHowSmart(smartID, stu);
else
    howSmart = smartID;
end
pointCloud_ub = [];
pointCloud_ua = [];
for iFish = howSmart

    int_ub = syn.unchangedBefore.intensity_mp{iFish};
    int_ua = syn.unchangedAfter.intensity_mp{iFish};
    
    norm_before = median(int_ub);
    
    int_ub = int_ub/norm_before;
    int_ua = int_ua/norm_before;
    
    pointCloud_ub = [pointCloud_ub;int_ub];
    pointCloud_ua = [pointCloud_ua;int_ua];
end
end

function cl_w = getDBfromInt(smartIDs,stu,syn)
% bleaching correction
mult = (100 + 3.86)/100;

% per fish to do the median intensity correction 
pointCloud_ub =[];
int_diff = [];
for smartID = smartIDs
    % get intensity
    [intensity_ub, intensity_ua] = getIntensityClouds(smartID,stu,syn);
    
    % get position
    [i_pointCloud_ub, ~] = getPointClouds(smartID,stu,syn);
    
    % set median difference of intensity to zero (per fish!?!?)
    i_int_diff = intensity_ua*mult - intensity_ub;
    i_int_diff = i_int_diff - median(i_int_diff);
    
    % add to the previous data
    pointCloud_ub = [pointCloud_ub;i_pointCloud_ub];
    int_diff = [int_diff;i_int_diff];
end

% split into "intensity lost" & "intensity gain"
pos = int_diff>0; % intensity gain
neg = int_diff<0; % intensity loss

int_gain = int_diff(pos);
int_lost = -int_diff(neg);

lost = pointCloud_ub(neg,:);
gained = pointCloud_ub(pos,:);

% find the weighted decision boundary
nSamples = min(length(lost),length(gained)); % N to downsample
cl_w = getDecisionBoundaryWithWeights(gained,lost,int_gain,int_lost,nSamples);

end

