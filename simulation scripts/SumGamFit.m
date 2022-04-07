function [c] = SumGamFit(isi, lambda1, lambda2, k1, k2)
%SUMGAMFIT fits an ISI distribution to a weighted sum of gamma
%distributions
% We actually fit the log of the ISI distribution to the log of a sum
% of gammas 

% INPUTS
% isi = interspike intervals from a spike train
% lambda1 = firing rate controlling bursts/s
% lambda2 = firing rate controlling spikes/burst
% k1 = renewal factor for bursting process
% k2 = renewal factor for spiking process

% OUTPUTS
% c = fitting function (cfit object)

l1 = lambda1*0.001;
l2 = lambda2*0.1;

edges = [1:10 12:5:250]; % define bin edges with 1 ms precision for the first 10 ms and 5 ms precision for up to 250 ms
y = histcounts(isi, edges, 'Normalization', 'pdf'); % isi distribution we will fit to
logy = log2(y); % log isi distribution
x = mean([edges(1:end-1);edges(2:end)]);

% exclude -Inf values and reshape x and y into column vectors
keep = find(logy > -Inf);
logy = logy(keep);
x = x(keep);
logy = reshape(logy,[],1);
x = reshape(x,[],1);

s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0,0],... 
               'Upper',[1,10,10,100,10],...
               'Startpoint',[1,k1,k2,l1,l2]);
myfit = fittype('log2(a.*(l1^k1*x.^(k1-1).*exp(-l1.*x)./gamma(k1))+(1-a).*(l2^k2.*x.^(k2-1).*exp(-l2.*x)./gamma(k2)))','options',s);

[c, gof] = fit(x,logy,myfit);

end