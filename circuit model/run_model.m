function mse = run_model(params)

tau_syn = params(1); %ms
R_I_halfmax = params(2);
R_I_slope = params(3);

I_D_halfmax = params(4);
I_D_slope = params(5);
tau_syn_ID = params(6); %ms

R_D_halfmax = params(7);
R_D_slope = params(8);

load('trainingset_ITs_50Hz.mat');
N = size(ALL_IT,1);

ALL_modelout = [];
for i=1:N

    trn = all_trains(i,:);
    D = three_synapse_model_func_params(trn,tau_syn,R_I_halfmax,R_I_slope,I_D_halfmax,I_D_slope,tau_syn_ID,R_D_halfmax,R_D_slope);
    D = rescale(D); % rescale since we just want to match the shape. 
    ALL_modelout = [ALL_modelout; D];

end

%% get the total mean squared error
total_dif = ALL_modelout - ALL_IT;
s = sqrt(total_dif.^2);
error = mean(s,2);


mse = mean(error);
% std_of_mse = std(error);



















end