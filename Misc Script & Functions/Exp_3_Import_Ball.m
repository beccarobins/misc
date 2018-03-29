CurrentFolder = pwd;
Directory = dir('*.txt');

for k = 1:length(Directory);
    FileNames(k,:) = {Directory(k,:).name};
end

load('Participant');

for TrialNum = 1:9;
    load(['Exp_3_',Participant,'_QuietEye_0',num2str(TrialNum),'.mat']);
    A = strmatch(strcat('QuietEye_0',num2str(TrialNum),'.txt'), FileNames);
    if A>=1
        data = importdata(['QuietEye_0',num2str(TrialNum),'.txt']);
        Ball = data.data;
        [X,Y] = find(LED~=0);
        SyncTime = X(1,1);
        RawQuietEye_Ball = Ball(SyncTime:SyncTime+399,:);
        RawTrial_Ball = Ball(SyncTime+400:end,:);
        [d,c] = butter(2,6/100,'low');
        QuietEye_Ball = filtfilt(d,c,RawQuietEye_Ball);
        Trial_Ball = filtfilt(d,c,RawTrial_Ball);
        Ball_X = Trial_Ball(:,3);
        Ball_Y = Trial_Ball(:,4);
        Ball_Z = Trial_Ball(:,5);
        clearvars A data X Y d c k
        save(['Exp_3_',Participant,'_QuietEye_0',num2str(TrialNum),'.mat']);
    else
    end
    clearvars -except Participant FileNames
end

for TrialNum = 10:30;
    load(['Exp_3_',Participant,'_QuietEye_',num2str(TrialNum),'.mat']);
    A = strmatch(strcat('QuietEye_',num2str(TrialNum),'.txt'), FileNames);
    if A>=1
        data = importdata(['QuietEye_',num2str(TrialNum),'.txt']);
        Ball = data.data;
        [X,Y] = find(LED~=0);
        SyncTime = X(1,1);
        RawQuietEye_Ball = Ball(SyncTime:SyncTime+399,:);
        RawTrial_Ball = Ball(SyncTime+400:end,:);
        [d,c] = butter(2,6/100,'low');
        QuietEye_Ball = filtfilt(d,c,RawQuietEye_Ball);
        Trial_Ball = filtfilt(d,c,RawTrial_Ball);
        Ball_X = Trial_Ball(:,3);
        Ball_Y = Trial_Ball(:,4);
        Ball_Z = Trial_Ball(:,5);
        clearvars A data X Y d c k
        save(['Exp_3_',Participant,'_QuietEye_',num2str(TrialNum),'.mat']);
    else
    end
    clearvars -except Participant FileNames
end

beep
h = msgbox('Exp_3_Import_Ball Script Complete');
clear
clc