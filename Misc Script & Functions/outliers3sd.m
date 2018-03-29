%% remove outliers beyond 3SD
% Nikita Kuznetsov 01/27/2016
% assumes dataIn is in column format.
function dataOut = outliers3sd(dataIn)
    remU = find(dataIn>mean(dataIn)+3*std(dataIn));
    remL = find(dataIn<mean(dataIn)-3*std(dataIn));
    dataIn([remU; remL]) = NaN;
    dataOut = dataIn;
end