function [xl,tih] = plot_stimspecs(callList, stims, figh, axespos, figparams, callnames, titstr, plotup, fwdrev)
% plot_stimspecs plots histograms of call stimuli from list of files
%
% callList  Text file of stimulus file names
% stims     Indices of stimulus subset
% plotup    If 1, first stimulus is plotted at bottom, last at top

masterfont = 10;

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

figure(figh);
set(gca,'visible','off');

lmargin = 0.15;

Stimulus_Total = size(filenames,1);
if plotup
    pos_b = [lmargin, 0, 0.84, 0.9*(1/Stimulus_Total)];
    pos_a = [0, 1/Stimulus_Total, 0, 0];
else
    pos_b = [lmargin, 1-(1/Stimulus_Total), 0.84, 0.9*(1/Stimulus_Total)];
    pos_a = [0, -1/Stimulus_Total, 0, 0];
end
axscale = [axespos(3), axespos(4), axespos(3), axespos(4)];
axoffset = [axespos(1), axespos(2), 0, 0];
for currentfile=1:Stimulus_Total
    plotstim = 1;
    g = textread(deblank(filenames(currentfile,:)),'', 'delimiter', ' ');
    stimSR = 48828; 
    hold on
    ax(currentfile) = axes('position',(pos_b+(currentfile-1)*pos_a).*axscale+axoffset,'visible','off');
    [spect,f,t_spect] = spectrogram(g(3:end),200,180,1000,stimSR,'yaxis');
    f = f/1000;
    surf(t_spect,f,log10(abs(spect)),'EdgeColor','none');  
    colormap(jet); 
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
        xlabel('Time(s)','fontsize',figparams.fsize+1,'visible','on');
    else        
        set(gca,'XTick',[]);
        set(gca,'XColor','w');
    end
    
    if ((currentfile==1) && ~plotup) || ((currentfile==Stimulus_Total) && plotup)
        kHz_h = text('String','kHz','FontSize',figparams.fsize,...
            'FontName',figparams.fontchoice,...
            'Position',[-0.080, 30.0, 1.0]);
        tih = title(titstr,'fontname',figparams.fontchoice,'fontsize',figparams.fsize+2);
    end
     
    if ~isempty(callnames) && rem(currentfile,2)
        ylh = ylabel(callnames{currentfile},'fontname',figparams.fontchoice,...
            'fontsize',figparams.fsize,'visible','on','Rotation',0);
        ylh.HorizontalAlignment = 'right';
        ylh.VerticalAlignment = 'middle';
        ylh.Position(1) = -0.22;
        ylh.Position(2) = 25.8;
    end
    if fwdrev
        if rem(currentfile,2)
            text(0.9,0.8,'nat','Units','normalized','fontname',figparams.fontchoice,...
                'fontsize',figparams.fsize,'color', [0.7 0.7 0.7]);
        else
             text(0.9,0.8,'rev','Units','normalized','fontname',figparams.fontchoice,...
                'fontsize',figparams.fsize,'color', [0.7 0.7 0.7]);
        end
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
%h_label=ylabel('Frequency (kHz)','fontsize',masterfont,'visible','on');

xl = max(xlims);
for i = 1:Stimulus_Total
    set(ax(i),'ylim',[0 25])
    set(ax(i), 'xlim', [0 xl]);
end

callListShort = fliplr(strtok(fliplr(callList),'\'));
callListShort = callListShort(1:end-4);

end

