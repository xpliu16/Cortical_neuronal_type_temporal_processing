function [CI_max, CI_avg, CI_log, baseline_rate_mean, responsive_stims, rateresp_len, PSTHresp_len, outlier_rejected, response_rate_mean, top_20_frac] = mSAC(inputs)
% Shuffled autocorrelogram calculation based on Joris et al., 2003, 2006
% Checked with Joris 2006 code outputs

file = inputs.file;
ch = inputs.ch;
stims = inputs.stims;
reps = inputs.reps;
ana_window = inputs.ana_window;
binsize = inputs.binsize;
response_type = inputs.response_type;
plotornot = inputs.plotornot;
try
    axh1 = inputs.ax(1);
    axh2 = inputs.ax(2);
catch
end

filedir = ['C:\Experiments\' file(1:end-4) '\Spikes'];

cd (filedir)
unitID = [file 'ch' num2str(ch)];

[spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type,...
    last_rep_complete, last_rep_stims, stimulus_ch1, reps, stimulus_ch2]...    
    = get_spikes_xpl (file,ch,stims,reps);

nstims = length(stims);
nreps = length(reps);
w = logspace(-2,1,31);   
w = w(2:end);
w = w/1000;
binsize = binsize/1000;     % for PSTH determining whether responsive
outlier_rejected = 0;

win_after_onset = ana_window(1);     
win_after_offset = ana_window(2);     
blue = [50,109,214]/256;

edges = 0:binsize: (pre_stim+max(stim_len)+post_stim)/1000;   % s  
centers=mean([edges(1:end-1);edges(2:end)]);

% Pool baseline prestim psth values across all stims
baseline_psth = [];

for s = 1:nstims 
    train_s_allreps = [];
    train_s = spk_ms(spk_ms(:,1)==stims(s),:);       
    for r = 1:nreps
        train_s_r = train_s(train_s(:,2)==reps(r),4)/1000;   % Change to sec
        train_s_allreps = [train_s_allreps; train_s_r];   
        
        train_base = train_s_r((train_s_r>0) & (train_s_r<(0+(pre_stim)/1000)));
        baseline_count(s,r) = length(train_base);

        train_resp = train_s_r(train_s_r>((pre_stim+win_after_onset)/1000));
        train_resp = train_resp(train_resp<(pre_stim+stim_len(stims(s))+win_after_offset)/1000);
        all_resp_trains{s}{r} = train_resp;
        all_resp_trains_t{s}{r} = train_resp';
        response_count(s,r) = length(train_resp);        
        
    end
    
    if plotornot
        LineFormat = struct();
        LineFormat.Color = blue;
        LineFormat.LineWidth = 0.8;
        LineFormat.LineStyle = '-';
    end

    % PSTH
    bincounts = histc(train_s_allreps,edges); 
    rates = bincounts/nreps/(binsize);   % rate in sec
    rates = rates(1:end-1);       % last bin is for exactly equal to last bin edge
    psth_cells{s}=[centers(:), rates(:)];
    if plotornot
        figure;
        bar(centers, rates); 
        xlim([0 (pre_stim+stim_len(stims(s))+win_after_offset)/1000]);
    end
    baseline_temp = psth_cells{s}((psth_cells{s}(:,1)>0) & (psth_cells{s}(:,1)<pre_stim/1000),2);
    baseline_psth = [baseline_psth; baseline_temp];
end

baseline_rate_all = baseline_count/(pre_stim/1000);

baseline_rate_means = mean(baseline_rate_all,2);   % Should be as long as nstims
baseline_rate_mean = mean(baseline_rate_means);
baseline_rate_var = var(baseline_rate_means);

baseline_rate_mean2 = mean(baseline_rate_all(:));
baseline_rate_std2 = std(baseline_rate_all(:));    

PSTHresp = zeros(nstims,1);
rateresp = zeros(nstims,1);
responsive = zeros(nstims,1);

events_per_bin = baseline_psth*binsize*length(reps); 
edges1 = -0.5:1:max(events_per_bin)+0.5;
centers1 = movmean(edges1,2);
centers1 = centers1(2:end);
[N] = histcounts(events_per_bin,edges1);
Nnorm = N / length(events_per_bin);
lambdahat = poissfit(events_per_bin);

response_PSTH_all = [];
for s = 1:nstims   
    % Decide whether the unit is responsive to this stimulus
    response = psth_cells{s} ((psth_cells{s}(:,1)>((pre_stim+win_after_onset)/1000))...
        &(psth_cells{s}(:,1)<(pre_stim+stim_len(stims(s))+win_after_offset)/1000),2);
    response_PSTH_all = [response_PSTH_all;response];
    if plotornot
        figure;
        bar(centers1,Nnorm);      
        hold on
        x = 0:1:max(edges1);
        y = exp(-1*lambdahat)*lambdahat.^x./factorial(round(x));
        plot(x,y,'-r');
    end
   
    response_events_per_bin = response*binsize*length(reps);
    p = exp(-1*lambdahat)*lambdahat.^max(round(response_events_per_bin))./factorial(max(round(response_events_per_bin)));
    PSTHresp(s) = (p < (0.01/length(response)));
    response_rate = response_count(s,:)/((stim_len(stims(s))+win_after_offset-win_after_onset)/1000);
    response_rate_mean(s) = mean(response_rate);
    enough_spikes(s) = length(find(response_count(s,:)>=2))>= 0.5*nreps;    % must have at least two spikes on half the trials
    
    scaled_baseline_rate_std = baseline_rate_std2*sqrt(pre_stim/1000)/sqrt(stim_len(stims(s))/1000);
    rate_thresh_inc = baseline_rate_mean2+3*(scaled_baseline_rate_std/sqrt(nreps));
    
    rate_thresh_dec = baseline_rate_mean2-3*(scaled_baseline_rate_std/sqrt(nreps));
    if strcmp(response_type, 'excited')
        rateresp(s) = response_rate_mean(s)> rate_thresh_inc;
    elseif strcmp (response_type, 'inhibited')
        rateresp(s) = response_rate_mean(s) < rate_thresh_dec;
    elseif strcmp(response_type, 'modulated')
        rateresp(s) = response_rate_mean(s) > rate_thresh_inc || ...
            response_rate_mean(s) < rate_thresh_dec;
    end
    
    rateresp_len = length(find(rateresp));
    PSTHresp_len = length(find(PSTHresp));
    
    responsive(s) = PSTHresp(s)||rateresp(s) && enough_spikes(s);
    
    CI_log(s,1) = stims(s);
    CI_log(s,2) = rateresp(s);
    CI_log(s,3) = PSTHresp(s);
    CI_log(s,4) = responsive(s);
    CI_log(s,5) = NaN;
    
    if responsive(s)
        [f_ints_all{s},N,t,N2,t2,CI{s},CI_final] = sac(all_resp_trains{s},w,(stim_len(stims(s))+win_after_offset-win_after_onset)/1000);
    
        CI_log(s,5) = CI_final;
        
        if plotornot
            if exist('axh1')
                axes(axh1);
            else
                figure
            end
            bar(t*1000,N,'FaceColor',[0.5 0.5 0.5],'BarWidth',1);
            xlim([0 80]);
            set(gca,'xTick',0:10:80);
            xlabel('Interval (ms)','FontSize', 24, 'FontName','Calibri');
            ylabel('Count', 'FontSize', 24, 'FontName','Calibri');
            set(gca,'FontSize', 24,'FontName','Calibri');
    
            figure
            plot(t2*1000,N2,'-');
            xlabel('Interspike interval (ms)');

            if exist('axh2')
                axes(axh2);
            else
                figure;
            end
            plot(w*1000,CI{s},'o','MarkerFaceColor',[0.7 0.7 0.7],'MarkerEdgeColor', [0.2 0.2 0.2]);
            set(gca,'XScale','log');
            xlim([10^-2, 10]);
            xticks([0.01, 0.1, 1, 10]);
            xlabel('Coincidence window (ms)','FontSize', 24, 'FontName','Calibri');
            ylabel('CI','FontSize', 24, 'FontName','Calibri');
            set(gca,'FontSize', 24,'FontName','Calibri');
        end
    end
end

top_20_frac = 1-prctile(response_PSTH_all,5)/length(response_PSTH_all);

responsive_stims = stims(find(responsive));

CI_avg = mean(CI_log(find(CI_log(:,4)),5));

% Outlier check
CInonzero = CI_log(find(CI_log(:,5)),5);
CImed = median(CInonzero,'omitnan');
CImad = median(abs(CInonzero-CImed),'omitnan');

[CI_max,ind] = max(CI_log(:,5));

while CI_max > CImed+20*CImad     % max is an outlier for this unit
    CI_log(ind,5)=NaN;
    [CI_max,ind] = max(CI_log(:,5));
    outlier_rejected = 1;
end

if CI_max == 0 
    CI_max = 'CI0';
end
if CI_avg == 0
    CI_avg = 'CI0';
end

end



function [f_ints_all,N,t,N2,t2,CI,CI_final] = sac (train_s, w, window_len)
% w - coincidence window (sec)
% trains - spike trains (sec), array{reps}

sp_count = 0;
f_ints_all = [];
nreps = length(train_s);

for j = 1:nreps
        sp_count = sp_count + length(train_s{j});
        for k = 1:nreps   
            if j==k
                continue
            end

            for i = 1:length(train_s{j})
                tspki = train_s{j}(i);
                intervals = (train_s{k}-tspki);
                f_ints = intervals(find(intervals>=0));
                f_ints_all = [f_ints_all f_ints'];
            end
        end
    end
    
    t = 0.00005:0.0001:max(f_ints_all);
    N = hist(f_ints_all,t);
    
    t2 = [-1*fliplr(t),t];
    N2 = [fliplr(N),N];
        
    for wi = 1:length(w)
        Nc = length(find(f_ints_all<w(wi)));
        M = nreps;
        D = window_len;
        r = sp_count/D/M;
        CI(wi) = Nc/(M*(M-1)*(r^2)*w(wi)*D);
    end

    [Y,I] = min(abs(w-0.0005));    % Get CI_final averaged 5 points around 0.5 ms
     
    try
        CI_final = mean(CI(I-2:I+2));
    catch
        CI_final = CI(1);
    end
end
