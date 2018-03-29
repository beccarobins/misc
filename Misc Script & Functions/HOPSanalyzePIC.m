function HOPSanalyzePIC(plane,data,trials,trialInfo,setup,f)
%data is all timeseries data (both oculus and qualisys data)
v = f-1;%length of velocity timeseries
a = f-2;%length of acceleration timeseries

%hopsanalyzedisplacementPIC(plane,data,trials,setup,f);
%hopsanalyzevelocityPIC(plane,data,trials,setup,v);
hopsanalyzeaccelerationPIC(plane,data,trials,setup,a);
