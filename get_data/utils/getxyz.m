function [lost,gained,unchangedBefore,unchangedAfter,allBefore,allAfter] = getxyz(table,nStudies,lostId,gainedId,unchangedId)

unchangedAfter.xyz = cell(nStudies,1);
lost.xyz = cell(nStudies,1);
gained.xyz = cell(nStudies,1);
unchangedBefore.xyz = cell(nStudies,1);
allBefore.xyz = cell(nStudies,1); 
allAfter.xyz = cell(nStudies,1); 

for iStudy = 1:nStudies 

    allBeforeId = [lostId{iStudy};unchangedId{iStudy}];
    allAfterId = [gainedId{iStudy};unchangedId{iStudy}];
    
    % get [x,y,z,I] 
    uA = getUnique(table,unchangedId{iStudy},1);
    uB = getUnique(table,unchangedId{iStudy},0);
    aA = getUnique(table,allAfterId,1);
    aB = getUnique(table,allBeforeId,0);
    ga = getUnique(table,gainedId{iStudy},1);
    lo = getUnique(table,lostId{iStudy},0);
    
    % get coordinates (multiply by resolution here if needed ...
    allBefore.xyz{iStudy} = aB(:,1:3);    
    allAfter.xyz{iStudy} = aA(:,1:3); 
    unchangedAfter.xyz{iStudy} = uA(:,1:3);   
    lost.xyz{iStudy} = lo(:,1:3);     
    gained.xyz{iStudy} = ga(:,1:3);     
    unchangedBefore.xyz{iStudy} = uB(:,1:3); 
    
    % get intensity
    allBefore.intensity{iStudy} = aB(:,4);    
    allAfter.intensity{iStudy} = aA(:,4); 
    unchangedAfter.intensity{iStudy} = uA(:,4);   
    lost.intensity{iStudy} = lo(:,4);     
    gained.intensity{iStudy} = ga(:,4);     
    unchangedBefore.intensity{iStudy} = uB(:,4);    
end

end
    function data = getUnique(table,indeces,after)
        if after == 0
            data = [table.x1(indeces),table.y1(indeces),table.z1(indeces),table.core1(indeces)];
            data = unique(data,'rows');
        end
        if after == 1
            data = [table.x2(indeces),table.y2(indeces),table.z2(indeces),table.core2(indeces)];
            data = unique(data,'rows');
        end
    end









