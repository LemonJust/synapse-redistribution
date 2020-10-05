function export_ratio_hist_rev(smartID,db,stu,syn,save_file)
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
mult = (100 + bleaching)/100;
cam_offset = 102;

lat_no_bl = [];
lat_bl = [];
med_no_bl = [];
med_bl = [];

for iLr = 1:length(who)
    iFish = who(iLr);

    cl = thirDb.intensity.cl{iLr};
    flip_class = thirDb.intensity.flip(iLr);
    
    % remove camera offset
    syn = subtractCameraOffset(syn,iFish,cam_offset);
    
    % combine intensity change for all the fish
    [latSideIdx, medSideIdx] = splitPoints(syn.unchangedBefore.xyz_anat_mp{iFish},cl,flip_class);
    
    % Pairwise devision
    % lateral
    unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx);
    unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(latSideIdx);
    lat_no_bl = [lat_no_bl;unchangedAfter./unchangedBefore];
    
    unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(latSideIdx)*mult;
    lat_bl = [lat_bl;unchangedAfter./unchangedBefore];
    
    % medial
    unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx);
    unchangedBefore = syn.unchangedBefore.intensity_mp{iFish}(medSideIdx);
    med_no_bl = [med_no_bl;unchangedAfter./unchangedBefore];
    
    unchangedAfter = syn.unchangedAfter.intensity_mp{iFish}(medSideIdx)*mult;
    med_bl = [med_bl;unchangedAfter./unchangedBefore];

end

t = table(lat_no_bl,lat_bl);
writetable(t,[save_file,'_lat.xlsx']);

t = table(med_no_bl,med_bl);
writetable(t,[save_file,'_med.xlsx']);


end

%% HELPER FUNCTIONS

function syn = subtractCameraOffset(syn,iFish,camOff)
% subtract camera offset 

syn.unchangedAfter.intensity_mp{iFish} = syn.unchangedAfter.intensity_mp{iFish} - camOff;
syn.unchangedBefore.intensity_mp{iFish} = syn.unchangedBefore.intensity_mp{iFish} - camOff;

end
