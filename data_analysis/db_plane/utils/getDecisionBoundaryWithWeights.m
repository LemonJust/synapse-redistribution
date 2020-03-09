function cl = getDecisionBoundaryWithWeights(pointCloud_ga,pointCloud_lo,weight_ga,weight_lo,nSamples)
% uses provided pointclouds
%% SVM
% Sample
idx = [1:length(pointCloud_ga)];
idx_ga = datasample(idx,nSamples,'Replace',false);
idx = [1:length(pointCloud_lo)];
idx_lo = datasample(idx,nSamples,'Replace',false);
% Sample & label ga
pointCloud_anat_ga = pointCloud_ga(idx_ga,:);
weight_ga = weight_ga(idx_ga);
label_ga = ones(nSamples,1);
% Sample & label lo
pointCloud_anat_lo = pointCloud_lo(idx_lo,:);
weight_lo = weight_lo(idx_lo);
label_lo = ones(nSamples,1)*(-1);
% combine data
data = [pointCloud_anat_lo;pointCloud_anat_ga];
class = [label_lo;label_ga];
weight = [weight_lo;weight_ga];
%Train the SVM Classifier
box = 0.0012;
KernelFunction = 'linear';
cl = fitcsvm(data,class,'Weights',weight,'KernelFunction',KernelFunction,... %'PolynomialOrder',3,...
    'BoxConstraint',box,'ClassNames',[-1,1]);
%,'OptimizeHyperparameters','BoxConstraint'); %'BoxConstraint',box,

end