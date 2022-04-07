function [spikes] = RenewalProcess(N, alpha1, alpha2, lambda1, lambda2, k1, k2)
% RENEWALPROCESS generates a nested renewal process with parameters lambda1 and
% lambda2, k1 and k2

% INPUTS
% N = # neurons in population
% alpha1 = population correlation between bursts (between 0 and 1)
% alpha2 = population correlation between spikes within bursts (between 0 and 1)
% lambda1 = firing rate controlling bursts/s
% lambda2 = firing rate controlling spikes/burst
% k1 = renewal factor for bursting process
% k2 = renewal factor for spiking process

% OUTPUTS
% spikes = matrix which holds spike trains for each cell


T = 10; % total time (in s) of our generated sequence
dt1 = 0.001; % set interval size = 0.01 s for burst sequence (10 ms precision for bursts)
dt2 = 0.0001; % set interval size = 0.001 s for spike sequence (1 ms precision for spikes)
L = T/dt1; % total length of burst and spike sequences

bursts = zeros(L, N); % preallocate matrix to hold burst trains for each cell
spikes = zeros(L, N); % preallocate matrix to hold spike trains for each cell

x1 = rand(L, 1); % generate L1 random numbers chosen uniformly between 0 and 1
y1 = rand(10^6, 1);

for cell = 1:N
    x2 = rand(L, 1);
    
    % with probability alpha1, choose uniform number from x1; with
    % probability 1-alpha1, choose uniform number from x2
    x = zeros(L,1);
    for j = 1:L
        x_test = rand(1,1);
        if x_test < alpha1
            x(j) = x1(j);
        else
            x(j) = x2(j);
        end
    end
        
    
    % Fill in bursts
    for i = 1:L
        if lambda1*dt1 > x(i) % if this condition holds...
            bursts(i,cell) = 1; % a burst occurs
        end
    end
    burst_ind = find(bursts(:,cell)); % indices at which a burst occurs
    
    % delete all but every k1-th spike
    burst_ind = burst_ind(mod(1:length(burst_ind),k1)==0);

    y2 = rand(10^6, 1);
    y = zeros(10^6,1);
    for j = 1:10^6
        y_test = rand(1,1);
        if y_test < alpha2
            y(j) = y1(j);
        else
            y(j) = y2(j);
        end
    end
    
    % For each burst, use a poisson process to generate a mini
    % spike train within it
    % Take each burst to be 10 ms long and simulate spikes inside it
    % if bursts overlap, simply overwrite the end of the previous burst
    % with the new burst
    
    withinburst_lambda = lambda2/0.01; % mean spikes/s inside of a burst
    spikeinburst = zeros(100,length(burst_ind));
    spikeinburst2 = zeros(10,length(burst_ind));
    for burst = 1:length(burst_ind)
        for i = 1:100
            if withinburst_lambda*dt2 > y(i+(burst-1)*100)
                spikeinburst(i,burst) = 1;
            end
        end
        % delete all but every k2-th spike
        spike_ind = find(spikeinburst(:,burst));
        spike_ind = spike_ind(mod(1:length(spike_ind),k2)==0);
        spike_ind = round(spike_ind./10); % convert to ms
        spike_ind = spike_ind(spike_ind>0); % spike ind must be greater than 0 ms
        spikeinburst2(spike_ind,burst) = ones(length(spike_ind),1);
    end
    
    % need to reshape spikeinburst into a spike train
    for burst = 1:length(burst_ind)-1
        spikes(burst_ind(burst):burst_ind(burst)+9,cell) = spikeinburst2(:,burst);
    end
end

spikes = spikes(1:L,:);