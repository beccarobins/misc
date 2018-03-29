clr;
folder_name = uigetdir; %select participant folder
cd(folder_name)

for i  = 2:4
    filename = strcat('HOPSOculus_',num2str(i),'.txt');%import Oculus time series
    oculusData = importdata(filename);
    
    for j = 1:4
        oculusData.data(:,j) = oculusData.data(:,j)-oculusData.data(1,j) ;
    end
    
    oculusYaw = oculusData.data(:,2);
    oculusYawVel = diff(oculusYaw);
    
    [minVel,minVelTime] = min(oculusYawVel);
    [maxVel,maxVelTime] = max(oculusYawVel);
    
    fixedYaw = vertcat(oculusYaw(1:minVelTime),360+(oculusYaw(minVelTime+1:maxVelTime)),oculusYaw(maxVelTime+1:end));
    oculusYaw = fixedYaw;
    [b,a] = butter(2,6/75,'low');
    oculusYaw = filtfilt(b,a,oculusYaw);
    %%
    subject = input('What is the subject ID?\n','s');
    
    filename = strcat(subject,'_Yaw_6D.tsv');%import Qualisys time series
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    qualisysHeadYaw = dataArray{:,8};
    
    filename = strcat(subject,'_Pitch_6D.tsv');%import Qualisys time series
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    qualisysHeadPitch = dataArray{:,6};
 
    filename = strcat(subject,'_Roll_6D.tsv');%import Qualisys time series
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    qualisysHeadRoll = dataArray{:,7};
    
    %%
    [Frame,Time,TestX,Y,Z,Roll,Pitch,Yaw,Residual,Rot0,Rot1,Rot2,Rot3,Rot4,Rot5,Rot6,Rot7,Rot8] = openDriftFile(filename);
    
    qualisysHeadYaw = -1*(Yaw-Yaw(1,1));
    qualisysHeadYawVel = diff(qualisysHeadYaw);
    
    [minVel,minVelTime] = min(qualisysHeadYawVel);
    [maxVel,maxVelTime] = max(qualisysHeadYawVel);
    
    fixedYaw = vertcat(qualisysHeadYaw(1:minVelTime),360+(qualisysHeadYaw(minVelTime+1:maxVelTime)),qualisysHeadYaw(maxVelTime+1:end));
    qualisysHeadYaw = fixedYaw;
    [b,a] = butter(2,6/100,'low');
    qualisysHeadYaw = filtfilt(b,a,qualisysHeadYaw);
    
    warning('off');
    qualisysYaw = qualisysHeadYaw(1:1.3333:end);%is this the correct subsample conversion rate?
    
    [qualisysLeftMax,maxQualisysTime] = max(qualisysYaw(1:1500));
    [oculusLeftMax,maxOculusTime] = max(oculusYaw(1:1500));
    qualisysRightMax = abs(min(qualisysYaw(1:3000)));
    oculusRightMax = abs(min(oculusYaw(1:3000)));
    qualisysSync = qualisysYaw(maxQualisysTime:end);
    oculusSync = oculusYaw(maxOculusTime:end);
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
    
    qualisysData = qualisysData-qualisysData(1,1);
    oculusData = oculusData-oculusData(1,1);
    scrsz = get(0,'ScreenSize');
    figure('Position',scrsz);
    plot(qualisysData(1:5000),'r')
    hold on
    plot(oculusData(1:5000),'b')
    Legend = {'Qualisys','Oculus'};
    legend(Legend,'Location','NorthWest');
    title(strcat('Model #',num2str(i)));
    pause
    close all
end

clr