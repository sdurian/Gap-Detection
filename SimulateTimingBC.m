function [ITB, ITC, corr, mycells] = SimulateTimingBC(n, spikes, lambda1, lambda2, k1, k2)
%SIMULATETIMINGBC runs our model for gap timing detection task with options
%B and C

% INPUTS
% n = # neurons in population
% spikes = matrix of spike trains for 30 cells
% lambda1 = firing rate controlling bursts/s
% lambda2 = firing rate controlling spikes/burst
% k1 = renewal factor for bursting process
% k2 = renewal factor for spiking process

% OUTPUTS
% ITB = information train from ensemble spike train
% ITC = short ISI-flipped information train
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
dt2 = 0.001;
silence = zeros(1/dt2,n);
silence(end,:) = ones(1,n);
spikes = [spikes; silence; ones(1,n)];

% 4. Get information trains

% ITB
spikeind = [];
for i = 1:n
    spike_ind = find(spikes(:,i));
    spikeind = [spikeind; spike_ind];
end
spikeind = unique(spikeind);

% 2. fit isi dist to sum of gammas
isi = diff(spikeind);
[c, ~] = SumGamFit(isi, lambda1, lambda2, k1, k2);

% 3. Simulate stimulus
dt2 = 0.001;
spikeind = [spikeind; 1/dt2+size(spikes,1); 1/dt2+size(spikes,1)+1];

% 4. Get information train
isi = diff(spikeind);
isi = [spikeind(1); isi];
ITB = InfoTrain(c, isi);


% ITC
% 2. fit isi dist to sum of gammas
C = cell(1,n);
for i = 1:n
    spikeind = find(spikes(:,i));
    isi = diff(spikeind);
    [c, ~] = SumGamFit(isi, lambda1, lambda2, k1, k2);
    C{i} = c;
end

% 3. Simulate stimulus
dt2 = 0.001;
silence = zeros(1/dt2,n);
silence(end,:) = ones(1,n);
spikes = [spikes; silence; ones(1,n)];

% 4. Get information train
ITC = zeros(11001,n);

for i = 1:n
    spikeind = find(spikes(:,i));
    isi = diff(spikeind);
    isi = [spikeind(1); isi];
    ITC(:,i) = InfoTrainC(C{i}, isi);
end
ITC = sum(ITC, 2);
end