clr

Question = input('What Mocap system are you importing data from?\n(1) Qualisys\n(2) Vicon\n(3) Motion Analysis\n ');

if Question==1
    display('Open folder with Qualysis data')
    MocapSoftware = 'Qualysis Track Manager';
elseif Question==2
    display('Open folder with Vicon data')
    MocapSoftware = 'Vicon Nexus';
elseif Question==3
    display('Open folder with Motion Analysis data')
    MocapSoftware = 'Motion Analysis Cortex';
end

folder_name = uigetdir; %select participant folder
cd(folder_name)
path = [folder_name '\'];

Question = input('What type of file did you use?\n(1) c3d\n(2) tsv\n(3) csv\n(4) txt\n(5) bvh\n(6) mat\n(7) wii\n');

if Question==1
    name = [folder_name '\*.c3d'];
elseif Question==2
    name = [folder_name '\*.tsv'];
elseif Question==3
    name = [folder_name '\*.csv'];
elseif Question==4
    name = [folder_name '\*.txt'];
elseif Question==5
    name = [folder_name '\*.bvh'];
elseif Question==6
    name = [folder_name '\*.mat'];
elseif Question==7
    name = [folder_name '\*.wii'];
end

Directory = dir(name);

for i = 1:length(Directory);
    FilePaths(i,1) = strcat(path,{Directory(i,:).name}); %#ok<*SAGROW>
    FileNames(i,1) = {Directory(i,:).name}; %#ok<*SAGROW>
end

for  i = 1:length(Directory)
    
    filename = char(FilePaths(i,1));
    Mocapdata = mcread(filename);
    trial = strsplit(char(FileNames(i,1)),'.');
    
    %% Determine if there are any gaps to be filled
    [mf,mm,mgrid] = mcmissing(Mocapdata);
    
    for j = 1:Mocapdata.nMarkers      
        Match = strmatch('*',Mocapdata.markerName(j,1));
        
        if isempty(Match)==1
            LabeledMarkers(j,1) = Mocapdata.markerName(j,1);
        end
    end
    
    Mocapdata.markerName = LabeledMarkers;
    Mocapdata.nMarkers = length(Mocapdata.markerName);
        
    %figure, set(gcf,'Position',[40 200 560 420])
    %subplot(3,1,1),
    bar(mf(1:Mocapdata.nMarkers)), xlabel('Marker'), ylabel('Num. of Missing frames')
    ax = gca;
    ax.XTick = 1:Mocapdata.nMarkers;
    ax.XTickLabelRotation=45;
    ax.XLim = [0 Mocapdata.nMarkers+1];
    set(gca,'XTickLabel',Mocapdata.markerName);
    % subplot(3,1,2), bar(mm), xlabel('Frame'), ylabel('Num. of Missing markers')
    % subplot(3,1,3), imagesc(-mgrid'), colormap gray, xlabel('Frame'),
    % ylabel('Marker')
    % subplot(3,1,2), bar(mm), xlabel('Frame'), ylabel('Num. of Missing markers')
    % subplot(3,1,3), imagesc(-mgrid'), colormap gray, xlabel('Frame'),
    % ylabel('Marker')
    
    % update position for personal monitor setup
    % use get(gcf,'Position')
    set(gcf,'Position',[112 115 1636 844])
    
    % update position for personal monitor setup
    % use get(gcf,'Position')
    % set(gcf,'Position',[112 115 1636 844])
    
    decision = input('Are there are gaps?\n (1) Yes \n (0) No\n');
    close all
    
    if decision == 1
        clc
        str = char(strcat('Return to',{' '},MocapSoftware,{' '},'to fill gaps in file:',{' '}, trial(1,1)'));
        disp(str)
        clear
        return
    else
        clc
    end
    
end