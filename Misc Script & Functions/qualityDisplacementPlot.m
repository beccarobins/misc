Question = input('Process:\n(1)All trials\n(2)Multiple trials\n(3)One trial\n ');
if Question==1;
    TS = 1;
    load('ExpInfo');
elseif Question==2;
    TS = input('Which trial to start with?\n');
    NumTrials = input('Which trial to end with?\n');
elseif Question==3
    TS = input('Which trial to process?\n');
    NumTrials = TS;
end

for TrialNum = TS:NumTrials;
    load('ParticipantID');
    load('ExpInfo');
    if TrialNum<=9
        load(char(strcat(ExpName,{' '},ParticipantID,{' 0'},num2str(TrialNum),'.mat')));
    elseif TrialNum>9
        load(char(strcat(ExpName,{' '},ParticipantID,{' '},num2str(TrialNum),'.mat')));
    end
    
    TF = strcmp(TrialCondition,'Dummy Trial');
    
    if TF ==0
        
        HeadL = length(Head.Yaw.Displacement);
        EyeL = length(EOG.Subsampled.Displacement.Filt25);
        if HeadL<EyeL
            Max = HeadL;
        else
            Max = EyeL;
        end
        Gaze.Yaw.Displacement = Head.Yaw.Displacement(1:Max)+EOG.Subsampled.Displacement.Filt25(1:Max);
        Gaze.Yaw.Velocity = 200*(diff(Gaze.Yaw.Displacement));
        Gaze.Yaw.Acceleration = 200*(diff(Gaze.Yaw.Velocity));
        Gaze.Yaw.Jerk = 200*(diff(Gaze.Yaw.Acceleration));
        
        MaxX = 1000;
        Xaxes = (((1:MaxX)*5)/1000)';
        
        scrsz = get(0,'ScreenSize');
        figure('Position',scrsz);
        subplot_tight(2,3,1,0.07)
        plot(Xaxes,Head.Yaw.Displacement(1:MaxX),'color',[0 0 0],'LineWidth',2);
        hold('on');
        plot(Xaxes,EOG.Subsampled.Displacement.Filt25(1:MaxX),'k:','LineWidth',2);
        plot(Xaxes,Gaze.Yaw.Displacement(1:MaxX),'k:','LineWidth',2);
        plot(Xaxes,Thorax.Yaw.Displacement(1:MaxX),'color',[.5 .5 .5],'LineWidth',2);
        plot(Xaxes,Pelvis.Yaw.Displacement(1:MaxX),'color',[.75 .75 .75],'LineWidth',2);
        plot(Xaxes,LeftFoot.Yaw.Displacement(1:MaxX),'color',[.5 .5 .5],'LineWidth',2,'LineStyle','--');
        plot(Xaxes,RightFoot.Yaw.Displacement(1:MaxX),'color',[.5 .5 .5],'LineWidth',2,'LineStyle','--');
        %legend('Head','Gaze','Thorax','Pelvis','Location','SouthEast','boxoff');
        xlabel ('Time (s)','FontName','Arial','Fontweight','bold','fontsize',14,'fontweight','bold');
        ylabel ('Amplitude (°)','FontName','Arial','Fontweight','bold','fontsize',14,'fontweight','bold');
        %set(gca,'XTickLabel',{'0','1','2','3'})
        axis([0 5 -20 200])
        set(gca,'fontsize',16)
        TF = strcmp(TrialCondition(1,2),'Control');
        if TF==1
            text(0.25,175,'a','fontsize',18,'fontweight','bold','fontweight','bold');
        else
            TF = strcmp(TrialCondition(1,2),'Subtraction');
            if TF==1
                text(0.25,175,'b','fontsize',18,'fontweight','bold','fontweight','bold');
            else
                text(0.25,175,'c','fontsize',18,'fontweight','bold','fontweight','bold');
            end
        end
        box('off')
        axis square
        
%         subplot_tight(2,3,4,0.07)
%         plot(Xaxes,Head.Yaw.Velocity(1:MaxX),'color',[0 0 0],'LineWidth',2);
%         hold('on');
%         plot(Xaxes,EOG.Subsampled.Velocity.Filt25(1:MaxX),'k:','LineWidth',2);
%         plot(Xaxes,Gaze.Yaw.Velocity(1:MaxX),'k:','LineWidth',2);
%         plot(Xaxes,Thorax.Yaw.Velocity(1:MaxX),'color',[.5 .5 .5],'LineWidth',2);
%         plot(Xaxes,Pelvis.Yaw.Velocity(1:MaxX),'color',[.75 .75 .75],'LineWidth',2);
%         plot(Xaxes,LeftFoot.Yaw.Velocity(1:MaxX),'color',[.5 .5 .5],'LineWidth',2,'LineStyle','--');
%         plot(Xaxes,RightFoot.Yaw.Velocity(1:MaxX),'color',[.5 .5 .5],'LineWidth',2,'LineStyle','--');
%         xlabel ('Time(s)','FontName','Arial','Fontweight','bold','fontsize',14,'fontweight','bold');
%         ylabel ('Velocity(°s^{-1})','FontName','Arial','Fontweight','bold','fontsize',14,'fontweight','bold');
%         axis([0 5 -100 500])
%         set(gca,'fontsize',16)
%         box('off')
%         axis square
%         TF = strcmp(TrialCondition(1,3),'Vision');
%         if TF==1
%             text(0.25,450,'FV','fontsize',14,'fontweight','bold','fontweight','bold');
%         else
%             TF = strcmp(TrialCondition(1,3),'No Vision');
%             if TF==1
%                 text(0.25,450,'NV','fontsize',14,'fontweight','bold','fontweight','bold');
%             else
%                 text(0.25,450,'GF','fontsize',14,'fontweight','bold','fontweight','bold');
%             end
%         end
set(gcf, 'Visible','off');
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
        if TrialNum<=9
            name = char(strcat(ExpName,{' '},ParticipantID,{' 0'},num2str(TrialNum),{' '},'Axial Segment Displacement','.tiff'));
        elseif TrialNum>9
            name = char(strcat(ExpName,{' '},ParticipantID,{' '},num2str(TrialNum),{' '},'Axial Segment Displacement','.tiff'));
        end %what you want the file to be called
        print(f,fullfile(path,name),'-dtiff','-r0','-opengl'); %save file
        close all
    else
    end
end

beep
msgbox('Plot Axial Segment Displacement Script Complete');
clc