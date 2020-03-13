function plot_ptc(ptc,varargin)
% a wrapper for plot3 fo pointclouds

   defaultColor = [1 1 1];
   defaultMarkerSize = 5;

   p = inputParser;
   classes = {'numeric'};
   attributes = {'ncols', 3};
   addRequired(p,'ptc',@(x) validateattributes(x,classes,attributes));
   addParameter(p,'Color',defaultColor,@(x) validateattributes(x,classes,attributes));
   validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
   addParameter(p,'MarkerSize',defaultMarkerSize,validScalarPosNum);
   
   parse(p,ptc,varargin{:});

plot3(p.Results.ptc(:,1),p.Results.ptc(:,2),p.Results.ptc(:,3),...
    '.','Color',p.Results.Color,'MarkerSize',p.Results.MarkerSize);

end