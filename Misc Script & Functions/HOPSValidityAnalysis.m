clr
folder_name = uigetdir; %select participant folder
cd(folder_name)

subject = strsplit(folder_name,'\');%subject name generated from folder
subject = char(subject(:,end));
subject = char(strsplit(subject,'_'));

%%import oculus data
filename = strcat('HOPS1_',subject,'_Yaw.txt');%import Oculus yaw data
oculusData = importdata(filename);
oculusYaw = -oculusData.data(:,2);%import Oculus yaw time series
oculusYawTime = oculusData.data(:,5);%import Oculus yaw time stamps

filename = strcat('HOPS1_',subject,'_Pitch.txt');%import Oculus pitch data
oculusData = importdata(filename);
oculusPitch = -oculusData.data(:,1);%import Oculus pitch time series
oculusPitchTime = oculusData.data(:,5);%import Oculus pitch time stamps

filename = strcat('HOPS1_',subject,'_Roll.txt');%import Oculus time series
oculusData = importdata(filename);
oculusRoll = oculusData.data(:,3);%import Oculus roll time series
oculusRollTime = oculusData.data(:,5);%import Oculus roll time stamps

%%import oculus bookmarks (include information about trial angles)
delimiter = ' ';%necessary information to import oculus bookmarks tsv file
startRow = 2;
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';

filename = strcat('HOPS1_',subject,'_YawBOOKMARKS.txt');%yaw bookmarks
fileID = fopen(filename,'r');
bookmarksDataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
a = bookmarksDataArray{1,2}(2:end,1);
oculusYawMarks=zeros(size(a,1),size(a,2)); %#ok<*PREALL>
oculusYawMarks=str2double(a);
oculusYawStart = bookmarksDataArray{1,1}(1,1);
oculusYawTimeStamps = bookmarksDataArray{1,1}(2:end,1);
%%
filename = strcat('HOPS1_',subject,'_PitchBOOKMARKS.txt');%pitch bookmarks
fileID = fopen(filename,'r');
bookmarksDataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
a = bookmarksDataArray{1,2}(2:end,1);
oculusPitchMarks=zeros(size(a,1),size(a,2));
oculusPitchMarks=str2double(a);
oculusPitchStart = bookmarksDataArray{1,1}(1,1);
oculusPitchTimeStamps = bookmarksDataArray{1,1}(2:end,1);

filename = strcat('HOPS1_',subject,'_RollBOOKMARKS.txt');%roll bookmarks
fileID = fopen(filename,'r');
bookmarksDataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
a = bookmarksDataArray{1,2}(2:end,1);
oculusRollMarks=zeros(size(a,1),size(a,2));
oculusRollMarks=str2double(a);
oculusRollStart = bookmarksDataArray{1,1}(1,1);
oculusRollTimeStamps = bookmarksDataArray{1,1}(2:end,1);

%%import qualisys data
delimiter = '\t';%necessary information to import qualisys tsv file
startRow = 12;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

filename = strcat(subject,'_Yaw_6D.tsv');%import Qualisys yaw time series
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
qualisysYaw = dataArray{:,8};

filename = strcat(subject,'_Pitch_6D.tsv');%import Qualisys pitch time series
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
qualisysPitch = dataArray{:,6};

filename = strcat(subject,'_Roll_6D.tsv');%import Qualisys roll time series
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
qualisysRoll = -dataArray{:,7};

clearvars -except oculusPitch oculusPitchMarks oculusPitchStart oculusPitchTime oculusPitchTimeStamps oculusRoll oculusRollMarks oculusRollStart oculusRollTime oculusRollTimeStamps oculusYaw oculusYawMarks oculusYawStart oculusYawTime oculusYawTimeStamps qualisysPitch qualisysRoll qualisysYaw subject

%%sync Qualisys and Oculus data
warning('off'); %#ok<*WNOFF>
qualisysYaw = qualisysYaw(1:1.3333:end);%subsample Qualisys data from 100Hz to 75Hz
[~,maxQualisysTime] = max(qualisysYaw(1:1700));%search for position peak in ROM test (Qualisys)
[~,maxOculusTime] = max(oculusYaw(1:5000));%search for position peak in ROM test (Oculus)
qualisysSync = qualisysYaw(maxQualisysTime:end);%cuts Qualisys data from ROM peak to end
oculusSync = oculusYaw(maxOculusTime:end);%cuts Oculus data from ROM peak to end
qualisysLength = length(qualisysSync);
oculusLength = length(oculusSync);

TF = gt(qualisysLength,oculusLength);%compares data lengths to cut the longer time series for further comparison

if TF==1
    qualisysData = qualisysSync(1:oculusLength);
    oculusData = oculusSync(1:oculusLength);
else
    qualisysData = qualisysSync(1:qualisysLength);
    oculusData = oculusSync(1:qualisysLength);
end

yawStart = str2double(oculusYawStart);
start = find(oculusYawTime>yawStart);

qualisysYaw = qualisysData-qualisysData(1,1);%zeros out the Qualisys dataset
oculusYaw = oculusData-oculusData(1,1);%zeros out the Oculus dataset
Xaxes = ((1:length(qualisysYaw))/75);%creates X axes to view data in seconds
scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
MaxY = (50*(ceil(max(qualisysYaw/50.))))+50;
MinY = (50*(floor(min(qualisysYaw/50.))))+50;
y1 = [MinY,MaxY];
x1 = [(start(2,1)/75),(start(2,1)/75)];
plot(Xaxes,qualisysYaw,'r')
hold on
plot(Xaxes,oculusYaw,'b')
plot(x1,y1,'k','linewidth',2);
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
title('Yaw Rotation Synchronized','fontsize',14,'fontweight','bold');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)

%In some instances, the timestamp in Oculus marked either 7 seconds or
%14 seconds before the start of the experimental session
%The following code corrects for that error
syncStart = input('How many seconds is the time stamp behind\n(0) 0\n(1) 7\n(2) 14\n');

if syncStart==0
    start = 1;
elseif syncStart==1
    start = 525;
elseif syncStart==2
    start = 1050;
end

qualisysYaw = qualisysYaw(start:end);
oculusYaw = oculusYaw(start:end);
qualisysYaw = qualisysYaw-qualisysYaw(1,1);
oculusYaw = oculusYaw-oculusYaw(1,1);

scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
Xaxes = ((1:length(qualisysYaw))/75);%creates X axes to view data in seconds
plot(Xaxes,qualisysYaw,'r')
hold on
plot(Xaxes,oculusYaw,'b')
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
title('Yaw Rotation Validity Session Only','fontsize',14,'fontweight','bold');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)
pause
close all
clc

qualisysPitch = qualisysPitch(1:1.3333:end);
[~,maxQualisysTime] = max(qualisysPitch(1:1200));
[~,maxOculusTime] = max(oculusPitch(1:1700));
qualisysSync = qualisysPitch(maxQualisysTime:end);
oculusSync = oculusPitch(maxOculusTime:end);
qualisysLength = length(qualisysSync);
oculusLength = length(oculusSync);

TF = gt(qualisysLength,oculusLength);

if TF==1
    qualisysData = qualisysSync(1:oculusLength);
    oculusData = oculusSync(1:oculusLength);
else
    qualisysData = qualisysSync(1:qualisysLength);
    oculusData = oculusSync(1:qualisysLength);
end

pitchStart = str2double(oculusPitchStart);
start = find(oculusPitchTime>pitchStart);

qualisysPitch = qualisysData-qualisysData(1,1);
oculusPitch = oculusData-oculusData(1,1);

scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
Xaxes = ((1:length(qualisysPitch))/75);%creates X axes to view data in seconds
MaxY = (50*(ceil(max(qualisysPitch/50.))))+50;
MinY = (50*(floor(min(qualisysPitch/50.))))+50;
y1 = [MinY,MaxY];
x1 = [start(2,1),start(2,1)];
plot(Xaxes,qualisysPitch,'r')
hold on
plot(Xaxes,oculusPitch,'b')
plot(x1,y1,'k','linewidth',2);
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)
title('Pitch Rotation Synchronized','fontsize',14,'fontweight','bold');

syncStart = input('How many seconds is the time stamp behind\n(0) 0\n(1) 7\n(2) 14\n');

if syncStart==0
    start = 1;
elseif syncStart==1
    start = 525;
elseif syncStart==2
    start = 1050;
end

qualisysPitch = qualisysPitch(start:end);
oculusPitch = oculusPitch(start:end);
qualisysPitch = qualisysPitch-qualisysPitch(1,1);
oculusPitch = oculusPitch-oculusPitch(1,1);

Xaxes = ((1:length(qualisysPitch))/75);%creates X axes to view data in seconds
figure('Position',scrsz);
plot(Xaxes,qualisysPitch,'r')
hold on
plot(Xaxes,oculusPitch,'b')
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
title('Pitch Rotation Validity Session Only','fontsize',14,'fontweight','bold');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)
pause
close all
clc

qualisysRoll = qualisysRoll(1:1.3333:end);
[~,maxQualisysTime] = max(qualisysRoll(1:2000));
[~,maxOculusTime] = max(oculusRoll(1:2000));
qualisysSync = qualisysRoll(maxQualisysTime:end);
oculusSync = oculusRoll(maxOculusTime:end);
qualisysLength = length(qualisysSync);
oculusLength = length(oculusSync);

TF = gt(qualisysLength,oculusLength);

if TF==1
    qualisysData = qualisysSync(1:oculusLength);
    oculusData = oculusSync(1:oculusLength);
else
    qualisysData = qualisysSync(1:qualisysLength);
    oculusData = oculusSync(1:qualisysLength);
end

rollStart = str2double(oculusRollStart);
start = find(oculusRollTime>rollStart);

qualisysRoll = qualisysData-qualisysData(1,1);
oculusRoll = oculusData-oculusData(1,1);
Xaxes = ((1:length(qualisysRoll))/75);%creates X axes to view data in seconds
scrsz = get(0,'ScreenSize');
figure('Position',scrsz);
MaxY = (50*(ceil(max(qualisysRoll/50.))))+50;
MinY = (50*(floor(min(qualisysRoll/50.))))+50;
y1 = [MinY,MaxY];
x1 = [start(2,1),start(2,1)];
plot(Xaxes,qualisysRoll,'r')
hold on
plot(Xaxes,oculusRoll,'b')
plot(x1,y1,'k','linewidth',2);
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)
title('Roll Rotation Synchronized','fontsize',14,'fontweight','bold');

syncStart = input('How many seconds is the time stamp behind\n(0) 0\n(1) 7\n(2) 14\n');

if syncStart==0
    start = 1;
elseif syncStart==1
    start = 525;
elseif syncStart==2
    start = 1050;
end

qualisysRoll = qualisysRoll(start:end);
oculusRoll = oculusRoll(start:end);
qualisysRoll = qualisysRoll-qualisysRoll(1,1);
oculusRoll = oculusRoll-oculusRoll(1,1);

figure('Position',scrsz);
Xaxes = ((1:length(qualisysRoll))/75);%creates X axes to view data in seconds
plot(Xaxes,qualisysRoll,'r')
hold on
plot(Xaxes,oculusRoll,'b')
Legend = {'Qualisys','Oculus'};
legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
legend('boxoff');
yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
ylabel(yLabel,'fontsize',14,'fontweight','bold')
xlabel('Time (s)','fontsize',14,'fontweight','bold')
set(gca,'Fontsize',14)
title('Roll Rotation Validity Session Only','fontsize',14,'fontweight','bold');
pause
close all
clc

clearvars -except oculusPitch oculusPitchMarks oculusPitchStart oculusPitchTime oculusPitchTimeStamps oculusRoll oculusRollMarks oculusRollStart oculusRollTime oculusRollTimeStamps oculusYaw oculusYawMarks oculusYawStart oculusYawTime oculusYawTimeStamps qualisysPitch qualisysRoll qualisysYaw subject

%%filter data
[b,a] = butter(2,2*(10/75),'low');

qualisysYaw = filtfilt(b,a,qualisysYaw);
qualisysPitch = filtfilt(b,a,qualisysPitch);
qualisysRoll = filtfilt(b,a,qualisysRoll);

oculusYaw = filtfilt(b,a,oculusYaw);
oculusPitch = filtfilt(b,a,oculusPitch);
oculusRoll = filtfilt(b,a,oculusRoll);

%%break yaw session into trials
trials = 40;
f = 1050;%frames per trial

oculusSessionData = vertcat(oculusYaw,nan(42000-length(oculusYaw),1));
qualisysSessionData = vertcat(qualisysYaw,nan(42000-length(qualisysYaw),1));
oculusYawTrials = nan(f,trials);
qualisysYawTrials = nan(f,trials);

for i = 1:1
    
    if oculusYawMarks(i,:)>0
        oculusYawTrials(:,i) = -oculusSessionData(1:f);
        qualisysYawTrials(:,i) = -qualisysSessionData(1:f);
    else
        oculusYawTrials(:,i) = oculusSessionData(1:f);
        qualisysYawTrials(:,i) = qualisysSessionData(1:f);
    end
    
    qualisysYawTrials(:,i) = qualisysYawTrials(:,i)-qualisysYawTrials(1,i);
    
    oculusSessionData(1:f) = [];
    qualisysSessionData(1:f) = [];
    question = 0;
    lastTime = 0;
    while question == 0;
        lastTime = lastTime+25;
        qualisysYawVelTrials(:,i) = diff(qualisysYawTrials(:,i))*75; %#ok<*SAGROW>
        qualisysYawAccTrials(:,i) = diff(qualisysYawVelTrials(:,i))*75;
        oculusYawVelTrials(:,i) = diff(oculusYawTrials(:,i))*75;
        oculusYawAccTrials(:,i) = diff(oculusYawVelTrials(:,i))*75;
        currentAcc = oculusYawAccTrials(:,i);
        times = 0;
        
        for N = 2:lastTime
            if currentAcc(N)<-100||currentAcc(N)>100
                times = times+1;
                zeroTime(times) = N;
            end
        end
        
        TF = exist('zeroTime','var');
        
        if TF==0
            zeroTime = 1;
        else
            zeroTime = max(zeroTime);
        end
        
        oculusYawTrials(:,i) = oculusYawTrials(:,i)-oculusYawTrials(zeroTime,i);
        oculusYawVelTrials(:,i) = diff(oculusYawTrials(:,i))*75;
        oculusYawAccTrials(:,i) = diff(oculusYawVelTrials(:,i))*75;
        
        Xaxes = ((1:length(oculusYawTrials(:,i)))/75);%creates X axes to view data in seconds
        plot(Xaxes,oculusYawTrials((1:end-2),i),'b');
        hold on
        plot(Xaxes,qualisysYawTrials((1:end-2),i),'r');
        set(gcf,'Position',[380 62 1098 934]);
        Legend = {'Oculus','Qualisys'};
        legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
        legend('boxoff');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',14,'fontweight','bold')
        xlabel('Time (s)','fontsize',14,'fontweight','bold')
        set(gca,'Fontsize',14)
        title(strcat('Yaw trial:',num2str(i)),'fontsize',14,'fontweight','bold');
        question = input('Is the data zeroed correctly?\n(1)Yes\n(0)No\n');
        close all
        yawStart(:,i) = zeroTime;
        clearvars zeroTime
        clc
    end
    
end

yawData = struct('qualisysDisplacement',qualisysYawTrials,'qualisysVelocity',qualisysYawVelTrials,'qualisysAcceleration',qualisysYawAccTrials,'oculusDisplacement',oculusYawTrials,'oculusVelocity',oculusYawVelTrials,'oculusAcceleration',oculusYawAccTrials);
%%
%%breaks pitch and roll sessions into trials
trials = 30;
oculusSessionData = oculusPitch;
qualisysSessionData = qualisysPitch;
oculusPitchTrials = nan(f,trials);
qualisysPitchTrials = nan(f,trials);

for i = 1:trials
    if str2double(oculusPitchMarks(i,:))>0
        oculusPitchTrials(:,i) = -oculusSessionData(1:f);
        qualisysPitchTrials(:,i) = -qualisysSessionData(1:f);
    else
        oculusPitchTrials(:,i) = oculusSessionData(1:f);
        qualisysPitchTrials(:,i) = qualisysSessionData(1:f);
    end
    
    oculusPitchTrials(:,i) = oculusPitchTrials(:,i)-oculusPitchTrials(1,i);
    qualisysPitchTrials(:,i) = qualisysPitchTrials(:,i)-qualisysPitchTrials(1,i);
    oculusSessionData(1:f) = [];
    qualisysSessionData(1:f) = [];
    
    plot(oculusPitchTrials(:,i),'b');
    hold on
    plot(qualisysPitchTrials(:,i),'r');
    set(gcf,'Position',[380 62 1098 934]);
    Legend = {'Oculus','Qualisys'};
    legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
    legend('boxoff');
    yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
    ylabel(yLabel,'fontsize',14,'fontweight','bold')
    xlabel('Time (s)','fontsize',14,'fontweight','bold')
    title(strcat('Pitch trial:',num2str(i)),'fontsize',14,'fontweight','bold');
    pause
    close all
end

oculusSessionData = vertcat(oculusRoll,nan(31500-length(oculusRoll),1));
qualisysSessionData = vertcat(qualisysRoll,nan(31500-length(qualisysRoll),1));
oculusRollTrials = nan(f,trials);
qualisysRollTrials = nan(f,trials);

for i = 1:trials
    
    if str2double(oculusRollMarks(i,:))>0
        oculusRollTrials(:,i) = oculusSessionData(1:f);
        qualisysRollTrials(:,i) = qualisysSessionData(1:f);
    else
        oculusRollTrials(:,i) = -oculusSessionData(1:f);
        qualisysRollTrials(:,i) = -qualisysSessionData(1:f);
    end
    
    oculusRollTrials(:,i) = oculusRollTrials(:,i)-oculusRollTrials(1,i);
    qualisysRollTrials(:,i) = qualisysRollTrials(:,i)-qualisysRollTrials(1,i);
    oculusSessionData(1:f) = [];
    qualisysSessionData(1:f) = [];
    
    plot(oculusRollTrials(:,i),'b');
    hold on
    plot(qualisysRollTrials(:,i),'r');
    set(gcf,'Position',[380 62 1098 934]);
    Legend = {'Oculus','Qualisys'};
    legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
    legend('boxoff');
    yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
    ylabel(yLabel,'fontsize',14,'fontweight','bold')
    xlabel('Time (s)','fontsize',14,'fontweight','bold')
    title(strcat('Roll trial:',num2str(i)),'fontsize',14,'fontweight','bold');
    pause
    close all
end

clearvars -except oculusRollTrials oculusRollVelTrials oculusRollAccTrials qualisysRollTrials qualisysRollVelTrials qualisysRollAccTrials oculusPitchTrials oculusPitchVelTrials oculusPitchAccTrials qualisysPitchTrials qualisysPitchVelTrials qualisysPitchAccTrials oculusYawTrials oculusYawVelTrials oculusYawAccTrials qualisysYawTrials qualisysYawVelTrials qualisysYawAccTrials oculusPitch oculusPitchAcc oculusPitchMarks oculusPitchStart oculusPitchTime oculusPitchTimeStamps oculusPitchTrials oculusPitchVel oculusRoll oculusRollAcc oculusRollMarks oculusRollStart oculusRollTime oculusRollTimeStamps oculusRollTrials oculusRollVel oculusYaw oculusYawAcc oculusYawMarks oculusYawStart oculusYawTime oculusYawTimeStamps oculusYawTrials oculusYawVel subject qualisysPitch qualisysPitchAcc qualisysPitchMarks qualisysPitchStart qualisysPitchTime qualisysPitchTimeStamps qualisysPitchTrials qualisysPitchVel qualisysRoll qualisysRollAcc qualisysRollMarks qualisysRollStart qualisysRollTime qualisysRollTimeStamps qualisysRollTrials qualisysRollVel qualisysYaw qualisysYawAcc qualisysYawMarks qualisysYawStart qualisysYawTime qualisysYawTimeStamps qualisysYawTrials qualisysYawVel

%%perform analysis
trials = 40;
oculusTrialAngle = [];
qualisysTrialAngle = [];

for i = 1:trials
    
    TF = isnan(oculusYawTrials(1,i));
    
    if TF==0
        
        displacement = oculusYawTrials(:,i);
        velocity = diff(displacement)*75;
        [maxVel,maxVelTime] = max(velocity(yawStart(:,i):end));
        [minVel,minVelTime] = min(velocity(yawStart(:,i):end));
        
        max2min = minVelTime-maxVelTime;
        trialTime = (max2min/2)+maxVelTime;
        
        MaxY = (10*(ceil(max(qualisysYawTrials(:,i)/10.))))+10;
        MinY = (10*(floor(min(qualisysYawTrials(:,i)/10.))))+10;
        y1 = [MinY,MaxY];
        x1 = [trialTime,trialTime];
        plot(oculusYawTrials(:,i),'b');
        hold on
        plot(qualisysYawTrials(:,i),'r');
        set(gcf,'Position',[380 62 1098 934]);
        plot(x1,y1,'k','linewidth',2);
        Legend = {'Qualisys','Oculus'};
        legend(Legend,'Location','NorthEast','fontsize',14,'fontweight','bold');
        legend('boxoff');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',14,'fontweight','bold')
        xlabel('Time (s)','fontsize',14,'fontweight','bold')
        title(strcat('Trial:',num2str(i)),'fontsize',14,'fontweight','bold');
        set(gca,'Fontsize',14)
        pause
        close all
        
        currentTrial = displacement(PeakPlace(1,1):TroughPlace(1,1));
        L = round(length(currentTrial)/2);
        trialTime = PeakPlace(1,1)+L;
        
        oculusTrialAngle = vertcat(oculusTrialAngle,oculusYawTrials(trialTime,i)); %#ok<*AGROW>
        qualisysTrialAngle = vertcat(qualisysTrialAngle,qualisysYawTrials(trialTime,i));
        
        clearvars velocity displacement
    else
        oculusTrialAngle = vertcat(oculusTrialAngle,nan);
        qualisysTrialAngle = vertcat(qualisysTrialAngle,nan);
    end
    
end

%%write data to xslx

allYawData = [oculusYawMarks,oculusYawTrialAngles,qualisysYawTrialAngles];
allYawData = sortrows(allYawData,1);
allYawData(:,4) = allYawData(:,2) - allYawData(:,3);
allPitchData = [oculusPitchMarks,oculusPitchTrialAngles,qualisysPitchTrialAngles];
allPitchData = sortrows(allPitchData,1);
allPitchData(:,4) = allPitchData(:,2) - allPitchData(:,3);
allRollData = [oculusRollMarks,oculusRollTrialAngles,qualisysRollTrialAngles];
allRollData = sortrows(allRollData,1);
allRollData(:,4) = allRollData(:,2) - allRollData(:,3);

MainFilename = sprintf(strcat(subject,'-HOPS.xlsx'));
heading = {'Trial Angle','Oculus Angle','Qualisys Angle','Angle Difference'};

xlswrite(MainFilename,heading,'Yaw Validity Data','A1');
xlswrite(MainFilename,allYawData,'Yaw Validity Data','A2');

xlswrite(MainFilename,heading,'Pitch Validity Data','A1');
xlswrite(MainFilename,allPitchData,'Pitch Validity Data','A2');

xlswrite(MainFilename,heading,'Roll Validity Data','A1');
xlswrite(MainFilename,allPitchData,'Roll Validity Data','A2');

save(char(strcat('HOPS_',subject,'.mat')));
clr