function FitColumn(filename,sheet,column,width)

True = 1;
False = 0;
xlCenter = -4108;

Excel=actxserver('excel.application');
Excel.DisplayAlerts = 0;
Workbooks = Excel.Workbooks;
Excel.Visible = 0; % if you want to see the excel file real time enter = 1;
filepath = fullfile([pwd,'\' filename]);
Workbook = Excel.Workbooks.Open(filepath);

ColumnCell = strcat(column,'1');

Sheet=Workbook.Sheets.Item(sheet);
Range=Sheet.Range(ColumnCell);
Range.ColumnWidth=width;

Workbook.Save;
Excel.Quit;