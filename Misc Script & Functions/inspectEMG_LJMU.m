function inspectEMG_LJMU(fl)

% Plots selected EMGs for a series of trials or a single rjf file, depending
% on user inputs. 
% User will be asked:
%       Exp Type: answer must be either Double Step or Point
%       Which perttype to plot: answer must be either [-3 -2 -1 0 1 2 3]
%               -3 = 90-45
%               -2 = 90-60
%               -1 = 90-75
%                0 = no target jump (will be asked if only want to plot
%                90-degree reaches)
%                1 = 90-105
%                2 = 90-120
%                3 = 90-135
%
% User will be asked if signals should be aligned to onset of movement. It
% is necessary that RFINon be tagged in the data file. Function also adds
% vlines for L2on, Fcorrect, Fend if the values are stored within the rjf
% data file. 
%
%
% Written for BVML by Julia Leonard



%%

fl2use = listdlg('ListString',{'fname.mat','single rjf', 'Using EVENTTAGGER'},...
    'PromptString','Load fname file or single rjf?',...
    'SelectionMode','Single',...
    'Name','Trials to load');

if fl2use == 1
    [f,p] = uigetfile('*fname*.mat','Open S###-fname_ordered.mat');
    load([p,f],'-mat')
    cd(p)
    [r,c] = size(fl);
elseif fl2use == 2
    [f,p] = uigetfile('*.rjf','Open rjf file to plot');
    cd(p)
    fl = [p,f];
    load([p,f], '-mat');
    [r,c] = size(fl);
else
    load(fl, '-mat');
    [r,c] = size(fl);
end

[V,A] = listchannelc3d(data);

EMGs = A(4:14,:);        %if force plates present use (13:(12+16),:);
EMGs{end+1} = '--- NONE ---';
answer = inputdlg({'Exp Type? [ex: Double Step / Point]',...
    'IF DS, Which perttype/column of data to plot?', ...
    'Low pass filter cut-off?',},...
    'Plot char.',1);

if strcmp(answer{1},'Double Step')
    cl = str2num(answer{2})+4;
    
    % if trial type is double step, and cl = 4,ask subject if they 
    % only want to plot 90-degree reaches
    if cl == 4
        answerreach = questdlg('Only plot 90-degree reaches?');
    end
  
else
    cl = str2num(answer{2});
end

if fl2use == 2 || 3
    cl = 1;
end



emgs2plot = listdlg('ListString', EMGs, ...
    'PromptString','Choose EMGs to PLOT on figure',...
    'SelectionMode','Multiple',...
    'Name','EMGs');
%emgs2plot = emgs2plot + 12;


answeremgs = listdlg('ListString', EMGs, ...
    'PromptString','Choose EMGs to HIGHLIGHT (red) on figure',...
    'SelectionMode','single',...
    'Name','EMGs');
emg2highlight = EMGs(answeremgs(1));



filtHz = str2num(answer{3});


for j = 1:r              %%%%%% Check parentheses ( vs. { %%%%%%
    
%     if isnan(fl{j,cl})
%         continue
%     end
%     if isempty(fl{j,cl})
%         continue
%     end
%     
% 	r = exist('answerreach','var');
%     if r == 1
%         if strcmp(answerreach,'Yes')
%             load(fl{j,cl},'-mat')
%             if data.LabviewData.light1 ~=90
%                 continue
%             end
%         end
%     end
%     
%    disp(fl(j,cl))
  sideplot_EMGonly(fl, emgs2plot, emg2highlight, filtHz);
  saveas (gcf,fl(1:end-4),'fig');
    
    printdata = questdlg('Print figure?');
    if strcmp(printdata,'Yes')
        h = findobj('Type','Figure');
        if ~isempty(h)
            print
        end
    end
%     
%             savefig = questdlg('Save figure?');
%         if strcmp(savefig,'Yes')
%             [p,f] = uiputfile('*.eps','Save file');
%              
% %                fname = [num2str(strrep(nm,' ','_')),...
% %                '_',num2str(rjf.LabviewData.light1),...
% %                'deg_EMGplot.eps'];

%            saveas (gcf,[p,f],'eps');
%         elseif strcmp(savefig,'Cancel')
%             msgbox('ERROR: plotting cancelled by user')
%             break
%         end
    
    
    pause(0.5)
    keyboard
    close
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sideplot_EMGonly(fl, emgs2plot, emg2highlight, filtHz)

aligndata = 'No' ; % questdlg('Align traces to Fon?');

fname = fl;

%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
TOP = 1.1;  %%%% Set to control the height of ylim for the figure ****MIGHT NEED TO ADJUST***
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%  offset control %%%%
if length(emgs2plot) == 16
    %off = 0:6.5e-005:1;
    off = 0:0.0625:1;
else
    incr = 1/length(emgs2plot);
    %off = 0: incr*10^-003:1;
    off = 0: incr:1; %*0.0625
end

%%%%%%%%%%%%%%%%%%%%%%%


t = load(fl,'-mat');
rjf = t.data;
[V,A] = listchannelc3d(rjf);
if isempty(A)
    disp('No Analog Channels')
    return
end

EMGch = fieldnames(rjf.AnalogData);
EMGch = EMGch(4:14);
EMGnames = A(4:14);



L1 = rjf.dir;


indxa = max(strfind(fname,'/'));     %%%%NOT WORKING%%%%
indxb = min(strfind(fname,'.'));
fname = fname(indxa+1:indxb-1);
%fname = strrep(fname,'DoubStep','Trial#'); %%% THIS NEEDS TO BE CHANGED FOR DIFFERENT EXPTYPES
fname = [fl,' // L1: ',num2str(L1),];
nm = strrep(fname,'_',' ');


%%%%%%%%%%%%%%%%%   EMG FILTER PARAMETERS %%%%%%%%%%%%%%%%
% High pass to remove motion artifact (35Hz)
myfiltHigh.type = 'butterworth';
myfiltHigh.pass = 'highpass';
myfiltHigh.order = 2;
myfiltHigh.smprate = 1000;
myfiltHigh.cut1 = 35;

myfilt1.type = 'butterworth';
myfilt1.pass = 'lowpass';
myfilt1.order = 2;
myfilt1.smprate = 1000;
myfilt1.cut1 = filtHz;


timemin = (rjf.variables.SYNCtime) - (rjf.variables.RFIN.Fon);
 

%%%%%%%%%%%%%%%%%   Figure generator %%%%%%%%%%%%%%%%
psize = [0 -3 8.5 11];
fig1 = figure('units','inches',...
    'position',psize,...
    'color',[1 1 1],...
    'tag','the big fig',...
    'paperunits','inches',...
    'papertype','usletter',...
    'papersize',[8.5 11],...
    'paperpositionmode','manual',...
    'paperposition',[.25 .25 8 10.5]);

ax1 = axes('parent',fig1,...
    'Xlim',[0 5000],...
    'Ylim',[0 TOP],...
    'color','none',...
    'gridlinestyle',':');



%%%% iterations for all muscles adding in consistent offset
for j = 1:length(EMGch)
    text('Position',[15 4e-5 + off(j)],...
        'HorizontalAlignment','Left',...
        'VerticalAlignment','top',...
        'string',EMGnames{j},...
        'FontSize',8);
    
    
    musc = rjf.AnalogData.(EMGch{j}).data;
       
    % align to Fon, if user requested
    if strcmp(aligndata,'Yes')
        if isfield(rjf.variables.RFIN,'Fon')
            Fon = rjf.variables.RFIN.Fon;
            if isnan(Fon)
                disp('Fon = NaN')
                return
            end
            musc = musc(Fon-(-timemin):end);
        end
        time = Fon-(-timemin):4500;
       
        
    elseif strcmp(aligndata,'No')
        time = 1:5000;
    end
        
    vec = filterline(musc, myfiltHigh); % highpass at 35Hz
    vec = abs(vec - mean(vec(1:200))); % demeaned and rectified
    vec_filt = filterline(vec,myfilt1); %lowpass filter at user input

    
    
    if strcmp(EMGnames{j}, emg2highlight)
        line ('parent',ax1,...
            'xdata',time(1:length(vec_filt)),...
            'ydata',vec_filt + off(j),...
            'color','r',...
            'linewidth',2)
    else
        line ('parent',ax1,...
            'xdata',time(1:length(vec_filt)),...
            'ydata',vec_filt + off(j))
    end
        
end

%%% if Fon, Fend exist, plot vlines:

if strcmp(aligndata,'No')
    
     if isfield(rjf.variables.RFIN,'Fon')
        vline(rjf.variables.RFIN.Fon,'g')
        text(rjf.variables.RFIN.Fon, TOP,'Fon','color','g')
        vline(rjf.variables.RFIN.Fend,'r')
        text(rjf.variables.RFIN.Fend,TOP, 'Fend','color','r')
    end
    
    if isfield(rjf.variables,'EOG')
        vline(rjf.variables.EOG.EOGon,'b')
        text(rjf.variables.EOG.EOGon,TOP,'EOGon','color','b')
    end
    
    if isfield(rjf.variables, 'SYNCtime')
            vline(rjf.variables.SYNCtime,'c')
            text(rjf.variables.SYNCtime, TOP,'LEDon','color','c')
    end
 
    xlbl = 'Time (ms) from VICON acquisition onset';

end

xlabel(xlbl)
ylabel(['Low-pass filter at ', num2str(filtHz),'Hz'])
title(fname,'FontWeight', 'bold', 'Interpreter', 'none')




function varargout = listchannelc3d(c3ddata)
%[video,analog] = listchannelc3d(c3ddata)
%
%This function will output the video and analog channels as a cell array of strings
%
%Created by JJ Loh  2006/09/20
%Departement of Kinesiology
%McGill University, Montreal, Quebec Canada
Afld = fieldnames(c3ddata.AnalogData);
Vfld = fieldnames(c3ddata.VideoData);

vch = [];
ach = [];
for i = 1:length(Afld);
    vl = getfield(c3ddata.AnalogData,Afld{i});
    ach = [ach;{vl.label}];
end
for i = 1:length(Vfld);
    vl = getfield(c3ddata.VideoData,Vfld{i});
    vch = [vch;{vl.label}];
end
varargout{1} = vch;
varargout{2} = ach;

function fdata = filterline(data,myfilt)

%%-----------------------------------------------
% Part of zoofilter.m function created by JJ Loh.
%%-----------------------------------------------


%structure of myfilt is
%myfilt.type
%myfilt.pass
%myfilt.order
%myfilt.smprate
%myfilt.cut1
%myfilt.cut2
%myfilt.srip
%myfilt.prip

% myfilt.type chooses filter type
% 'butterworth'
% 'chebychev I'
% 'chebychev II'
% 'eliptic'
% 'bessel'

% myfilt.pass chooses filter pass
% 'lowpass'
% 'highpass'
% 'bandpass'
% 'notch'


if strcmp(myfilt.pass,'bandpass')| strcmp(myfilt.pass,'notch')
    coff = [min([myfilt.cut1;myfilt.cut2]),max([myfilt.cut1;myfilt.cut2])];
else
    coff = myfilt.cut1;
end

coff = coff/(myfilt.smprate/2);
st = 'stop';
hi = 'high';

switch myfilt.type 
case 'butterworth'
    switch myfilt.pass
    case 'lowpass'
        [b,a] = butter(myfilt.order,coff);
    case 'bandpass'
        [b,a] = butter(myfilt.order,coff);
    case 'notch'
        [b,a] = butter(myfilt.order,coff,st);
    case 'highpass'
        [b,a] = butter(myfilt.order,coff,hi);
    end
case 'chebychev I'
    switch myfilt.pass
    case 'lowpass'
        [b,a] = cheby1(myfilt.order,myfilt.srip,coff);
    case 'bandpass'
        [b,a] = cheby1(myfilt.order,myfilt.srip,coff);
    case 'notch'
        [b,a] = cheby1(myfilt.order,myfilt.srip,coff,st);
    case 'highpass'
        [b,a] = cheby1(myfilt.order,myfilt.srip,coff,hi);
    end
case 'chebychev II'
    switch myfilt.pass
    case 'lowpass'
        [b,a] = cheby2(myfilt.order,myfilt.srip,coff);
    case 'bandpass'
        [b,a] = cheby2(myfilt.order,myfilt.srip,coff);
    case 'notch'
        [b,a] = cheby2(myfilt.order,myfilt.srip,coff,st);
    case 'highpass'
        [b,a] = cheby2(myfilt.order,myfilt.srip,coff,hi);
    end
case 'eliptic'
    switch myfilt.pass
    case 'lowpass'
        [b,a] = ellip(myfilt.order,myfilt.prip,myfilt.sripple,coff);
    case 'bandpass'
        [b,a] = ellip(myfilt.order,myfilt.prip,myfilt.sripple,coff);
    case 'notch'
        [b,a] = ellip(myfilt.order,myfilt.prip,myfilt.sripple,coff,st);
    case 'highpass'
        [b,a] = ellip(myfilt.order,myfilt.prip,myfilt.sripple,coff,hi);
    end
case 'bessel'
    switch myfilt.pass
    case 'lowpass'
        [b,a] = besself(myfilt.order,coff);
    case 'bandpass'
        [b,a] = besself(myfilt.order,coff);
    case 'notch'
        [b,a] = besself(myfilt.order,coff,st);
    case 'highpass'
        [b,a] = besself(myfilt.order,coff,hi);
    end
end

fdata = filtfilt(b,a,data);

function hhh=vline(x,in1,in2)
% function h=vline(x, linetype, label)
% 
% Draws a vertical line on the current axes at the location specified by 'x'.  Optional arguments are
% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
% label appears in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the function returns the axes to
% its prior hold state.
%
% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
% overridden by setting the root's ShowHiddenHandles property to on.
%
% h = vline(42,'g','The Answer')
%
% returns a handle to a green vertical line on the current axes at x=42, and creates a text object on
% the current axes, close to the line, which reads "The Answer".
%
% vline also supports vector inputs to draw multiple lines at once.  For example,
%
% vline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001

if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=vline(x(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,linetype);
    if length(label)
        xx=get(gca,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        else
            text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        end
    end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end


