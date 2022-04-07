function IT = InfoTrain(c, isi)
% InfoTrain creates an information train from a neuron's spike train
% adapted from Mark Agrios' code

% INPUTS
% c = fitting function for log2 isi distribution (output of SumGamFit function)
% isi = ISI counts

% OUTPUTS
% IT = information train

x = 1:max(isi); % range of ISIs
y = -c(x); % self information (-log2(p(x), where c = log2(p))
mininfo = min(y); % baseline information
% by defn, baseline/minimum information corresponds with the most frequent ISI value
modeisi_ind = find(y == mininfo);
modeisi = x(modeisi_ind);
modeisi = round(modeisi);

IT = [];
for i = 1:length(isi)
    this_isi = isi(i);
    if this_isi == modeisi
        chunk = ones(1, this_isi)*mininfo;
        chunk = reshape(chunk,1,[]);
    elseif this_isi > modeisi
        nothing = ones(1,modeisi-1)*mininfo;
        [~, this_x] = min(abs(x-this_isi));
        something = y(modeisi_ind:this_x);
        chunk = [nothing something.'];
        chunk = reshape(chunk,1,[]);
    elseif this_isi < modeisi
        nothing = ones(1,this_isi-1)*mininfo;
        [~, this_x] = min(abs(x-this_isi));
        something = y(this_x);
        chunk = [nothing something.'];
        chunk = reshape(chunk,1,[]);
    end
    
    IT = [IT chunk];  
end

if length(IT)>11001
    IT = IT(1:11001);
end
IT(end) = mininfo;
end

