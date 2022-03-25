sfig = figure;
set(0, 'DefaultAxesFontName', 'Arial');

figparams.fsize = 8;
figparams.fsize_big = figparams.fsize+2;
figparams.msize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
lmargin = 0.07;
tmargin = 0.0;
xexpand = 0.08;
yexpand = 0.065;
interrow = 0.04;
intercol = 0.07;

letteroffset = [-0.06, 0.03];      % Fraction of page

M7Elog = 'C:\Users\Ping\Desktop\AC_type_project\data\M7E_unit_log.xlsx';
M117Blog = 'C:\Users\Ping\Desktop\AC_type_project\data\M117B_unit_log.xlsx';

% Set up panels
ax_sch = axes(gcf,'Position',[lmargin-0.02, 1-tmargin-0.24, 0.42, 0.21]); 
th_A = annotation('textbox',[ax_sch.Position(1)+0.02+letteroffset(1), ...
    ax_sch.Position(2)+ax_sch.Position(4)+letteroffset(2)-0.01, 0, 0],...
    'EdgeColor','none',...
    'String','A',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 
set(gca,'YColor','none','XColor','none');

ax_viol(1) = axes(gcf,'Position',[lmargin-0.02+ax_sch.Position(3)+intercol,...
                                  1-tmargin-0.23, 0.165, 0.165]); 
th_B = annotation('textbox',[ax_viol(1).Position(1)+letteroffset(1), ...
    th_A.Position(2), 0, 0],...
    'EdgeColor','none',...
    'String','B',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 

ax_viol(2) = axes(gcf,'Position',[ax_viol(1).Position(1)+ax_viol(1).Position(3)+intercol-0.01,...
                                  1-tmargin-0.23, 0.165, 0.165]); 
th_C = annotation('textbox',[ax_viol(2).Position(1)+letteroffset(1), ...
    th_A.Position(2), 0, 0],...
    'EdgeColor','none',...
    'String','C',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 

ax1 = axes(gcf,'Position',[lmargin, 1-tmargin-0.23-interrow-0.19,...
                              0.39, 0.15]);
title('Marmoset 7E','FontSize',figparams.fsize+1);

th_D = annotation('textbox',[ax1.Position(1)+letteroffset(1), ...
    ax1.Position(2)+ax1.Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','D',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 

ax2(1) = axes(gcf,'Position',[lmargin, ax1.Position(2)-interrow-0.15,...
                              0.39, 0.15]);
th_F = annotation('textbox',[ax2(1).Position(1)+letteroffset(1), ...
    ax2(1).Position(2)+ax2(1).Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','F',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 

ax2(2) = axes(gcf,'Position',[lmargin, ax2(1).Position(2)-interrow-0.24,...
                              0.39, 0.24]);
                          
th_H = annotation('textbox',[ax2(2).Position(1)+letteroffset(1), ...
    ax2(2).Position(2)+ax2(2).Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','H',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 
     

ax3 = axes(gcf,'Position',[ax_viol(1).Position(1),...
                              1-tmargin-0.23-interrow-0.19,...
                              0.39, 0.15]);
th_E = annotation('textbox',[ax3.Position(1)+letteroffset(1), ...
    ax3.Position(2)+ax3.Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','E',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 
title('Marmoset 117B','FontSize',figparams.fsize+1);
ax4(1) = axes(gcf,'Position',[ax_viol(1).Position(1),...
                              ax1.Position(2)-interrow-0.15,...
                              0.39, 0.15]);
th_G = annotation('textbox',[ax4(1).Position(1)+letteroffset(1), ...
    ax4(1).Position(2)+ax4(1).Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','G',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 
ax4(2) = axes(gcf,'Position',[ax_viol(1).Position(1),...
                              ax2(1).Position(2)-interrow-0.24,...
                              0.39, 0.24]);
th_I = annotation('textbox',[ax4(2).Position(1)+letteroffset(1), ...
    ax4(2).Position(2)+ax4(2).Position(4)+letteroffset(2), 0, 0],...
    'EdgeColor','none',...
    'String','I',...
    'FontSize',figparams.fsize,...
    'FontWeight','bold'); 

Pooledanalyses ('Neuron type properties subpanel', ax_viol);

plot_cortex_map ('M7E',...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M7E\M7E_L_tracks_H17.mat', ...
    M7Elog,'bf','A1:HG620',0,'jet',0,0,0,ax1)

outputs = plot_cortex_map ('M7E',...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M7E\M7E_L_tracks_H17.mat', ...
    M7Elog,'groupIDcriteria','A1:HG620',0,'cool',0,0,0,ax2);

xls_filename = 'C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Final_figures\FigS2\FigS2.xlsx';
i = 1;
ID = 'M7E';
sheetname = 'Maps';
indsxls1 = 1:length(outputs.x_loc);
col1 = outputs.x_loc;
col2 = outputs.y_loc;
col3 = outputs.unit_type;
col4 = outputs.bf;
col5 = outputs.CImax;
col1_lab = 'x position(mm)';
col2_lab = 'y_position(mm)';
col3_lab = 'Unit type';
col4_lab = 'Best Freq(kHz)';
col5_lab = 'CImax';
range_unit = ['A' num2str((length(indsxls1)+2)*(i-1)+1) ':A' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col1_lab = ['B' num2str((length(indsxls1)+2)*(i-1)+1) ':B' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col2_lab = ['C' num2str((length(indsxls1)+2)*(i-1)+1) ':C' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col3_lab = ['D' num2str((length(indsxls1)+2)*(i-1)+1) ':D' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col4_lab = ['E' num2str((length(indsxls1)+2)*(i-1)+1) ':E' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col5_lab = ['F' num2str((length(indsxls1)+2)*(i-1)+1) ':F' num2str((length(indsxls1)+2)*(i-1)+1)];
xlswrite(xls_filename,{ID},sheetname,range_unit); 
xlswrite(xls_filename,{col1_lab},sheetname,range_col1_lab);
xlswrite(xls_filename,{col2_lab},sheetname,range_col2_lab);
xlswrite(xls_filename,{col3_lab},sheetname,range_col3_lab);
xlswrite(xls_filename,{col4_lab},sheetname,range_col4_lab);
xlswrite(xls_filename,{col5_lab},sheetname,range_col5_lab);

range1 = ['B' num2str((length(indsxls1)+2)*(i-1)+2) ':B' num2str((length(indsxls1)+2)*i-1)];
xlswrite(xls_filename,col1(:),sheetname,range1);
range2 = ['C' num2str((length(indsxls1)+2)*(i-1)+2) ':C' num2str((length(indsxls1)+2)*i-1)];
xlswrite(xls_filename,col2(:),sheetname,range2);
range3 = ['D' num2str((length(indsxls1)+2)*(i-1)+2) ':D' num2str((length(indsxls1)+2)*i-1)];
xlswrite(xls_filename,col3(:),sheetname,range3);
range4 = ['E' num2str((length(indsxls1)+2)*(i-1)+2) ':E' num2str((length(indsxls1)+2)*i-1)];
xlswrite(xls_filename,col4(:),sheetname,range4);
range5 = ['F' num2str((length(indsxls1)+2)*(i-1)+2) ':F' num2str((length(indsxls1)+2)*i-1)];
xlswrite(xls_filename,col5(:),sheetname,range5);

plot_cortex_map ('M117B', ...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M117B\M117B_L_tracks_H14.mat', ...
    M117Blog, 'bf', 'A1:FZ530', 0,'jet',0,0,0,ax3);

outputs = plot_cortex_map ('M117B', ...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M117B\M117B_L_tracks_H14.mat', ...
    M117Blog,'groupIDcriteria', 'A1:FZ530', 0,'cool',0,0,0,ax4);

i = 2;
ID = 'M117B';
sheetname = 'Maps';
indsxls2 = 1:length(outputs.x_loc);
col1 = outputs.x_loc;
col2 = outputs.y_loc;
col3 = outputs.unit_type;
col4 = outputs.bf;
col5 = outputs.CImax;
col1_lab = 'x position(mm)';
col2_lab = 'y_position(mm)';
col3_lab = 'Unit type';
col4_lab = 'Best Freq(kHz)';
col5_lab = 'CImax';
range_unit = ['A' num2str((length(indsxls1)+2)*(i-1)+1) ':A' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col1_lab = ['B' num2str((length(indsxls1)+2)*(i-1)+1) ':B' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col2_lab = ['C' num2str((length(indsxls1)+2)*(i-1)+1) ':C' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col3_lab = ['D' num2str((length(indsxls1)+2)*(i-1)+1) ':D' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col4_lab = ['E' num2str((length(indsxls1)+2)*(i-1)+1) ':E' num2str((length(indsxls1)+2)*(i-1)+1)];
range_col5_lab = ['F' num2str((length(indsxls1)+2)*(i-1)+1) ':F' num2str((length(indsxls1)+2)*(i-1)+1)];
xlswrite(xls_filename,{ID},sheetname,range_unit); 
xlswrite(xls_filename,{col1_lab},sheetname,range_col1_lab);
xlswrite(xls_filename,{col2_lab},sheetname,range_col2_lab);
xlswrite(xls_filename,{col3_lab},sheetname,range_col3_lab);
xlswrite(xls_filename,{col4_lab},sheetname,range_col4_lab);
xlswrite(xls_filename,{col5_lab},sheetname,range_col5_lab);

range1 = ['B' num2str((length(indsxls1)+2)*(i-1)+2) ':B' num2str(length(indsxls1)+length(indsxls2)+3)];
xlswrite(xls_filename,col1(:),sheetname,range1);
range2 = ['C' num2str((length(indsxls1)+2)*(i-1)+2) ':C' num2str(length(indsxls1)+length(indsxls2)+3)];
xlswrite(xls_filename,col2(:),sheetname,range2);
range3 = ['D' num2str((length(indsxls1)+2)*(i-1)+2) ':D' num2str(length(indsxls1)+length(indsxls2)+3)];
xlswrite(xls_filename,col3(:),sheetname,range3);
range4 = ['E' num2str((length(indsxls1)+2)*(i-1)+2) ':E' num2str(length(indsxls1)+length(indsxls2)+3)];
xlswrite(xls_filename,col4(:),sheetname,range4);
range5 = ['F' num2str((length(indsxls1)+2)*(i-1)+2) ':F' num2str(length(indsxls1)+length(indsxls2)+3)];
xlswrite(xls_filename,col5(:),sheetname,range5);

% Adjust axis lims to be same scale
axes(ax2(1));
xl_2_1 = xlim;
yl_2_1 = ylim;
axes(ax1);
xlim(xl_2_1);
ylim(yl_2_1);

axes(ax2(2));
xl_3_1 = xlim;
axes(ax4(2));
xl_3_2 = xlim;
xl_3_2_range = xl_3_2(2)-xl_3_2(1);
xl_shift = (xl_3_2(1)-xl_3_1(1))/xl_3_2_range;
x2_shift = (xl_3_2(2)-xl_3_1(2))/xl_3_2_range;
xl(1) = xl_3_2(1) - xl_shift * xl_3_2_range;    % Check default transform
xl(2) = xl_3_2(2) - x2_shift * xl_3_2_range;
xlim(xl);

axes(ax4(1));
xl_2_2 = xlim;
xl_2_2_range = xl_2_2(2)-xl_2_2(1);
xl(1) = xl_2_2(1) - xl_shift * xl_2_2_range;
xl(2) = xl_2_2(2) - x2_shift * xl_2_2_range;
xlim(xl);

axes(ax3);
xl_1_2 = xlim;
xl_1_2_range = xl_1_2(2)-xl_1_2(1);
xl(1) = xl_1_2(1) - xl_shift * xl_1_2_range;
xl(2) = xl_1_2(2) - x2_shift * xl_1_2_range;
xlim(xl);

set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontWeight','Bold');

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [18.5*0.3937, 22*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 18.5*0.3937, 22*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 18.5*0.3937, 22*0.3937]);

axes(ax_sch)
[I,map] = imread('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\schematic.png');
imshow(I,map); 

print('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\Supp\maps.tif','-dtiff',['-r' num2str(figparams.res)]);

ax_sch.Units = 'pixels';
ax_sch.Position    % Print to get size for schematic image
