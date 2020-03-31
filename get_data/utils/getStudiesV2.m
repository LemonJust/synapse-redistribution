function [unchanged,lost,gained] = getStudiesV2(table,unique_id)
% returns all id of synapses gained, lost, etc for each separate study
% 0   - Paired before/after (unchanged)
% 1    - Unpaired before (lost)
% 2   - Unpaired after (gained)

study_id = strtrim(table.study_id);

is_unchanged = (table.t==0);
is_lost = (table.t==1);
is_gained = (table.t==2);

unchanged = cell(length(unique_id),1);
lost = cell(length(unique_id),1);
gained = cell(length(unique_id),1);

for iStudy = 1:length(unique_id)
    fish_id = unique_id{iStudy};
    
    unchanged{iStudy} = find(ismember(study_id,fish_id).*is_unchanged);
    lost{iStudy} = find(ismember(study_id,fish_id).*is_lost);
    gained{iStudy} = find(ismember(study_id,fish_id).*is_gained);
end

end