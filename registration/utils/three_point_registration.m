%% Get three points in pixels, go to physical space
function [TransformedPoints,Transform,scaleFactor] = three_point_registration(Pm,OffsetMoving,Pf,OffsetFixed,freeP1)
%Add space for the image 
    Pf(:,1) = Pf(:,1) + OffsetFixed;
    Pf(:,2) = Pf(:,2) + OffsetFixed;
    Pf(:,3) = Pf(:,3) + OffsetFixed;
%Add space for the image 
    Pm(:,1) = Pm(:,1) + OffsetMoving;
    Pm(:,2) = Pm(:,2) + OffsetMoving;
    Pm(:,3) = Pm(:,3) + OffsetMoving;
    
    Pmaf(:,1) = [Pm(:,1);1];
    Pmaf(:,2) = [Pm(:,2);1];
    Pmaf(:,3) = [Pm(:,3);1];
%Switch places for P1 and P2 in the code
if(freeP1 == 1)
    Switch = Pm(:,2);
    Pm(:,2) = Pm(:,3);
    Pm(:,3) = Switch;
    
    Switch = Pf(:,2);
    Pf(:,2) = Pf(:,3);
    Pf(:,3) = Switch;
end

%% Translate to origin:  Pm0 = Pf0 = 0
Zerf = Pf(:,1);
Zerm = Pm(:,1);
% create translation
Tm=[1 0 0 0; 0 1 0 0; 0 0 1 0; -Zerm(1),-Zerm(2),-Zerm(3),1];
Tm = Tm.';

Pm = Pm - Zerm;
Pf = Pf - Zerf;

%% Rotate Pm1 to Pf1 around 0:

axis = cross(Pm(:,2),Pf(:,2))/norm(cross(Pm(:,2),Pf(:,2))) ;
radians = acos(dot(Pm(:,2),Pf(:,2))/(norm(Pf(:,2))*norm(Pm(:,2))));
R1 = matrix_rotate(axis, radians);
Pm = R1*Pm;
Raf1 = eye(4,4);
Raf1(1:3,1:3) = R1;
%% Scale Pm1 to Pf1 : 
scaleFactor = norm(Pf(:,2))/norm(Pm(:,2));
S = eye(3)*scaleFactor;
Pm = S*Pm;
Saf = eye(4,4);
Saf(1:3,1:3) = S;
%% Rotate Pm2 to Pf2 (Rotate Planes):
axis = Pm(:,2)/norm(Pm(:,2));
normal_m= cross(Pm(:,2),Pm(:,3))/norm(cross(Pm(:,2),Pm(:,3))) ;
normal_f= cross(Pf(:,2),Pf(:,3))/norm(cross(Pf(:,2),Pf(:,3))) ;

crossProduct = cross(normal_m,normal_f)/norm(cross(normal_m,normal_f));
sign = (-1)^(norm(axis+crossProduct)<1); % direction of rotation
radians = sign*acos(dot(normal_m,normal_f));
R2 = matrix_rotate(axis, radians);
% Pm = R2*Pm;
Raf2 = eye(4,4);
Raf2(1:3,1:3) = R2;
%% Return to template space:
% Pm = Pm + Zerf;
% create translation
Tf=[1 0 0 0; 0 1 0 0; 0 0 1 0; Zerf(1),Zerf(2),Zerf(3),1];
Tf = Tf.'; % for columns

%% Combine tramsforms
Transform = Tf*Raf2*Saf*Raf1*Tm;
    Pmaf(:,1) = Transform*Pmaf(:,1);
    Pmaf(:,2) = Transform*Pmaf(:,2);
    Pmaf(:,3) = Transform*Pmaf(:,3);
   
TransformedPoints = Pmaf(1:3,1:3);

end

function R = matrix_rotate(axis, radians)
    %Produce rotation transform matrix about axis through origin.
    s = sin(radians);
    c = cos(radians);
    C = 1 - c;
    u = axis / norm(axis);
    x = u(1);
    y = u(2);
    z = u(3);
    R = [[ x*x*C + c,   x*y*C - z*s, x*z*C + y*s ];...
            [ y*x*C + z*s, y*y*C + c,   y*z*C - x*s ];...
            [ z*x*C - y*s, z*y*C + x*s, z*z*C + c   ]];
end