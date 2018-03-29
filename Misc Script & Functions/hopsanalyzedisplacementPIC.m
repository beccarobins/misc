function hopsanalyzedisplacementPIC(plane,data,trials,setup,f)

for i = 6:trials%determines an angular position measurement during the sustained head rotation to use in the validity analysis
    
    TF = isnan(data.oculusTrialDisplacement(:,i));
    
    if TF(1,1)==0
        oculusDisplacement = data.oculusTrialDisplacement(:,i);
        qualisysDisplacement = data.qualisysTrialDisplacement(:,i);
        qualisysVelocity = data.qualisysTrialVelocity(:,i);
        [~,maxVelTime] = max(qualisysVelocity);
        [~,minVelTime] = max(-qualisysVelocity);
        
        max2min = minVelTime-maxVelTime;
        trialTime = round(max2min/2)+maxVelTime;
        
        
        if setup==1
            scrsz = get(0,'ScreenSize');
            figure('Position',scrsz);
        else
            set(gcf,'Position',[697 45 1214 964]);
        end
        y1 = [qualisysDisplacement(trialTime)+2,qualisysDisplacement(trialTime)+12];%y needs to be below the value at the timestamp
        my1 = [qualisysDisplacement(trialTime)+3,qualisysDisplacement(trialTime)+3];%y needs to be below the value at the timestamp
        x1 = [(trialTime/75),(trialTime/75)];
        Xaxes = ((1:f)/75);
        plot(Xaxes,oculusDisplacement(1:f),'b','linewidth',3);
        hold on
        plot(Xaxes,qualisysDisplacement(1:f),'r','linewidth',3);
        plot(x1,y1,'k','linewidth',2);
        plot(x1,my1,'vk','MarkerSize',20,'MarkerFaceColor','k');
        text(x1(1,1)-3,my1(1,1)+13,'Position Measurement','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        yLabel = strcat('Amplitude (', sprintf('%c', char(176)),')');
        ylabel(yLabel,'fontsize',45,'fontweight','bold','fontname','Gill Sans MT')
        %xlabel('Time (s)','fontsize',45,'fontweight','bold')
        Legend = {'Oculus','Qualisys'};
        legend(Legend,'Location','NorthEast','fontsize',45,'fontweight','bold','fontname','Gill Sans MT');
        legend('boxoff');
        %title(strcat(plane,{' '},'Trial',{' '},num2str(i),' - Measurement for Position Analysis'),'fontsize',22,'fontweight','bold');
        set(gca,'fontsize',45,'fontname','Gill Sans MT')
        box('off')
        t = f/75;
        axis([0 12 -20 100]);
        axis square
        set(gcf, 'Visible','off');
        
        F=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(F); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(F,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        name = char(strcat(plane,{' '},'Displacment Analysis',{' - '},num2str(i),'.tiff'));
        print(F,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        close all;clc
    end
    clearvars -except setup plane data trials oculusTrialAngle qualisysTrialAngle trialInfo f
    clc
end