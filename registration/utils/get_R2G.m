function r2gTrfm = get_R2G(fishID)
% finds the transform for fishID fish in the pre-computed transforms
%%
t = load('data\R2G.mat');
R2G = t.R2G;

for iTrfm = 2:length(R2G)
    if string(fishID)==string(R2G(iTrfm).ID)
        r2gTrfm = R2G(iTrfm).transforms(2).matrix;
        r2gTrfm(:,4) = [0 0 0 1];
    end
end
end