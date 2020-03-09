function subset = get_subset(idx,iSkip)
% returns a subset 
% without the element at position iSkip

useFish = ones(size(idx));
useFish(iSkip) = 0;
subset = idx(logical(useFish));

end