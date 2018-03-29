clear; close all; clc;
folder_name = uigetdir;%open the main directory that has all participant folders
cd(folder_name)
name = [folder_name '\*\**.mat'];
files = rdir(name);%sequentially goes through each subfolder to find the .mat file
nFiles = length(files);%determines how many of the participant folders have a .mat file (if this is fewer than the numner of folders, then one or more partiipants were not processed

for i = 1:nFiles
    
    temp = getfield(files(i,:),'name'); %#ok<*GFLD>
    subject = strsplit(temp,'\');%subject name generated from folder
    subject = char(subject(:,end-1));
    subject = char(strsplit(subject,'_'));
    
    cd(strcat(folder_name,'\',subject))
    load(char(strcat('HOPS_',subject,'.mat')));
    
    trials = 30;
    setup = 1;
    f = 2250;
    
    HOPSprocessPIC('Yaw',HOPSdata.filteredData.oculusYawData,HOPSdata.filteredData.qualisysYawData,trials,f,HOPSdata.rawData.oculusYawData.oculusMarks,setup);%
   HOPSanalyzeJPMPIC('Yaw',HOPSdata.timeseries.Yaw,trials,HOPSdata.rawData.oculusYawData.oculusMarks,setup,f);
    
    clearvars -except nFiles files folder_name
    
    cd('C:\Users\tug41619\Documents\HOPS\HOPS Data\Pilot Validation and Joint Position Matching Data')
end
tts('hello hello hello');