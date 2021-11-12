function plot_raster (resp_filename, resp_channel, stiminds, repinds, ylabelstr, titlestr, savepath, multifile, scaleby1000, papersize, showyticks, customyticks, plothandle, displaymini, symb_type, tickwidth)
% Enter negative stimindices or repindices to compute all of them
% resp_filename in form e.g., 'M117A4239' so it can be run as eval
% For Chamber 3, resp_channel is 4, 5, or 6
% stiminds and repinds as strings
% symb_type: ‘dot’, ‘diamond,’ or ‘vertical tick’ 

% Example call: plot_raster ({'M117B0646'}, 4, '1:20', '1:10', '', '', ...
% 'C:\Users\Ping\Desktop\Analysis_practice\Poster_figures_SFN_2019\Rasters\', 'single', 0, papersize, 0, [], fig, 0)

respSR = 97656.25;    % Circuit SR from Zero.m line 1080

% Colors from zero.m
handles.white = [1 1 1];
handles.black = [0 0 0];
handles.red1 = [224 44 48]/256;
handles.pink = [256 240 240]/256;
handles.orange1 = [1 .55 .22];
handles.aqua = [.9 .95 .95];
handles.aqua2 = [.95 .98 .98];
handles.blue1 = [.49, .49, .839];
handles.green1 = [130 255 124]/256;
handles.green2 = [130 196 147]/256;
handles.green3 = [240 256 240]/256;
handles.gray1 = [226 226 226]/256;
handles.gray2 = [.698 .671 .624];
handles.gray3 = [147 137 121]/256;

blue = [50,109,214]/256*0.7;   % For SFN 2019 poster, darker for contrast

%masterfont = 20;
%masterfont = 14;
masterfont = 7;
dotsize = 14;
if displaymini
    dotsize = 3;
end
markersize = 1;
%markersize = 4;

if strcmp (multifile, 'stitch')
    for f = 1:length(resp_filename)    
        [spk_ms_f{f}, D{f}, stim_len(f), pre_stim, post_stim, stims, stim_file, analysis_type, ...
            last_rep_complete, last_rep_stims, stimulus_ch1_f{f}, reps]...
            =get_spikes_xpl(resp_filename{f}, resp_channel, stiminds, repinds);
        stim_ch1_ncols(f) = size(stimulus_ch1_f{f},2);
        stimulus_ch1_f{f}(:,1) = f;    % temporarily mark stim identity as file index
        spk_ms_f{f}(:,1) = f;
    end
    % TODO check all stimulus_ch1 are the same or throw error
    spk_ms = vertcat(spk_ms_f{:});
    min_ncols = min(vertcat(stim_ch1_ncols(:)));
    stimulus_ch1_f = cellfun(@(x) x(:,1:min_ncols),stimulus_ch1_f, 'uni', false);
    stimulus_ch1 = vertcat(stimulus_ch1_f{:});    % When bandwidth is set to 0, random seed columns are omitted
    params = num2cell(stimulus_ch1(:,2:end),1);
    varparams = find(cellfun(@(x) length(unique(x))>1,params))+1;    % Ind of varying parameter
    uni_params = sort(unique(stimulus_ch1(:,varparams),'rows'));
    nstim = size(uni_params,1);
    %stims = 1:nstim;
    for i = 1:size(stimulus_ch1,1)
        new_stim_ind = find(uni_params == stimulus_ch1(i,varparams));
        stimulus_ch1 (i,1) = new_stim_ind;    % remark stim index
        spk_ms(spk_ms(:,1)==i,1) = new_stim_ind;
    end
    stimulus_ch1 = unique(stimulus_ch1,'rows');
    stim_len = stimulus_ch1(:,cellfun(@(x)strcmp(x,'len(ms)'),D{1}.stimulus_tags_ch1));
    
elseif strcmp (multifile, 'avg')
elseif strcmp (multifile, 'single')
    [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, ...
        last_rep_complete, last_rep_stims, stimulus_ch1, reps]...
        =get_spikes_xpl(resp_filename{1}, resp_channel, stiminds, repinds);
    nstim = length(stims);
    params = num2cell(stimulus_ch1(:,2:end),1);
    varparams = find(cellfun(@(x) length(unique(x))>1,params))+1;    % Ind of varying parameter
    uni_params = unique(stimulus_ch1(:,varparams),'rows');
end
% Pad out stimulus file so you can look at firing rate after the end of the
% stimulus
%before_time = pre_stim/1000;
%after_time = post_stim/1000;     % seconds
%g = cat(1, zeros(before_time*stimSR, 1), g);
%g = cat(1, g, zeros(after_time*stimSR, 1));

%t = 1/respSR:1/respSR:(pre_stim+stim_len+post_stim)/1000;
if exist('plothandle','var')
    fig = plothandle;
else
    fig = figure;
end
%set(fig,'Position', [360   198   330   340]);
%grid off
hold on

for s = 1:nstim
    if mod(s,2)==1
        stim_color = handles.aqua;
    else
        stim_color = handles.aqua2;
    end
    r = rectangle('Position',[pre_stim,s-1,stim_len(stims(s)),1],...
        'FaceColor',stim_color,'EdgeColor','none');
end

for i = 1:size(spk_ms,1)
    stimid(i) = spk_ms(i,1);
    stimid_compress(i) = find(eval(stiminds)==stimid(i));     % Renumber stimuli from 1:nstims to plot without blanks
    [temp,repid(i)] = find(reps==spk_ms(i,2));
    tspk(i) = spk_ms(i,4);
end

yval = (stimid_compress-1)+repid*1/(length(reps)+1);
halfheight = 0.04;
xvals=[tspk;tspk;NaN(1,length(tspk))];   % NaN separator causes each pair to plot as a line
xvals = xvals(:);
yvals =[yval-halfheight; yval+halfheight; NaN(1,length(tspk))];
yvals = yvals (:);

switch symb_type
    case 'dot'
        ax = plot(tspk,yval,'.','MarkerSize',dotsize,'MarkerEdgeColor',[0.2,0.2,0.2]);
    case 'diamond'
        ax = plot(tspk,yval,'d','MarkerSize',markersize,'MarkerFaceColor',[0.1,0.1,0.1],'MarkerEdgeColor',[0.1,0.1,0.1]);
    case 'vertical tick'
        ax = plot(xvals,yvals,'k-','LineWidth',tickwidth);
        %ax = plot(xvals,yvals,'k-','LineWidth',0.5);
        %ax = plot(xvals,yvals,'k-','LineWidth',0.8);
end
        
%ax = plot(tspk,yval,'d','MarkerSize',markersize,'MarkerFaceColor',blue,'MarkerEdgeColor',blue);
%ax = plot(tspk,yval,'k.','MarkerSize',markersize);
X = repmat([0; pre_stim+max(stim_len)+post_stim],1,nstim-1);
Y = repmat(1:nstim-1,2,1);
%axlines = plot(X,Y,'-');
%set(axlines, 'Color',handles.gray2);

xlim([0 pre_stim+stim_len(1)+post_stim]);
%xlim([0 pre_stim+stim_len(1)+post_stim+300]);
ylim([-0.3 nstim]);

params = num2cell(stimulus_ch1(:,2:end),1);
varparams = find(cellfun(@(x) length(unique(x))>1,params))+1;

if showyticks
    yt = 0.5:1:nstim-0.5;
    if exist('customyticks','var') && ~isempty(customyticks)
        showy = eval(customyticks);
        set(gca,'YTick', yt(showy));
        set(gca,'YTickLabel',num2str(uni_params(showy,1)/(scaleby1000*1000+~scaleby1000*1),2));
    else
        showy = 1:size(uni_params,1);
        set(gca,'YTick',yt);
        set(gca,'YTickLabel',num2str(uni_params(:,1)/(scaleby1000*1000+~scaleby1000*1),2));
    end
else
    set(gca,'YTick',[]);
end

if ~displaymini
    yl = ylabel(ylabelstr,'FontSize',masterfont);
    % Tight position
    %set(yl,'Position',[0.95,1,1].*get(yl,'Position'));
    % Croppable far position
    set(yl,'Position',[1.3,1,1].*get(yl,'Position'));

    if ~strcmp(savepath, '')
        cellID = ['Unit' ' ' savepath(end-7:end-1)];
    else
        cellID = ['File' resp_filename{1}];
    end

    set(gca,'XTick',[0, pre_stim, pre_stim+max(stim_len)]);
    pos = get(gca,'Position');
    %pos(4) = pos(4)*0.95;
    %pos(1) = pos(1)*1.05;
    pos(3) = pos(3)*0.95;
    set(gca,'Position',pos);
    %set(gca,'XTickLabel',[cellID,num2str(pre_stim),num2str(pre_stim+max(stim_len))]);
    xlabel('ms','FontSize',masterfont,'Units','normalized','Position',[1.05,-0.015]);

    ti = title(titlestr,'FontSize',masterfont);
    %ti = title(titlestr,'FontSize',masterfont,'Units','normalized',...
    %     'horizontalAlignment', 'left','verticalAlignment','middle',...
    %     'Position',[-0.2,1.05]);
    ti_xy = get(ti,'Position');
    ti_xy = ti_xy.*[1 1.04 1];
    set(ti,'Position',ti_xy);
    %t1 = text(0.72,ti_xy(2), cellID,'Units','normalized','FontSize',masterfont,'Color',handles.gray3);
    %t1 = text(0.7,1.04, cellID,'Units','normalized','FontSize',masterfont-4);

    set(gcf, 'PaperUnits', 'inches');
    if papersize ~=0
        set(gcf, 'PaperPosition', papersize);  % else default size
    end
    set(gcf, 'renderer', 'openGL');
    set(gca, 'FontSize',masterfont-2);
else
    set(gca,'XTick',[]);
    title(titlestr,'FontSize',masterfont);
end


if strcmp(multifile,'stitch')
    r = vertcat(resp_filename{:});
    r(:,end+1) = '_';
    r2 = r(:,6:end)';
    r3 = r2(:)';
    resp_filename_full = strcat(r(1,1:5),r3,'stitch');   
elseif strcmp(multifile,'avg')
elseif strcmp(multifile,'single')
    resp_filename_full = resp_filename{1};
end

if strcmp(D(1).analysis_type,'mixed')    % likely LFM
    set(gca,'YTick',[]);
    pos = get(gca,'Position');
    pos(4) = pos(4)*0.95; pos(1) = pos(1)*1.3; pos(3)=pos(3)*0.9;
    set(gca,'Position',pos);
    %ylab = get(gca,'YTickLabel');
    %ylabnew = strcat(ylab, '\uparrow');
    %ylabnew = cellfun(@(x) [x ' \uparrow'], ylab, 'uni',false);
    %set(gca,'YTickLabel', ylabnew);
    %fmwidth = mat2cell(num2str(stimulus_ch1(:,8)),ones(size(stimulus_ch1,1),1));
    fmparam = mat2cell(num2str(uni_params(showy,1),'%0.1f'),ones(size(uni_params(showy,1),1),1));
    fmlab(find(stimulus_ch1(showy,10)==1))= cellfun(@(x) [x '\uparrow'], fmparam(find(stimulus_ch1(showy,10)==1)),'uni',false);
    fmlab(find(stimulus_ch1(showy,10)==-1))= cellfun(@(x) [x '\downarrow'], fmparam(find(stimulus_ch1(showy,10)==-1)),'uni',false);
    t = text(-7*ones(size(yt(showy))),yt(showy), fmlab, ...
               'horizontal','right','vertical','middle','FontSize',masterfont-4);      
    set(yl,'Position',[1.3 1 1].*get(yl,'Position'));
end

if ~strcmp(savepath, '')
    print([savepath resp_filename_full '_raster'],'-dpng','-painters');
end




