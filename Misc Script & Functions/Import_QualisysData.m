clear;
folder_name = uigetdir; %select participant folder
cd(folder_name)
path = [folder_name '\'];
name = [folder_name '\*.tsv'];
TSVDirectory = dir(name);

for i = 1:length(TSVDirectory);
    FileNames(i,1) = strcat(path,{TSVDirectory(i,:).name}); %#ok<*SAGROW>
    FileNames(i,2) = {TSVDirectory(i,:).name}; %#ok<*SAGROW>
end

for  i = 1:length(TSVDirectory)
    %i = 1:length(TSVDirectory)
    
    filename = char(FileNames(i,1));
    Qualisysdata = mcread(filename);
    trial = strsplit(char(FileNames(i,2)),' ');
    
    %% Determine if there are any gaps to be filled
    [mf,mm,mgrid] = mcmissing(Qualisysdata);
    figure, set(gcf,'Position',[40 200 560 420])
    subplot(3,1,1),
    bar(mf), xlabel('Marker'), ylabel('Num. of Missing frames')
    set(gca,'XTickLabel',Qualisysdata.markerName)
    set(gcf,'Position',[-1906 23 1891 966])
    subplot(3,1,2), bar(mm), xlabel('Frame'), ylabel('Num. of Missing markers')
    subplot(3,1,3), imagesc(-mgrid'), colormap gray, xlabel('Frame'),
    ylabel('Marker')
    
    % update position for personal monitor setup
    % use get(gcf,'Position')
    %set(gcf,'Position',[112 115 1636 844])
    
    
    decision = input('Are there are gaps?\n (1) Yes \n (0) No\n');
    close all
    
    if decision == 1
        clc
        str = char(strcat('Return to Qualisys Track Manager to fill gaps in file:',{' '}, char(trial(1,1)),'.qtm'));
        disp(str)
        clear
        return
    else
        clc
    end
    
    %% Model segments
    %Head Pitch Data = Qualisysdata.data(:,1);Qualisysdata.data(:,4);Qualisysdata.data(:,7);Qualisysdata.data(:,10);Qualisysdata.data(:,13)
    %Head Roll Data = Qualisysdata.data(:,2);Qualisysdata.data(:,5);Qualisysdata.data(:,8);Qualisysdata.data(:,11);Qualisysdata.data(:,14)
    %Head Yaw Data = Qualisysdata.data(:,3);Qualisysdata.data(:,6);Qualisysdata.data(:,9);Qualisysdata.data(:,12);Qualisysdata.data(:,15)
    %Trunk Pitch Data = Qualisysdata.data(:,16);Qualisysdata.data(:,19);Qualisysdata.data(:,34)
    %Trunk Roll Data = Qualisysdata.data(:,17);Qualisysdata.data(:,20);Qualisysdata.data(:,35)
    %Trunk Yaw Data = Qualisysdata.data(:,18);Qualisysdata.data(:,21);Qualisysdata.data(:,36)
    
    %Output = ModeledHead;ModeledTrunk
    %put in structure form: Head.Pitch.Displacement;Head.Roll.Displacement;Head.Yaw.Displacement;Trunk.Pitch.Displacement;Trunk.Roll.Displacement;Trunk.Yaw.Displacement
    
    %Change MoCapSampFreq to motion capture samping rate
    MoCapSampFreq = 100;
    
    %     Head.Pitch.Velocity = MoCapSampFreq*(diff(Head.Pitch.Displacement));
    %     Head.Roll.Velocity = MoCapSampFreq*(diff(Head.Roll.Displacement));
    %     Head.Yaw.Velocity = MoCapSampFreq*(diff(Head.Yaw.Displacement));
    %     Trunk.Pitch.Velocity = MoCapSampFreq*(diff(Trunk.Pitch.Displacement));
    %     Trunk.Roll.Velocity = MoCapSampFreq*(diff(Trunk.Roll.Displacement));
    %     Trunk.Yaw.Velocity = MoCapSampFreq*(diff(Trunk.Yaw.Displacement));
    %     Head.Pitch.Acceleration = MoCapSampFreq*(diff(Head.Pitch.Velocity));
    %     Head.Roll.Acceleration = MoCapSampFreq*(diff(Head.Roll.Velocity));
    %     Head.Yaw.Acceleration = MoCapSampFreq*(diff(Head.Yaw.Velocity));
    %     Trunk.Pitch.Acceleration = MoCapSampFreq*(diff(Trunk.Pitch.Velocity));
    %     Trunk.Roll.Acceleration = MoCapSampFreq*(diff(Trunk.Roll.Velocity));
    %     Trunk.Yaw.Acceleration = MoCapSampFreq*(diff(Trunk.Yaw.Velocity));
    %
    %% Analyze the data
    
    %     Head.Pitch.Displacement.DependentVariables = depvars(Head.Pitch.Displacement);
    %     Head.Pitch.Velocity.DependentVariables = depvars(Head.Pitch.Velocity);
    %     Head.Pitch.Acceleration.DependentVariables = depvars(Head.Pitch.Acceleration);
    %
    %     Head.Roll.Displacement.DependentVariables = depvars(Head.Roll.Displacement);
    %     Head.Roll.Velocity.DependentVariables = depvars(Head.Roll.Velocity);
    %     Head.Roll.Acceleration.DependentVariables = depvars(Head.Roll.Acceleration);
    %
    %     Head.Yaw.Displacement.DependentVariables = depvars(Head.Yaw.Displacement);
    %     Head.Yaw.Velocity.DependentVariables = depvars(Head.Yaw.Velocity);
    %     Head.Yaw.Acceleration.DependentVariables = depvars(Head.Yaw.Acceleration);
    
    %     Trunk.Pitch.Displacement.DependentVariables = depvars(Trunk.Pitch.Displacement);
    %     Trunk.Pitch.Velocity.DependentVariables = depvars(Trunk.Pitch.Velocity);
    %     Trunk.Pitch.Acceleration.DependentVariables = depvars(Trunk.Pitch.Acceleration);
    %
    %     Trunk.Roll.Displacement.DependentVariables = depvars(Trunk.Roll.Displacement);
    %     Trunk.Roll.Velocity.DependentVariables = depvars(Trunk.Roll.Velocity);
    %     Trunk.Roll.Acceleration.DependentVariables = depvars(Trunk.Roll.Acceleration);
    %
    %     Trunk.Yaw.Displacement.DependentVariables = depvars(Trunk.Yaw.Displacement);
    %     Trunk.Yaw.Velocity.DependentVariables = depvars(Trunk.Yaw.Velocity);
    %     Trunk.Yaw.Acceleration.DependentVariables = depvars(Trunk.Yaw.Acceleration);
    
    %% Visualize the data
    %mcplottimeseries
    
    filesave = strcat(char(trial(1,1)),'.mat');
    save(filesave,'Qualisysdata');
end

clr

%HOP_Oculus