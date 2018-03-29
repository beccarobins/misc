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
        Target = data.data;
        [X,Y] = find(LED~=0);
        SyncTime = X(1,1);
        RawQuietEye_Target = Target(SyncTime:SyncTime+1399,:);
        [d,c] = butter(2,6/100,'low');
        QuietEye_Target = filtfilt(d,c,RawQuietEye_Target);
        Mean_Target = mean(QuietEye_Target);
        X_Positions(1,1) = Mean_Target(1,3);
        X_Positions(1,2) = Mean_Target(1,6);
        X_Positions(1,3) = Mean_Target(1,9);
        X_Positions(1,4) = Mean_Target(1,12);
        Y_Positions(1,1) = Mean_Target(1,4);
        Y_Positions(1,2) = Mean_Target(1,7);
        Y_Positions(1,3) = Mean_Target(1,10);
        Y_Positions(1,4) = Mean_Target(1,13);
        Z_Positions(1,1) = Mean_Target(1,5);
        Z_Positions(1,2) = Mean_Target(1,8);
        Z_Positions(1,3) = Mean_Target(1,11);
        Z_Positions(1,4) = Mean_Target(1,14);
        TargetCentre_X = mean(X_Positions);
        TargetCentre_Y = mean(Y_Positions);
        TargetCentre_Z = mean(Z_Positions);
        clearvars A data X Y d c k MeanTarget X_Positions Y_Positions Z_Positions
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
        Target = data.data;
        [X,Y] = find(LED~=0);
        SyncTime = X(1,1);
        RawQuietEye_Target = Target(SyncTime:SyncTime+1399,:);
        [d,c] = butter(2,6/100,'low');
        QuietEye_Target = filtfilt(d,c,RawQuietEye_Target);
        Mean_Target = mean(QuietEye_Target);
        X_Positions(1,1) = Mean_Target(1,3);
        X_Positions(1,2) = Mean_Target(1,6);
        X_Positions(1,3) = Mean_Target(1,9);
        X_Positions(1,4) = Mean_Target(1,12);
        Y_Positions(1,1) = Mean_Target(1,4);
        Y_Positions(1,2) = Mean_Target(1,7);
        Y_Positions(1,3) = Mean_Target(1,10);
        Y_Positions(1,4) = Mean_Target(1,13);
        Z_Positions(1,1) = Mean_Target(1,5);
        Z_Positions(1,2) = Mean_Target(1,8);
        Z_Positions(1,3) = Mean_Target(1,11);
        Z_Positions(1,4) = Mean_Target(1,14);
        TargetCentre_X = mean(X_Positions);
        TargetCentre_Y = mean(Y_Positions);
        TargetCentre_Z = mean(Z_Positions);
        clearvars A data X Y d c k MeanTarget X_Positions Y_Positions Z_Positions
        save(['Exp_3_',Participant,'_QuietEye_',num2str(TrialNum),'.mat']);
    else
    end
    clearvars -except Participant FileNames
end

beep
h = msgbox('Exp_3_Import_Target Script Complete');
clear
clc