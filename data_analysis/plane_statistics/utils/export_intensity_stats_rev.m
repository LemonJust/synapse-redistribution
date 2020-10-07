function export_intensity_stats_rev(smartID,db,stu,syn,save_file)
% changed the defenition of syn int change for the paper review 

switch smartID
    case "LR"
        who = stu.Learners;
        theirNames = stu.Id.Learners;
        theyAre = 'Learners';
        thirDb = db.Learners;
    case "NL"
        who = stu.Nonlearners;
        theirNames = stu.Id.Nonlearners;
        theyAre = 'Nonlearners';
        thirDb = db.Nonlearners;
    case "US"
        who = stu.UStim;
        theirNames = stu.Id.UStim;
        theyAre = 'UStim';
        thirDb = db.UStim;
    case "CS"
        who = stu.CStim;
        theirNames = stu.Id.CStim;
        theyAre = 'CStim';
        thirDb = db.CStim;
    case "NS"
        who = stu.NStim;
        theirNames = stu.Id.NStim;
        theyAre = 'NStim';
        thirDb = db.NStim;
end

bleaching = 6.7;
cam_offset = 102;


alphabeth = getletters();

for iLr = 1:length(who)
    iFish = who(iLr);

    cl = thirDb.intensity.cl{iLr};
    flip_class = thirDb.intensity.flip(iLr);
    
    % remove camera offset
    syn = subtractCameraOffset(syn,iFish,cam_offset);
    
    % get intensity stats for each fish
    stat = getSoloStats(syn,iFish,cl,flip_class,bleaching);
    
    % write data
    if iLr == 1
        row = 3;
        iLetter = 1;
        writeColumn(save_file,alphabeth,iLetter,1,1,{'ID'});
        writeColumn(save_file,alphabeth,iLetter,row,row,{theyAre});
        row = row + 1;
        writeColumn(save_file,alphabeth,iLetter,row,row,theirNames(iLr));
        % write data
        writedata(save_file,alphabeth,2,2,stat,1);
    else
        row = row + 1;
        writeColumn(save_file,alphabeth,1,row,row,theirNames(iLr));
        writedataNoHeader(save_file,alphabeth,2,row,stat,1);
        
    end
end
end

%% HELPER FUNCTIONS

function iLetter = writeColumn(save_file,alphabeth,iLetter,top,bottom,data)
col = alphabeth{iLetter};
xlRange = [col,num2str(top),':',col,num2str(bottom)];
xlswrite(save_file,data,xlRange)
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

function iLetter = writeCaseNoSplit(save_file,title,start,alphabeth,iLetter,data,howSmart)

writeColumn(save_file,alphabeth,iLetter,start,start,{title});
start = start+1;
writeColumn(save_file,alphabeth,iLetter,start,start,{'total'});
dataLength = length(howSmart);
writeColumn(save_file,alphabeth,iLetter,start+1,dataLength+start,data.all(howSmart)');
iLetter = iLetter + 1;
end


function alphabeth = getletters()
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
alphabeth = cell(52,1);
for ii = 1:26
    alphabeth{ii} = letters(ii);
    alphabeth{ii+26} = ['A',letters(ii)];
end
end

function syn = subtractCameraOffset(syn,iFish,camOff)
% subtract camera offset 

syn.unchangedAfter.intensity_mp{iFish} = syn.unchangedAfter.intensity_mp{iFish} - camOff;
syn.unchangedBefore.intensity_mp{iFish} = syn.unchangedBefore.intensity_mp{iFish} - camOff;

end

function stat = getPairWiseStatSolo(stat,syn,iFish,cl,flip_class)

[latSideIdx, medSideIdx] = splitPoints(syn.unchangedBefore.xyz_anat_mp{iFish},cl,flip_class);

% Pairwise devision
% all
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish};
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish};
stat.pairWiseRatioMedianInt.all = median(unchangedAfter./unchangedBefore);
% lateral
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx);
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(latSideIdx);
stat.pairWiseRatioMedianInt.lat = median(unchangedAfter./unchangedBefore);
% medial
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx);
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(medSideIdx);
stat.pairWiseRatioMedianInt.med = median(unchangedAfter./unchangedBefore);

% Median devision
% all
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish};
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish};
stat.pairWiseDiffMedianInt.all = median(unchangedAfter)/median(unchangedBefore);
% lateral
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx);
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(latSideIdx);
stat.pairWiseDiffMedianInt.lat = median(unchangedAfter)/median(unchangedBefore);
% medial
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx);
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(medSideIdx);
stat.pairWiseDiffMedianInt.med = median(unchangedAfter)/median(unchangedBefore);

end

function stat = getPairWiseStatBleachingCorrectedSolo(stat,syn,iFish,cl,flip_class,bleaching)
% bleaching = percent of bleaching
mult = (100 + bleaching)/100;

[latSideIdx, medSideIdx] = splitPoints(syn.unchangedBefore.xyz_anat_mp{iFish},cl,flip_class);

% Pairwise devision
% all
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish};
stat.pairWiseRatioMedianIntBlCorr.all = median(unchangedAfter./unchangedBefore);
% lateral
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx)*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(latSideIdx);
stat.pairWiseRatioMedianIntBlCorr.lat = median(unchangedAfter./unchangedBefore);
% medial
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx)*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(medSideIdx);
stat.pairWiseRatioMedianIntBlCorr.med = median(unchangedAfter./unchangedBefore);

% Median devision
% all
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish};
stat.pairWiseDiffMedianIntBlCorr.all = median(unchangedAfter)/median(unchangedBefore);
% lateral
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx)*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(latSideIdx);
stat.pairWiseDiffMedianIntBlCorr.lat = median(unchangedAfter)/median(unchangedBefore);
% medial
unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx)*mult;
unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(medSideIdx);
stat.pairWiseDiffMedianIntBlCorr.med = median(unchangedAfter)/median(unchangedBefore);

end

function stat = getSoloStats(syn,iStudy,cl,flip_class,bleaching)
% For one fish , iStudy:
%
% 1. calls getRegionStatIndividual on 6 groups of synapses:
% lost, gained, allBefore, allAfter, unchangedBefore, unchangedAfter
%
% 2. calls getPairWiseStatSolo and getPairWiseStatBleachingCorrectedSolo

[stat.lost.totInt,stat.lost.totNum,...
    stat.lost.intPerSyn,stat.lost.medianInt] = getRegionStatIndividual(syn.lost,iStudy,cl,flip_class);
[stat.gained.totInt,stat.gained.totNum,...
    stat.gained.intPerSyn,stat.gained.medianInt] = getRegionStatIndividual(syn.gained,iStudy,cl,flip_class);

[stat.allBefore.totInt,stat.allBefore.totNum,...
    stat.allBefore.intPerSyn,stat.allBefore.medianInt] = getRegionStatIndividual(syn.allBefore,iStudy,cl,flip_class);
[stat.allAfter.totInt,stat.allAfter.totNum,...
    stat.allAfter.intPerSyn,stat.allAfter.medianInt] = getRegionStatIndividual(syn.allAfter,iStudy,cl,flip_class);

[stat.unchangedBefore.totInt,stat.unchangedBefore.totNum,...
    stat.unchangedBefore.intPerSyn,stat.unchangedBefore.medianInt] = getRegionStatIndividual(syn.unchangedBefore,iStudy,cl,flip_class);
[stat.unchangedAfter.totInt,stat.unchangedAfter.totNum,...
    stat.unchangedAfter.intPerSyn,stat.unchangedAfter.medianInt] = getRegionStatIndividual(syn.unchangedAfter,iStudy,cl,flip_class);


stat = getPairWiseStatSolo(stat,syn,iStudy,cl,flip_class);
stat = getPairWiseStatBleachingCorrectedSolo(stat,syn,iStudy,cl,flip_class,bleaching);

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

function iLetter = writedata(save_file,alphabeth,iLetter,offset,stat,howSmart)

% median intensity
writeColumn(save_file,alphabeth,iLetter,1,1,{'median intensity'});
% allBefore
iLetter = writeCase(save_file,'allBefore',offset,alphabeth,iLetter,stat.allBefore.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.allBefore.medianInt,howSmart);
% allAfter
iLetter = writeCase(save_file,'allAfter',offset,alphabeth,iLetter,stat.allAfter.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.allAfter.medianInt,howSmart);
% unchBefore
iLetter = writeCase(save_file,'unchBefore',offset,alphabeth,iLetter,stat.unchangedBefore.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.unchangedBefore.medianInt,howSmart);
% unchAfter
iLetter = writeCase(save_file,'unchAfter',offset,alphabeth,iLetter,stat.unchangedAfter.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.unchangedAfter.medianInt,howSmart);
% lost
iLetter = writeCase(save_file,'lost',offset,alphabeth,iLetter,stat.lost.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.lost.medianInt,howSmart);
% gained
iLetter = writeCase(save_file,'gained',offset,alphabeth,iLetter,stat.gained.medianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.gained.medianInt,howSmart);

% Fraction : unchBefore - Pairwise
writeColumn(save_file,alphabeth,iLetter,1,1,{'pairwise median intensity'});
iLetter = writeCase(save_file,'(UA - UB)/UB',offset,alphabeth,iLetter,stat.pairWiseRatioMedianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.pairWiseRatioMedianInt,howSmart);
% unchBefore - Pairwise BLeaching corrected
writeColumn(save_file,alphabeth,iLetter,1,1,{'bleach corrected pairwise median intensity'});
iLetter = writeCase(save_file,'(UA - UB)/UB',offset,alphabeth,iLetter,stat.pairWiseRatioMedianIntBlCorr,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.pairWiseRatioMedianIntBlCorr,howSmart);

% Difference: unchBefore - Pairwise
writeColumn(save_file,alphabeth,iLetter,1,1,{'pairwise median intensity'});
iLetter = writeCase(save_file,'UA - UB',offset,alphabeth,iLetter,stat.pairWiseDiffMedianInt,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.pairWiseDiffMedianInt,howSmart);
% unchBefore - Pairwise BLeaching corrected
writeColumn(save_file,alphabeth,iLetter,1,1,{'bleach corrected pairwise median intensity'});
iLetter = writeCase(save_file,'UA - UB',offset,alphabeth,iLetter,stat.pairWiseDiffMedianIntBlCorr,howSmart);
iLetter = writeCaseNoSplit(save_file,' ',offset,alphabeth,iLetter,stat.pairWiseDiffMedianIntBlCorr,howSmart);

end

function iLetter = writedataNoHeader(save_file,alphabeth,iLetter,offset,stat,howSmart)

% median intensity
% allBefore
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.allBefore.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.allBefore.medianInt,howSmart);
% allAfter
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.allAfter.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.allAfter.medianInt,howSmart);
% unchBefore
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.unchangedBefore.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.unchangedBefore.medianInt,howSmart);
% unchAfter
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.unchangedAfter.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.unchangedAfter.medianInt,howSmart);
% lost
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.lost.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.lost.medianInt,howSmart);
% gained
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.gained.medianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.gained.medianInt,howSmart);

% Fraction : unchBefore - Pairwise
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseRatioMedianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseRatioMedianInt,howSmart);
% unchBefore - Pairwise BLeaching corrected
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseRatioMedianIntBlCorr,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseRatioMedianIntBlCorr,howSmart);

% Difference: unchBefore - Pairwise
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseDiffMedianInt,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseDiffMedianInt,howSmart);
% unchBefore - Pairwise BLeaching corrected
iLetter = writeCaseNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseDiffMedianIntBlCorr,howSmart);
iLetter = writeCaseNoSplitNoHead(save_file,offset,alphabeth,iLetter,stat.pairWiseDiffMedianIntBlCorr,howSmart);

end