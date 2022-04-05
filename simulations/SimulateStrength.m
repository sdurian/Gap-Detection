function [IT] = SimulateStrength(n, spikes_prestim, spikes_poststim, lambda1, lambda2, k1, k2)
%SIMULATESTRENGTH runs our model for gaplength detection task

% INPUTS
% n = # neurons in population
% spikes_prestim = matrix of spike trains during prestim
% spikes_poststim = matrix of spike trains after stimulus is presented
% lambda1 = firing rate controlling bursts/s
% lambda2 = firing rate controlling spikes/burst
% k1 = renewal factor for bursting process
% k2 = renewal factor for spiking process

% OUTPUTS
% IT = population information train

% 1. fit isi dist during prestim time to sum of gammas
C = cell(1,n);
for i = 1:n
    spikeind = find(spikes_prestim(:,i));
    isi = diff(spikeind);
    [c, ~] = SumGamFit(isi, lambda1, lambda2, k1, k2);
    C{i} = c;
end

% 2. Simulate stimulus
spikes = [spikes_prestim; spikes_poststim; ones(1,n)];

% 3. Get information train
IT = zeros(11001,n);

for i = 1:n
    spikeind = find(spikes(:,i));
    isi = diff(spikeind);
    isi = [spikeind(1); isi];
    IT(:,i) = InfoTrain(C{i}, isi);
end
IT = sum(IT, 2);
end

