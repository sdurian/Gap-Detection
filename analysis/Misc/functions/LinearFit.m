function [gof] = LinearFit(x, y, a, b)
%LINEARFIT uses the parameters previously found from a linear least squares
%fit to find goodness of fit.

% INPUTS
% x = x data
% y = y data
% a = fitting parameter in y = ax+b
% b = fitting parameter in y = ax+b

% OUTPUTS
% gof = goodness of fit

[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Lower = [b a];
opts.Upper = [b a];

% Fit model to data.
[~, gof] = fit( xData, yData, ft, opts );


