function Exp_4_Plot_Displacement_SDCloud

Control = [];
Stroop = [];
Subtraction = [];

for k = 1:60;
    
    load('Participant');
    if k<=9
        load(['Exp_4_',Participant,'_0',num2str(k),'.mat']);
    elseif k>9
        load(['Exp_4_',Participant,'_',num2str(k),'.mat']);
    end
    
    TF = strcmp(TrialCondition(1,1),'Dummy Trial');
    
    if TF == 0
        TF = strcmp(TrialCondition(2,1),'Control');
        if TF == 1;
            Control = horzcat(Control,NormalizedData.TimeNormalized.HeadonPelvis.Yaw.Displacement);
        elseif TF == 0;
            TF = strcmp(TrialCondition(2,1),'Stroop');
            if TF == 1;
                Stroop = horzcat(Stroop,NormalizedData.TimeNormalized.HeadonPelvis.Yaw.Displacement);
            elseif TF == 0;
                Subtraction = horzcat(Subtraction,NormalizedData.TimeNormalized.HeadonPelvis.Yaw.Displacement);
            end
        end
    end
    clearvars -except Control Stroop Subtraction Participant
end
%%
ControlMean = mean(Control,2);
StroopMean = mean(Stroop,2);
SubtractionMean = mean(Subtraction,2);

ControlSD = std(ControlMean);
StroopSD = std(StroopMean);
SubtractionSD = std(SubtractionMean);

ControlPos = ControlMean+ControlSD;
ControlNeg = ControlMean-ControlSD;
StroopPos = StroopMean+StroopSD;
StroopNeg = StroopMean-StroopSD;
SubtractionPos = SubtractionMean+SubtractionSD;
SubtractionNeg = SubtractionMean-SubtractionSD;

scrsz = get(0,'ScreenSize');
figure('Position',scrsz);

plot(ControlMean,'k');
hold on
plot(ControlPos,(':k'));
plot(ControlNeg,(':k'));
plot(StroopMean,'r');
plot(StroopPos,':r');
plot(StroopNeg,':r');
plot(SubtractionMean,'b');
plot(SubtractionPos,':b');
plot(SubtractionNeg,':b');
Figure = gcf;
set(gcf,'visible','off')

rez=1200; %resolution (dpi) of final graphic
f=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(f); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path= pwd; %the folder where you want to put the file

name = strcat('Exp_4_',Participant,'_MeanSDPlot','.png');
print(f,fullfile(path,name),'-dpng','-r0','-zbuffer'); %save file


beep
msgbox('Exp_4_Plot_FastPhases Script Complete');
clear
clc

Source = pwd;
Destination = strrep(Source,'MATLAB','Figures');
movefile(strcat(Source,'/*.png'),Destination);
clear
clc