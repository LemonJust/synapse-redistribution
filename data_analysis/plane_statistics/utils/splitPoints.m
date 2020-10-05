function [latSideIdx, medSideIdx] = splitPoints(pointCloud,SvmModel,flip)
% Returns indexes of points on lateral and medial sides of the db plane.
% db plane can be either of class ClassificationSVM or coefficients for
% plane equation.

if class(SvmModel) ==  "ClassificationSVM"
    [label,~] = predict(SvmModel,pointCloud);

    % wether or not to switch the med and lat sides
    if flip
        latSideIdx = find(label<0);
        medSideIdx = find(label>0);
    else
        latSideIdx = find(label>0);
        medSideIdx = find(label<0);
    end
else
    
    [a, b, c] = get3PointsOnPlane(pointCloud,SvmModel);
    classif = boolean(zeros(length(pointCloud),1));
    
    for iPoint = 1:length(pointCloud)
        my_db = ([b - a; c - a; pointCloud(iPoint,:) - a]);
        classif(iPoint) = det(my_db)<0;
    end
    
    % wether or not to switch the med and lat sides
    if flip
        medSideIdx = find(classif);
        latSideIdx = find(~classif);
    else
        medSideIdx = find(~classif);
        latSideIdx = find(classif);
    end
end



%% HELPER FUNCTIONS 
    function [a, b, c] = get3PointsOnPlane(pointCloud,SvmModel)
        
        xy1 = [max(pointCloud(:,1)) max(pointCloud(:,2))];
        z1 = (xy1*SvmModel.Beta(1:2) + SvmModel.Bias)/(-SvmModel.Beta(3));
        xy2 = [max(pointCloud(:,1)) min(pointCloud(:,2))];
        z2 = (xy2*SvmModel.Beta(1:2) + SvmModel.Bias)/(-SvmModel.Beta(3));
        xy3 = [min(pointCloud(:,1)) min(pointCloud(:,2))];
        z3 = (xy3*SvmModel.Beta(1:2) + SvmModel.Bias)/(-SvmModel.Beta(3));
        
        a = [xy1 z1];
        b = [xy2 z2];
        c = [xy3 z3];
    end
end