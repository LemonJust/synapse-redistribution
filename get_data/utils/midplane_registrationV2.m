function MidplaneAlignment = midplane_registrationV2(MidplanePoints,...
    bra_resolution,priorTransform,TPath,tem_resolution,Plotting)
% Registration
% Example input:
% Path = 'D:\TR01\RealData_All\Paleum_Habenula\Learners\';
% MPath = [Path,'\Midline_dot_pairs.csv'];
% assuming points are in pixels: will be multiplied by the resolution if
% read from file ('fileID'). If provided as 'points' - resolution is ignored
% bra_resolution = [0.52,0.52,0.4]; % resolution of the moving image
% Path = 'D:\TR01\RealData_Learners\Template\';
% TPath = [Path,'\Midline_dot_pairs_bin221.csv'];
% tem_resolution = [0.26,0.26,0.4];
% Plotting = 1;
% Output: 
% affine transformation matrix MidplaneAlignment for row vector [x y z 1]:
% (Fixed_vector = Moving_vector*MidplaneAlignment)



%if(InputType == 'fileID')
t = readtable(MidplanePoints);
points_m = [t.X,t.Y,t.Slice].*bra_resolution;

if ~isempty(priorTransform)
    points_m_4D = [points_m,ones(length(t.X),1)]*priorTransform;
    points_m = points_m_4D(:,1:3);
end

sf_m = fit([points_m(:,1),points_m(:,2)],points_m(:,3),'poly11');
%Plane_m = planeModel([sf_m.p10,sf_m.p01,-1,sf_m.p00]);
Plane_m.Normal = [sf_m.p10,sf_m.p01,-1];
% end
% if(InputType == 'points')
% points_m = MidplanePoints;
% sf_m = fit([points_m(:,1),points_m(:,2)],points_m(:,3),'poly11');
% %Plane_m = planeModel([sf_m.p10,sf_m.p01,-1,sf_m.p00]);
% Plane_m.Normal = [sf_m.p10,sf_m.p01,-1];
% end

t = readtable(TPath);
points_f = [t.X,t.Y,t.Z].*tem_resolution;
sf_f = fit([points_f(:,1),points_f(:,2)],points_f(:,3),'poly11');
%Plane_f = planeModel([sf_f.p10,sf_f.p01,-1,sf_f.p00]);
Plane_f.Normal = [sf_f.p10,sf_f.p01,-1];

%% Get rotation between the planes
normal_m = Plane_m.Normal;
normal_m = normal_m/norm(normal_m);
normal_f = Plane_f.Normal;
normal_f = normal_f/norm(normal_f);

radians = acos(dot(normal_m,normal_f));
%%
if (radians>(pi/2))
    normal_m = -normal_m;
    radians = acos(dot(normal_m,normal_f));
end
axis = cross(normal_m,normal_f);
axis = axis/norm(axis);
R = matrix_rotate(axis, radians);

normal_t = R*normal_m';
%% Determine plane intersection
A = [sf_m.p10 sf_m.p01;sf_f.p10 sf_f.p01];
D = [sf_m.p00;sf_f.p00];
XY = A\(-D);

% point where plains intersect
P_intersec = [XY(1),XY(2),0];

%% Output to create the transform:
TranslateToIntersec = eye(4);
TranslateToIntersec(4,1:3) = -P_intersec;

TranslateFromIntersec = eye(4);
TranslateFromIntersec(4,1:3) = P_intersec;

RotatePlanes = eye(4);
RotatePlanes(1:3,1:3) = R.';

MidplaneAlignment = TranslateToIntersec*RotatePlanes*TranslateFromIntersec;

if Plotting == 1
    % transform moving points
    %points_t = transpose(R*transpose(points_m - P_intersec)) + P_intersec;
    pointsAffine = ones(length(points_m(:,1)),4);
    pointsAffine(:,1:3) = points_m;
    pointsTransformed = pointsAffine*MidplaneAlignment;
    points_t = pointsTransformed(:,1:3);
    sf_t = fit([points_t(:,1),points_t(:,2)],points_t(:,3),'poly11');
  
    %% See the transformation
    % Plot planes
    
    % fixed plane
    figure
    p = plot3(points_f(:,1),points_f(:,2),points_f(:,3),'.',...
        'Color',[0 0.8 0.2],'MarkerSize',40);
    xlim([0 2048*tem_resolution(1)])
    ylim([0 700*tem_resolution(2)]) % 1000->> 2048
    zlim([0 510*tem_resolution(3)])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    hold on
    %m = plot(Plane_f,'Color',[0 0.7 0.3]);
    m = plot(sf_f);
    hold on
    alpha(m,.5)
    hold on
    % moving plane
    p2 = plot3(points_m(:,1),points_m(:,2),points_m(:,3),'.',...
        'Color',[0.2 0 0.8],'MarkerSize',40);
    hold on
    m2 = plot(sf_m);
    hold on
    alpha(m2,.5)
    hold on
    % transformed plane
    % Plane_t = planeModel([sf_t.p10,sf_t.p01,-1,sf_t.p00]);
    % m3 = plot(Plane_t,'Color',[1 0 0]);
    % alpha(m3,.5)
    % hold on
    p3 = plot3(points_t(:,1),points_t(:,2),points_t(:,3),'.',...
        'Color',[1 0 0],'MarkerSize',40);
    hold off
    
end
end

























