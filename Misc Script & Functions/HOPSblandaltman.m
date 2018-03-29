planes = {'Yaw';'Pitch';'Roll'};

for i = 1:3
    [a,b] = xlsread('HOPS - Validity Data.xlsx',char(strcat(planes(i,:),'-SPSS-ICC')));
    
    for j = 1:length(a)/4
        qualisys = a(:,1);
        oculus = a(:,2);
        a(:,1:4) = [];
        angle = strsplit(char(b(1,1)),' ');
        angle = char(angle(1,2));
        b(:,1:4) = [];
        dataTitle = (char(strcat(planes(i,:),angle)));
        blandaltplot(qualisys,oculus,dataTitle);
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        path= pwd; %the folder where you want to put the file
        
        name = char(strcat('Bland-Altman Plots -',dataTitle,'.tiff'));
        print(f,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        %close all
    end
end