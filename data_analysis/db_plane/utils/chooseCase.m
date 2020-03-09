function [whichCase,caseText,nCase] = chooseCase(theCase, syn)

    lost = syn.lost ;
    gained = syn.gained ;
    unchangedBefore = syn.unchangedBefore ;
    unchangedAfter = syn.unchangedAfter ;
    allBefore = syn.allBefore ;
    allAfter = syn.allAfter ;                       

    nCase = length(theCase);

    if (find(theCase =="lo"))
        whichCase = lost;
        caseText = 'lost';
    end
    if (find(theCase =="ga"))
        whichCase = gained;
        caseText = 'gained';
    end
    if (find(theCase =="ub"))
        whichCase = unchangedBefore;
        caseText = 'unchangedBefore';
    end
    if (find(theCase =="ua"))
        whichCase = unchangedAfter;
        caseText = 'unchangedAfter';
    end
    if (find(theCase =="ab"))
        whichCase = allBefore;
        caseText = 'allBefore';
    end
    if (find(theCase =="aa"))
        whichCase = allAfter;
        caseText = 'allAfter';
    end

end
