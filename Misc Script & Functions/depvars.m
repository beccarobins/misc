function [Analysis] = depvars(data)

Analysis.Mean = mean(data);
Analysis.Median = median(data);
Analysis.Mode = mode(data);
Analysis.Min = min(data);
Analysis.Max = max(data);
Analysis.Range = Analysis.max-Analysis.min;
Analysis.STD = std(data);
Analysis.STE = ste(data);
Analysis.CI = ci(data);
Analysis.CV = cv(data);
Analysis.IQR = iqr(data);
Analysis.RMS = rms(data);

end
