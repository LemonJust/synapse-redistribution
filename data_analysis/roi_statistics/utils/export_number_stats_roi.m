function export_number_stats_roi(smartID,roi,stu,syn,save_file)

alphabeth = getletters();
[names,fish_subset,full_name] = get_smart_info(smartID,stu);

for iSubject = 1:length(fish_subset)
    iFish = fish_subset(iSubject);
    
    stat = get_totInt_totNum_intPerSyn_medianInt(syn,iFish,roi);
    
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
function [names,fish_subset,full_name] = get_smart_info(smartID,stu)
switch smartID
    case "LR"
        names = stu.Id.Learners;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "NL"
        names = stu.Id.Nonlearners;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "US"
        names = stu.Id.UStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "CS"
        names = stu.Id.CStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
    case "NS"
        names = stu.Id.NStim;
        [fish_subset,full_name] = chooseHowSmart(smartID, stu);
end
end


function stat = get_totInt_totNum_intPerSyn_medianInt(syn,iFish,roi)

[stat.lost.totInt,stat.lost.totNum,...
    stat.lost.intPerSyn,stat.lost.medianInt] = getRegionStatIndividualRoi(syn.lost,iFish,roi);

[stat.gained.totInt,stat.gained.totNum,...
    stat.gained.intPerSyn,stat.gained.medianInt] = getRegionStatIndividualRoi(syn.gained,iFish,roi);

[stat.allBefore.totInt,stat.allBefore.totNum,...
    stat.allBefore.intPerSyn,stat.allBefore.medianInt] = getRegionStatIndividualRoi(syn.allBefore,iFish,roi);

[stat.allAfter.totInt,stat.allAfter.totNum,...
    stat.allAfter.intPerSyn,stat.allAfter.medianInt] = getRegionStatIndividualRoi(syn.allAfter,iFish,roi);

end

function [totInt,totNum,intPerSyn,medianInt] = getRegionStatIndividualRoi(whichCase,iStudy,roi)

% returns: totInt,totNum,intPerSyn,medianInt
% total intensity 
% total number of synapses 
% intensity per synapse 
% median intensity 


%% get point cloud
pointCloud = whichCase.xyz_anat_mp{iStudy};
intensityCloud = whichCase.intensity_mp{iStudy};

assert(length(pointCloud(:,1))==length(intensityCloud),...
    'Coordinates and intensity arrays are different');

%% Split points 
[gaSideIdx_ab, loSideIdx_ab] = splitPointsRoi(pointCloud,roi);

%% Calculate stats 
% lateral : in the lateral ROI
totInt.lat = sum(intensityCloud(gaSideIdx_ab));
totNum.lat = length(gaSideIdx_ab);
medianInt.lat = median(intensityCloud(gaSideIdx_ab));
intPerSyn.lat = totInt.lat./totNum.lat;

% medial : in the medial ROI
totInt.med = sum(intensityCloud(loSideIdx_ab));
totNum.med = length(loSideIdx_ab);
medianInt.med = median(intensityCloud(loSideIdx_ab));
intPerSyn.med = totInt.med./totNum.med;

% all : in the whole fish, disregard the ROI 
totInt.all = sum(intensityCloud);
totNum.all = length(intensityCloud);
medianInt.all = median(intensityCloud);
intPerSyn.all = totInt.all./totNum.all;
end

function [latSideIdx, medSideIdx] = splitPointsRoi(pointCloud,rois)
% return the indexes of points inside different ROIs

if string(class(rois.lat.vtc))=="alphaShape"
    isin_lat = inShape(rois.lat.vtc,pointCloud);
    latSideIdx = find(isin_lat);
    
    isin_med = inShape(rois.med.vtc,pointCloud);
    medSideIdx = find(isin_med);
else
    isin_lat = inhull(pointCloud,rois.lat.ptc,rois.lat.vtc);
    latSideIdx = find(isin_lat);
    
    isin_med = inhull(pointCloud,rois.med.ptc,rois.med.vtc);
    medSideIdx = find(isin_med);
end
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












