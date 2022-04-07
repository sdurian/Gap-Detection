function [avgcorr] = Correlation(spikes)
% Correlation computes mean cross-correlation between spike trains in
% "spikes"

% INPUTS
% spikes = spike matrix

% OUTPUTS
% avgcorr = average cross correlation between spike trains

N = size(spikes,2);

spikes2 = reshape(sum(reshape(spikes,2,[])),[],N); % measure cross-correlations with 2 ms binning

corr = corrcoef(spikes2);
for i = 1:N
    corr(i,i) = NaN;
end
avgcorr = mean(corr,'all','omitnan');

end

