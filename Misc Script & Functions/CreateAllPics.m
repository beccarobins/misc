clear; close all; clc;
folder_name = uigetdir;%open the main directory that has all participant folders
cd(folder_name)
name = [folder_name '\*\**.mat'];
files = rdir(name);%sequentially goes through each subfolder to find the .mat file
nFiles = length(files);%determines how many of the participant folders have a .mat file (if this is fewer than the numner of folders, then one or more partiipants were not processed

setup = 1;

for i = 1:1
    
    temp = getfield(files(i,:),'name'); %#ok<*GFLD>
    subject = strsplit(temp,'\');%subject name generated from folder
    subject = char(subject(:,end-1));
    subject = char(strsplit(subject,'_'));
    cd(strcat(folder_name,'\',subject))
    
    load(char(strcat('HOPS_',subject,'.mat')));
    
    subjectNum = str2num(subject); %#ok<*ST2NM>

    trials = 30;%testing pictures

    HOPSprocessPIC('Yaw',HOPSdata.filteredData.oculusYawData,HOPSdata.filteredData.qualisysYawData,trials,f,HOPSdata.rawData.oculusYawData.oculusMarks,setup);
    HOPSanalyzeJPMPIC('Yaw',HOPSdata.timeseries.Yaw,trials,HOPSdata.rawData.oculusYawData.oculusMarks,setup,f);
    
    HOPSanalyzePIC('Pitch',HOPSdata.timeseries.Pitch,trials,HOPSdata.rawData.oculusPitchData.oculusMarks,setup,f);
   
    clearvars -except subject HOPSdata folder_name files setup
    
end
tts('Check out your pictures');