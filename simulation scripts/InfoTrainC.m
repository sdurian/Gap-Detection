function IT = InfoTrainC(c, isi)
% InfoTrainC creates an information train from a neuron's spike train,
% with negative deflections for short ISIs
% adapted from Mark Agrios' function

% INPUTS
% c = fitting function for log2 isi distribution (output of SumExpFit function)
% isi = ISI counts

% OUTPUTS
% IT = information train

x = 1:max(isi); % range of ISIs 
y = -c(x); % information (-log2(p(x), where c = log2(p))
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
        something = -1*something;
        chunk = [nothing something.'];
        chunk = reshape(chunk,1,[]);
    end
    
    IT = [IT chunk];  
end

IT = IT(1:11001);
IT(11001) = mininfo;
end

