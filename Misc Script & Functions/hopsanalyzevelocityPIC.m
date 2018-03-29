function hopsanalyzevelocityPIC(plane,data,trials,setup,v)

for i = 1:trials%determines the peak velocity TOWARDS the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        
        oculusVelocity = data.oculusTrialVelocity(:,i);
        qualisysVelocity = data.qualisysTrialVelocity(:,i);
        
        [~,maxVelTime] = max(qualisysVelocity(1:525));
        
        [~,minVelTime] = min(qualisysVelocity(526:end));
        minVelTime = minVelTime+525;
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        y1 = [qualisysVelocity(maxVelTime)+5,qualisysVelocity(maxVelTime)+35];%y needs to be below the value at the timestamp
        my1 = [qualisysVelocity(maxVelTime)+5,qualisysVelocity(maxVelTime)+5];%y needs to be below the value at the timestamp
        x1 = [(maxVelTime/75),(maxVelTime/75)];
        y2 = [qualisysVelocity(minVelTime)-5,qualisysVelocity(minVelTime)-35];%y needs to be below the value at the timestamp
        my2 = [qualisysVelocity(minVelTime)-5,qualisysVelocity(minVelTime)-5];%y needs to be below the value at the timestamp
        x2 = [(minVelTime/75),(minVelTime/75)];
        Xaxes = ((1:v)/75);
        plot(Xaxes,oculusVelocity(1:v),'b','linewidth',3);
        hold on
        plot(Xaxes,qualisysVelocity(1:v),'r','linewidth',3);
        plot(x1,y1,'k','linewidth',2);
        plot(x1,my1,'vk','MarkerSize',20,'MarkerFaceColor','k');
        text(x1(1,1)-3,my1(1,1)+40,'Peak TO Target','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        plot(x2,y2,'k','linewidth',2);
        plot(x2,my2,'^k','MarkerSize',20,'MarkerFaceColor','k');
        text(x2(1,1)-5,my2(1,1)-40,'Peak FROM Target','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Velocity (', sprintf('%c', char(176)),'s^{-1})');
        ylabel(yLabel,'fontsize',30,'fontweight','bold','fontname','Gill Sans MT')
        %xlabel('Time (s)','fontsize',30,'fontweight','bold')
        %             Legend = {'Oculus','Qualisys'};
        %             legend(Legend,'Location','NorthEast','fontsize',22,'fontweight','bold');
        %             legend('boxoff');
        % title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Velocity TO Target'),'fontsize',22,'fontweight','bold');
        set(gca,'fontsize',45,'fontname','Gill Sans MT')
        box('off')
        t = v/75;
        axis([0 12 -150 150]);
        axis square
        set(gcf, 'Visible','off');
        
        F=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(F); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        name = char(strcat(plane,{' '},'Velocity Analysis',{' - '},num2str(i),'.tiff'));
        print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        close all;clc
    end
    clearvars -except setup plane data trials oculusTrialPeakVel qualisysTrialPeakVel v
    clc
end