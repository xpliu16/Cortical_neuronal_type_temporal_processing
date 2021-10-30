function plot_stimspecs(callList, stims, savepath, papersize, plotup, printornot)
% plot_stimspecs plots histograms of call stimuli from list of files
%
% callList  Text file of stimulus file names
% stims     Indices of stimulus subset
% plotup    If 1, first stimulus is plotted at bottom, last at top

masterfont = 20;

fid = fopen(callList,'r');

filenames='11111';  % char can't start with an empty matrix
count = 1;
while count == 1;
   [s,count] = fscanf(fid,'%s',1);
   if count == 1
      filenames = char(filenames,s);
   end
end
fclose(fid);
filenames(1,:)=[];

if isempty(stims)== 0
   filenames = filenames(eval(stims),:);
end

fig = figure;
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', papersize);
set(gca,'visible','off');

lmargin = 0.14;

Stimulus_Total = size(filenames,1);
if plotup
    pos_b = [lmargin, 0.98-0.89, 0.84, 0.99*(0.89/Stimulus_Total)];
    pos_a = [0, 0.89/Stimulus_Total, 0, 0];
else
    pos_b = [lmargin, 0.98-(0.89/Stimulus_Total), 0.84, 0.99*(0.89/Stimulus_Total)];
    pos_a = [0, -(0.89/Stimulus_Total), 0, 0];
end
for currentfile=1:Stimulus_Total
    plotstim = 1;
    g = textread(deblank(filenames(currentfile,:)),'', 'delimiter', ' ');
    stimSR = 48828; 
    hold on
    ax(currentfile) = axes('position',pos_b+(currentfile-1)*pos_a,'visible','off');
    [spect,f,t_spect] = spectrogram(g(3:end),200,180,1000,stimSR,'yaxis');
    f = f/1000;     % to show kHz
    surf(t_spect,f,log10(abs(spect)),'EdgeColor','none');  
    axis xy;
    caxis('auto');
    view(0,90); axis tight;
    temp = xlim;
    xlims(currentfile) = temp(2);
    set(gca, 'FontSize',masterfont-4);
    set(gca, 'YTick', [10 20]);
    set(gca, 'Color','w');
    set(gca,'TickDir','out');
    if ((currentfile==Stimulus_Total) && ~plotup) || ((currentfile==1) && plotup)
        xlabel('Time(s)','fontsize',masterfont,'visible','on');
    else        
        set(gca,'XTick',[]);
        set(gca,'XColor','w');
    end
    grid OFF;
end

p1=get(ax(1),'position');
p2=get(ax(end),'position');
if plotup
    height=p2(2)+p2(4)-p1(2);
    h3=axes('position',[p1(1)*0.7 p1(2)*0.7 p1(3) height],'visible','off');
else
    height=p1(2)+p1(4)-p2(2);
    h3=axes('position',[p2(1)*0.7 p2(2)*0.7 p2(3) height],'visible','off');
end
h_label=ylabel('Frequency (kHz)','fontsize',masterfont,'visible','on');

for i = 1:Stimulus_Total
    set(ax(i),'ylim',[0 25])
    set(ax(i), 'xlim', [0 max(xlims)]);
end

callListShort = fliplr(strtok(fliplr(callList),'\'));
callListShort = callListShort(1:end-4);
if savepath(end) ~= '\'
    savepath = [savepath '\'];
end
if printornot
    print([savepath callListShort '_spect.png'],'-dpng','-painters');
    disp(['Figure saved to' ' ' savepath callListShort '_spect.png']);
end
end

