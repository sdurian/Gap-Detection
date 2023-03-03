function IT = make_infotrain(trn)

isi = diff(find(trn));


M = 250;
edges = [1:10 12:5:M]; % define bin edges with 1 ms precision for the first 10 ms and 5 ms precision for up to 250 ms
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
               'Lower',[0,0],... 
               'Upper',[10,100],...
               'Startpoint',[1,1]);
myfit = fittype('log2((l1^k1*x.^(k1-1).*exp(-l1.*x)./gamma(k1)))','options',s);

[c, gof] = fit(x,logy,myfit);

IT = InfoTrain(c,isi);

end