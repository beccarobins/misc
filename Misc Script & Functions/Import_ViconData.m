clear;
folder_name = uigetdir; %select participant folder
cd(folder_name)
path = [folder_name '\'];
name = [folder_name '\*.c3d'];
c3dDirectory = dir(name);

for i = 1:length(c3dDirectory);
    FileNames(i,1) = strcat(path,{c3dDirectory(i,:).name}); %#ok<*SAGROW>
    FileNames(i,2) = {c3dDirectory(i,:).name}; %#ok<*SAGROW>
end

for  i = 1:length(c3dDirectory)
    
    filename = char(FileNames(i,1));
    Vicondata = mcread(filename);
    trial = strsplit(char(FileNames(i,2)),' ');
    
    %% Determine if there are any gaps to be filled
    [mf,mm,mgrid] = mcmissing(Vicondata);
    figure, set(gcf,'Position',[40 200 560 420])
    %subplot(3,1,1),
    bar(mf), xlabel('Marker'), ylabel('Num. of Missing frames')
    ax = gca;
    ax.XTick = 1:Vicondata.nMarkers;
    ax.XTickLabelRotation=45;
    ax.XLim = [0 Vicondata.nMarkers+1];
    set(gca,'XTickLabel',Vicondata.markerName);
    set(gcf,'Position',[-1906 23 1891 966]);
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
        str = char(strcat('Return to Vicon Nexus to fill gaps in file:',{' '}, char(trial(1,1)),'.qtm'));
        disp(str)
        clear
        return
    else
        clc
    end
    
    %% Model segments
    %Head Pitch Data = Vicondata.data(:,1);Vicondata.data(:,4);Vicondata.data(:,7);Vicondata.data(:,10);Vicondata.data(:,13)
    %Head Roll Data = Vicondata.data(:,2);Vicondata.data(:,5);Vicondata.data(:,8);Vicondata.data(:,11);Vicondata.data(:,14)
    %Head Yaw Data = Vicondata.data(:,3);Vicondata.data(:,6);Vicondata.data(:,9);Vicondata.data(:,12);Vicondata.data(:,15)
    %Trunk Pitch Data = Vicondata.data(:,16);Vicondata.data(:,19);Vicondata.data(:,34)
    %Trunk Roll Data = Vicondata.data(:,17);Vicondata.data(:,20);Vicondata.data(:,35)
    %Trunk Yaw Data = Vicondata.data(:,18);Vicondata.data(:,21);Vicondata.data(:,36)
    
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
    save(filesave,'Vicondata');
end

clr

%HOP_Oculus