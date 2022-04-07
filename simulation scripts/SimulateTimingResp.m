function [IT, corr, mycells] = SimulateTimingResp(r, n, spikes, lambda1, lambda2, k1, k2)
%SIMULATETIMINGRESP runs our model for gap timing detection task with less
%than 100% responsivity

% INPUTS
% r = proportion of cells responding
% n = # neurons in population
% spikes = matrix of spike trains for 30 cells
% lambda1 = firing rate controlling bursts/s
% lambda2 = firing rate controlling spikes/burst
% k1 = renewal factor for bursting process
% k2 = renewal factor for spiking process

% OUTPUTS
% IT = population information train from individual summed information trains
% corr = mean cross correlation between spike trains
% mycells = cells in population

% 1. Generate 10 s of background noise for the population of neurons
[spikes, corr, mycells] = RenewalStats(n, spikes);

% 2. fit isi dist to sum of gammas
C = cell(1,n);
for i = 1:n
    spikeind = find(spikes(:,i));
    isi = diff(spikeind);
    [c, ~] = SumGamFit(isi, lambda1, lambda2, k1, k2);
    C{i} = c;
end

% 3. Simulate stimulus
n_responsive = round(r*n);
n_unresponsive = n-n_responsive;
unresponsivespikes = RenewalProcess(n_unresponsive, 0.8, 0, lambda1, lambda2, k1, k2);
unresponsivespikes = unresponsivespikes(1:1000,:);

silence = zeros(1000,n_responsive);
silence(end,:) = ones(1,n_responsive);

stim_spikes = [unresponsivespikes silence];
spikes = [spikes; stim_spikes; ones(1,n)];

% 4. Get information train
IT = zeros(11001,n);

for i = 1:n
    spikeind = find(spikes(:,i));
    isi = diff(spikeind);
    isi = [spikeind(1); isi];
    IT(:,i) = InfoTrain(C{i}, isi);
end
IT = sum(IT, 2);
end