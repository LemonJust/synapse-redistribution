function stu = getHowSmartIdV2(PathKey,studyName)
%% How smart fish (Learner/Nonlearner)
% returns the studies id (iStudy set) corresponding to 
% Learners, Nonlearners, USTim, CStim 

studyName = strtrim(studyName);
tableKey = readtable(PathKey);
%%
howSmart = strtrim(tableKey.StudyType);
ID = strtrim(tableKey.ID);
SynStdID = strtrim(tableKey.SynStdID);
%%
Learners_name = SynStdID(ismember(howSmart, 'Learner'));
Nonlearners_name = SynStdID(ismember(howSmart, 'Nonlearner'));
NS_name = SynStdID(ismember(howSmart, 'No Stim Control'));
US_name = SynStdID(ismember(howSmart, 'US Only Control'));
CS_name = SynStdID(ismember(howSmart, 'CS Only Control'));
%%
Learners_ID = ID(ismember(howSmart, 'Learner'));
Nonlearners_ID = ID(ismember(howSmart, 'Nonlearner'));
NS_ID = ID(ismember(howSmart, 'No Stim Control'));
US_ID = ID(ismember(howSmart, 'US Only Control'));
CS_ID = ID(ismember(howSmart, 'CS Only Control'));
%%
[stu.Learners,isThere] = getWhoIsWho(Learners_ID,studyName);
stu.Id.Learners = Learners_ID(isThere);
stu.Name.Learners = Learners_name(isThere);

[stu.Nonlearners,isThere] = getWhoIsWho(Nonlearners_ID,studyName);
stu.Id.Nonlearners = Nonlearners_ID(isThere);
stu.Name.Nonlearners = Nonlearners_name(isThere);

[stu.NStim,isThere] = getWhoIsWho(NS_ID,studyName);
stu.Id.NStim = NS_ID(isThere);
stu.Name.NStim = NS_name(isThere);

[stu.UStim,isThere] = getWhoIsWho(US_ID,studyName);
stu.Id.UStim = US_ID(isThere);
stu.Name.UStim = US_name(isThere);

[stu.CStim,isThere] = getWhoIsWho(CS_ID,studyName);
stu.Id.CStim = CS_ID(isThere);
stu.Name.CStim = CS_name(isThere);
end
%% HELPER FUNCTIONS:
function [Learners,isImageThere] = getWhoIsWho(Learners_name,studyName)
    
    nLearners = length(Learners_name);
    Learners = zeros(1,nLearners);
    isImageThere = zeros(1,nLearners);
    
    for iL = 1:nLearners        
        entryNumber = find(ismember(studyName,['Zf',Learners_name{iL}]));
        if ~isempty(entryNumber)
            Learners(iL) = entryNumber;
            isImageThere(iL) = 1;
        end
    end
    isImageThere = logical(isImageThere);
    Learners = Learners(isImageThere);
end
















