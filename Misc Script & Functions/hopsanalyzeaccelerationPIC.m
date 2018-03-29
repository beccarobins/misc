function accelerationVariables = hopsanalyzeaccelerationPIC(plane,data,trials,setup,a)

for i = 1:trials%determines the peak acceleration TOWARDS the target amplitude to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        
        oculusAcceleration = data.oculusTrialAcceleration(:,i);
        qualisysAcceleration = data.qualisysTrialAcceleration(:,i);
        
        [~,maxAccTime] = max(qualisysAcceleration(1:525));%finds peak Acc during first half of trial
        [~,minAccTime] = min(qualisysAcceleration(526:end));%finds peak Acc during last half of trial
        minAccTime = minAccTime+525;%corrects for maxAccTime by adding first half frame #
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        y1 = [qualisysAcceleration(maxAccTime)+10,qualisysAcceleration(maxAccTime)+75];%y needs to be below the value at the timestamp
        my1 = [qualisysAcceleration(maxAccTime)+10,qualisysAcceleration(maxAccTime)+10];%y needs to be below the value at the timestamp
        x1 = [(maxAccTime/75),(maxAccTime/75)];
        y2 = [qualisysAcceleration(minAccTime)-10,qualisysAcceleration(minAccTime)-75];%y needs to be below the value at the timestamp
        my2 = [qualisysAcceleration(minAccTime)-10,qualisysAcceleration(minAccTime)-10];%y needs to be below the value at the timestamp
        x2 = [(minAccTime/75),(minAccTime/75)];
        Xaxes = ((1:a)/75);
        plot(Xaxes,oculusAcceleration(1:a),'b','linewidth',3);
        hold on
        plot(Xaxes,qualisysAcceleration(1:a),'r','linewidth',3);
        plot(x1,y1,'k','linewidth',2);
        plot(x1,my1,'vk','MarkerSize',10,'MarkerFaceColor','k');
        text(x1(1,1)-3,my1(1,1)+100,'Peak TO Target','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        plot(x2,y2,'k','linewidth',2);
        plot(x2,my2,'^k','MarkerSize',10,'MarkerFaceColor','k');
        text(x2(1,1)-3,my2(1,1)-100,'Peak FROM Target','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Acceleration (', sprintf('%c', char(176)),'s^{-2})');
        ylabel(yLabel,'fontsize',45,'fontweight','bold','fontname','Gill Sans MT')
        xlabel('Time (s)','fontsize',45,'fontweight','bold','fontname','Gill Sans MT')
        %         Legend = {'Oculus','Qualisys'};
        %         legend(Legend,'Location','NorthEast','fontsize',30,'fontweight','bold');
        %         legend('boxoff');
        %         title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Acceleration TO Target'),'fontsize',22,'fontweight','bold');
        set(gca,'fontsize',45,'fontname','Gill Sans MT')
        box('off')
        t = a/75;
        axis([0 12 -500 500]);
        axis square
        set(gcf, 'Visible','off');
        
        F=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(F); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        name = char(strcat(plane,{' '},'Acceleration Analysis',{' - '},num2str(i),'.tiff'));
        print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        close all;clc
    end
    clearvars -except setup plane data trials oculusTrialPeakAcc qualisysTrialPeakAcc a
    clc
end