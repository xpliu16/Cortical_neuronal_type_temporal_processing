units_all = {'M7E0500ch1','RS','Phee','M7E0484ch1'; ...
              'M7E0591ch1','FS','Phee','M7E0574ch1'; ...
              'M117B3849ch4','Bu','Phee','M117B3813ch4'; ...           % 476 Hz intraburst   Bu/Bu          
              'M7E0523ch1','RS','Phee','M7E0512ch1'; ...
              'M7E0830ch1','FS','Phee','M7E0812ch1'; ...
              'M117B1055ch5','Bu','Phee','M117B1033ch5'; ...           % 476 Hz intraburst   Bu/Bu
              'M7E0801ch1','RS','Phee','M7E0781ch1'; ...
              'M117B3622ch4','FS','Phee','M117B3602ch4'; ...
              'M117B2082ch4','Bu','Phee','M117B2050ch4'; ...           % 526 Hz intraburst   Bu/Bu
              'M7E1690ch1','RS','Phee','M7E1677ch1'; ...
              'M7E1218ch1','FS','Phee','M7E1192ch1'; ...              
              'M7E1039ch2','Bu','Phee','M7E1026ch2'; ...             % 588 Hz intraburst   Bu/Bu
              'M117B0856ch5','RS','Trill','M117B0849ch5'; ...
              'M7E1018ch2','FS','Trill','M7E1005ch2'; ...
              'M117B0653ch4','Bu','Trill','M117B0636ch4'; ...          % 909 Hz intraburst   Bu/Bu
              };

inset_stim = [1,8,3];
xl_inset = [350,550; 340,470; 330, 460];

RSColor = [0.6350    0.0780    0.1840];
FSColor = [0    0.4470    0.7410];
BuColor = [0.4660    0.6740    0.1880];

fig7 = figure;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [17.2*0.3937, 22*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 17.2*0.3937, 22*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 17.2*0.3937, 22*0.3937]);
figparams.fsize = 7;
figparams.msize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
fontstr = {'FontSize',figparams.fsize,'FontWeight','bold','FontName',figparams.fontchoice};
lmargin = 0.09;
tmargin = 0.95;
xwidth = 0.21;
ywidth = 0.15;
ywidthsp = 0.08;
interrow = 0.02;
intercol = 0.02;
intercol2 = 0.1;  % For spectrograms
interrow2 = 0; % Bet spectrogram and wav
interrow3 = 0.03; % Additional between phee and trill
xaxis_scale = 0.15;   % Between normalized width of spectrogram and time in s
 
call_lists = {'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\Stimulus_Files\Phee\phee_list.txt',...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\Stimulus_Files\Trill\trill_list.txt'};
% Plot spectrograms

fid = fopen(call_lists{1},'r');

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

axsp(1) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-0.33*ywidth, 0.35, 0.33*ywidth]);
g = textread(deblank(filenames(1,:)),'', 'delimiter', ' ');
stimSR = 50000; 
t_max_phee = 1.4;
[spect,f,t_spect] = spectrogram(g(3:end),200,180,1000,stimSR,'yaxis');
f = f/1000;     % to show kHz instead of scientific notation
surf(t_spect,f,log10(abs(spect)),'EdgeColor','none');  
axis xy; %colormap(jet); 
caxis('auto');
view(0,90); axis tight;
set(gca, 'YTick', [10 20]);
set(gca, 'Color','w');
set(gca,'TickDir','out','TickLength',[0.015 0.025]);
pos1 = get(axsp(1),'Position');
pos1(3) = xaxis_scale*t_max_phee;
set(axsp(1),'Position',pos1);
set(gca,'xticklabel',[]);
text(-0.2,27,'kHz','FontSize',figparams.fsize,'FontName','Times New Roman','FontAngle','italic');
title('Phee call #1');

%set(axsp(1),'FontSize',figparams.fsize);
%text(-0.23,1.24,'A','Units','normalized','FontWeight','bold');
%text(-0.12,-1.15,'B','Units','normalized','FontWeight','bold');

axsp(2) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-0.66*ywidth, 0.35, ywidth*0.33]);
pos1b = get(axsp(2),'Position');
pos1b(3) = xaxis_scale*t_max_phee;
set(axsp(2),'Position',pos1b);
gwav = g(3:end)/max(abs(g(3:end)));  % First two are sample length and SR
plot(0:1/stimSR:(length(gwav)-1)/stimSR,gwav,'k','Color',[0.3 0.3 0.3]);
set(gca, 'Color','w');
set(gca,'TickDir','out','TickLength',[0.015 0.025]);
ylim([-1.15 1.15]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
box off

axsp(3) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-ywidth, 0.35, ywidth*0.34]);
pos1b = get(axsp(3),'Position');
pos1b(3) = xaxis_scale*t_max_phee;
set(axsp(3),'Position',pos1b);
unit = units_all{3,1};
stims = '1';
plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig7, 1,'vertical tick',0.8);
ylim([-0.01 1]);
set(gca,'xtick',[0 500 1000 1500 1700],'xticklabels',{'0','0.5','1','1.5','\it s'});
set(gca,'TickDir','out','TickLength',[0.015 0.025]);
%txh = text(1700,-0.1,'s','FontSize',figparams.fsize+2,'FontName','Times New Roman','FontAngle','italic');
set(axsp(1),'xlim',[0 t_max_phee]);
set(axsp(2),'xlim',[0 t_max_phee]);
set(axsp(3),'xlim',[300 t_max_phee*1000+300]);

fid = fopen(call_lists{2},'r');

filenames='11111';  % char can't start with an empty matrix
count = 1;
while count == 1
   [s,count] = fscanf(fid,'%s',1);
   if count == 1
      filenames = char(filenames,s);
   end
end
fclose(fid);
filenames(1,:)=[];

axsp2(1) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-4*ywidth-4*interrow-0.33*ywidth-interrow3, 0.1*33/35, 0.33*ywidth]);
g = textread(deblank(filenames(1,:)),'', 'delimiter', ' ');
stimSR = 50000; 
t_max_trill = 0.47;
[spect,f,t_spect] = spectrogram(g(3:end),200,180,1000,stimSR,'yaxis');
f = f/1000;     % to show kHz instead of scientific notation
surf(t_spect,f,log10(abs(spect)),'EdgeColor','none');  
axis xy; %colormap(jet); 
caxis('auto');
view(0,90); axis tight;
set(gca, 'YTick', [10 20]);
set(gca,'xticklabels',[]);
set(gca, 'Color','w');
set(gca,'TickDir','out','TickLength',[0.03 0.025]);
pos2 = get(axsp2(1),'Position');
pos2(3) = xaxis_scale*t_max_trill;
set(axsp2(1),'Position',pos2);
title('Trill call #1');
text(-0.2,27,'kHz','FontSize',figparams.fsize,'FontName','Times New Roman','FontAngle','italic');

axsp2(2) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-4*ywidth-4*interrow-0.66*ywidth-interrow3, 0.1*33/35, ywidth*0.33]);
pos2b = get(axsp2(2),'Position');
pos2b(3) = xaxis_scale*t_max_trill;
set(axsp2(2),'Position',pos2b);
gwav = g(3:end)/max(abs(g(3:end)));
plot(0:1/stimSR:(length(gwav)-1)/stimSR,gwav,'k','Color',[0.3 0.3 0.3]);
set(gca, 'Color','w');
set(gca,'TickDir','out','TickLength',[0.015 0.025]);
ylim([-1.15 1.15]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off
%txh = text(0.51,-1.48,'s','FontSize',figparams.fsize+2,'FontName','Times New Roman','FontAngle','italic');
ncols = 3;

axsp2(3) = axes('Position', [lmargin+3*(xwidth+intercol)-0.01, tmargin-4*ywidth-4*interrow-ywidth-interrow3, 0.1*32/35, ywidth*0.34]);
pos1b = get(axsp2(3),'Position');
pos1b(3) = xaxis_scale*t_max_trill;
set(axsp2(3),'Position',pos1b);
unit = units_all{15,1};
stims = '1';
plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig7, 1,'vertical tick',0.8);
ylim([-0.01 1]);
set(gca,'xtick',[0 200 400 600 770],'xticklabels',{'0','0.2','0.4','0.6','\it s'});
set(gca,'TickDir','out','TickLength',[0.015 0.025]);
set(axsp2(1),'xlim',[0 t_max_trill]);
set(axsp2(2),'xlim',[0 t_max_trill]);
set(axsp2(3),'xlim',[300 t_max_trill*1000+300]);

for i = 1:size(units_all,1)
    row = ceil(i/ncols); 
    column = i-(row-1)*ncols;
    %column = column+1;
    
    calltype = units_all{i,3};
    
    pos(1) = 0.055 +(column-1)*(xwidth+intercol);
    if strcmp(calltype,'phee')
        pos(2) = tmargin-ywidth-(row-1)*(ywidth+interrow);
    else
        pos(2) = tmargin-ywidth-(row-1)*(ywidth+interrow)-interrow3;
    end
    pos(3) = xwidth;
    pos(4) = ywidth;
   
    if (row == 5) && (column == 3)
    %    annotation('rectangle','Units','normalized','Position',[lmargin-0.08, pos(2)-0.04, 0.08+3*(xwidth+intercol)+pos1b(3)+0.02, pos(4)+0.07],'LineWidth',1);
    end
    ax(i) = axes('Position',pos);
    unit = units_all{i,1};
    stims = '1:10';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig7, 1,'vertical tick',0.8);

    xlim([100,2500]);
    %xticks([300]);
    %set(gca,'xticklabel',{'0.3'});
    if (row == 1) && (column == 1)
        text(-0.23,1.17,'A','Units','normalized','FontWeight','bold');
    elseif (row == 5) && (column == 1)
        text(-0.23,1.09,'B','Units','normalized','FontWeight','bold');
    end
    if (row == 4) && (column == 3)
   %     annotation('rectangle','Units','normalized','Position',[lmargin-0.08, pos(2)-0.02, 0.08+3*(xwidth+intercol)+pos1b(3)+0.02, tmargin+0.02-(pos(2)-0.05)],'LineWidth',1);
    end
    if column == 1
        lh_ct = ylabel([calltype ' #'],'FontSize',figparams.fsize+1,'FontName',figparams.fontchoice,'FontWeight','bold','Units','normalized');
        lh_ct.Position(1) = -0.1160;
        set(gca,'ytick',[0.5 9.5],'yticklabels',{'1','10'});
    end
    if row == 1
        ti = title(units_all{i,2},'FontSize',figparams.fsize+1,'FontName',figparams.fontchoice,'FontWeight','bold','Units','normalized');   % Colorize text
        oldposti = get(ti,'Position');
        oldposti(2) = oldposti(2)*1.1;
        set(ti,'Position',oldposti);
    end
    if (strcmp(calltype,'trill')) && (column==1)
        shortprestim = i;
    end
    if row == 5
        set(gca,'Xtick',[300, 1000, 2000]);
        if column == 3
            th_ms = text(2300,-1.1,'ms','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        end
    end
    
    text(0.5,1.05,['Unit ' units_all{i,4}],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    %text(0,1.05,['Unit ' units_all{i,4}],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','left'); 
    
    if (row>1)&(row<5)&(column==3)
        rh1 = rectangle('Position',[xl_inset(row-1,1),(inset_stim(row-1)-1), xl_inset(row-1,2)-xl_inset(row-1,1),1],'EdgeColor',[0.9 0 0 0.5],'LineWidth',0.5);
        xl = xlim;
        yl = ylim;
        rh1p = rh1.Position;
        
        ax_ins = axes('Position',[lmargin+3*(xwidth+intercol), pos(2)+0.025, xwidth*0.77, ywidth*0.55]);
        %ax_ins = axes('Position',[lmargin+3*(xwidth+intercol), pos(2)+0.01-(4-row)*0.01, xwidth*0.75, ywidth*0.5]);
        stims = num2str(inset_stim(row-1));
        plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig7, 1,'vertical tick',0.5);
        xlim(xl_inset(row-1,:));
        ylim([0 1]);
        pos2 = ax_ins.Position;
        %box on  % Axes end up behind patch on right and top
        xl2 = xlim;
        yl2 = ylim;
        rh2 = rectangle('Position',[xl2(1), yl2(1), xl2(2)-xl2(1), yl2(2)-yl2(1)],'EdgeColor',[0.8 0.1 0.1],'LineWidth',1);
        rh2p = rh2.Position;
        temp = 0.6*(xl_inset(row-1,2)-xl_inset(row-1,1))+xl_inset(row-1,1);
        line([temp temp+40],[0.9,0.9], 'LineWidth', 1.5,'Color','k');
        text(temp+20, 0.77, '40 ms', fontstr{:},'HorizontalAlignment','center');
        x = [pos(1)+((rh1p(1)+rh1p(3))-xl(1))/(xl(2)-xl(1))*pos(3)  pos2(1)+(rh2p(1)-xl2(1))/(xl2(2)-xl2(1))*pos2(3)];
        y = [pos(2)+((rh1p(2)+rh1p(4))-yl(1))/(yl(2)-yl(1))*pos(4)  pos2(2)+(rh2p(2)+rh1p(4)-yl2(1))/(yl2(2)-yl2(1))*pos2(4)];
        ah = annotation('line',x,y,'Color',[0.9 0 0 0.3],'LineWidth',0.5);
        y2 = [pos(2)+(rh1p(2)-yl(1))/(yl(2)-yl(1))*pos(4)  pos2(2)+(rh2p(2)-yl2(1))/(yl2(2)-yl2(1))*pos2(4)];
        ah = annotation('line',x,y2,'Color',[0.9 0 0 0.3],'LineWidth',0.5);
    end
end
xl = get(ax(shortprestim),'Xlim');
xl(1) = 0;
set(ax(shortprestim),'Xlim',xl);
set(ax(shortprestim),'Xtick',[200, 900, 1900],'XTickLabel',{'300','1000','2000'});

set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'box','off');
 
print('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\Fig 7\Fig7b.tif','-dtiff',['-r' num2str(figparams.res)]);