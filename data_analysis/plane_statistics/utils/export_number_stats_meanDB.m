function export_number_stats_meanDB(smartID,db,stu,syn,save_file)

alphabeth = getletters();
[cl,flip_class,names,fish_subset,full_name] = get_smart_info(smartID,...
    db,stu);

for iSubject = 1:length(fish_subset)
    iFish = fish_subset(iSubject);
    
    stat = get_totInt_totNum_intPerSyn_medianInt(syn,iFish,cl,flip_class);
    
    %% calculate some
    stat.relDiff = getRelDiffAllStats(stat.allBefore,stat.allAfter);
    stat.lgRatio = getRatioAllStats(stat.lost,stat.gained);
    stat.frLost = getRatioAllStats(stat.lost,stat.allBefore);
    stat.frGained = getRatioAllStats(stat.gained,stat.allBefore);
    
    %% wride to file
    if iSubject == 1
        row = 3;
        iLetter = 1;
        writeColumn(save_file,alphabeth,iLetter,1,1,{'ID'});
        writeColumn(save_file,alphabeth,iLetter,row,row,{full_name});
        writeColumn(save_file,alphabeth,iLetter,1+row,1+row,names(iSubject));
        writedata(save_file,alphabeth,2,row-1,stat,1);
        row = 4;
    else
        row = row + 1;
        writeColumn(save_file,alphabeth,1,row,row,names(iSubject));
        writedataNoHeader(save_file,alphabeth,2,row,stat,1);
    end
end
end

%% HELPER FUNCTIONS
function [cl,flip_classes,names,fish_subset,full_name] = get_smart_info(smartID,db,stu)
switch smartID
    case "LR"
        flip_classes = 0;
        cl = db.Learners.mean.data;
        names = stu.Id.Learners;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "NL"
        flip_classes = 0;
        cl = db.Nonlearners.mean.data;
        names = stu.Id.Nonlearners;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "US"
        flip_classes = 0;
        cl = db.UStim.mean.data;
        names = stu.Id.UStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "CS"
        flip_classes = 0;
        cl = db.CStim.mean.data;
        names = stu.Id.CStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "NS"
        flip_classes = 0;
        cl = db.NStim.mean.data;
        names = stu.Id.NStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
end
end


function stat = get_totInt_totNum_intPerSyn_medianInt(syn,iFish,cl,flip_class)

[stat.lost.totInt,stat.lost.totNum,...
    stat.lost.intPerSyn,stat.lost.medianInt] = getRegionStatIndividual(syn.lost,iFish,cl,flip_class);

[stat.gained.totInt,stat.gained.totNum,...
    stat.gained.intPerSyn,stat.gained.medianInt] = getRegionStatIndividual(syn.gained,iFish,cl,flip_class);

[stat.allBefore.totInt,stat.allBefore.totNum,...
    stat.allBefore.intPerSyn,stat.allBefore.medianInt] = getRegionStatIndividual(syn.allBefore,iFish,cl,flip_class);

[stat.allAfter.totInt,stat.allAfter.totNum,...
    stat.allAfter.intPerSyn,stat.allAfter.medianInt] = getRegionStatIndividual(syn.allAfter,iFish,cl,flip_class);

end

function relDiff = getRelDiffAllStats(before,after)
% get sats ratio after - before / before
relDiff.totInt = getRelDiffLatMed(before.totInt,after.totInt);
relDiff.totNum = getRelDiffLatMed(before.totNum,after.totNum);
relDiff.intPerSyn = getRelDiffLatMed(before.intPerSyn,after.intPerSyn);
relDiff.medianInt = getRelDiffLatMed(before.medianInt,after.medianInt);

end
function relDiff = getRelDiffLatMed(before,after)

relDiff.lat = getRelDiff(before.lat,after.lat);
relDiff.med = getRelDiff(before.med,after.med);
relDiff.all = getRelDiff((before.med+before.lat),(after.med+after.lat));
end
function relDiff = getRelDiff(before,after)

relDiff = (after - before)./before;
end


function ratio = getRatioAllStats(lost,gained)

ratio.totInt = getLgRatioLatMed(lost.totInt,gained.totInt);
ratio.totNum = getLgRatioLatMed(lost.totNum,gained.totNum);
ratio.intPerSyn = getLgRatioLatMed(lost.intPerSyn,gained.intPerSyn);
ratio.medianInt = getLgRatioLatMed(lost.medianInt,gained.medianInt);
end
function ratio = getLgRatioLatMed(before,after)
ratio.lat = getLgRatio(before.lat,after.lat);
ratio.med = getLgRatio(before.med,after.med);
ratio.all = getLgRatio((before.med+before.lat),(after.med+after.lat));
end
function ratio = getLgRatio(lost,gained)
ratio = lost./gained;
end


function iLetter = writeColumn(save_file,alphabeth,iLetter,top,bottom,data)
col = alphabeth{iLetter};
xlRange = [col,num2str(top),':',col,num2str(bottom)];
xlswrite(save_file,data,xlRange);
iLetter = iLetter + 1;
end

function iLetter = writeCase(save_file,title,start,alphabeth,iLetter,data,howSmart)

writeColumn(save_file,alphabeth,iLetter,start,start,{title});
start = start+1;
writeColumn(save_file,alphabeth,iLetter,start,start,{'lateral'});
writeColumn(save_file,alphabeth,iLetter+1,start,start,{'medial'});
dataLength = length(howSmart);
writeColumn(save_file,alphabeth,iLetter,start+1,dataLength+start,data.lat(howSmart)');
writeColumn(save_file,alphabeth,iLetter+1,start+1,dataLength+start,data.med(howSmart)');
iLetter = iLetter + 2;
end

function iLetter = writeCaseNoSplitNoHead(save_file,start,alphabeth,iLetter,data,howSmart)

dataLength = length(howSmart);
writeColumn(save_file,alphabeth,iLetter,start,dataLength+start-1,data.all(howSmart)');
iLetter = iLetter + 1;
end

function iLetter = writeCaseNoHead(save_file,start,alphabeth,iLetter,data,howSmart)

dataLength = length(howSmart);
writeColumn(save_file,alphabeth,iLetter,start,dataLength+start-1,data.lat(howSmart)');
writeColumn(save_file,alphabeth,iLetter+1,start,dataLength+start-1,data.med(howSmart)');
iLetter = iLetter + 2;
end

function iLetter = writeCaseNoSplit(save_file,title,start,alphabeth,iLetter,data,howSmart)

writeColumn(save_file,alphabeth,iLetter,start,start,{title});
start = start+1;
writeColumn(save_file,alphabeth,iLetter,start,start,{'total'});
dataLength = length(howSmart);
writeColumn(save_file,alphabeth,iLetter,start+1,dataLength+start,data.all(howSmart)');
iLetter = iLetter + 1;
end

function alphabeth = getletters()
% returns 52 line of letters for excel columns
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
alphabeth = cell(52,1);
for ii = 1:26
    alphabeth{ii} = letters(ii);
    alphabeth{ii+26} = ['A',letters(ii)];
end
end

function iLetter = writedata(save_file,alphabeth,iLetter,offset,stat,howSmart)

% median intensity
% aa-ab/ab
writeColumn(save_file,alphabeth,iLetter,1,1,{'median intensity'});
iLetter = writeCase(save_file,'(AA-AB)/AB',offset,alphabeth,iLetter,stat.relDiff.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.relDiff.medianInt,howSmart);
% fraction lost
writeColumn(save_file,alphabeth,iLetter,1,1,{'fraction lost'});
iLetter = writeCase(save_file,'lost/AB',offset,alphabeth,iLetter,stat.frLost.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.frLost.totNum,howSmart);
% fraction gained
writeColumn(save_file,alphabeth,iLetter,1,1,{'fraction gained'});
iLetter = writeCase(save_file,'gained/AB',offset,alphabeth,iLetter,stat.frGained.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.frGained.totNum,howSmart);
% total number of synapse
writeColumn(save_file,alphabeth,iLetter,1,1,{'number of synapse'});
iLetter = writeCase(save_file,'before',offset,alphabeth,iLetter,stat.allBefore.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.allBefore.totNum,howSmart);
iLetter = writeCase(save_file,'after',offset,alphabeth,iLetter,stat.allAfter.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.allAfter.totNum,howSmart);
iLetter = writeCase(save_file,'lost',offset,alphabeth,iLetter,stat.lost.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.lost.totNum,howSmart);
iLetter = writeCase(save_file,'gained',offset,alphabeth,iLetter,stat.gained.totNum,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.gained.totNum,howSmart);

end

function iLetter = writedataNoHeader(save_file,alphabeth,iLetter,offset,stat,howSmart)

% median intensity
% aa-ab/ab
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.relDiff.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.relDiff.medianInt,howSmart);
% fraction lost
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.frLost.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.frLost.totNum,howSmart);
% fraction gained
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.frGained.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.frGained.totNum,howSmart);
% total number of synapse
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.allBefore.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.allBefore.totNum,howSmart);
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.allAfter.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.allAfter.totNum,howSmart);
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.lost.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.lost.totNum,howSmart);
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.gained.totNum,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.gained.totNum,howSmart);

end












