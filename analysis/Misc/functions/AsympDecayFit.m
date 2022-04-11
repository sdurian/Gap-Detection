function [fitresult, gof] =  AsympDecayFit(fit_x, fit_y)
% ASYMPDECAYFIT fits the data using an asymptotically decaying function.

% INPUTS
% fit_x = x data to fit
% fit_y = y data to fit

% OUTPUTS
% fitresult = fitting result
% gof = goodness of fit

[xData, yData] = prepareCurveData( fit_x, fit_y );

% Set up fittype and options.
ft = fittype( 'a+(b/x^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.0942548625051298 0.0811247769061523];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

