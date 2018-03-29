function [currentTrialOculus,currentTrialQualisys] = HOPSmanualsync(oculusDisplacement,qualisysDisplacement)

max1 = max(oculusDisplacement);
max1 = .75*max1;

Peaks1 = 0;
PeakSize1 = [];
E = length(oculusDisplacement);
T = E-2;

for N = 2:T;
    if oculusDisplacement(N-1)<oculusDisplacement(N) && oculusDisplacement(N+1)<oculusDisplacement(N)&& oculusDisplacement(N)>max1;
        Peaks1 = Peaks1+1;
        PeakPlace1(Peaks1) = N; %#ok<*SAGROW>
        PeakSize1 = vertcat(PeakSize1,oculusDisplacement(N));
    end
end

max2 = max(qualisysDisplacement);
max2 = .75*max2;

Peaks2 = 0;
PeakSize2 = [];
E = length(qualisysDisplacement);
T = E-2;

for N = 2:T;
    if qualisysDisplacement(N-1)<qualisysDisplacement(N) && qualisysDisplacement(N+1)<qualisysDisplacement(N)&& qualisysDisplacement(N)>max2;
        Peaks2 = Peaks2+1;
        PeakPlace2(Peaks2) = N; %#ok<*SAGROW>
        PeakSize2 = vertcat(PeakSize2,qualisysDisplacement(N));
    end
end

a = gt(Peaks1,Peaks2);

if a==1
    totalPeaks = Peaks1;
else
    totalPeaks = Peaks2;
end

scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
MaxX = length(oculusDisplacement);
axis([min(0) max(MaxX) min(-20) max(30)]);
Xaxes = 1:MaxX;
y1 = [-20,70];
plot(Xaxes,oculusDisplacement,'b');
hold on
plot(Xaxes,qualisysDisplacement,'r');
Legend = {'Oculus','Qualisys'};
legend(Legend,'Location','NorthWest');
title('Choose 0 if no options are available');

for i = 1:Peaks1;
    x2 = PeakPlace1(:,i);
    x1 = [x2,x2];
    plot(x1,y1,'b:','LineWidth',2);
    hold on
end

for i = 1:Peaks2;
    x2 = PeakPlace2(:,i);
    x1 = [x2,x2];
    plot(x1,y1,'r:','LineWidth',2);
    hold on
end

AllPeaks = nan(totalPeaks+1,3);
AllPeaks = {nan,'Oculus','Qualisys'};
AllPeaks(2:totalPeaks+1,1) = num2cell(1:totalPeaks);
AllPeaks(2:Peaks1+1,2) = num2cell(PeakPlace1');
AllPeaks(2:Peaks2+1,3) = num2cell(PeakPlace2');

display(AllPeaks)

Question1 = input('Which sync time to use for Oculus data?\n');

Question2 = input('\nWhich sync time to use for Qualisys data?\n');

if Question1==0
    close all
    currentTrialQualisys = nan(2250,1);
    currentTrialOculus = nan(2250,1);
    
else
    syncOculusTime = PeakPlace1(1,Question1);
    syncQualisysTime = PeakPlace2(1,Question2);
    
    timediff = abs(syncQualisysTime-syncOculusTime);
    
    if syncQualisysTime>syncOculusTime
        qualisysSync = qualisysDisplacement(timediff:end);
        oculusSync = oculusDisplacement(1:end-timediff);
    else
        qualisysSync = qualisysDisplacement(1:end-timediff);
        oculusSync = oculusDisplacement(timediff:end);
    end
    
    currentTrialQualisys = vertcat(qualisysSync,nan(2250-length(qualisysSync),1));
    currentTrialOculus = vertcat(oculusSync,nan(2250-length(oculusSync),1));
    
    scrsz = get(0,'ScreenSize');
    figure('Position',scrsz);
    axis([min(0) max(MaxX) min(-10) max(50)]);
    %Xaxes = 1:1050;
    y1 = [-10,50];
    plot(Xaxes,currentTrialOculus,'b');
    hold on
    plot(Xaxes,currentTrialQualisys,'r');
    Legend = {'Oculus','Qualisys'};
    legend(Legend,'Location','NorthWest');
    title('I do not know what to put here yet');
    
    decision = input('Hit 1 to accept or 0 to reject\n');
    
    if decision==1
        currentTrialQualisys = vertcat(qualisysSync,nan(2250-length(qualisysSync),1));
        currentTrialOculus = vertcat(oculusSync,nan(2250-length(oculusSync),1));
        close all
    else
        close all
    end
    clc
end
