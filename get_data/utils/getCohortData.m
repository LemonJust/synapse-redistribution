function [stu,syn] = getCohortData(in)
%% get input
cohort_path = in.cohort_path;
cohort_key = in.key_path;

if isfield(in, 'dorsalize')
    dorsalize = in.dorsalize;
else
    dorsalize = true;
end

%% read cohort
table = readtable(cohort_path);
%% sort studies into Learners/Nonlearners/CStim/NStim/UStim
unique_id = strtrim(unique(table.study_id));
nStudies = length(unique_id);

% TODO : make cohort_key = [] be an option

stu = getHowSmartIdV2(cohort_key,unique_id);
%% get indices of lost/gained/unchanged synapses for each study
[unchangedId,lostId,gainedId] = getStudiesV2(table,unique_id);

%% get xyz coordinates for all the synapses in the Standart Fish Space
[lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = getxyz(table,...
    nStudies,lostId,gainedId,unchangedId);

%% get xyz coordinates for all the synapses in the Dorsal space
% apply midplane transform :
% dorsalize by setting midplane of the fish to be Oyz
dorsalize
if dorsalize
    
    template_midplane = in.template_midplane;
    yzplane_points = in.yzplane_points;
    template_midplane_res = in.template_midplane_res;
    yzplane_res = in.yzplane_res;
    
    [lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = ...
        getxyzAnat(lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter,...
        template_midplane,yzplane_points,...
        template_midplane_res,yzplane_res);
end

%% form a structure
syn.lost = lost;
syn.gained = gained;
syn.unchangedBefore = unchangedBefore;
syn.unchangedAfter = unchangedAfter;
syn.allBefore = allBefore;
syn.allAfter = allAfter;

%% remove synapses on the other side of the midplane
% plane YZ coordinates
if dorsalize
    midplanePoints = readtable(yzplane_points);
    midplaneX = midplanePoints.X(1)*yzplane_res(1);
    syn = removewrongside(syn,midplaneX);
end

end