clr
folder_name = uigetdir; %select participant folder
cd(folder_name)

subject = input('What is the subject ID?\n','s');

oculusYawData = oculusimport(subject,'Yaw');
qualisysYawData = qualisysimport(subject,'Yaw');

syncedYawData = syncOculusQualisys('Yaw',oculusYawData.oculusTimeSeries,qualisysYawData,oculusYawData.oculusTime,oculusYawData.oculusStart);
[b,a] = butter(2,2*(6/75),'low');

syncedYawData.oculusFilt = filtfilt(b,a,syncedYawData.oculusData);
syncedYawData.qualisysFilt = filtfilt(b,a,syncedYawData.qualisysData);
f = 1050;%frames per trial
trials = 40;
yawTrialData = HOPSprocess('Yaw',syncedYawData.oculusFilt,syncedYawData.qualisysFilt,trials,f,oculusYawData.oculusMarks);