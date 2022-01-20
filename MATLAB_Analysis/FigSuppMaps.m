sfig = figure;
set(0, 'DefaultAxesFontName', 'Arial');

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [18.5*0.3937, 22*0.3937]);
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition', [0 0 18.5*0.3937, 22*0.3937]);
set(gcf,'Units','inches');
set(gcf,'Position',[0 0 18.5*0.3937, 22*0.3937]);
figparams.fsize = 8;
figparams.fsize_big = figparams.fsize+2;
figparams.msize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
lmargin = 0.05;
tmargin = 0.0;
xexpand = 0.08;
yexpand = 0.065;
interrow = 0.05;
intercol = 0.1;

M7Elog = 'C:\Users\Ping\Desktop\AC_type_project\data\M7E_unit_log.xlsx';
M117Blog = 'C:\Users\Ping\Desktop\AC_type_project\data\M117B_unit_log.xlsx';

% Schematic of map
ax_sch = axes(gcf,'Position',[lmargin, 1-tmargin-0.25, 0.5, 0.24]); 

ax1 = axes(gcf,'Position',[lmargin, 1-tmargin-ax_sch.Position(4)-interrow-0.16,...
                              (1-2*lmargin-intercol)/2, 0.16]);
ax2(1) = axes(gcf,'Position',[lmargin, ax1.Position(2)-interrow-0.16,...
                              (1-2*lmargin-intercol)/2, 0.16]);
ax2(2) = axes(gcf,'Position',[lmargin, ax2(1).Position(2)-interrow-0.24,...
                              (1-2*lmargin-intercol)/2, 0.24]);

ax3 = axes(gcf,'Position',[lmargin+ax1.Position(3)+intercol,...
                              1-tmargin-ax_sch.Position(4)-interrow-0.16,...
                              (1-2*lmargin-intercol)/2, 0.16]);
ax4(1) = axes(gcf,'Position',[lmargin+ax1.Position(3)+intercol,...
                              ax1.Position(2)-interrow-0.16,...
                              (1-2*lmargin-intercol)/2, 0.16]);
ax4(2) = axes(gcf,'Position',[lmargin+ax1.Position(3)+intercol,...
                              ax2(1).Position(2)-interrow-0.24,...
                              (1-2*lmargin-intercol)/2, 0.24]);

%inputs.AID = 'M7E';
%inputs.tracks = 'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M7E\M7E_L_tracks_H17.mat';
%inputs.logfile = 'C:\Users\Ping\Desktop\AC_type_project\data\M7E_unit_log.xlsx';
%inputs.logrange = 'A1:HG620';

plot_cortex_map ('M7E',...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M7E\M7E_L_tracks_H17.mat', ...
    M7Elog,'bf','A1:HG620',0,'jet',0,0,0,ax1)

plot_cortex_map ('M7E',...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M7E\M7E_L_tracks_H17.mat', ...
    M7Elog,'groupIDcriteria','A1:HG620',0,'cool',0,0,0,ax2);

plot_cortex_map ('M117B', ...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M117B\M117B_L_tracks_H14.mat', ...
    M117Blog, 'bf', 'A1:FZ530', 0,'jet',0,0,0,ax3);

plot_cortex_map ('M117B', ...
    'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M117B\M117B_L_tracks_H14.mat', ...
    M117Blog,'groupIDcriteria', 'A1:FZ530', 0,'cool',0,0,0,ax4);

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
%xlim(xl_3_1);
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

print('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\Supp\maps.tif','-dtiff',['-r' num2str(figparams.res)]);
