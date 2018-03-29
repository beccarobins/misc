clr
folder_name = uigetdir;
cd(folder_name)
name = [folder_name '\*\**.xlsx'];
files = rdir(name);
nFiles = length(files);

Filename = char({files(1,1).name});

Heading = {'Subject','Firm-Double-1','Firm-Double-2','Firm-Single-1','Firm-Single-2','Firm-Tandem-1','Firm-Tandem-2','Firm-Total-1','Firm-Total-2','Foam-Double-1','Foam-Double-2','Foam-Single-1','Foam-Single-2','Foam-Tandem-1','Foam-Tandem-2','Foam-Total-1','Foam-Total-2','BESS-Total-1','BESS-Total-2'};
spssHeading = {'Firm-Double-1','Firm-Double-2','Firm-Single-1','Firm-Single-2','Firm-Tandem-1','Firm-Tandem-2','Firm-Total-1','Firm-Total-2','Foam-Double-1','Foam-Double-2','Foam-Single-1','Foam-Single-2','Foam-Tandem-1','Foam-Tandem-2','Foam-Total-1','Foam-Total-2','BESS-Total-1','BESS-Total-2'};

Sheet1 = 'BESS-Becca-1';
Sheet2 = 'BESS-Appiah-1';
SheetA = 'Healthy';
SheetB = 'Concussed';
SheetC = 'Healthy-SPSS';
SheetD = 'Concussed-SPSS';

MainFilename = sprintf('BESS - ICC.xlsx');
warning('off','all');
xlswrite(MainFilename,Heading,SheetA,'A1');
xlswrite(MainFilename,Heading,SheetB,'A1');
xlswrite(MainFilename,spssHeading,SheetC,'A1');
xlswrite(MainFilename,spssHeading,SheetD,'A1');

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

healthydata = {};
healthyspss = [];
concusseddata = {};
concussedspss = [];

for i = 1:nFiles;
    Filename = char({files(i,1).name});
    [~,subjectinfo] = xlsread(Filename,'TARGET - Leg','B2');
    [A,B] = xlsfinfo(Filename);
    sheetValid1 = any(strcmp(B, Sheet1));
    sheetValid2 = any(strcmp(B, Sheet2));
    
    if sheetValid1==1&&sheetValid2==1
        data = xlsread(Filename,Sheet1,'B2:C6')';
        data1 = horzcat(data(1,1:4),data(2,1:4),data(1,5));
        data = xlsread(Filename,Sheet2,'B2:C6')';
        data2 = horzcat(data(1,1:4),data(2,1:4),data(1,5));
        
        data = [];
        for j = 1:9
            data = horzcat(data,data1(:,j)); %#ok<*AGROW>
            data = horzcat(data,data2(:,j));
        end
        
        type = strsplit(char(subjectinfo),{'1','2','3','4','5','6','7','8','9','0'});
        TF = strcmp(type(1,1),'H');
        
        if TF==1
            healthydata = vertcat(healthydata,horzcat(subjectinfo,num2cell(data)));
            healthyspss = vertcat(healthyspss,num2cell(data));
        else
            concusseddata = vertcat(concusseddata,horzcat(subjectinfo,num2cell(data)));
            concussedspss = vertcat(concussedspss,num2cell(data));
        end
    end
end

[numHealthy,~] = size(healthydata);
[numConcussed,~] = size(concusseddata);

HTF = isempty(healthydata);
CTF = isempty(concusseddata);

if HTF==1
    healthydata(1:19) = num2cell(nan);
end
if CTF==1
    concusseddata(1:19) = num2cell(nan);
end

HTF = isempty(healthyspss);
CTF = isempty(concussedspss);

if HTF==1
    healthyspss(1:18) = nan;
    healthyspss = num2cell(healthyspss);
end
if CTF==1
    concussedspss(1:18) = nan;
    concussedspss = num2cell(concussedspss);
end

xlswrite(MainFilename,healthydata,SheetA,'A2');
xlswrite(MainFilename,concusseddata,SheetB,'A2');

healthyspss = cell2mat(healthyspss)+1;
concussedspss = cell2mat(concussedspss)+1;
xlswrite(MainFilename,healthyspss,SheetC,'A2');
xlswrite(MainFilename,concussedspss,SheetD,'A2');

healthydata = cell2mat(healthydata(:,2:end));
concusseddata = cell2mat(concusseddata(:,2:end));

[r,~] = size(healthydata);
testData = isnan(healthydata);
sumData = sum(testData,2);%sums each row

for i = 1:r
    if sumData(i,:)>0
        healthydata(i,:) = [];
    end
end

[r,~] = size(concusseddata);
testData = isnan(concusseddata);
sumData = sum(testData,2);%sums each row

for i = 1:r
   if sumData(i,:)>0
       concusseddata(i,:) = [];
   end
end

c = [1,2;3,4;5,6;7,8;9,10;11,12;13,14;15,16;17,18;];

for h = 1:9
    
    M = healthydata(:,c(h,1):c(h,2));
    
    type = {'1-1';'1-k';'C-1';'C-k';'A-1';'A-k'};
    
    for i = 1:6
        Results(i,:) = ICC(M,char(type(i,:))); %#ok<*SAGROW>
    end
    
    iccResults(:,h) = Results;
    
end

Heading = {'ICC type','Firm-Double','Firm-Single','Firm-Tandem','Firm-Total','Foam-Double','Foam-Single','Foam-Tandem','Foam-Total','BESS-Total'};
iccResults = horzcat(type,num2cell(iccResults));
iccResults = vertcat(Heading,iccResults);

cell = strcat('A',num2str(numHealthy+3));
xlswrite(MainFilename,iccResults,SheetA,cell);

clearvars iccResults

for h = 1:9

    M = concusseddata(:,c(h,1):c(h,2));

    type = {'1-1';'1-k';'C-1';'C-k';'A-1';'A-k'};

    for i = 1:6
        Results(i,:) = ICC(M,char(type(i,:)));
    end

    iccResults(:,h) = Results;

end

iccResults = horzcat(type,num2cell(iccResults));
iccResults = vertcat(Heading,iccResults);

cell = strcat('A',num2str(numConcussed+3));
xlswrite(MainFilename,iccResults,SheetB,cell);
clearvars iccResults

msgbox('Import BESS Data into SPSS and run ICC analysis');
clr