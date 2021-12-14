units_opt = {'M7E0491ch1','M7E2133ch1','M7E2256ch1'};   % Best freq, level, and BW
tuning_stims_opt = {'10','3','3'};
units_lessopt = {'M7E0488ch1','M7E2129ch1','M7E2256ch1'};   % Less optimal stimulus
tuning_stims_lessopt = {'11','22','5'};

units_std_tuning = {{'M7E0484ch1','M7E0485ch1'},{'M7E2129ch1'},{'M7E2255ch1'}};

units_call_types = {'M7E0499ch1','M7E2130ch1','M7E2254ch1'};

units_type = {'RS','RS','FS','FS','Burster','Burster'};

RSColor = [0.6350    0.0780    0.1840];
FSColor = [0    0.4470    0.7410];
BuColor = [0.4660    0.6740    0.1880];
BuColorDark = [0.3843    0.6118    0.0863];
Color_i = {RSColor, FSColor, BuColor};
Color_ii = {RSColor, FSColor, BuColorDark};

fig1 = figure;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [17.2*0.3937, 21.5*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 17.2*0.3937, 21.5*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 17.2*0.3937, 21.5*0.3937]);
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

for i = 1:length(units_opt)
    ax_row1(i) = subplot(6,3,i);
    oldpos = get(ax_row1(i),'Position');
    if i ==1
        xshift = lmargin-oldpos(1);
    end
    set(ax_row1(i),'Position',oldpos.*[1 1 1 1]+[xshift+xexpand*0.5*(i-1) +0.05 xexpand -0.02]);
    
%   plot_raster ({units_tuning{i}(1:end-3)}, str2num(units_tuning{i}(end)), '1:31', '1:10', 'Frequency (kHz)', ['Unit ' units_tuning{i}], '', 'single', 1, 0, 1, '1:10:32', fig1, 1);
    plot_raster ({units_opt{i}(1:end-3)}, str2num(units_opt{i}(end)), tuning_stims_opt{i}, '1:10', 'Frequency (kHz)', '', '', 'single', 1, 0, 1, '', fig1, 1,'vertical tick',0.5);
    ax_row1(i).FontSize = figparams.fsize;
    ax_row1(i).FontName = figparams.fontchoice;
    set(gca,'linewidth',0.5);
    set(gca,'xlim',[90 500]);
    set(gca,'XTick', []);
    set(gca,'ylim',[0,1]);    
    
    if i == 1
        yl = get(gca,'ylim');
        %text(75,yl(2)*1.08,'kHz','FontSize',figparams.fsize);
        lh1 = ylabel('Best stim','FontSize',figparams.fsize_big);
        pos = get(lh1,'Position');
        set(lh1,'Position',[65,pos(2),pos(3)]);
        %txh = text(-0.17,1.13,'A','Units','normalized','FontWeight','bold','FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
        txh = annotation('textbox','Position',[ax_row1(1).Position(1)-0.17*ax_row1(1).Position(3),ax_row1(1).Position(2)+ax_row1(1).Position(4)+0.03,0,0],'String','A','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
    end
    set(gca,'yTick',[]);
        
    if i == 1
        ti = title('Regular spiking','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.1,['Unit M7E0484ch1, 8.14 kHz, 18 dB tone'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 2
        ti = title('Fast spiking','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.1,['Unit M7E2129ch1, 4.44 kHz, 48 dB, 0.2 oct noise'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 3
        ti = title('Bursting','FontSize', figparams.fsize_big);
        txh2 = text(0.5,1.1,['Unit M7E2253ch1, 6.96 kHz, 38 dB tone'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    end
    oldposti = get(ti,'Position');
    oldposti(2) = yl(2)*1.25;
    set(ti,'Position',oldposti); 
    
    oldpos= ax_row1(i).Position;
    ax_row1b(i) = axes('Position', [oldpos(1), oldpos(2)-oldpos(4)-0.02, oldpos(3), oldpos(4)]);
    plot_raster ({units_lessopt{i}(1:end-3)}, str2num(units_lessopt{i}(end)), tuning_stims_lessopt{i}, '1:10', 'Frequency (kHz)', '', '', 'single', 1, 0, 1, '', fig1, 1,'vertical tick',0.5);   
    ax_row1b(i).FontSize = figparams.fsize;
    ax_row1b(i).FontName = figparams.fontchoice;
    set(gca,'linewidth',0.5);
    set(gca,'xlim',[90 500]);
    set(gca,'XTick', [0 200 400]);
    set(gca,'ylim',[0,1]);   
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.155;
    set(lh,'Position',lh_pos);
    if i == 1
        yl = get(gca,'ylim');
        %text(75,yl(2)*1.08,'kHz','FontSize',figparams.fsize);
        lh1 = ylabel('Other','FontSize',figparams.fsize_big);
        pos = get(lh1,'Position');
        set(lh1,'Position',[65,pos(2),pos(3)]);
    end
    set(gca,'yTick',[]);

    if i == 1
        txh2 = text(0.5,1.1,['8.28 kHz, 8 dB tone'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 2
        txh2 = text(0.5,1.1,['9.19 kHz, 48 dB tone'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    elseif i == 3
        txh2 = text(0.5,1.1,['6.96 kHz, 18 dB tone'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    end

end

for i = 1:length(units_std_tuning)
    pos_row1 = get(ax_row1b(i),'Position');
    ax_row2(i) = axes('Position', [pos_row1(1), pos_row1(2)-((pos_row1(4)+yexpand)*0.7)-interrow, pos_row1(3), (pos_row1(4)+yexpand)*0.76]);
    xautocorr = [];
    yautocorr = [];
    for j = 1:length(units_std_tuning{i})    
        file = units_std_tuning{i}{j}(1:end-3); channel = str2num(units_std_tuning{i}{j}(end)); stims = 1:31; reps = 1:10;
        if i == 1
            reps = 1:7;
        end
        try
            D = eval (file);
        catch
            mfilename_m = strcat(file, '.m');
            D=header_reader_mfile(mfilename_m);    % If file is incomplete so data matrix is irregular shaped, use this alternative reader, ignores final incomplete data line
        end
        [outputs, centers, N,centers2,N2,log_ISI_list,prestim_total_time,nint]...
        = spktr(D,file,channel,stims,reps,0.5,50,'all',1,0,0.5); 
        xautocorr(j,:) = [-1*fliplr(outputs.xautocorr) outputs.xautocorr];
        yautocorr(j,:) = [fliplr(outputs.yautocorr) outputs.yautocorr];
    end
    xautocorr = sum(xautocorr,1);
    yautocorr= sum(yautocorr,1);
    hb = bar(xautocorr,yautocorr,1,'FaceColor',Color_i{i},'FaceAlpha',0.7);
    ax_row2(i).FontSize = figparams.fsize;
    ax_row2(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[-50 50]);
    [val,ind] = max(find(outputs.xautocorr<= 50));
    set(gca,'ylim',[0 max(outputs.yautocorr(1:ind))*1.1]);
    set(gca,'xtick',[-50,0,50]);
    lh = xlabel('ms');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
  
    set(gca,'ytick',[]);
    
    if i == 1
         lh2 = ylabel('Autocorrelogram','FontSize',figparams.fsize_big);
         txh = annotation('textbox','Position',[ax_row1(1).Position(1)-0.17*ax_row1(1).Position(3),ax_row2(1).Position(2)+ax_row2(1).Position(4)+0.03,0,0],'String','B','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');       
    end
        
    pos_row2 = get(ax_row2(i),'Position');
    ax_row3(i) = axes('Position', [pos_row2(1), pos_row2(2)-pos_row2(4)-interrow, pos_row2(3), pos_row2(4)]);

    hb2 = bar(centers2,N2,1,'FaceColor',Color_i{i},'FaceAlpha',0.7,'EdgeColor','none');
    ax_row3(i).FontSize = figparams.fsize;
    ax_row3(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[0,4]);
    set(gca,'XTick', [0 2 4]);
    set(gca,'ylim',[0 max(N2(centers2<4))*1.1]);
    
    lh = xlabel('log(ms)');
    set(lh,'Units','normalized');
    lh_pos = get(lh,'Position');
    lh_pos(2) = -0.17;
    set(lh,'Position',lh_pos);
  
    set(gca,'ytick',[]);
    
    if i == 1
        lh3 = ylabel('Log(ISI)','FontSize',figparams.fsize_big);
        txh = annotation('textbox','Position',[ax_row1(1).Position(1)-0.17*ax_row1(1).Position(3),ax_row3(1).Position(2)+ax_row3(1).Position(4)+0.03,0,0],'String','C','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');       
    end
end

for i = 1:length(units_std_tuning)
    
    pos_row3 = get(ax_row3(i),'Position');
    ax_row4(i) = axes('Position', [pos_row3(1), pos_row3(2)-pos_row2(4)-interrow, pos_row3(3)*0.3, pos_row3(4)]);

    for j = 1:length(units_std_tuning{i}) 
        file = units_std_tuning{i}{j}(1:end-3); channel = str2num(units_std_tuning{i}{j}(end)); stims = 1:31; reps = 1:10;
        ad2_file = {['C:\Experiments\' file(1:end-4) '\Ad2\' file '.ad2']};
        if i == 1
            reps = 1:6;
        end
        [traces,psth_cells,output] = plotad2 (ad2_file, stims, reps, 'spikes', 0, channel, ms_after_peak_nospike, 0, 'extra', [file 'ch' num2str(channel)], 10, 1,0);
        sp_wave(j,:) = output.sp_wave;
        sp_wave_count(j) = output.sp_wave_count;
        ttp(j) = output.ttp_ms;
    end
    
    sp_wave_avg = sp_wave_count*sp_wave./sum(sp_wave_count);
    TTP = mean(ttp);
     
    output.t_shifted = output.t_shifted-0.3;
    plot(output.t_shifted(100:180),sp_wave_avg(100:180), 'color',Color_i{i},'LineWidth',0.8);
    ax_row4(i).FontSize = figparams.fsize;
    ax_row4(i).FontName = figparams.fontchoice;
    set(gca,'xlim',[output.t_shifted(100) output.t_shifted(180)]);
    ymin = min(sp_wave_avg(100:180));
    ymax = max(sp_wave_avg(100:180));
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
        txh = annotation('textbox','Position',[ax_row1(1).Position(1)-0.17*ax_row1(1).Position(3),ax_row4(1).Position(2)+ax_row4(1).Position(4)+0.03,0,0],'String','B','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');       
        hold on
        %TTP = output.ttp_ms;     % Peakfinder fails on the broad toothy peak here, so calculated using max and min
        an = annotation('doublearrow');
        [val,ind] = min(sp_wave_avg);
        tmin = output.t_shifted(ind);
        an.Parent = gca;
        an.Position = [tmin, val*1.05, TTP,0];
        an.Head1Length = 2;
        an.Head2Length = 2;
        an.Head1Width = 4;
        an.Head2Width = 4;
        txh = text(tmin*1.8, val*0.95, '{\it t}_T_T_P','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        yl = get(gca,'ylim');
        set(gca,'ylim',[yl(1)-0.1*(yl(2)-yl(1)), yl(2)]);
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
    ax_row6(i) = axes('Position', [pos_row1(1), pos_row5(2)-(pos_row1(4)+yexpand+0.02)-interrow-0.02, pos_row1(3), pos_row1(4)+yexpand+0.04]);
    
    plot_raster ({units_call_types{i}(1:end-3)}, str2num(units_call_types{i}(end)), '1:20', '1:10', '', '', '', 'single', 1, 0, 0, [], fig1, 1,'diamond',1);
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
        txh = annotation('textbox','Position',[ax_row1(1).Position(1)-0.17*ax_row1(1).Position(3),ax_row5(1).Position(2)+ax_row5(1).Position(4)+0.03,0,0],'String','E','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');       
        txh1n = text(-30,0.3,'1n','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh1r = text(-30,1.5,'1r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh20n = text(-30,18.5,'10n','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        txh20r = text(-30,19.7,'10r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
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
 