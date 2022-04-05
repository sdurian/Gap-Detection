function [spikes, avgcorr, mycells] = RenewalStats(n, spikes)
% RENEWALSTATS subsamples spike trains from a population of cells to get a
% smaller population and computes statistics on it

% INPUTS
% n = # neurons in subpopulation
% spikes = matrix which holds spike trains for a larger population of cells

% OUTPUTS
% spikes = matrix which holds spike trains for each cell
% avgcorr = mean cross correlation between spike trains
% mycells = cells in subsampled population

N = size(spikes,2);
mycells = randperm(N,n); % choose n cells randomly
spikes = spikes(:,mycells); % get spike trains for those n cells

avgcorr = Correlation(spikes);
