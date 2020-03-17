function [idx,unp_from_idx,unp_to_idx] = uniqueNN(from_xyz, to_xyz)
% returns unique idx of nearest neighbours in to_xyz for each point in from_xyz , 
% for unpaired points idx = 0
% Anna 10/1/2019

[idx,distance] = knnsearch(to_xyz,from_xyz); %,'K',1); % To , From 
notUnique = notunique(idx);
from_idx = 1:length(from_xyz);
to_idx = 1:length(to_xyz);

for point = notUnique
    pot_pair_idx = from_idx(idx==point);
    dist = distance(idx==point);
    
    is_min_dist = (dist == min(dist));
    assert((sum(is_min_dist)==1),'Can not decide how to choose the true pair');
    
    unp_idx = pot_pair_idx(~is_min_dist);
    idx(unp_idx) = 0;
end

unp_from_idx = from_idx(idx == 0);
unp_to_idx = to_idx(~ismember(to_idx,idx));
       
end