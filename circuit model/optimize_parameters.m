%% do fminsearch

%% test it once
tau_syn = 20; %ms
R_I_halfmax = .4;
R_I_slope = .2;

I_D_halfmax = .25;
I_D_slope = .03;
tau_syn_ID = 2; %ms

R_D_halfmax = 1.5;
R_D_slope = .4;

% run optimize_model onces
greg_params = [tau_syn,R_I_halfmax,R_I_slope,I_D_halfmax,I_D_slope,tau_syn_ID,R_D_halfmax,R_D_slope];
lower_bounds = [5,0.01,0.01,0.01,0.001,1,0.01,0.01];
upper_bounds = [50,Inf,Inf,Inf,Inf,20,Inf,Inf];
mse = run_model(greg_params)

%% do fminsearch once on gregs params
tic
% [p,mse] = fminsearch(@run_model,greg_params);
[p,mse] = fmincon(@run_model,greg_params,[],[],[],[],lower_bounds,upper_bounds) % constrains the params above the lower bounds
toc
%%
options.MaxFunEvals = 5000;
options.MaxIter = 5000;
nStarts = 100+1;
all_start_points = [];
params = [];
error = [];
for i=2:nStarts
    disp([i nStarts]);

    if(i==1)
        disp('starting with Gregs params');
        start_x = greg_params;
    else
        start_x = [rand_uniform_bounded(10,30); ...     % uniform random in (maybe biologically realistic) range
            rand_uniform_bounded(0.1,0.6); ...
            rand_uniform_bounded(0.05,0.4); ...
            rand_uniform_bounded(0.1,0.5); ...
            rand_uniform_bounded(0.001,0.01); ...
            rand_uniform_bounded(0.5,4); ...
            rand_uniform_bounded(0.5,3); ...
            rand_uniform_bounded(0.1,1.5)]';
    end

    all_start_points = [all_start_points; start_x];

%     [p,mse] = fminsearch(@run_model,start_x,options);
    [p,mse] = fmincon(@run_model,start_x,[],[],[],[],lower_bounds,[])

    params = [params; p];
    error = [error; mse];

end
disp('done!')

%
vnames = {'tau_syn','R_I_halfmax','R_I_slope','I_D_halfmax','I_D_slope', ...
    'tau_syn_ID','R_D_halfmax','R_D_slope','mean_squared_error'};


T = array2table([params error],'VariableNames',vnames);

disp('done making table!')

%% save output
save('output_uniformbounded_2.mat','T','all_start_points');
disp('saved!');











%%