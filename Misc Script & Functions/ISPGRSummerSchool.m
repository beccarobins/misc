clear;
folder_name = uigetdir; %select participant folder
cd(folder_name)
name = [folder_name '\*.xls'];
Files = dir(name);
nFiles = length(Files);

for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'CP_ML_LF');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'Centre of Pressure - Medio-Lateral Displacement'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Time = [0:100];
    Y = 95;
    for j = 1:16
        
        Max = max(Data(j,:));
        
        if Max>0
            Y = Y-4;
            Num = num2str(Participant(j,1));
            plot(Time,Data(j,:))
            text(102,Y,strcat('Participant',{' '},Num));
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'APdist_CP_RF_post');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'Anterior-Posterior Distance of COP to Right Foot'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            plot(Data(j,:))
            text(110,Y,Num);
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'vitCOP_1');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'COP Velocity (X)'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            plot(Data(j,:),1)
            text(110,Y,Num);
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'vitCOP_2');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'COP Velocity (Y)'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            plot(Data(j,:))
            text(110,Y,Num);
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'vitCOP_3');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'COP Velocity (Z)'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            plot(Data(j,:))
            text(110,Y,Num);
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'APdist_CP_RF_posM');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'Anterior-Posterior Distance of COP to Right Malleolus'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            plot(Data(j,:))
            text(110,Y,Num);
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end
for i = 1:nFiles
    
    FileName = getfield(Files(i,1),'name');
    
    [Data,Participants] = xlsread(FileName,'APdist_CP_RF_posE');
    
    file1 = strsplit(FileName,'_');
    file2 = char(file1(1,2));
    file3 = strsplit(file2,'-');
    Condition = file3(1,1);
    
    Data = Data(2:17,:);
    Participant = [123;nan;073;nan;132;nan;146;nan;186;nan;008;036;040;177;nan;016];
    
    plot_meanSD(Data);
    xlabel('Frame (N)')
    ylabel('%')
    title([Condition,'Anterior-Posterior Distance of COP to Right Malleolus SD'])
    set(gcf,'Position',[49 59 1850 917])
    hold
    
    pause
    
    Y = 95;
    for j = 1:16
        Y = Y-4;
        Num = num2str(Participant(j,1));
        Max = max(Data(j,:));
        
        if Max>0
            
            plot(Data(j,:))
            text(110,Y,strcat('Participant',{' '},Num));
            pause
        else
        end
    end
    clearvars Data
    close all
    clc
    
end