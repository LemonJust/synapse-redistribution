function [unchanged,lost,gained] = getStudiesV2(table,studyName)
%% separate synapse type
% returns all id of synapses gained, lost, etc for each separate study 

% 0   - Paired before/after (unchanged)
% 1    - Unpaired before (lost)
% 2   - Unpaired after (gained)

unchanged = cell(length(studyName),1);
lost = cell(length(studyName),1);
gained = cell(length(studyName),1);
studyID = strtrim(table.subject);

allUnchanged = (table.t==0);
allLost = (table.t==1);
allGained = (table.t==2);

nStudies = length(studyName);
for iStudy = 1:nStudies
    fishID = studyName{iStudy};
    unchanged{iStudy} = find(ismember(studyID,fishID).*allUnchanged);
    lost{iStudy} = find(ismember(studyID,fishID).*allLost);
    gained{iStudy} = find(ismember(studyID,fishID).*allGained);
end

end