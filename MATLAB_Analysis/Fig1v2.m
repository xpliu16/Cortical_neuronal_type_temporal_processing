units_tuning = {'M7E0491ch1','M7E2129ch1','M7E2255ch1'}
units_std_tuning = {'M7E0483ch1','M7E2129ch1','M7E2255ch1'}
tuning_stims = {'6:16','12:22','17:27'}

units_call_types = {'M7E0499ch1','M7E2130ch1','M7E2254ch1'}

units_type = {'RS','RS','FS','FS','Burster','Burster'};

RSColor = [0.6350    0.0780    0.1840];
FSColor = [0    0.4470    0.7410];
BuColor = [0.4660    0.6740    0.1880];
BuColorDark = [0.3843    0.6118    0.0863];
Color_i = {RSColor, FSColor, BuColor};
Color_ii = {RSColor, FSColor, BuColorDark};

fig1 = figure;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [17.2*0.3937, 23*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 17.2*0.3937, 23*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 17.2*0.3937, 23*0.3937]);
figparams.fsize = 7;
figparams.fsize_big = figparams.fsize+2;
figparams.msize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
lmargin = 0.05;
xexpand = 0.08;
yexpand = 0.065;
interrow = 0.048;
intercol = 0.03;

ms_after_peak_nospike = 6;

for i = 1:length(units_tuning)
    ax_row1(i) = subplot(6,3,i);
    oldpos = get(ax_row1(i),'Position');
    if i ==1
        xshift = lmargin-oldpos(1);
    end
    set(ax_row1(i),'Position',oldpos.*[1 1 1 1]+[xshift+xexpand*0.5*(i-1) -yexpand*0.4 xexpand yexpand]);
    
%   plot_raster ({units_tuning{i}(1:end-3)}, str2num(units_tuning{i}(end)), '1:31', '1:10', 'Frequency (kHz)', ['Unit ' units_tuning{i}], '', 'single', 1, 0, 1, '1:10:32', fig1, 1);
    plot_raster ({units_tuning{i}(1:end-3)}, str2num(units_tuning{i}(end)), tuning_stims{i}, '1:10', 'Frequency (kHz)', '', '', 'single', 1, 0, 1, '', fig1, 1,'vertical tick',1);
    ax_row1(i).FontSize = figparams.fsize;
    ax_row1(i).FontName = figparams.fontchoice;
    set(gca,'linewidth',0.5);
    set(gca,'xlim',[100 500]);
    set(gca,'XTick', [0 200 400]);
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.1;
    set(lh,'Position',lh_pos);
        
    if i == 1
        yl = get(gca,'ylim');
        text(75,yl(2)*1.08,'kHz','FontSize',figparams.fsize);
        set(gca,'YTick',1:10:32);
        set(gca,'yticklabels',{'0.5','2','8','32'});
        lh1 = ylabel('Tone tuning','FontSize',figparams.fsize_big);
        pos = get(lh1,'Position');
        set(lh1,'Position',[65,pos(2),pos(3)]);
        txh = text(-0.17,1.13,'A','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
    else
        set(gca,'yTick',[]);
    end
        
    if i == 1
        ti = title('Regular spiking','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.05,['Unit M7E0385ch3, BF 6.1 kHz, 48 dB'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 2
        ti = title('Fast spiking','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.05,['Unit M7E2129ch1, BF 4.4 kHz, 48 dB'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 3
        ti = title('Bursting','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.05,['Unit M117B3934ch4, BF 6.5 kHz, 48 dB'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    end
    oldposti = get(ti,'Position');
    oldposti(2) = yl(2)*1.12;
    set(ti,'Position',oldposti); 
end

for i = 1:length(units_std_tuning)
    pos_row1 = get(ax_row1(i),'Position');
    ax_row2(i) = axes('Position', [pos_row1(1), pos_row1(2)-pos_row1(4)-interrow+pos_row1(4)*0.35, pos_row1(3), pos_row1(4)*0.7]);
     
    file = units_std_tuning{i}(1:end-3); channel = str2num(units_std_tuning{i}(end)); stims = 1:31; reps = 1:10;
    try
        D = eval (file);
    catch
        mfilename_m = strcat(file, '.m');
        D=header_reader_mfile(mfilename_m);    % If file is incomplete so data matrix is irregular shaped, use this alternative reader, ignores final incomplete data line
    end
    [outputs, centers, N,centers2,N2,log_ISI_list,prestim_total_time,nint,logISIskewness]...
    = spktr(D,file,channel,stims,reps,0.2,50,'all',0); 
    xautocorr = outputs.xautocorr;
    yautocorr = outputs.yautocorr;
    hb = bar(xautocorr,yautocorr,1,'FaceColor',Color_i{i},'FaceAlpha',0.7);
    ax_row2(i).FontSize = figparams.fsize;
    ax_row2(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[0 50]);
    [val,ind] = max(find(xautocorr<= 50));
    set(gca,'ylim',[0 max(yautocorr(1:ind))*1.1]);
    set(gca,'xtick',[0,10,20,30,40,50]);
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
  
    set(gca,'ytick',[]);
    
    if i == 1
         lh2 = ylabel('Autocorrelogram','FontSize',figparams.fsize_big);
         txh = text(-0.17,1+0.13*ax_row2(1).Position(4)/ax_row1(1).Position(4),'B','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
    end
        
    pos_row2 = get(ax_row2(i),'Position');
    ax_row3(i) = axes('Position', [pos_row2(1), pos_row2(2)-pos_row2(4)-interrow, pos_row2(3), pos_row2(4)]);

    hb2 = bar(centers2,N2,1,'FaceColor',Color_i{i},'FaceAlpha',0.7,'EdgeColor','none');
    ax_row3(i).FontSize = figparams.fsize;
    ax_row3(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[-0.3,4]);
    set(gca,'XTick', [0 2 4]);
    
    lh = xlabel('log(ms)');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
  
    set(gca,'ytick',[]);
    
    if i == 1
        lh3 = ylabel('Log(ISI)','FontSize',figparams.fsize_big);
        txh = text(-0.17,1+0.13*ax_row3(1).Position(4)/ax_row1(1).Position(4),'C','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
    end
end

for i = 1:length(units_std_tuning)
    
    pos_row3 = get(ax_row3(i),'Position');
    ax_row4(i) = axes('Position', [pos_row3(1), pos_row3(2)-pos_row2(4)-interrow, pos_row3(3)*0.3, pos_row3(4)]);

    file = units_std_tuning{i}(1:end-3); channel = str2num(units_std_tuning{i}(end)); stims = 1:31; reps = 1:10;
    
    [traces,psth_cells,output] = plotad2 ({['C:\Experiments\' file(1:end-4) '\Ad2\' file '.ad2']}, stims, reps, 'spikes', 0, channel, ms_after_peak_nospike, 0, 'extra', [file 'ch' num2str(channel)], 10, 1,0);
                          
    output.t_shifted = output.t_shifted-0.3;
    plot(output.t_shifted(100:180),output.sp_wave(100:180), 'color',Color_i{i},'LineWidth',0.8);
    ax_row4(i).FontSize = figparams.fsize;
    ax_row4(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[output.t_shifted(100) output.t_shifted(180)]);
    ymin = min(output.sp_wave(100:180));
    ymax = max(output.sp_wave(100:180));
    set(gca,'ylim',[ymin-0.1*(ymax-ymin), ymax+0.1*(ymax-ymin)]);  
    
    set(gca,'xtick',[0 1]);
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
    
    set(gca,'ytick',[]);
    
    if i == 1
        lh4 = ylabel('Spike','FontSize', figparams.fsize_big);
        txh = text(-0.17*ax_row1(3).Position(3)/ax_row4(1).Position(3),1+0.13*ax_row4(1).Position(4)/ax_row1(1).Position(4),'D','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
        hold on
        TTP = output.ttp_ms;     % Peakfinder fails on the broad toothy peak here, so calculated using max and min
        an = annotation('doublearrow');
        [val,ind] = min(output.sp_wave);
        tmin = output.t_shifted(ind);
        an.Parent = gca;
        an.Position = [tmin, val*1.05, TTP,0];
        an.Head1Length = 2;
        an.Head2Length = 2;
        an.Head1Width = 4;
        an.Head2Width = 4;
        txh = text(tmin*1.8, val*0.85, '{\it t}_T_T_P','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    end
    
    pos_row4 = get(ax_row4(i),'Position');
    ax_row5(i) = axes('Position', [pos_row4(1)+pos_row4(3)+intercol, pos_row4(2), pos_row3(3)-pos_row4(3)-intercol, pos_row4(4)]);

    plot(output.f,output.pxx_spike,'color',[0.7 0.7 0.7]); 

    max1 = max(output.pxx_spike(13:end));
    
    hold on
    % Now not permitting multiple spikes
    [traces,psth_cells,output] = plotad2 ({['C:\Experiments\' file(1:end-4) '\Ad2\' file '.ad2']}, stims, reps, 'spikes', 0, channel, ms_after_peak_nospike, 0, 'extra', [file 'ch' num2str(channel)], 10, 0,0);
    plot(output.f,output.pxx_spike, 'color',Color_ii{i});     
    
    set(gca,'xtick',[0 2000 4000 6000]);
    set(gca,'xticklabels',{'0','2','4','6'});
    lh = xlabel('kHz');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
    
    set(gca,'ytick',[]);
    
    if i == 1
        lh5 = ylabel('Spike spectrum','FontSize', figparams.fsize_big);
    end
    
    max2 = max(output.pxx_spike(13:end));
    set(gca,'xlim',[0 max(output.f)*0.6]);
    set(gca,'ylim',[0 max(max1,max2)*1.1]);
    
    if i == 2
        hold on
        p = plot(output.f50,output.pxx_spike(output.f==output.f50),'ko','MarkerSize',4);
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        text(1.1*output.f50,output.pxx_spike(output.f==output.f50),'{\it f}_5_0','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    end
    
    ax_row5(i).FontSize = figparams.fsize;
    ax_row5(i).FontName = figparams.fontchoice;
end

for i = 1:length(units_call_types)
    pos_row5 = get(ax_row5(i),'Position');
    pos_row1 = get(ax_row1(i),'Position');
    ax_row6(i) = axes('Position', [pos_row1(1), pos_row5(2)-pos_row1(4)-interrow, pos_row1(3), pos_row1(4)]);
    
    plot_raster ({units_call_types{i}(1:end-3)}, str2num(units_call_types{i}(end)), '1:20', '1:10', '', '', '', 'single', 1, 0, 0, [], fig1, 1,'vertical tick',1);
    ax_row6(i).FontSize = figparams.fsize;
    ax_row6(i).FontName = figparams.fontchoice;
    set(gca,'linewidth',0.5);
    set(gca,'xlim',[0 2100]);   % End of longest stim is 2146 ms
    
    set(gca,'XTick', [0 1000 2000]);
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.11;
    set(lh,'Position',lh_pos);
    
    if i == 1
        lh6 = ylabel('Vocalizations','FontSize', figparams.fsize_big);
        txh = text(-0.17,1+0.13*ax_row5(1).Position(4)/ax_row1(1).Position(4),'E','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
        txh1n = text(270,0.3,'1n','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh1r = text(270,1.5,'1r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh20n = text(270,18.5,'10n','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh20r = text(270,19.7,'10r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    end
    
end

set(lh1,'Units','normalized');
xalign = ax_row1(1).Position(1)+lh1.Position(1)*(ax_row1(1).Position(3));
set(lh2,'Units','normalized');
set(lh2,'Position',[(xalign-ax_row2(1).Position(1))/ax_row2(1).Position(3),lh2.Position(2),lh2.Position(3)]);
set(lh3,'Units','normalized');
set(lh3,'Position',[(xalign-ax_row3(1).Position(1))/ax_row3(1).Position(3),lh3.Position(2),lh3.Position(3)]);
set(lh4,'Units','normalized');
set(lh4,'Position',[(xalign-ax_row4(1).Position(1))/ax_row4(1).Position(3),lh4.Position(2),lh4.Position(3)]);
set(lh6,'Units','normalized');
set(lh6,'Position',[(xalign-ax_row6(1).Position(1))/ax_row6(1).Position(3),lh6.Position(2),lh6.Position(3)]);

set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontWeight','Bold','box','off');
    
print('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\Fig 1\Fig1openGL.tif','-dtiff',['-r' num2str(figparams.res)]);
 