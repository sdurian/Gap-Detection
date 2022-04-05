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

%{
% find FWHM of mean cross-correlation function
spikes2 = zeros(L, N); % preallocate matrix to hold spikes-mean of each column
for cell = 1:N
    spikes2(:,cell) = spikes(:,cell) - mean(spikes(:,cell)); % subtract mean of each column
end
[c,lags] = xcorr(spikes2, 100, 'normalized'); % find cross-correlations

% remove columns which hold autocorrelations
auto_col = zeros(1,N);
for i = 1:N
    auto_col(i) = N*(i-1)+i;
end
keep_col = setdiff(1:N^2,auto_col);
c = c(:,keep_col);
c = mean(c,2); % average across cells
HM = max(c)/2; % half max

% find all local minima of abs(c-HM)
TF = islocalmin(abs(c-HM));
lmin = find(TF);
% now find the local minima which are closest to zero lag
zerolag = find(lags == 0);
[~,HMind]=min(abs(lmin-zerolag));
HMind = lmin(HMind);
FWHM = abs(zerolag-HMind)*2;
%}
end

