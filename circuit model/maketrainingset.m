%% make a training dataset with spike trains and their infotrains

fr = 50; % Hz
duration = 10; % seconds
N = 100;
%[trn,timevec] = poissonSpikeGen(fr,duration,N);
fr = fr/1000; %convert to kHz
dt = 1; % ms
all_trains = rand(N,duration*10^3/dt) < fr*dt;

ALL_IT = [];

%%
for i=1:N
    trn = all_trains(i,:);

    this_it = make_infotrain(trn);
    this_it = rescale(this_it);
    diflen = length(trn) - length(this_it);
    zpad = zeros(1,diflen) + min(this_it);
    this_it = [zpad this_it];
    ALL_IT = [ALL_IT; this_it];
end

%%
trainset_name = sprintf('trainingset_ITs_%dHz.mat',fr*1000);
save(trainset_name,'ALL_IT','all_trains');
disp('saved!');