function [lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = ...
    getxyzAnat(lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter)

%TFile = 'D:\TR01\RealData_All\Template\TEMPLATE_ImgZfDsy20180223B3_1_MMStack_Pos0_bin221.tif';
TMidplaneFile = 'D:\TR01\RealData_All\Template\Midline_dot_pairs_bin221.csv';
YZPath = 'D:\TR01\RealData_All\Template\planeYZ.csv';
Tresolution = [0.52 0.52 0.4];
MidplaneAlignment = midplane_registrationV2(TMidplaneFile,Tresolution,[],YZPath,Tresolution,0)
%%
nStudies = length(allBefore.xyz);
for iStudy = 1:nStudies
    % get coordinates (multiply by resolution here if needed ...
    allBefore.xyz_anat{iStudy} = rotate2yz(allBefore.xyz{iStudy},MidplaneAlignment);
    allAfter.xyz_anat{iStudy} = rotate2yz(allAfter.xyz{iStudy},MidplaneAlignment);
    unchangedAfter.xyz_anat{iStudy} = rotate2yz(unchangedAfter.xyz{iStudy},MidplaneAlignment);
    lost.xyz_anat{iStudy} = rotate2yz(lost.xyz{iStudy},MidplaneAlignment);
    gained.xyz_anat{iStudy} = rotate2yz(gained.xyz{iStudy},MidplaneAlignment);
    unchangedBefore.xyz_anat{iStudy} = rotate2yz(unchangedBefore.xyz{iStudy},MidplaneAlignment);
end

    function rotatedPoints = rotate2yz(pointsXYZ,MidplaneAlignment)
        whichCase_anat = [pointsXYZ,...
        ones(length(pointsXYZ(:,1)),1)]*MidplaneAlignment;
        rotatedPoints  = whichCase_anat(:,1:3);
    end
end










