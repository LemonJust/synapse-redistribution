function xyz2_corrected = correctDisplacement(xyz2,xyz1,idx) 
% gets the mode of the displacement between the paired points in xyz2 and
% xyz1 using the idx for pairing. Shifts xyz2 by the mode to correct for
% the overal shift. 
%
% returns shifter xyz2

dxdydz = [xyz2(:,1)-xyz1(idx,1),xyz2(:,2)-xyz1(idx,2),xyz2(:,3)-xyz1(idx,3)];
displacement = mode(dxdydz);
% correct for displacement
xyz2_corrected = xyz2-displacement;
end