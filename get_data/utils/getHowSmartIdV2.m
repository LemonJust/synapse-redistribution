function stu = getHowSmartIdV2(cohort_key,unique_id)
%% How smart fish (Learner/Nonlearner)
% returns the studies id (iStudy set) corresponding to
% Learners, Nonlearners, USTim, CStim

unique_id = strtrim(unique_id);
key = readtable(cohort_key);
%%
study_type = strtrim(key.study_type);
legacy_id = strtrim(key.id);
study_id = strtrim(key.study_id);
%%
Learners_name = study_id(ismember(study_type, 'Learner'));
Nonlearners_name = study_id(ismember(study_type, 'Nonlearner'));
NS_name = study_id(ismember(study_type, 'No Stim Control'));
US_name = study_id(ismember(study_type, 'US Only Control'));
CS_name = study_id(ismember(study_type, 'CS Only Control'));
%%
Learners_ID = legacy_id(ismember(study_type, 'Learner'));
Nonlearners_ID = legacy_id(ismember(study_type, 'Nonlearner'));
NS_ID = legacy_id(ismember(study_type, 'No Stim Control'));
US_ID = legacy_id(ismember(study_type, 'US Only Control'));
CS_ID = legacy_id(ismember(study_type, 'CS Only Control'));
%%
[stu.Learners,is_in_key] = get_group(study_id,study_type,...
    'Learner',unique_id);
stu.Id.Learners = Learners_ID(is_in_key);
stu.Name.Learners = Learners_name(is_in_key);

[stu.Nonlearners,is_in_key] = get_group(study_id,study_type,...
    'Nonlearner',unique_id);
stu.Id.Nonlearners = Nonlearners_ID(is_in_key);
stu.Name.Nonlearners = Nonlearners_name(is_in_key);

[stu.NStim,is_in_key] = get_group(study_id,study_type,...
    'No Stim Control',unique_id);
stu.Id.NStim = NS_ID(is_in_key);
stu.Name.NStim = NS_name(is_in_key);

[stu.UStim,is_in_key] = get_group(study_id,study_type,...
    'US Only Control',unique_id);
stu.Id.UStim = US_ID(is_in_key);
stu.Name.UStim = US_name(is_in_key);

[stu.CStim,is_in_key] = get_group(study_id,study_type,...
    'CS Only Control',unique_id);
stu.Id.CStim = CS_ID(is_in_key);
stu.Name.CStim = CS_name(is_in_key);
end
%% HELPER FUNCTIONS:
function [group_members,is_in_key] = get_group(study_id,study_type,...
    how_smart,unique_id)
% since key file can contain info about more fish than currently considered
% in the cohort, we take all the fish in the key for that group and search
% for them in the current cohort

group_name = study_id(ismember(study_type, how_smart));

n_members = length(group_name);
group_members = zeros(1,n_members);
is_in_key = zeros(1,n_members);

for i_memb = 1:n_members
    entryNumber = find(ismember(unique_id,group_name{i_memb}));
    if ~isempty(entryNumber)
        group_members(i_memb) = entryNumber;
        is_in_key(i_memb) = 1;
    end
end
is_in_key = logical(is_in_key);
group_members = group_members(is_in_key);
end
















