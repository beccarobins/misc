% Simple single link in Simulink

%% Initial set up (don't change)
    clear all global
    close all
    
    global samprate %sample rate
    global JL ALg %inertia, gravity (mass x g x com height)
    
    samprate=200; %samping rate (Hz)
    J = 80; m = 60; h=1; g=9.81; mgh = m*g*h;  

    %% Model parameters
    Td = 0.18; %Time delay - on proprioception, vestibular, visual
    
    Wvest = .0; %Vestibular + Visual reliance (weight)
    Wvis  = .765; %Vestibular + Visual reliance (weight)
    Wprop = 1-Wvest-Wvis; %Proprioceptive relatince (weight)
    
    Kp = 900;  %"Neural stiffness" (900) newton meter/radian
    Kd = 350;   %"Neural damping" (350)
    Ki = 0;     %"Neural integral" (30)
    
    K=0;        %Passive stiffness (orients body to surface w/no time delay)
    B=0;        %Passive damping (resists velocity of body wrt surface w/no time delay)

    %% Stimulus parameters
    %Stimulus scaling
    Sscale=0; %scaling on surface tilt angle (input equals amp of stim in degrees)
    Vscale=2; %scaling on visual tilt (equals amp of stim in degrees)
    Tscale=0; %scaling on ankle torque perturbation (N.m) 
    Vestscale=0; %scaling on vestibul input
    Nscale = 0; %scaling on noise 
   
    %Stimulus type
    Stim_type = 2; % 0 =step response; 1 =PRTS (pseudorandom input); 2=sine wave
    V_freq = 2
    ; % if sine wave, enter in frequency in Hz 
    
    %% Program to create stimulus
    load SURF_IN.mat; %sample stimulus waveform
    stim_sim1cycle  = (SURF_IN.pos-mean(SURF_IN.pos(1:5))); %setting to ACTUAL ss stim for one cycle, 2 deg PP stim is what the SURF_IN.pos is based on
    L=length(stim_sim1cycle);
    
    %Time vector
    t_sim = [0,(1:(1200+length(stim_sim1cycle)-1))/samprate]'; %time vector - the 1200 is 3s before and after
    
    if Stim_type==1 %prts
    Stim_sim = 1*[zeros(600,1);stim_sim1cycle;zeros(600,1)];
    elseif Stim_type==0 %step input
    Stim_sim = 1*[zeros(600,1);ones(L+600,1)]; %step input
    elseif Stim_type==2 %sine wave
    Stim_sim = 1*[sin(t_sim*2*pi*V_freq)];
    end
  
    %Noise stimulus
    [NoiseLB_T_sim2]=pinknoise(length(t_sim));
    NoiseLB_T_sim=Nscale*.0033*0.15*NoiseLB_T_sim2';
    %Surface tilt stimulus
    SS_sim = Sscale*Stim_sim;
    %Visual tilt stimulus
    VS_sim = Vscale*Stim_sim;
    %Vestib tilt stimulus
    Vest_sim = Vestscale*Stim_sim;
    %Torque stimulus
    Tq_sim = Tscale*Stim_sim;
    
%% Run Simulink
    sim('Single_PID',[0 max(t_sim)]) %Runs the simulink model

%% Create plots and further analyses

    %cgvL=cdiff(cgL)*samprate; %calculate velocities of body sway
    
    figure(1)
    subplot(321);plot(t_sim,180/pi*cgL,'r'); hold on; ylabel('body sway (deg)')
    
    subplot(322);plot(t_sim,SS_sim,'b'); ylabel('Surface Stim');
    subplot(323);plot(t_sim,VS_sim,'b'); ylabel('Vis Stim')
    subplot(324);plot(t_sim,Vest_sim,'b'); ylabel('Vest Stim')
    subplot(325);plot(t_sim,NoiseLB_T_sim,'b'); ylabel('Sensory noise'); xlabel('time (s)')
    subplot(326);plot(t_sim,Tq_sim,'b'); ylabel('Torque Stim'); xlabel('time (s)')
    pause
%     clf
    
%% Create plots and further analyses

  %Movie parameters
    movie_speed=5; %the higher the number the faster the movie
    movie_scale=2; %amplification of angles for visualization (10 is pretty good if Sscale=2)
    
    cg_m = -movie_scale*cgL*180/pi;
    surf_m = movie_scale*SS_sim;
    interval = movie_speed*0.005;
    
for i=[1:movie_speed:length(cg_m)]
    
    plot([-2*cosd(surf_m(i)),2*cosd(surf_m(i))],[-2*sind(surf_m(i)),2*sind(surf_m(i))],'k','LineWidth',3)
    hold on
    plot([0,sind(cg_m(i))*7.5],[0,7.5*cosd(cg_m(i))],'b','LineWidth',3)
    axis([-5 5 -1.5 8.5])
    pause(.01)
    clf
end

