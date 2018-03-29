close all;clear;clc

cd('F:\Exp 1 - Behaviour\');

Amplitude = {'Deg45' 'Deg90' 'Deg135' 'Deg180'};
Speed = {'Moderate' 'Fast'};

load('ParticipantList.mat');

for ii = 1:2
    
    for j = 1:4
        grandEyeDisMean = [];
        grandGazeDisMean = [];
        grandHeadDisMean = [];
        grandThoraxDisMean = [];
        grandPelvisDisMean = [];
        
        grandEyeVelMean = [];
        grandGazeVelMean = [];
        grandHeadVelMean = [];
        grandThoraxVelMean = [];
        grandPelvisVelMean = [];
        
        for subjectID = 1:length(ParticipantList);
            
            cd(char(strcat('F:\Exp 1 - Behaviour\',ParticipantList(subjectID,:),'\',ParticipantList(subjectID,:),{' '},'MATLAB')));
            
            eyeDisMean = [];
            gazeDisMean = [];
            headDisMean = [];
            thoraxDisMean = [];
            pelvisDisMean = [];
            
            eyeVelMean = [];
            gazeVelMean = [];
            headVelMean = [];
            thoraxVelMean = [];
            pelvisVelMean = [];
            
            for TrialNum = 1:80;
                load('ParticipantID');
                load('ExpInfo');
                if TrialNum<=9
                    load(char(strcat(ExpName,{' '},ParticipantID,{' 0'},num2str(TrialNum),'.mat')));
                elseif TrialNum>9
                    load(char(strcat(ExpName,{' '},ParticipantID,{' '},num2str(TrialNum),'.mat')));
                end
                
                TF = strcmp(TrialCondition,'Dummy Trial');
                
                if TF ==0
                    TF = strcmp(TrialCondition(1,2),Amplitude(:,j));
                    if TF ==1
                        TF = strcmp(TrialCondition(1,3),Speed(:,ii));
                        if TF ==1
                            AxialSegmentOnsets = [Head.Yaw.DisplacementVariables.OnsetLatency,Thorax.Yaw.DisplacementVariables.OnsetLatency,Pelvis.Yaw.DisplacementVariables.OnsetLatency];
                            Min = min(AxialSegmentOnsets);
                            AxialSegmentEnds = [Head.Yaw.DisplacementVariables.EndTime,Thorax.Yaw.DisplacementVariables.EndTime,Pelvis.Yaw.DisplacementVariables.EndTime];
                            Max = max(AxialSegmentEnds);
                            NormalizedData.TimeNormalized.Gaze.Yaw.Displacement = timenorm(Gaze.Yaw.Displacement,Min,Max);
                            NormalizedData.TimeNormalized.Gaze.Yaw.Velocity = timenorm(Gaze.Yaw.Velocity,Min,Max);
                            NormalizedData.TimeNormalized.Eye.Yaw.Displacement = timenorm(EOG.Subsampled.Displacement.Filt10,Min,Max);
                            NormalizedData.TimeNormalized.Eye.Yaw.Velocity = timenorm(EOG.Subsampled.Velocity.Filt10,Min,Max);
                            
                            eyeDisMean = vertcat(eyeDisMean,NormalizedData.TimeNormalized.Eye.Yaw.Displacement');
                            gazeDisMean = vertcat(gazeDisMean,NormalizedData.TimeNormalized.Gaze.Yaw.Displacement');
                            headDisMean = vertcat(headDisMean,NormalizedData.TimeNormalized.Head.Yaw.Displacement');
                            thoraxDisMean = vertcat(thoraxDisMean,NormalizedData.TimeNormalized.Thorax.Yaw.Displacement');
                            pelvisDisMean = vertcat(pelvisDisMean,NormalizedData.TimeNormalized.Pelvis.Yaw.Displacement');
                            
                            eyeVelMean = vertcat(eyeVelMean,NormalizedData.TimeNormalized.Eye.Yaw.Velocity');
                            gazeVelMean = vertcat(gazeVelMean,NormalizedData.TimeNormalized.Gaze.Yaw.Velocity');
                            headVelMean = vertcat(headVelMean,NormalizedData.TimeNormalized.Head.Yaw.Velocity');
                            thoraxVelMean = vertcat(thoraxVelMean,NormalizedData.TimeNormalized.Thorax.Yaw.Velocity');
                            pelvisVelMean = vertcat(pelvisVelMean,NormalizedData.TimeNormalized.Pelvis.Yaw.Velocity');
                            
                        end
                    end
                end
            end
            grandEyeDisMean = vertcat(grandEyeDisMean,nanmean(eyeDisMean));
            grandGazeDisMean = vertcat(grandGazeDisMean,nanmean(gazeDisMean));
            grandHeadDisMean = vertcat(grandHeadDisMean,nanmean(headDisMean));
            grandThoraxDisMean = vertcat(grandThoraxDisMean,nanmean(thoraxDisMean));
            grandPelvisDisMean = vertcat(grandPelvisDisMean,nanmean(pelvisDisMean));
            
            grandEyeVelMean = vertcat(grandEyeVelMean,nanmean(eyeVelMean));
            grandGazeVelMean = vertcat(grandGazeVelMean,nanmean(gazeVelMean));
            grandHeadVelMean = vertcat(grandHeadVelMean,nanmean(headVelMean));
            grandThoraxVelMean = vertcat(grandThoraxVelMean,nanmean(thoraxVelMean));
            grandPelvisVelMean = vertcat(grandPelvisVelMean,nanmean(pelvisVelMean));
            cd('F:\Exp 1 - Behaviour\');
            load('ParticipantList.mat');load('ParticipantList.mat');
        end
        
        %(1) Plot:
        close all
        subplot_tight(6,2,1,.03)
        [s00,s01] = spm1d_plot_meanSE(grandEyeDisMean);
        hold on
        [t00,t01] = spm1d_plot_meanSE(grandGazeDisMean);
        [h00,h01] = spm1d_plot_meanSE(grandHeadDisMean);
        [h10,h11] = spm1d_plot_meanSE(grandThoraxDisMean);
        [h20,h21] = spm1d_plot_meanSE(grandPelvisDisMean);
        set(s00, 'color',[0.4,0,0.8]);   set(s01, 'facecolor',[0.8,0.6,1]);
        set(t00, 'color',[0,0.4,0.5]);   set(t01, 'facecolor',[0,1,0.5]);
        set(h00, 'color','b');   set(h01, 'facecolor',[0,0.6,1]);
        set(h10, 'color','k');   set(h11, 'facecolor',0.7*[1 1 1]);
        set(h20, 'color','r');   set(h21, 'facecolor',[1,0.4,0.2]);
        axis([0 2000 -20 200])
        ylabel('Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,3,.03)
        Xaxes = 1:2000;
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandEyeDisMean', 'LineWidth', .5);
        axis([0 2000 -20 200])
        ylabel('Eye Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,5,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandGazeDisMean', 'LineWidth', .5);
        axis([0 2000 -20 200])
        ylabel('Gaze Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,7,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandHeadDisMean', 'LineWidth', .5);
        axis([0 2000 -20 200])
        ylabel('Head Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,9,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandThoraxDisMean', 'LineWidth', .5);
        axis([0 2000 -20 200])
        ylabel('Thorax Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,11,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandPelvisDisMean', 'LineWidth', .5);
        axis([0 2000 -20 200])
        ylabel('Pelvis Amplitude (°s)','FontName','Arial')
        xlabel('Time (%)')
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        axis square
        
        subplot_tight(6,2,2,.03)
        [s00,s01] = spm1d_plot_meanSE(grandEyeVelMean);
        hold on
        [t00,t01] = spm1d_plot_meanSE(grandGazeVelMean);
        [h00,h01] = spm1d_plot_meanSE(grandHeadVelMean);
        [h10,h11] = spm1d_plot_meanSE(grandThoraxVelMean);
        [h20,h21] = spm1d_plot_meanSE(grandPelvisVelMean);
        set(s00, 'color',[0.4,0,0.8]);   set(s01, 'facecolor',[0.8,0.6,1]);
        set(t00, 'color',[0,0.4,0.5]);   set(t01, 'facecolor',[0,1,0.5]);
        set(h00, 'color','b');   set(h01, 'facecolor',[0,0.6,1]);
        set(h10, 'color','k');   set(h11, 'facecolor',0.7*[1 1 1]);
        set(h20, 'color','r');   set(h21, 'facecolor',[1,0.4,0.2]);
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        xlabel('Time (%)')
        ylabel('Velocity (°s^1)','FontName','Arial');
        axis([0 2000 -100 400])
        axis square
        
        subplot_tight(6,2,4,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandEyeVelMean', 'LineWidth', .5);
        axis([0 2000 -100 400])
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        ylabel('Eye Velocity (°s^1)','FontName','Arial');
        xlabel('Time (%)')
        axis square
        
        subplot_tight(6,2,6,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandGazeVelMean', 'LineWidth', .5);
        axis([0 2000 -100 400])
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        ylabel('Gaze Velocity (°s^1)','FontName','Arial');
        xlabel('Time (%)')
        axis square
        
        subplot_tight(6,2,8,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandHeadVelMean', 'LineWidth', .5);
        axis([0 2000 -100 400])
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        ylabel('Head Velocity (°s^1)','FontName','Arial');
        xlabel('Time (%)')
        axis square
        
        subplot_tight(6,2,10,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandThoraxVelMean', 'LineWidth', .5);
        axis([0 2000 -100 400])
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        ylabel('Thorax Velocity (°s^1)','FontName','Arial');
        xlabel('Time (%)')
        axis square
        
        subplot_tight(6,2,12,.03)
        set(gca, 'ColorOrder', [0.4,0,0.8;1 0 0;0,1,0.7;0 0.2 .9;0 0 0], 'NextPlot', 'replacechildren');
        plot(Xaxes',grandPelvisVelMean', 'LineWidth', .5);
        axis([0 2000 -100 400])
        set(gca,'XTickLabel',{'0','25','50','75','100'})
        ylabel('Pelvis Velocity (°s^1)','FontName','Arial');
        xlabel('Time (%)')
        axis square
        set(gcf, 'Position',[-2999 -367 1080 1844]);
        set(gcf, 'Visible','off');
        
        %rez=1200; %resolution (dpi) of final graphic
        f=gcf; %f is the handle of the figure you want to export
        figpos=getpixelposition(f); %dont need to change anything here
        resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
        set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
        cd('F:\Exp 1 - Behaviour\');
        path= pwd; %the folder where you want to put the file
        
        name = char(strcat(ExpName,{' '},'Saglam Plots -',Amplitude(:,j),{' '},Speed(:,ii),'.tiff'));
        print(f,fullfile(path,name),'-dtiff','-r300','-opengl'); %save file
        close all
        
        load('ParticipantList.mat');
    end
end

tts('S E cloud plots complete');