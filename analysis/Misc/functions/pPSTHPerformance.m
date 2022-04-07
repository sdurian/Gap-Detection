function [reactiontime, gapwidth] = pPSTHPerformance(PSTH)
%pPSTHPerformance evaluates the performance of an information train on its
%accuracy and reaction time to a stimulus

% INPUTS
% PSTH = filtered PSTH

% OUTPUTS
% reactiontime = time it takes to detect stimulus (in ms)

L = 10000; % length of background cox process
stimtime = L+1; % time (in ms) that the stimulus was presented
negPSTH = -1.*PSTH;
%threshold = max(negPSTH(n:L));
threshold = 0;

if negPSTH(stimtime)==threshold % if PSTH is aleady at 0 when the stimulus is presented...
    reactiontime = 1; % reaction time is 1
    x1 = 1:1001;
    y1 = negPSTH(stimtime:end);
    ind_zero = x1(y1==0); % indices at which PSTH is at 0
    difference = diff(ind_zero);    
    end_gap = find(difference>1,1);   
    gapwidth = ind_zero(end_gap)-ind_zero(1)+1;
else
    x1 = 1:1001;
    y1 = negPSTH(stimtime:end);
    ind_zero = x1(y1==0); % indices at which PSTH is at 0
    if isempty(ind_zero)
        reactiontime = NaN;
        gapwidth = NaN;
    elseif length(ind_zero)>=2
        reactiontime = ind_zero(1);
        difference = diff(ind_zero);    
        end_gap = find(difference>1,1);   
        gapwidth = ind_zero(end_gap)-ind_zero(1)+1;
    else
        reactiontime = ind_zero(1);
        gapwidth = NaN;
    end    
end
    
end