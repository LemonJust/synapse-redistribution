function plotDecisionBoundary(data,cl,varargin)
% by AN
% calulate and plot the surface : calculate 4 points laying on the plain 
% and in the max min region of the data from the surface eq. and plot DB

defaultColor = [1 1 1];
defaultAlpha = 0.5;

p = inputParser;
classes = {'numeric'};
attributes = {'ncols', 3};
addRequired(p,'data',@(x) validateattributes(x,classes,attributes));
addRequired(p,'cl',@(x) or(and(isfield(x,'Bias'),isfield(x,'Beta')),isa(x,'ClassificationSVM'))); %
addParameter(p,'Color',defaultColor,@(x) validateattributes(x,classes,attributes));
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addParameter(p,'FaceAlpha',defaultAlpha,validScalarPosNum);

parse(p,data,cl,varargin{:});

cl = p.Results.cl;
data = p.Results.data;

% these are all to make sure the boundary looks good and not too stretched
% based on xy
xy1 = [max(data(:,1)) max(data(:,2))];
z1 = (xy1*cl.Beta(1:2) + cl.Bias)/(-cl.Beta(3));
xy2 = [max(data(:,1)) min(data(:,2))];
z2 = (xy2*cl.Beta(1:2) + cl.Bias)/(-cl.Beta(3));
xy3 = [min(data(:,1)) min(data(:,2))];
z3 = (xy3*cl.Beta(1:2) + cl.Bias)/(-cl.Beta(3));
xy4 = [min(data(:,1)) max(data(:,2))];
z4 = (xy4*cl.Beta(1:2) + cl.Bias)/(-cl.Beta(3));

zRange = max([z1,z2,z3,z4]) - min([z1,z2,z3,z4]);
% based on xz
xz1 = [max(data(:,1)) max(data(:,3))];
y1 = (xz1*cl.Beta([1,3]) + cl.Bias)/(-cl.Beta(2));
xz2 = [max(data(:,1)) min(data(:,3))];
y2 = (xz2*cl.Beta([1,3]) + cl.Bias)/(-cl.Beta(2));
xz3 = [min(data(:,1)) min(data(:,3))];
y3 = (xz3*cl.Beta([1,3]) + cl.Bias)/(-cl.Beta(2));
xz4 = [min(data(:,1)) max(data(:,3))];
y4 = (xz4*cl.Beta([1,3]) + cl.Bias)/(-cl.Beta(2));

yRange = max([y1,y2,y3,y4]) - min([y1,y2,y3,y4]);
% based on yz
yz1 = [max(data(:,2)) max(data(:,3))];
x1 = (yz1*cl.Beta(2:3) + cl.Bias)/(-cl.Beta(1));
yz2 = [max(data(:,2)) min(data(:,3))];
x2 = (yz2*cl.Beta(2:3) + cl.Bias)/(-cl.Beta(1));
yz3 = [min(data(:,2)) min(data(:,3))];
x3 = (yz3*cl.Beta(2:3) + cl.Bias)/(-cl.Beta(1));
yz4 = [min(data(:,2)) max(data(:,3))];
x4 = (yz4*cl.Beta(2:3) + cl.Bias)/(-cl.Beta(1));

xRange = max([x1,x2,x3,x4]) - min([x1,x2,x3,x4]);

if min([zRange,yRange,xRange])==zRange
    patch([xy1(1),xy2(1),xy3(1),xy4(1)],...
        [xy1(2),xy2(2),xy3(2),xy4(2)],[z1,z2,z3,z4],p.Results.Color,'EdgeColor','none','FaceAlpha',p.Results.FaceAlpha);
elseif min([zRange,yRange,xRange])==yRange
    patch([xz1(1),xz2(1),xz3(1),xz4(1)],...
        [y1,y2,y3,y4],[xz1(2),xz2(2),xz3(2),xz4(2)],p.Results.Color,'EdgeColor','none','FaceAlpha',p.Results.FaceAlpha);
else
    patch([x1,x2,x3,x4],[yz1(1),yz2(1),yz3(1),yz4(1)],...
        [yz1(2),yz2(2),yz3(2),yz4(2)],p.Results.Color,'EdgeColor','none','FaceAlpha',p.Results.FaceAlpha);
end

end