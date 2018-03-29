function HOPSprocessPIC(plane,oculusData,qualisysData,trials,f,oculusMarks,setup)
%f = frames per trial;
oculusSessionData = vertcat(oculusData,nan((f*trials)-length(oculusData),1));
qualisysSessionData = vertcat(qualisysData,nan((f*trials)-length(qualisysData),1));
oculusTrialsRaw = nan(f,trials);
oculusTrials = nan(f,trials);
qualisysTrials = nan(f,trials);
study = strsplit(pwd,'\');%subject name generated from folder
study = char(study(:,end-1));
ST = strcmp(study,'Pilot Validation and Joint Position Matching Data');

for i = 1:trials%must start at 1 because trials are being processed from full session
    
    if ST==1
        if oculusMarks(i,:)>0%flips session data so that trial is positive
            oculusTrialsRaw(:,i) = -oculusSessionData(1:f);
            qualisysTrials(:,i) = -qualisysSessionData(1:f);
        else
            oculusTrialsRaw(:,i) = oculusSessionData(1:f);
            qualisysTrials(:,i) = qualisysSessionData(1:f);
        end
    else
        if oculusMarks(i,:)>0%flips session data so that trial is positive
            oculusTrialsRaw(:,i) = oculusSessionData(1:f);
            qualisysTrials(:,i) = qualisysSessionData(1:f);
        else
            oculusTrialsRaw(:,i) = -oculusSessionData(1:f);
            qualisysTrials(:,i) = -qualisysSessionData(1:f);
        end
    end
    
    qualisysTrials(:,i) = qualisysTrials(:,i)-qualisysTrials(1,i);
    oculusSessionData(1:f) = [];
    qualisysSessionData(1:f) = [];
    question = 0;
    lastTime = 0;
    test = -1;
    while question == 0;
        test = test+1;
        lastTime = lastTime+25;
        oculusVelTrials(:,i) = diff(oculusTrialsRaw(:,i))*75; %#ok<*AGROW>
        oculusAccTrials(:,i) = diff(oculusVelTrials(:,i))*75;
        currentAcc = oculusAccTrials(:,i);
        times = 0;
        
        for N = 2:lastTime
            if currentAcc(N)<-100||currentAcc(N)>100
                times = times+1;
                zeroTime(times) = N;
            end
        end
        
        TF = exist('zeroTime','var');
        
        if TF==0
            zeroTime = 1;%offset for recalibration
        else
            zeroTime = max(zeroTime);
        end
        
        oculusTrials(:,i) = oculusTrialsRaw(:,i)-oculusTrialsRaw(zeroTime,i);%zeros out trial data
        qualisysTrials(:,i) = qualisysTrials(:,i)-qualisysTrials(zeroTime,i);
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        Xaxes = ((1:f)/75);
        y1 = [oculusTrials(zeroTime(1,1),i)-10,oculusTrials(zeroTime(1,1),i)-3];%y needs to be below the value at the timestamp
        x1 = [(zeroTime(1,1)/75),(zeroTime(1,1)/75)];
        my1 = [oculusTrials(zeroTime(1,1),i)-3,oculusTrials(zeroTime(1,1),i)-3];%y needs to be below the value at the timestamp
        plot(Xaxes,oculusTrials((1:f),i),'b','linewidth',3);
        hold on
        plot(Xaxes,qualisysTrials((1:f),i),'r','linewidth',3);
        if test==0
            plot(1.5,0,'ok','MarkerSize',50,'linewidth',4);
            text(0,-8,'Offset','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');
        else
            plot(x1,y1,'k','linewidth',2);
            plot(x1,my1,'^k','MarkerSize',10,'MarkerFaceColor','k');
            text(x1(1,1)-3,y1(1,1)-3,'Calibration Point','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');
        end
        %text((oculusTrials(zeroTime(1,1),i)/75)-3,oculusTrials(zeroTime(1,1),i)-12,'Calibration Point','fontsize',25,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
        %Legend = {'Oculus','Qualisys'};
        %legend(Legend,'Location','NorthEast','fontsize',22,'fontname','Gill Sans MT');
        %legend('boxoff');
        if test==0
            title('Raw Trial Data','fontsize',55,'fontweight','bold','fontname','Gill Sans MT');
        else
            title('Calibration Procedure','fontsize',55,'fontweight','bold','fontname','Gill Sans MT');
        end
        set(gca,'fontsize',50,'fontname','Gill Sans MT')
        set(gca,'Ticklength',[0,0]);
        box('off');
        t = f/75;
        axis([0 t -20 100]);
        axis square
        set(gcf, 'Visible','off');
        
        if test==0
            question = 0;
            F=gcf; %f is the handle of the figure you want to export
            figpos=getpixelposition(F); %dont need to change anything here
            resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
            set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
            path= pwd; %the folder where you want to put the file
            
            name = char(strcat('Pre-cal ',{' - '},num2str(i),'.tiff'));
            print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
            close all;clc
        elseif test<4
            question = 0;
            F=gcf; %f is the handle of the figure you want to export
            figpos=getpixelposition(F); %dont need to change anything here
            resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
            set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
            path= pwd; %the folder where you want to put the file
            
            name = char(strcat('Post-cal ',{' - '},num2str(i),{'-'},num2str(test),'.tiff'));
            print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
            close all;clc
        else
            question = 1;
        end
        
        Start(:,i) = zeroTime;
        
        if question==1
            hopstrialsyncPIC(oculusTrials(:,i),qualisysTrials(:,i),f,Start(:,i),i,setup);
        end
        clearvars -except test setup plane qualisysTrials oculusTrials oculusMarks i lastTime trials f question oculusTrialsRaw oculusSessionData qualisysSessionData ST
    end
end