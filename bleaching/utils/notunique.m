function nUnique = notunique(input)
% From : https://www.mathworks.com/matlabcentral/answers/175086-finding-non-unique-values-in-an-array
% by:  Sean de Wolski on 4 Feb 2015

% Unique values
[~,idxu,idxc] = unique(input);
% count unique values (use histc in <=R2014b)
[count, ~, idxcount] = histcounts(idxc,numel(idxu));
% Where is greater than one occurence
idxkeep = count(idxcount)>1;
% Extract from input
nUnique = (unique(input(idxkeep,:)))';
end