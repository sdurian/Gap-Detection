function D_total = three_synapse_model_func_params(sp_train,tau_syn,R_I_halfmax,R_I_slope,I_D_halfmax,I_D_slope,tau_syn_ID,R_D_halfmax,R_D_slope)
%sp_train is a spike train in ms where 1s are spikes and 0s are silence
% set up params
% tau_syn = 20; %ms
% R_I_halfmax = .4;
% R_I_slope = .2;
% 
% I_D_halfmax = .25;
% I_D_slope = .03;
% tau_syn_ID = 2; %ms
% 
% R_D_halfmax = 1.5;
% R_D_slope = .4;

%synaptic drive
exp_win = exp(-[0:100]/tau_syn);
syn_train = conv(sp_train,exp_win,"full");
syn_train = syn_train(1:end-100);

% sigmoidal activation of R->I synapse
x_synapse_RI = linspace(0, max(syn_train),1000);
y_synapse_RI = sigmoid(x_synapse_RI,R_I_halfmax,R_I_slope);
I_activation = interp1(x_synapse_RI,y_synapse_RI,syn_train);

% sigmoidal activation of I->D synapse (inhibitory so 1 - sigmoid)
x_synapse_ID = linspace(0, 1, 1000);
y_synapse_ID = 1-sigmoid(x_synapse_ID,I_D_halfmax,I_D_slope);
exp_win_ID = exp(-[0:100]/tau_syn_ID);
D_activation_fromI = conv(interp1(x_synapse_ID,y_synapse_ID,I_activation), exp_win_ID, 'full');
D_activation_fromI = D_activation_fromI(1:end-100);

%% sigmoidal activation of R->D synapse
x_synapse_RD = linspace(0, max(syn_train),1000);
y_synapse_RD = sigmoid(x_synapse_RD,R_D_halfmax,R_D_slope);
D_activation_fromR = interp1(x_synapse_RD,y_synapse_RD,syn_train);

D_total = D_activation_fromR + D_activation_fromI;