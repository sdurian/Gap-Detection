function [fitresult, gof] = createFit2(fit_x, fit_y, all_x, all_y)
%CREATEFIT5(FIT_X,FIT_Y)
%  Create a fit.
%
%  Data for 'untitled fit 2' fit:
%      X Input : fit_x
%      Y Output: fit_y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 27-Jan-2022 12:20:29


%% Fit: 'untitled fit 2'.
[xData, yData] = prepareCurveData( fit_x, fit_y );
[xData2, yData2] = prepareCurveData( all_x, all_y );

% Set up fittype and options.
ft = fittype( 'a+(b/x^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.0942548625051298 0.0811247769061523];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
%{
figure;
x = 1:0.1:10;
semilogx(x, fitresult(x))
hold on
semilogx(xData2, yData2,'o' );
hold off
% Label axes
xlabel( 'lambda_s/lambda_b', 'Interpreter', 'none' );
ylabel( 'NRMSE', 'Interpreter', 'none' );
xlim([1 10])
ylim([0 0.4])
%}
