function Img = read_nii3d(ProcessFile)
% it is a wrapper function for niftiread
% keeps the order of the exes xyz, not yxz as in niftiread

Img.img = permute(niftiread(ProcessFile),[2 1 3]); % by default YXZ, make XYZ
Img.nFrame = size(Img.img,3);    %# Get the number of z slices
Img.width = size(Img.img,1);
Img.height = size(Img.img,2);
end

