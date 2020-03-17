function [xyz,I] = getCoordAndI(fileName)
% a wrapper for readtable
    tp = readtable(fileName);
    xyz = [tp.X,tp.Y,tp.Z].*[0.26 0.26 0.4];
    I = tp.rawCore;
end