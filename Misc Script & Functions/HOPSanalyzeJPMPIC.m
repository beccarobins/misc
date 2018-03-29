function HOPSanalyzeJPMPIC(plane,data,trials,~,setup,f)

%data is all timeseries data (qualisys data
%Determine trial angle and match angle
for i = 28:28
    
    TF = isnan(data.qualisysTrialDisplacement(:,i));
    
    if TF(1,1)==0
        displacement = data.qualisysTrialDisplacement(:,i);
        oculusDisplacement = data.oculusTrialDisplacement(:,i);
        h = f/2;
        positionDisplacement = displacement(1:h);
        matchDisplacement = displacement(h+1:end);
        positionVelocity = diff(positionDisplacement)*75;
        matchVelocity = diff(matchDisplacement)*75;
        
        [~,maxVelTime] = max(positionVelocity);
        [~,minVelTime] = min(positionVelocity);
        
        errorStart = minVelTime;
        
        max2min = minVelTime-maxVelTime;
        positionTime = round(max2min/2)+maxVelTime;
        
        [~,maxVelTime] = max(matchVelocity);
        [~,minVelTime] = min(matchVelocity);
        
        errorEnd = maxVelTime+h;
        midError = round((errorEnd-errorStart)/2)+errorStart;
        
        max2min = minVelTime-maxVelTime;
        matchTime = (round(max2min/2)+maxVelTime)+h;
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        
        y1 = [displacement(positionTime)+2,displacement(positionTime)+12];%y needs to be below the value at the timestamp
        my1 = [displacement(positionTime)+3,displacement(positionTime)+3];%y needs to be below the value at the timestamp
        x1 = [(positionTime/75),(positionTime/75)];
        y2 = [displacement(matchTime)+2,displacement(matchTime)+12];%y needs to be below the value at the timestamp
        my2 = [displacement(matchTime)+3,displacement(matchTime)+3];%y needs to be below the value at the timestamp
        x2 = [(matchTime/75),(matchTime/75)];
        
        positionMeasurement(1:errorEnd-errorStart) = displacement(positionTime);
        matchMeasurement(1:errorEnd-errorStart) = displacement(matchTime);
        if positionMeasurement(1,1)<matchMeasurement(1,1)
            bottomLine = horzcat(nan(1,errorStart),positionMeasurement,nan(1,f-errorEnd));
            topLine = horzcat(nan(1,errorStart),matchMeasurement,nan(1,f-errorEnd));
            errorPosition = matchMeasurement(1,1)+2;
        else
            bottomLine = horzcat(nan(1,errorStart),matchMeasurement,nan(1,f-errorEnd));
            topLine = horzcat(nan(1,errorStart),positionMeasurement,nan(1,f-errorEnd));
            errorPosition = positionMeasurement(1,1)+2;
        end
        verticalLine = [positionMeasurement(1,1),matchMeasurement(1,1)];
        verticalX = [(midError/75),(midError/75)];
        
        Xaxes = ((1:f)/75);
        plot(Xaxes,oculusDisplacement(1:f),'b','linewidth',3);
        hold on
        plot(Xaxes,displacement(1:f),'r','linewidth',3);
        plot(Xaxes,bottomLine,'k','linewidth',2);
        plot(Xaxes,topLine,'k','linewidth',2);
        plot(verticalX,verticalLine,'k','linewidth',2);
        text(verticalX(1,1)-2,errorPosition+1,'Error','fontsize',32,'fontweight','bold','fontname','Gill Sans MT');
        plot(x1,y1,'k','linewidth',2);
        plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
        text(x1(1,1)-6.5,my1(1,1)+13,'Position Angle','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');
        plot(x2,y2,'k','linewidth',2);
        plot(x2,my2,'vk','MarkerSize',10,'MarkerFaceColor','k');
        text(x2(1,1)-5,my2(1,1)+13,'Match Angle','fontsize',40,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',50,'fontweight','bold','fontname','Gill Sans MT')
        %Legend = {'Oculus','Qualisys'};
        %legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold','fontname','Gill Sans MT');
        %legend('boxoff');
        title('JPM Analysis','fontsize',55,'fontweight','bold','fontname','Gill Sans MT');
        set(gca,'fontsize',50,'fontname','Gill Sans MT')
        set(gca,'Ticklength',[0,0]);
        box('off')
        t = f/75;
        axis([0 t -20 100]);
        axis square
        set(gcf, 'Visible','off');
        
        F=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(F); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
        name = char(strcat('JMP measurements',{' - '},num2str(i),'.tiff'));
        print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        close all;clc
    end
    clearvars -except setup plane data trials positionAngle matchAngle trialInfo f oculusPositionAngle oculusMatchAngle
end