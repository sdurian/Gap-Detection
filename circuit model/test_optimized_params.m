%% test optimized parameters

%% load optimized params
load('output_uniformbounded_2.mat');
params = T{:,:};
error = params(:,end);
min_error_p = find(error==min(error));
best = params(min_error_p,1:end-1);  % don't include the error in the params;
%%
fr = 50; % Hz
duration = 10; % seconds
N = 1;
%[trn,timevec] = poissonSpikeGen(fr,duration,N);
fr = fr/1000; %convert to kHz
dt = 1; % ms
trn = rand(N,duration*10^3/dt) < fr*dt;
ALL_IT = [];


IT = make_infotrain(trn);
IT = rescale(IT);
diflen = length(trn) - length(IT);
zpad = zeros(1,diflen) + min(IT);
IT = [zpad IT];

disp('done making test train');
%%
tau_syn = best(1); %ms
R_I_halfmax = best(2);
R_I_slope = best(3);

I_D_halfmax = best(4);
I_D_slope = best(5);
tau_syn_ID = best(6); %ms

R_D_halfmax = best(7);
R_D_slope = best(8);

D = three_synapse_model_func_params(trn,tau_syn,R_I_halfmax,R_I_slope,I_D_halfmax,I_D_slope,tau_syn_ID,R_D_halfmax,R_D_slope);
D = rescale(D); % rescale since we just want to match the shape.


%% get the total mean squared error
total_dif = IT - D;
s = sqrt(total_dif.^2);
test_error = mean(s(:));

%% plot the model output and infotrain

figure;
hold on
plot(IT);
plot(D);
legend('infotrain','model output')
title(['mean squared error ' num2str(test_error)]);

fprintf('tau_syn = %f \n',best(1));
fprintf('R_I_halfmax = %f \n',best(2));
fprintf('R_I_slope = %f \n',best(3));
fprintf('I_D_halfmax = %f \n',best(4));
fprintf('I_D_slope = %f \n',best(5));
fprintf('tau_syn_ID = %f \n',best(6));
fprintf('R_D_halfmax = %f \n',best(7));
fprintf('R_D_slope = %f \n',best(8));
























%%