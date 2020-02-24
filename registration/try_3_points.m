% 3 Point registration
% this example shows how to get a transformation based on the 3 points
% ThreePoints: resulting transformation (for row - vectors)
addpath('utils');

fishID = 'ImgZfZdu20180123A3'; 

plotting = true;
ThreePoints = register3Points(fishID,[],plotting);