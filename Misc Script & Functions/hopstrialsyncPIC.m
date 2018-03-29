function hopstrialsyncPIC(oculusDisplacement,qualisysDisplacement,f,S,trial,setup)
%f = frames per trial
%S = start of oculus sync
%detemine the peaks in each of the data sets to use an 'event' to
%synchronize each trial
%this is necessary due to the variable sampling of the Oculus Rift
%choose time points that relate to the same event
%the two time series should appear to be line up or be on top of each other
%if the correct time points are chosen
%if the synchronization is off, the program allows the user to choose again
v = f-1;
oculusVelocity = diff(oculusDisplacement)*75;

max1 = max(oculusVelocity(S:end));
max1 = .75*max1;%set velocity threshold criterion at 75% of peak velocity

Peaks1 = 0;
PeakSize1 = [];
E = length(oculusVelocity);
T = E-2;
S = S+1;

for N = S:T;%runs through the data and finds peaks that are above the criterion value in oculus data
    if oculusVelocity(N-1)<oculusVelocity(N) && oculusVelocity(N+1)<oculusVelocity(N)&& oculusVelocity(N)>max1;
        Peaks1 = Peaks1+1;
        PeakPlace1(Peaks1) = N; %#ok<*AGROW>
        PeakSize1 = vertcat(PeakSize1,oculusVelocity(N));
    end
end

qualisysVelocity = diff(qualisysDisplacement)*75;

max2 = max(qualisysVelocity);
max2 = .75*max2;%set velocity threshold criterion at 75% of peak velocity

Peaks2 = 0;
PeakSize2 = [];
E = length(qualisysVelocity);
T = E-2;

for N = 2:T;%runs through the data and finds peaks that are above the criterion value in oculus data
    if qualisysVelocity(N-1)<qualisysVelocity(N) && qualisysVelocity(N+1)<qualisysVelocity(N)&& qualisysVelocity(N)>max2;
        Peaks2 = Peaks2+1;
        PeakPlace2(Peaks2) = N;
        PeakSize2 = vertcat(PeakSize2,qualisysVelocity(N));
    end
end

a = gt(Peaks1,Peaks2);%compares # of peaks found in each timeseries

if a==1%determines total peaks found as the largest # of peaks found in either time series
    totalPeaks = Peaks1;
else
    totalPeaks = Peaks2;
end

if setup==1
    scrsz = get(0,'ScreenSize');
    figure('Position',scrsz);
else
    set(gcf,'Position',[697 45 1214 964]);
end
y1 = [-100,150];%if necessary change axis limits to ensure all data is visible
t = v/75;
axis([0 t -150 150]);
Xaxes = ((1:v)/75);
plot(Xaxes,oculusVelocity(1:v),'b','linewidth',3);
hold on
plot(Xaxes,qualisysVelocity(1:v),'r','linewidth',3);
%Legend = {'Oculus','Qualisys'};
%legend(Legend,'Location','NorthEast','fontsize',30,'fontweight','bold','fontname','Gill Sans MT');
yLabel = strcat('Velocity (', sprintf('%c', char(176)),'s^{-1})');
ylabel(yLabel,'fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
xlabel('Time (s)','fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
title('Trial Synchronization','fontsize',55,'fontweight','bold','fontname','Gill Sans MT');
set(gca,'fontsize',50,'fontname','Gill Sans MT')
set(gca,'Ticklength',[0,0]);
box('off')
axis square
set(gcf, 'Visible','off');

for i = 1:1;%plots vertical lines on top of time series data to view time points that can be used for synchronization
    x2 = PeakPlace1(:,i);
    x1 = [(x2/75),(x2/75)];
    plot(x1,y1,'b-.','LineWidth',2);%time points from oculus data
    hold on
end

for i = 1:1;
    x2 = PeakPlace2(:,i);
    x1 = [(x2/75),(x2/75)];
    plot(x1,y1,'r:','LineWidth',2);%time points from qualisys data
    hold on
end

AllPeaks = {'Number','Oculus','Qualisys'};
AllPeaks(2:totalPeaks+1,1) = num2cell(1:totalPeaks);
AllPeaks(2:Peaks1+1,2) = num2cell(PeakPlace1');
AllPeaks(2:Peaks2+1,3) = num2cell(PeakPlace2');

oculusMeasurement(1:225) = 50;
qualisysMeasurement(1:225) = 75;
bottomLine = horzcat(nan(1,PeakPlace1(1,1)),oculusMeasurement);
bottomLine = horzcat(bottomLine,nan(1,f-length(bottomLine)-1));
topLine = horzcat(nan(1,PeakPlace2(1,1)),qualisysMeasurement);
topLine = horzcat(topLine,nan(1,f-length(topLine)-1));
plot(Xaxes,bottomLine,'k','linewidth',2);
plot(Xaxes,topLine,'k','linewidth',2);

plot((PeakPlace1(1,1)/75)+.2,50,'<k','MarkerSize',10,'MarkerFaceColor','k');
text((PeakPlace1(1,1)/75)+3,50,'Oculus Velocity Peaks','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');
plot((PeakPlace2(1,1)/75)+.2,75,'<k','MarkerSize',10,'MarkerFaceColor','k');
text((PeakPlace2(1,1)/75)+3,75,'Qualisys Velocity Peaks','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');

F=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(F); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path= pwd; %the folder where you want to put the file

name = char(strcat('Pre-sync',{' - '},num2str(trial),'.tiff'));
print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
close all;clc