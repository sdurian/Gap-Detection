function [error, reactiontime, gaplength] = Performance(IT, threshold)
%PERFORMANCE evaluates the performance of an information train on its
%error rate, reaction time, and gaplength resulting from a stimulus

% INPUTS
% IT = information train
% threshold = threshold on information

% OUTPUTS
% error = error rate (# errors/s)
% reactiontime = time it takes to detect stimulus (in ms)
% gaplength = duration of time from stimulus onset detection to offset
% detection

L = 10000; % length of background nested renewal process
stimtime = L+1; % time (in ms) that the stimulus was presented

[pks,locs] = findpeaks(IT, 'MinPeakHeight',threshold); % find peaks where information crosses the threshold
warning('off','all')

if isempty(pks) % if there are no peaks above threshold, failure = 1
    error = 1; 
    reactiontime = NaN;
    gaplength = NaN;
elseif locs(end) < stimtime % if there is no peak above threshold after stimulus is presented, failure = 1
    error = 1;
    reactiontime = NaN;
    gaplength = NaN;
else
    error = (length(pks)-1)/10; % otherwise, the failure rate is determined by the number of false crossings in the 10 s of background noise
    if IT(stimtime)>threshold % if information has already crossed the threshold by the time the stimulus is presented...
        reactiontime = 1; % reaction time is 1
        x1 = 1:1001;
        y1 = IT(stimtime:end);
        y2 = threshold*ones(1,1001);
        [xi,~] = polyxpoly(x1,y1,x1,y2); % find intersection
        secondcrossing = xi(1); % time at which IT next reaches threshold on the way down
        gaplength = secondcrossing-reactiontime;
    else
        x1 = 1:1001;
        y1 = IT(stimtime:end);
        y2 = threshold*ones(1,1001);
        [xi,~] = polyxpoly(x1,y1,x1,y2); % find intersection
        reactiontime = xi(1); % time at which IT first reaches threshold after stimulus is presented
        secondcrossing = xi(2); % time at which IT next reaches threshold on the way down
        gaplength = secondcrossing-reactiontime;
    end
end
end

