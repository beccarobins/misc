function Plot_Axial_Segment_Displacement_Velocity


        scrsz = get(0,'ScreenSize');
        figure('Position',scrsz);
        MaxX = length(Head.Yaw.Velocity);
        Xaxes = (((1:MaxX)*5)/1000)';
        plot(Xaxes,Head.Yaw.Displacement(1:MaxX),'k');
        hold
        plot(Xaxes,Head.Yaw.Velocity,'b');
        TrialNumber = num2str(TrialNum);
        Title = strcat('Trial Number',{' '},TrialNumber);
        title(strcat('Head Yaw Displacement & Velocity -',Title));
        legend('Displacement','Velocity','Location','SouthEast');
        xlabel ('Time(s)');
        ylabel ('Displacement(°) & Velocity (°s^1)');
        %set(gcf, 'Visible','off');
        pause
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
        if TrialNum<=9
            name = char(strcat(ExpName,{' '},ParticipantID,{' 0'},num2str(TrialNum),{' '},'Head Yaw Displacement & Velocity','.tiff'));
        elseif TrialNum>9
            name = char(strcat(ExpName,{' '},ParticipantID,{' '},num2str(TrialNum),{' '},'Head Yaw Displacement & Velocity','.tiff'));
        end %what you want the file to be called
        print(f,fullfile(path,name),'-dtiff','-r0','-opengl'); %save file
        close all
        
        scrsz = get(0,'ScreenSize');
        figure('Position',scrsz);
        MaxX = length(Head.Yaw.Velocity);
        Xaxes = (((1:MaxX)*5)/1000)';
        plot(Xaxes,Thorax.Yaw.Displacement(1:MaxX),'k');
        hold
        plot(Xaxes,Thorax.Yaw.Velocity,'b');
        TrialNumber = num2str(TrialNum);
        Title = strcat('Trial Number',{' '},TrialNumber);
        title(strcat('Thorax Yaw Displacement & Velocity -',Title));
        legend('Displacement','Velocity','Location','SouthEast');
        xlabel ('Time(s)');
        ylabel ('Displacement(°) & Velocity (°s^1)');
        %set(gcf, 'Visible','off');
        pause
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
        if TrialNum<=9
            name = char(strcat(ExpName,{' '},ParticipantID,{' 0'},num2str(TrialNum),{' '},'Thorax Yaw Displacement & Velocity','.tiff'));
        elseif TrialNum>9
            name = char(strcat(ExpName,{' '},ParticipantID,{' '},num2str(TrialNum),{' '},'Thorax Yaw Displacement & Velocity','.tiff'));
        end %what you want the file to be called
        print(f,fullfile(path,name),'-dtiff','-r0','-opengl'); %save file
        close all
        
        scrsz = get(0,'ScreenSize');
        figure('Position',scrsz);
        MaxX = length(Head.Yaw.Velocity);
        Xaxes = (((1:MaxX)*5)/1000)';
        plot(Xaxes,Pelvis.Yaw.Displacement(1:MaxX),'k');
        hold
        plot(Xaxes,Pelvis.Yaw.Velocity,'b');
        TrialNumber = num2str(TrialNum);
        Title = strcat('Trial Number',{' '},TrialNumber);
        title(strcat('Pelvis Yaw Displacement & Velocity -',Title));
        legend('Displacement','Velocity','Location','SouthEast');
        xlabel ('Time(s)');
        ylabel ('Displacement(°) & Velocity (°s^1)');
        %set(gcf, 'Visible','off');
        pause
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
 