function plot_cortex_map (monkey_name, hole_location_struct_file, data_log_file, prop_name, xlsrange, fliphem, cm, plot_circles)

% prop_name   Column name of the property in the worksheet that you want
%             plotted e.g., best frequency, latency, spontaneous rate
%
% xlsrange    Range of properly formatted data on spreadsheet
% cm          Colormap e.g., 'cool' 'jet'

RSColor = [0.6350    0.0780    0.1840];
FSColor = [0    0.1    0.7410];
Bu1Color = [0.05    0.4    0.0];
Bu2Color = [0.4    0.8    0.3];
BuColor = [0.2392    0.5608    0.0784];
backcolor = [1 1 1];
alpha = 0.7;


plot_path = 'C:\Users\Ping\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\';
plot_dir = strcat(plot_path, monkey_name);

if exist('hole_location_struct_file', 'var')
    if exist(hole_location_struct_file)
        load(hole_location_struct_file);
    end
else
    H.AnimalID = monkey_name;
    c = input('Which hemisphere? (L) or (R)','s');
    H.Hem = c;
    H.hole_radius = [];
    H.hole_centers = [];
    H.photo_file = '';
    H.ls = [];
end

c = input('Input new data? (1) or (0)');

if c
    H = cortex_map_input (H, plot_dir);

    c = input('Save new coordinates? (1) or (0)');

    nHoles = size(H.hole_centers, 1);
    if c
        save([monkey_name '_' H.Hem '_tracks_H' num2str(nHoles) '.mat'], 'H');
    end
end

% Load spreadsheet
matfilename = fliplr(strtok(fliplr(data_log_file),'\'));
matfilename = strtok(matfilename,'.');

c = input('Load log from .mat file (1) or reload from .xlsx file (0)?'); 
if c && (exist([plot_path matfilename '.mat'], 'file') == 2)
    load([plot_path matfilename '.mat']);
else
    if c
        disp('Cannot find .mat file, reloading from .xlsx');
    end
    [dl_num, dl_txt, dlUM_raw] = xlsread(data_log_file, 'UnitMetaExtracellular', xlsrange);
    col_hole = find(cellfun (@(x) strcmp('hole',x), dlUM_raw(1,:)));
    col_track = find(cellfun (@(x) strcmp('track',x), dlUM_raw(1,:)));
    save([plot_path matfilename '.mat'], 'dlUM_raw', 'col_hole','col_track');
end
col_prop = find(cellfun(@(x) strcmp(prop_name,x), dlUM_raw(1,:)));
col_CImax = find(cellfun(@(x) strcmp('CImax',x), dlUM_raw(1,:))); 
col_BF = find(cellfun(@(x) strcmp('bf',x), dlUM_raw(1,:)));
% For CImax-cell type-lateral sulcus projection plot
        

% Get plot tuples

prop_vals = dlUM_raw(3:end, col_prop);
CImax_vals = dlUM_raw(3:end, col_CImax);
BF_vals  = dlUM_raw(3:end, col_BF);
hole_vals = cell2mat(dlUM_raw(3:end, col_hole));
track_vals = cell2mat(dlUM_raw(3:end, col_track));
if strcmp(prop_name, 'bf')
    col_aud = find(cellfun (@(x) strcmp('aud',x), dlUM_raw(1,:)));
    aud_vals = dlUM_raw(3:end, col_aud);
    [inds,foo] = find(cellfun(@(x) strcmp('N',x) || isequal(x,0), aud_vals));
    prop_vals(inds)= {'non'};
end
non_blank = cellfun(@(x) not(max(isnan(x))), prop_vals);
prop_vals = prop_vals(non_blank);
CImax_vals = CImax_vals(non_blank);
BF_vals = BF_vals(non_blank);

%if iscellstr(prop_vals)
%    error('Non-numeric values');
%end
hole_vals = hole_vals(non_blank);
track_vals = track_vals(non_blank);
if strcmp(prop_name,'nvt')    % If responsive to 0 vocalizations, plot as x later
    prop_vals(cellfun(@(x)isequal(x,0),prop_vals))= {'non v'};
end

xp = H.hole_centers(:,1); yp = H.hole_centers(:,2);
r = H.hole_radius;

%Recalculate coordinates
scaleup = 10     % scale up to increase resolution
P = H.photo_file;
cd(plot_dir);
h2 = figure('Color',[1 1 1]);
[I,map] = imread(P);
imshow(I,map);   % doubleclick in crop rectangle
c = input('Crop image area (1) or (0)');
if c
    [Icr,rect] = imcrop(I);
    %[Icr, rect] = imcrop(I,[218,90,181,135]);
else
    Icr = I;
    rect = [0,0,size(I,2),size(I,1)]
end
Icr = imresize(Icr, scaleup);

xp = scaleup*(xp - rect(1));      % shift for crop and scale up
yp = scaleup*(yp - rect(2));
if ~isempty(H.ls)
    H.ls(:,1) = scaleup*(H.ls(:,1)-rect(1));
    H.ls(:,2) = scaleup*(H.ls(:,2)-rect(2));
end
r = scaleup*r;

% Flip LR for visualization of left / right hemispheres
if exist('fliphem', 'var') && (fliphem==1)
    Icr = flipdim(Icr,2);
    xp = scaleup*rect(3)-xp;
    if ~isempty(H.ls)
        H.ls(:,1) = scaleup*rect(3)-H.ls(:,1);
    end
end
close(h2);
h2 = figure('Color',[1 1 1]);
hi = imshow(Icr);
set(gca,'Position',[0.05 0.05 0.9 0.9])
hold on
    
H_fn = fieldnames(H);
temp = cellfun(@(x) regexp(x, '^H\d+$'),H_fn, 'uni', false);
H_inds = not(cellfun('isempty', temp));
H_nums = cellfun(@(x) str2num(x(2:end)),H_fn(H_inds));
nHoles = length(H_nums);

for n = 1:nHoles
    if (n==11) && strcmp(monkey_name,'M7E')
        continue
    end
    %plot circle
    if plot_circles
        th = 0:pi/50:2*pi;
        xunit = r * cos(th) + xp(n);
        yunit = r * sin(th) + yp(n);
        plot(xunit, yunit,'Color', [0.45 0.45 0.45],'LineWidth',1.5);     % was 1.5
    end
end

% Separate these so circles are plotted under markers
x_all = [];
y_all = [];
if iscellstr(prop_vals)
    prop_vals_all = {};
    CImax_vals_all = [];
    BF_vals_all = [];
else
    prop_vals_all = [];
end

rng(1);

% Rotate to make sulcus horizontal
v = [H.ls(2,1)-H.ls(1,1), H.ls(2,2)-H.ls(1,2)]; 
theta = atan(abs(v(2))/abs(v(1)));
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
R_cent = [mean([max(xp),min(xp)]); mean([max(yp),min(yp)])];  % center of rotation
h_centers = [xp';yp'] - R_cent;
h_centers = R*h_centers + R_cent;
xp = h_centers(1,:)';
yp = h_centers(2,:)';
H.ls = (R*(H.ls'-R_cent) + R_cent)';

for n = 1:nHoles
    ncoor = eval(['H.H' num2str(n) '.coor']);    % x, y coords of trks on unit circle
    if ~isempty(ncoor)
        ncoor = (R*(ncoor'))';
    end
    ntr = cell2mat(eval(['H.H' num2str(n) '.track']));
    prop_vals_n = prop_vals(find(hole_vals == n));
    CImax_vals_n = CImax_vals(find(hole_vals == n));
    BF_vals_n = BF_vals(find(hole_vals == n));
    track_vals_n = track_vals(find(hole_vals == n));
    
    for m = 1:length(prop_vals_n) 
        if isnan(track_vals)      % track value blank
            continue
        end
        ncoorm = ncoor(ntr==track_vals_n(m), :);
        if isempty(ncoorm)        % missing track on map
            continue
        end
        %jitr = r*0.2;       % jitter offset to make multiple units on the same track visible
        %jitoffx = 0.25*r*(2*rand(1)-1);
        %jitoffy = 0.25*r*(2*rand(1)-1);
        jitoffx = randsample([-1, 1],1)*r*(0.1+0.2*(rand(1)));
        jitoffy = randsample([-1, 1],1)*r*(0.1+0.2*(rand(1)));
        unitsintrack = length(find(track_vals_n == track_vals_n(m)));
        %jitoffx = jitr*cos(-m*2*pi/(unitsintrack-1));     % made angle negative to offset two points from two tracks that overlaid
        %jitoffy = jitr*sin(-m*2*pi/(unitsintrack-1));
        
        xn(m) = (ncoorm(1)*r + xp(n))+jitoffx;
        yn(m) = (-1*(ncoorm(2)*r) + yp(n))+jitoffy; 
               
        if isnumeric(prop_vals_n{m})
            if strcmp(prop_name,'bf') || strcmp(prop_name,'latency')
                scatter(xn(m),yn(m),10,log(prop_vals_n{m}),'o','filled');
            elseif strcmp(prop_name,'CImax')
                scatter(xn(m),yn(m),9,prop_vals_n{m},'o','filled');
            elseif strcmp(prop_name,'q_Opt')
                scatter(xn(m),yn(m),10,prop_vals_n{m},'o','filled');
            else
                scatter(xn(m),yn(m),10,prop_vals_n{m},'o','filled');
            end
            % Store propval, x, y (unjittered) for regression
            x_all = [x_all; ncoorm(1)*r + xp(n)];
            y_all = [y_all; (-1*(ncoorm(2)*r) + yp(n))];
            prop_vals_all = [prop_vals_all; prop_vals_n{m}];
        else
            if any(strcmp(prop_name,{'groupIDcriteria','groupIDgmm'}))
                colors = containers.Map({'RS','FS','Burster_h','Burster_l','Burster'}, ...
                    {RSColor, FSColor, Bu1Color, Bu2Color, BuColor});
                symbols = containers.Map({'RS','FS','Burster_h','Burster_l','Burster'}, ...
                    {'o','s','^','d','^'});
                if isKey (colors, prop_vals_n{m})
                    scatter(xn(m),yn(m),10,colors(prop_vals_n{m}),...
                        symbols(prop_vals_n{m}),...
                        'filled',...                           
                        'MarkerFaceAlpha', alpha)    
                        %'MarkerEdgeColor', colors(prop_vals_n{m})*0.9,...
                        %'MarkerFaceColor', [1 1 1]-([1 1 1]-colors(prop_vals_n{m}))*0.7,...
                        %'LineWidth', 1,...
                               
                    x_all = [x_all; ncoorm(1)*r + xp(n)];
                    y_all = [y_all; (-1*(ncoorm(2)*r) + yp(n))];
                    prop_vals_all = [prop_vals_all; prop_vals_n{m}];
                    if isnumeric(CImax_vals_n{m})
                        CImax_vals_all = [CImax_vals_all; CImax_vals_n{m}];
                    else
                        CImax_vals_all = [CImax_vals_all; NaN];
                    end
                    if isnumeric(BF_vals_n{m})
                        BF_vals_all = [BF_vals_all; BF_vals_n{m}];
                    else
                        BF_vals_all = [BF_vals_all; NaN];
                    end
                end
            else
                switch prop_vals_n{m}
                    case 'non'        % Not auditory responsive
                        %text(xn(m), yn(m),'x','Color','y','FontSize',16)
                        %scatter(xn(m),yn(m),30,[1 1 1], 'x', 'sizedata',16)
                        plot(xn(m),yn(m),'x','MarkerEdgeColor',[0.7 0.7 0.7], 'MarkerSize',6);
                    case 'non v'   % Non responsive to vocalizations
                        plot(xn(m),yn(m),'x','MarkerEdgeColor',[0.7 0.7 0.7], 'MarkerSize',6);
                    case 'CI0'     % CI 0 - likely not enough spikes
                        plot(xn(m),yn(m),'o','MarkerEdgeColor',[0.7 0.7 0.7], 'MarkerSize',4);
                    case 'H'     % High spont rate (putative FS neurons)
                        plot(xn(m),yn(m),'^','MarkerEdgeColor',[0.7 0.7 0.7], 'MarkerSize',4);

                end
            end
        end
        c = colormap(gca,eval(cm));       
    end
end
title(['Property:' prop_name],'Interpreter', 'none');

switch prop_name
    case 'bf'
        minmax = [log(0.5) log(32)];
        ticks = log([0.5 1 2 4 8 16 32]);
        ticklabels = [0.5 1 2 4 8 16 32];
        yunits = 'kHz';
        titlestr = 'Best frequency';
        f=get(gca,'Children');
        %legend([f(3)],'no response to auditory stimuli','AutoUpdate', 'off');
    case 'latency'
        minmax = [log(10) log(200)];
        ticks = log([10,50,100,150,200]);
        ticklabels = [10,50,100,150,200];
        yunits = 'ms';
        titlestr = 'Minimal latency';
    case 'nvt'    % number of vocalization types responsive to, [tw#7 and trtwpp#17] and tsikbarks non-unique 
        minmax = [0 14];
        ticks = [0 2 4 6 8 10 12 14];
        ticklabels = [0 2 4 6 8 10 12 14];
        yunits = '# call types';
        titlestr = 'Call type response';
    case 'CImax'
        prop_vals_num = dl_num(3:end, col_prop);
        minmax = [0 60];
        ticks = minmax(1):20:minmax(2);
        ticklabels = minmax(1):20:minmax(2);
        yunits = 'CI_M_A_X';
        titlestr = 'Correlation Index';
        f=get(gca,'Children');
        legend([f(6),f(8)],'no response to mixed call types','CI_M_A_X of zero','AutoUpdate', 'off');
        
        % Calculate 2D regression
        X = [ones(size(x_all)) x_all y_all];
        y = prop_vals_all;
        [b,bint,res,rint,stats] = regress(y,X); 
        grad = [b(2),b(3)];
        grad = grad/norm(grad)*100;
        mdl = fitlm(X,y)
        midx = mean([max(x_all), min(x_all)]);
        midy = mean([max(y_all), min(y_all)]);
        
        %{
        quiver(midx+30,midy+100,grad(1),grad(2), 'LineWidth',2,'MaxHeadSize',0.5, 'Color', 'k');            
        
        xl = linspace(min(x_all), max(x_all), 50);
        yl = grad(2)/grad(1)*xl+(midy-grad(2)/grad(1)*midx);    % Line passing through midx/midy
        plot(xl, yl);
        %}
        % Lateral sulcus line
        %quiver(midx+30,midy+100,H.ls(2,1)-H.ls(1,1),H.ls(2,2)-H.ls(1,2), 'LineWidth',2,'MaxHeadSize',0.5, 'Color', 'k');
 
        
        %v = [grad(1), grad(2)];
        v = [H.ls(2,1)-H.ls(1,1), H.ls(2,2)-H.ls(1,2)]; 
        normv = norm(v);
        for i = 1:length(x_all)
            u = [x_all(i),y_all(i)];
            proj_all(i) = dot(u,v)/normv;
        end
        main_fig = gcf;
        proj_fig = figure;
        plot(proj_all, prop_vals_all,'*');
        
        figure (main_fig);
    case 'CIavg'
        minmax = [0 50];
        ticks = minmax(1):10:minmax(2);
        ticklabels = minmax(1):10:minmax(2);
        yunits = 'CIavg';
        titlestr = 'Correlation Index';
    case 'q_Opt'
        minmax = [0 150];
        ticks = [1, logspace(log10(5),log10(500),3)];   % matched to sigma samples
        %ticks = ticks(1:end-1); % up to 464 ms 
        %ticklabels = round(ticks*1000)/1000;   % don't display lots of decimal places
        ticklabels = ticks;
        yunits = 'q_Opt';
        titlestr = 'Optimum cost for classification';    
        try
            c.FontSize = 12;
        catch
            pause;
        end
    case 'RespDurIndex_highspont'
        minmax = [-1 2];
        ticks = -1:0.5:2;
        ticklabels = ticks;
        yunits = 'NSSR';
        titlestr = 'Normalized Steady-state Response (FS)';    
        
    case 'RespDurIndex_lowspont'
        minmax = [-1 2];
        ticks = -1:0.5:2;
        ticklabels = ticks;
        yunits = 'NSSR';
        titlestr = 'Normalized Steady-state Response (RS)';   
        
    case {'groupIDcriteria','groupIDgmm'}
        minmax = NaN;   % Categorical does not need color axis
        titlestr = 'Unit type based on criteria';
         
        v = [H.ls(2,1)-H.ls(1,1), H.ls(2,2)-H.ls(1,2)]/(2*r); 
        v = v/norm(v)*sign(v(1));
        for i = 1:length(x_all)
            u = [x_all(i),y_all(i)]/(2*r);
            proj_all(i) = dot(u,v);
            %proj_all(i) = dot(u,v)/normv*sign(v(1));   % Want x direction to be pointing positive
        end
        shift = min(proj_all);
        proj_all = proj_all-shift;
        colors_all = cell2mat(cellfun(@(x) colors(x), prop_vals_all,'UniformOutput', false));
        symbols_all = cellfun(@(x) symbols(x), prop_vals_all,'UniformOutput', false);
        main_fig = gcf;
        xl(1) = min(x_all)-0.05*(max(x_all)-min(x_all));
        xl(2) = max(x_all)+0.1*(max(x_all)-min(x_all));
        xlim(xl);
        xl_main = xlim;
        xl_trans = xl_main/(2*r) - shift;
        ax_main = gca;
        pos_main = ax_main.Position;
        proj_fig1 = figure;
        for i = 1:length(proj_all)    % Can't pass in array of marker symbols
            scatter(proj_all(i), CImax_vals_all(i), 10, colors_all(i,:),...
                symbols_all{i},'filled','MarkerFaceAlpha',alpha);
            hold on
        end
        xlabel('Anterior-posterior location on sulcal axis (mm)');
        xlim(xl_trans);
        xl = xlim;
        yl = ylim;
        %xticks(0:1:xl(2));
        set(gca,'Position',pos_main);
    
        patch([xl fliplr(xl)], [yl(1) yl(1) yl(2) yl(2)], backcolor);
        ax = gca;
        uistack(ax.Children(1),'bottom');
        proj_fig2 = figure;
        for i = 1:length(proj_all)
            scatter(proj_all(i), BF_vals_all(i), 10, colors_all(i,:),...
                symbols_all{i},'filled','MarkerFaceAlpha',alpha);
            hold on
        end
        xlim(xl_trans);
        xl = xlim;
        yl = ylim;
        set(gca,'Position',pos_main);
        figure (main_fig);
       
    otherwise
        prop_vals_num = dl_num(3:end, col_prop);
        minmax = [min(prop_vals_num) max(prop_vals_num)];
        ticks = linspace(minmax(1), minmax(2), 8);
        ticklabels = ticks;
        yunits = '';
        titlestr = '';
end      
    

if ~isnan(minmax)
    %Scale color from 0.5 to 32 kHz
    caxis(minmax)
    c=colorbar;
    set(c,'YTick',ticks)
    set(c,'YTickLabel',ticklabels)
    set(c,'FontSize',14)
    cpos = get(c,'Position');
    cpos = [0.875 0.12 0.03 0.8];
    set(c,'Position',cpos);

    axpos = get(gca,'Position');
    set(c,'Position',cpos)
    set(gca,'Position',axpos);
    ylabel(c,yunits,'FontSize',16)
else
    %[types, I] = unique(prop_vals_all);
    %types(types=="Burster_h") = "Bu1";
    %types(types=="Burster_l") = "Bu2";
    p = flipud(findobj(gca,'Type','Scatter'));
    %legend(p(flipud(I)),flipud(types),'AutoUpdate','off','Location',[0.65, 0.2, 0.2, 0.2]);
    indRS = find(strcmp(prop_vals_all, 'RS'),1);
    indFS = find(strcmp(prop_vals_all, 'FS'),1);
    indBu1 = find(strcmp(prop_vals_all, 'Burster_h'),1);
    indBu2 = find(strcmp(prop_vals_all, 'Burster_l'),1);
    inds = [indRS, indFS, indBu1, indBu2];
    legend(p(inds),{'RS','FS','Bu1','Bu2'},...
        'AutoUpdate','off','Location',[0.65, 0.8, 0.2, 0.2]);
    
    legend boxoff;
    % set gca 'Color' doesn't work if axes are visible off
    xl = xlim;
    yl = ylim;
    patch([xl fliplr(xl)], [yl(1) yl(1) yl(2) yl(2)], [backcolor]);
    ax = gca;
    uistack(ax.Children(1),'bottom');
end

ti = title(titlestr);
if fliphem
    set(ti,'Position',[0.25*scaleup*rect(3), 0.1*scaleup*rect(4)]);
else 
    set(ti,'Position',[0.50*scaleup*rect(3), 0.1*scaleup*rect(4)]);
end
set(ti,'FontSize',16);

set (hi,'visible','off');
%set(gca, 'visible', 'on')
%set(gca,'color',[0.9,0.9,0.9]);
%set(gca, 'TickLength',[0 0]);

% Draw lateral sulcus line
if ~isempty(H.ls)
    line(H.ls(:,1),H.ls(:,2),'LineStyle','--','Color',[0.5,0.5,0.5],'LineWidth',2.5);
end
% Show scale bar (2r is 1 mm)
mm = 2; 
scaley = round(0.95*scaleup*rect(4));
if fliphem
    scalex = round(0.6*scaleup*rect(3));
else
    scalex = round(0.2*scaleup*rect(3));
end
scaledx = mm*2*r;
if exist('fliphem', 'var') && (fliphem==1)
    t(1) = text(scalex-0.03*scaleup*rect(3),scaley-0.12*scaleup*rect(4),'Left-right flipped');
    set(t(1),'FontSize', 16);
end
t(2) = text(scalex+0.25*scaledx,scaley-0.05*scaleup*rect(4),[num2str(mm) ' mm']);
line([scalex,scalex+scaledx],[scaley, scaley],'Color','k','LineWidth',4);
set(t(2),'FontSize', 16);

set(gca,...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',15,...
    'FontName','Calibri');

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 6 3.692]);
set(gcf, 'renderer', 'painters');

print([monkey_name '_' prop_name '_map'],'-dpng','-painters');




function H_new = cortex_map_input (H_old, plot_dir)

% Input track and hole locations via GUI
% Append to existing struct H_old and output as updated struct H_new

% Create topographic map over cortex based on recording
% Must save('monkeyname_hemisphere.mat', 'H') after entering each hole

%plot_dir = 'C:\Users\xpliu\Documents\MATLAB\Xblaster3_Chamber3_GIT\XPL_code\plot_cortex\M117A';

cd(plot_dir)

%clear;
%l=input('Load previous file?  (1) or (0)    ');
%if l==1
%    load(uigetfile('Select previous file to map craniotomies','.m'))
%else
%    H =[];
%    H.AnimalID= input('Animal ID?     ','s');
%    H.Hem= input('(L) or (R) hemisphere?     ','s');
%end
H = H_old;

% Unit circle, mark points and value, save as a structure with hole number
% Create unit circle
newData =  input('Input data for new hole? (1) or (0)      ');
if newData==1
    nHole = input('Input hole number      ');
    h = figure('Color',[1 1 1]);
    set(h, 'Position', [400 200 400 400])
    t = 0:0.1:2*pi;
    x = cos(t);
    y = sin(t);
    plot(x,y,'k')
    set(gca,'XTick',[-1:0.5:1])
    set(gca,'YTick',[-1:0.5:1])
    pbaspect('manual'); pbaspect([1 1 1]); %x,y coordinates are to scale
    c = input('Start selecting points? (1) or (0)     ');
    m = 1;
    while c == 1
        [x,y] = getpts(h);
        disp('Press enter ')
        z = input('Enter track number     ');
        text(x, y, num2str(z));%label point with CF
        n = ['H' num2str(nHole)];
        H.(n).coor(m,1:2) = [x y]; %
        H.(n).track{m,1} = z; %
        c = input('Keep selecting points? (1) or (0)     ');
        m = m+1;
    end
end

% Legend for strings
% 's' somatosensory
% 'v' visual
% 'b' broad frequency tuning
% 'n' auditory non-responsive
% 'p' persistent activity
% 'l' late activity (distinct from early activity)
% 'i' inhibited by sound

% Get picture of headcap with coordinates of center of holes
% import

P = uigetfile('*.jpg;*.png','Select image of craniotomy');
% P = 'M117A_L_h12.jpg';
H.photo_file = P;
h2 = figure('Color',[1 1 1]);
imshow(P)

c = input('Append location for new hole (0) or re-enter hole locations (1) or draw lateral sulcus line (2)?');
if c == 1
    %measure size of hole on picture for scale factor
    disp ('Select 2 points to measure diameter of holes');
    [xd,yd] = getpts(get(imshow(P),'Parent'));
    % d = sqrt((xd(2)-xd(1))^2+(yd(2)-yd(1))^2);
    r = pdist([xd yd])/2;
    H.hole_radius = r;

    disp ('Select center of holes in order');
    [xp,yp] = getpts(get(imshow(P),'Parent'));
    H.hole_centers = [xp,yp];
elseif c == 0
    disp ('Select center of new hole');
    [xtemp, ytemp] = getpts(get(imshow(P), 'Parent'));
    coord_temp = [xtemp, ytemp];
    H.hole_centers = [H.hole_centers; coord_temp];
    %xp = H.hole_centers(:,1); yp = H.hole_centers(:,2);
    %r = H.hole_radius;
elseif c == 2
    while c 
        disp ('Select endpoints of lateral sulcus line');
        [xl,yl] = getpts(get(imshow(P),'Parent'));
        line(xl,yl,'Color','k','LineWidth',2);
        c = not(input('Accept line (1) or retry (0)?'));
    end
    H.ls = [xl,yl];
end    


H_new = H;
