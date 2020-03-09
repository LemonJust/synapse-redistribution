function cl = getDecisionBoundaryFromPointCloud(pointCloud_ga,pointCloud_lo,nSamples)
% uses provided pointclouds
    %% SVM
    newSVM = 1;
    if newSVM == 1
        % Sample & label ga
        pointCloud_anat_ga = datasample(pointCloud_ga,nSamples,1,'Replace',false);
        gainedSize = size(pointCloud_anat_ga);
        label_ga = ones(gainedSize(1),1);
        % Sample & label lo
        pointCloud_anat_lo = datasample(pointCloud_lo,nSamples,1,'Replace',false);
        lostSize = size(pointCloud_anat_lo);
        label_lo = ones(lostSize(1),1)*(-1);
        % combine data
        data = [pointCloud_anat_lo;pointCloud_anat_ga];
        class = [label_lo;label_ga];
        %Train the SVM Classifier
        box = 0.0012;
        KernelFunction = 'linear';
        cl = fitcsvm(data,class,'KernelFunction',KernelFunction,... %'PolynomialOrder',3,...
            'BoxConstraint',box,'ClassNames',[-1,1]);
        %,'OptimizeHyperparameters','BoxConstraint'); %'BoxConstraint',box,
    end
end