clr
folder_name = uigetdir;
cd(folder_name)
name = [folder_name '\*\**.mat'];
files = rdir(name);
nFiles = length(files);

MainFilename = sprintf('HOPS-Data.xlsx');
Heading = {'Oculus','Qualisys'};
xlswrite(MainFilename,Heading,'SPSS-Pearsons','A1');
xlswrite(MainFilename,Heading,'SPSS-ICC','A1');

%deletesheet(folder_name,Filename)
warning('off','all');

excelFilePath = folder_name; % Current working directory.
sheetName = 'Sheet'; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(fullfile(excelFilePath, MainFilename)); % Full path is necessary!
% Delete sheets.
try
    % Throws an error if the sheets do not exist.
    objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
    objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;
    objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;
catch
    % Do nothing.
end
% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;
%movefile(strcat(pwd,Filename,folder_name));
%%
allData = [];
allOculusData = {};
allQualisysData = {};
allOculusPositionTrials = {};
allOculusMatchTrials = {};
allQualisysPositionTrials = {};
allQualisysMatchTrials = {};
angleSort = {};
positionMatch = {};
allPositionMatch = {};
subjectID = {};
diffData = {};
allIDmeanDataValid = {};
allIDmeanDataPosMatch = {};

allIDmeanConstantError = {};
allIDmeanAbsoluteError = {};
allIDmeanGainError = {};

allIDmeanConstantErrorPooled = {};
allIDmeanAbsoluteErrorPooled = {};
allIDmeanGainErrorPooled = {};

allIDsdConstantErrorPooled = {};
%%
for i = 1:nFiles
    filename = char({files(i,1).name});
    load(filename)
    
    subjectID(1:30,:) = cellstr(subject);
    
    specificAngle = [];
    for j = 1:30
        specificAngle = vertcat(specificAngle,oculusIntendedTrialAngles(j,2),oculusIntendedTrialAngles(j,2));
    end
    
    test = horzcat(specificAngle,QualvsOcul);
    test(:,4) = test(:,2)-test(:,3);%calculates constant (i.e., signed) error
    test(:,5) = abs(test(:,4));%calculates absolute error
    %diffData = horzcat(vertcat(subjectID,subjectID),num2cell(test));
    diffData = sortrows(test);
    diffData = diffData(:,4);
    
    for k = 1:6%calculates the mean differences between Oculus and Qualisys data
        meanData(k,:) = nanmean(diffData(1:10));
        diffData(1:10,:) = [];
    end
    
    meanData = meanData';
    IDmeanData = horzcat(subject,num2cell(meanData));
    allIDmeanDataValid = vertcat(allIDmeanDataValid,IDmeanData);%mean data for Oculus v Qualisys validity
    
    clearvars specificAngle test diffData meanData IDmeanData
    
    test = horzcat(oculusIntendedTrialAngles(:,2),qualisysTrialAngle,qualisysMatchAngle);
    test(:,4) = test(:,3)-test(:,2);%calculates constant (i.e., signed) error
    test(:,5) = abs(test(:,4));%calculates absolute error
    test(:,6) = (test(:,3)-test(:,2))./abs(test(:,1));%calculates gain error
    diffData = sortrows(test);
    diffDataPooled = sortrows(test);
    
    for k = 1:6
        meanConstantError(k,:) = nanmean(diffData(1:5,4));
        meanAbsoluteError(k,:) = nanmean(diffData(1:5,5));
        meanGainError(k,:) = nanmean(diffData(1:5,6));
        diffData(1:5,:) = [];
    end
    
    meanConstantError = meanConstantError';
    meanAbsoluteError = meanAbsoluteError';
    meanGainError = meanGainError';
    
    IDmeanConstantError = horzcat(subject,num2cell(meanConstantError));
    IDmeanAbsoluteError = horzcat(subject,num2cell(meanAbsoluteError));
    IDmeanGainError = horzcat(subject,num2cell(meanGainError));
    
    allIDmeanConstantError = vertcat(allIDmeanConstantError,IDmeanConstantError);
    allIDmeanAbsoluteError = vertcat(allIDmeanAbsoluteError,IDmeanAbsoluteError);
    allIDmeanGainError = vertcat(allIDmeanGainError,IDmeanGainError);
    
    diffDataPooled(:,1) = abs(diffDataPooled(:,1));
    diffDataPooled = sortrows(diffDataPooled);
    
    for k = 1:3
        meanConstantErrorPooled(k,:) = nanmean(diffDataPooled(1:10,4));
        meanAbsoluteErrorPooled(k,:) = nanmean(diffDataPooled(1:10,5));
        meanGainErrorPooled(k,:) = nanmean(diffDataPooled(1:10,6));
        
        sdConstantErrorPooled(k,:) = nanstd(diffDataPooled(1:10,4));
        
        diffDataPooled(1:10,:) = [];
    end
    
    meanConstantErrorPooled = meanConstantErrorPooled';
    meanAbsoluteErrorPooled = meanAbsoluteErrorPooled';
    meanGainErrorPooled = meanGainErrorPooled';
    
    sdConstantErrorPooled = sdConstantErrorPooled';
    
    IDmeanConstantErrorPooled = horzcat(subject,num2cell(meanConstantErrorPooled));
    IDmeanAbsoluteErrorPooled = horzcat(subject,num2cell(meanAbsoluteErrorPooled));
    IDmeanGainErrorPooled = horzcat(subject,num2cell(meanGainErrorPooled));
    
    IDsdConstantErrorPooled = horzcat(subject,num2cell(sdConstantErrorPooled));
    
    allIDmeanConstantErrorPooled = vertcat(allIDmeanConstantErrorPooled,IDmeanConstantErrorPooled);
    allIDmeanAbsoluteErrorPooled = vertcat(allIDmeanAbsoluteErrorPooled,IDmeanAbsoluteErrorPooled);
    allIDmeanGainErrorPooled = vertcat(allIDmeanGainErrorPooled,IDmeanGainErrorPooled);
    
     allIDsdConstantErrorPooled = vertcat(allIDsdConstantErrorPooled,IDsdConstantErrorPooled);
   
    
    %     allData = vertcat(allData,QualvsOcul);
    %     allOculusData = vertcat(allOculusData,oculusTrialAngle,oculusMatchAngle);
    %     allQualisysData = vertcat(allQualisysData,qualisysTrialAngle,qualisysMatchAngle);
    %     allOculusPositionTrials = vertcat(allOculusPositionTrials,oculusTrialAngle);
    %     allOculusMatchTrials = vertcat(allOculusMatchTrials,oculusMatchAngle);
    %     allQualisysPositionTrials = vertcat(allQualisysPositionTrials,qualisysTrialAngle);
    %     allQualisysMatchTrials = vertcat(allQualisysMatchTrials,qualisysMatchAngle);
    %     trialAngles = horzcat(subjectID,num2cell(oculusIntendedTrialAngles),num2cell(oculusTrialAngle),num2cell(qualisysTrialAngle));
    %     matchAngles = horzcat(subjectID,num2cell(oculusIntendedTrialAngles),num2cell(oculusMatchAngle),num2cell(qualisysMatchAngle));
    %     angleSort = vertcat(angleSort,trialAngles,matchAngles);
    %     positionMatch = horzcat(subjectID,num2cell(oculusIntendedTrialAngles),num2cell(qualisysTrialAngle),num2cell(qualisysMatchAngle));
    %     allPositionMatch = vertcat(allPositionMatch,positionMatch);
    
    clearvars meanAbsoluteError sdConstantError meanConstantError meanGainError diffData meanAbsoluteErrorPooled sdConstantErrorPooled meanConstantErrorPooled meanGainErrorPooled diffDataPooled
end

%sortHeading = {'Angle','Oculus','Qualisys','Difference','Mean'};
%sortAngle = horzcat(angleSort(:,1),angleSort(:,3),angleSort(:,4),angleSort(:,5));
%sortAngle = sortrows(angleSort,2);

% sorted20 = sortAngle(1:160,:);
% sorted20 = sortrows(sorted20,2);
% sorted39 = sortAngle(161:320,:);
% sorted39 = sortrows(sorted39,2);
% sorted57 = sortAngle(321:end,:);
% sorted57 = sortrows(sorted57,2);
% 
% functions = {'=B2-C2','=(B2+C2)/2'};
MainFilename = sprintf('HOPS-Data.xlsx');
% Sheet = 'SPSS-Pearsons';

heading = {'Subject','Left 57',' Left 39','Left 20','Right 20','Right 39','Right 57'};
% xlswrite(MainFilename,heading,'RMANOVA-Validity','A1');
% xlswrite(MainFilename,allIDmeanDataValid,'RMANOVA-Validity','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchConstError','A1');
xlswrite(MainFilename,allIDmeanConstantError,'RMANOVA-PosMatchConstError','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchAbsError','A1');
xlswrite(MainFilename,allIDmeanAbsoluteError,'RMANOVA-PosMatchAbsError','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchGainError','A1');
xlswrite(MainFilename,allIDmeanGainError,'RMANOVA-PosMatchGainError','A2');

heading = {'Subject','20',' 39','57'};
% xlswrite(MainFilename,heading,'RMANOVA-Validity','A1');
% xlswrite(MainFilename,allIDmeanDataValid,'RMANOVA-Validity','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchConstErrPooled','A1');
xlswrite(MainFilename,allIDmeanConstantErrorPooled,'RMANOVA-PosMatchConstErrPooled','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchConstErrPooled','F1');
xlswrite(MainFilename,allIDsdConstantErrorPooled,'RMANOVA-PosMatchConstErrPooled','F2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchAbsErrPooled','A1');
xlswrite(MainFilename,allIDmeanAbsoluteErrorPooled,'RMANOVA-PosMatchAbsErrPooled','A2');

xlswrite(MainFilename,heading,'RMANOVA-PosMatchGainErrPooled','A1');
xlswrite(MainFilename,allIDmeanGainErrorPooled,'RMANOVA-PosMatchGainErrPooled','A2');

% xlswrite(MainFilename,allData,Sheet,'A2');
% xlswrite(MainFilename,allData,'SPSS-ICC','A2');

% xlswrite(MainFilename,sortHeading,'Bland-Altman 20','A1');
% xlswrite(MainFilename,sortHeading,'Bland-Altman 39','A1');
% xlswrite(MainFilename,sortHeading,'Bland-Altman 57','A1');
% 
% xlswrite(MainFilename,functions,'Bland-Altman 20','D2');
% xlswrite(MainFilename,functions,'Bland-Altman 39','D2');
% xlswrite(MainFilename,functions,'Bland-Altman 57','D2');
% 
% xlswrite(MainFilename,sorted20,'Bland-Altman 20','A2');
% xlswrite(MainFilename,sorted39,'Bland-Altman 39','A2');
% xlswrite(MainFilename,sorted57,'Bland-Altman 57','A2');

% [h,p,ci,stats] = ttest2(allData(:,1),allData(:,2));
% [r,~] = size(allOculusData);
% group1(1:r,:)= 1;
% [r,~] = size(allQualisysData);
% group2(1:r,:) = 2;
%
% independentTtestData = vertcat(num2cell(allOculusData),num2cell(allQualisysData));
% independentTtestData = horzcat(vertcat(num2cell(group1),num2cell(group2)),independentTtestData);
% independentTtestData = vertcat({'Group','Data'},independentTtestData);
%
% xlswrite(MainFilename,independentTtestData,'SPSS-independentTtest','A1');

% sortHeading = {'Angle','Position Trial','Match Trial','Difference'};
% sortMatchPosition = sortrows(allPositionMatch,2);
% 
% sortedLeft57 = sortMatchPosition(1:40,:);
% sortedLeft39 = sortMatchPosition(41:80,:);
% sortedLeft20 = sortMatchPosition(81:120,:);
% 
% sortedRight20 = sortMatchPosition(121:160,:);
% sortedRight39 = sortMatchPosition(161:200,:);
% sortedRight57 = sortMatchPosition(201:240,:);
% 
% sortedLeft20 = sortrows(sortedLeft20,2);
% sortedLeft39 = sortrows(sortedLeft39,2);
% sortedLeft57 = sortrows(sortedLeft57,2);
% 
% sortedRight20 = sortrows(sortedRight20,2);
% sortedRight39 = sortrows(sortedRight39,2);
% sortedRight57 = sortrows(sortedRight57,2);
% 
% functions = {'=B2-C2'};
% xlswrite(MainFilename,sortHeading,'MatchPosition-Left20','A1');
% xlswrite(MainFilename,sortedLeft20,'MatchPosition-Left20','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Left20','D2');
% 
% xlswrite(MainFilename,sortHeading,'MatchPosition-Right20','A1');
% xlswrite(MainFilename,sortedRight20,'MatchPosition-Right20','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Right20','D2');
% 
% xlswrite(MainFilename,sortHeading,'MatchPosition-Left39','A1');
% xlswrite(MainFilename,sortedLeft39,'MatchPosition-Left39','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Left39','D2');
% 
% xlswrite(MainFilename,sortHeading,'MatchPosition-Right39','A1');
% xlswrite(MainFilename,sortedRight39,'MatchPosition-Right39','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Right39','D2');
% 
% xlswrite(MainFilename,sortHeading,'MatchPosition-Left57','A1');
% xlswrite(MainFilename,sortedLeft57,'MatchPosition-Left57','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Left57','D2');
% 
% xlswrite(MainFilename,sortHeading,'MatchPosition-Right57','A1');
% xlswrite(MainFilename,sortedRight57,'MatchPosition-Right57','A2');
% xlswrite(MainFilename,functions,'MatchPosition-Right57','D2');

% pearsonsR = corr(allData(:,1),allQualisysData(:,2));
% validityCorr = horzcat(cellstr(strcat('Pearson''','s r')),pearsonsR);
% xlswrite(MainFilename,validityCorr,Sheet,'D2');
% validityTtest = {'t-statistic',stats.tstat;'df',stats.df;'p-value',p};
% xlswrite(MainFilename,validityTtest,Sheet,'D4');

msgbox('HOPS Data Compiled');
clr