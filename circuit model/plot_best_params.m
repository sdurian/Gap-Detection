%% plot model and IT for the best parameters

load('output_uniformbounded.mat');
params = T{:,:};
%%
error = params(:,end);
min_error_p = find(error==min(error));

best = params(min_error_p,1:end-1);  % don't include the error in the params;
test = params(1,1:end-1);
%%
mse = run_model(best)

%%













%%