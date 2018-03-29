function [h0,h1] = plot_meanSD(Y)

% Copyright (C) 2014  Todd Pataky
% Version: M0.1 (2014/05/01)

[y,ys]    = deal(nanmean(Y,1), nanstd(Y,1));       
x         = 0:numel(y)-1;
h0        = plot(x, y, 'k-', 'linewidth', 2);
h1        = plot_errorcloud(y, ys);