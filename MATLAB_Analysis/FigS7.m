units_all = {...
 'M7E0571ch1', '667', 'M7E0556ch1';... 
 'M117B3989ch4', '526', 'M117B3981ch4';... 
 'M7E2254ch3', '476', 'M7E2254ch3';...  
 'M7E2509ch1', '909', 'M7E2508ch1';...  
 'M7E2270ch1', '204', 'M7E2269ch1';...    
 'M7E2758ch1', '526', 'M7E2757ch1';...
 'M117B1017ch4', '667', 'M117B1010ch4';...  
 'M117B2080ch4', '476', 'M117B2050ch4';...  
 'M7E1461ch1', '667', 'M7E1459ch1'}       

RSColor = [0.6350    0.0780    0.1840];
FSColor = [0    0.4470    0.7410];
BuColor = [0.4660    0.6740    0.1880];

figS4 = figure;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [17.2*0.3937, 15*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 17.2*0.3937, 15*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 17.2*0.3937, 15*0.3937]);
figparams.fsize = 7;
figparams.msize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
lmargin = 0.07;
tmargin = 0.96;
xwidth = 0.29;
ywidth = 0.27;
ywidthsp = 0.08;
interrow = 0.05;
intercol = 0.02;
intercol2 = 0.1;  % For spectrograms
interrow2 = 0; % Bet spectrogram and wav
interrow3 = 0.05; % Additional between phee and trill
xaxis_scale = 0.13;   % Between normalized width of spectrogram and time in s

ncols=3;
   
for i = 1:size(units_all,1)
    row = ceil((i)/ncols); 
    column = i-(row-1)*ncols;
    
    pos(1) = lmargin +(column-1)*(xwidth+intercol);
    pos(2) = tmargin-ywidth-(row-1)*(ywidth+interrow);
    pos(3) = xwidth;
    pos(4) = ywidth;
   
    ax(i) = axes('Position',pos);
    unit = units_all{i,1};
    stims = '1:20';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', figS4, 1,'vertical tick',0.7);
    xlim([100,2500]);
    xl = xlim;
    yl = ylim;
    text(0.84*xl(2), 0.97*yl(2), [units_all{i,2} ' Hz'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    text(0.5,1.05,['Unit ' units_all{i,3}],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 

    if column ==1
        ylabel('Vocalization #');
        set(gca,'YTick',[0.5,1.5,18.5, 19.5],'YTickLabel',{'1n','1r','10n','10r'});
    end
    if row ==3
        set(gca,'XTick',[300, 1000, 2000]);
        if column == 3
            th_ms = text(2350,-1.55,'ms','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        end
    end
end

set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'box','off');
 
print('C:\Users\Ping\Desktop\Wang_lab\Paperwriting\Figures\Supp\Bu_call_rasters.tif','-dtiff',['-r' num2str(figparams.res)]);

papersize = [0 0 8*0.3937, 16*0.3937];
