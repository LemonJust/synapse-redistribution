function stu = getHowSmartIdV2(cohort_key,unique_id)
%% How smart fish (Learner/Nonlearner)
% returns the studies id (iStudy set) corresponding to
% Learners, Nonlearners, USTim, CStim

% unique_id = strtrim(unique_id);
key = readtable(cohort_key);

study_type = strtrim(key.study_type);
study_id = strtrim(key.study_id);
%% split into behavioural groups
% Learners_name contains only the names of learners, Nonlearners_name -
% nonlearners and etc

% TODO : replace it by group_name from get_group
Learners_name = study_id(ismember(study_type, 'Learner'));
Nonlearners_name = study_id(ismember(study_type, 'Nonlearner'));
NS_name = study_id(ismember(study_type, 'No Stim Control'));
US_name = study_id(ismember(study_type, 'US Only Control'));
CS_name = study_id(ismember(study_type, 'CS Only Control'));

%% Search the manes in csv for the enties in the key
all_found = [];
% TODO : make this a function call
[stu.Learners,is_in_key] = get_group(study_id,study_type,...
    'Learner',unique_id);
% count how many fish has been found
n_in_key = sum(is_in_key);
disp([num2str(sum(is_in_key)),' Learners']);
% finalise creating entry if there are any
if sum(is_in_key)>0
    stu.Id.Learners = Learners_name(is_in_key);
    all_found = [all_found,stu.Learners];
else
    stu = rmfield(stu,'Learners');
end

[stu.Nonlearners,is_in_key] = get_group(study_id,study_type,...
    'Nonlearner',unique_id);
% count how many fish has been found
n_in_key = n_in_key + sum(is_in_key);
disp([num2str(sum(is_in_key)),' Nonlearners']);
% finalise creating entry if there are any
if sum(is_in_key)>0
    stu.Id.Nonlearners = Nonlearners_name(is_in_key);
    all_found = [all_found,stu.Nonlearners];
else
    stu = rmfield(stu,'Nonlearners');
end

[stu.NStim,is_in_key] = get_group(study_id,study_type,...
    'No Stim Control',unique_id);
% count how many fish has been found
n_in_key = n_in_key + sum(is_in_key);
disp([num2str(sum(is_in_key)),' No Stim Controls']);
% finalise creating entry if there are any
if sum(is_in_key)>0
    stu.Id.NStim = NS_name(is_in_key);
    all_found = [all_found,stu.NStim];
else
    stu = rmfield(stu,'NStim');
end

[stu.UStim,is_in_key] = get_group(study_id,study_type,...
    'US Only Control',unique_id);
% count how many fish has been found
n_in_key = n_in_key + sum(is_in_key);
disp([num2str(sum(is_in_key)),' US Only Controls']);
% finalise creating entry if there are any
if sum(is_in_key)>0
    stu.Id.UStim = US_name(is_in_key);
    all_found = [all_found,stu.UStim];
else
    stu = rmfield(stu,'UStim');
end

[stu.CStim,is_in_key] = get_group(study_id,study_type,...
    'CS Only Control',unique_id);
% count how many fish has been found
n_in_key = n_in_key + sum(is_in_key);
disp([num2str(sum(is_in_key)),' CS Only Controls']);
% finalise creating entry if there are any
if sum(is_in_key)>0
    stu.Id.CStim = CS_name(is_in_key);
    all_found = [all_found,stu.CStim];
else
    stu = rmfield(stu,'CStim');
end


%% See if there are any unassigned fish
n_in_table = length(unique_id);
n_unasgn = n_in_table - n_in_key;
disp([num2str(n_unasgn),' Unassigned']);
if n_unasgn>0
   
    % create unassigned group
    stu.Unassigned = 1:n_in_table;
    stu.Unassigned(all_found) = [];
    stu.Id.Unassigned = unique_id(stu.Unassigned);
    
end


end
%% HELPER FUNCTIONS:
function [group_members,is_in_key] = get_group(study_id,study_type,...
    how_smart,unique_id)
% key file can contain info about more fish than currently considered
% we take all the fish in the KEY for that group and search
% for them in the current cohort
% if the fish is there - remember the number of that fish

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
















