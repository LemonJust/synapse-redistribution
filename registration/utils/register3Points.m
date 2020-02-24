function ThreePoints = register3Points(fishID,previousTransform,plotting)
% Registers fish fishID to the Template fish 
% TEMPLATE_ImgZfDsy20180223B3_1_MMStack_Pos0_bin221 (rotated by 25deg) 
% using three points as landmarks
% applies previousTransform before performong the registration
%
% Shows a figure of the 3 points before and after the registration. 

% !!! Hardcoded:
% Template resolution in the physical space
Pf(:,1) = [700;704;191]'.*[0.26 0.26 0.4];
Pf(:,2) = [1233;1006;221]'.*[0.26 0.26 0.4];
Pf(:,3) = [765;1042;296]'.*[0.26 0.26 0.4];

Pm_row = getThreePoints(fishID,[],1);
if ~isempty(previousTransform)
    Pm_row = Pm_row*previousTransform;
end
Pm = Pm_row(:,1:3)';

[Pm,Transform,~] = three_point_registration(Pm,[0;0;0],Pf,[0;0;0],0);
ThreePoints = Transform.';

if plotting
    figure
    plot3(Pm(1,:),Pm(2,:),Pm(3,:),':b',Pm(1,:),Pm(2,:),Pm(3,:),'.b',Pf(1,:),Pf(2,:),Pf(3,:),'-.c',Pf(1,:),Pf(2,:),Pf(3,:),'.c','LineWidth',3,'Markersize',20);
    legend('Transformed','','Template','')
    xlabel('X, um')
    ylabel('Y, um')
    zlabel('Z, um')
end
end