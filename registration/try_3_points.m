% 3 Point registration
% this example shows how to get a transformation based on the 3 points
% ThreePoints: resulting transformation (for row - vectors)
addpath('utils');

fishID = 'ImgZfDsy20190201B3'; 

plotting = true;
ThreePoints = register3Points(fishID,[],plotting);