function [adaptratio, nss] = response_adapt(file,ch,stims,reps,ana_window,binsize,plotornot)
% Analyze response duration
% Adaptratio: metric of sustained versus transient response

win_after_onset = ana_window(1);      
win_after_offset = ana_window(2);     
binsize = binsize/1000; 

filedir = ['C:\Experiments\' file(1:end-4) '\Spikes'];
cd (filedir)
unitID = [file 'ch' num2str(ch)];

[spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type,...
    last_rep_complete, last_rep_stims, stimulus_ch1, reps, stimulus_ch2]...    
    = get_spikes_xpl (file,ch,stims,reps);

edges = 0:binsize: (pre_stim+max(stim_len)+post_stim)/1000;   % s  
centers=mean([edges(1:end-1);edges(2:end)]);
nstims = length(stims);
nreps = length(reps);

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
    % Make PSTH
    bincounts = histc(train_s_allreps,edges); 
    rates = bincounts/nreps/(binsize);   % rate in sec
    rates = rates(1:end-1);       % last bin is for exactly equal to last bin edge
    psth_cells{s}=[centers(:), rates(:)];
    if plotornot
        figure
        bar(centers, rates); 
        xlim([0 (pre_stim+stim_len(stims(s))+win_after_offset)/1000]);
    end
    baseline_temp = psth_cells{s}((psth_cells{s}(:,1)>0) & (psth_cells{s}(:,1)<pre_stim/1000),2);
    baseline_psth = [baseline_psth; baseline_temp];
end

baseline = mean(baseline_psth);    % same as calculated from count

% Find peak rate
for s = 1:nstims
    rates = psth_cells{s}(:,2);
    % 700 ms with 5 ms bins
    inds = find((centers>(pre_stim+win_after_onset)/1000) & (centers<(pre_stim+stim_len(s)+win_after_offset)/1000));  
    
    stimrate(s) = mean(rates(inds));
    if stimrate(s) < 3/nreps/((stim_len(s)-win_after_onset+win_after_offset)/1000)   
        adaptratio(s) = NaN;
        NSS = NaN;
    else
        indsearly = find((centers>(pre_stim+win_after_onset)/1000) & (centers<(pre_stim+win_after_onset)/1000+0.1));   % First 100 ms
        indslate = find((centers>(pre_stim+win_after_onset+stim_len(stims(s)))/1000-0.1) & (centers<(pre_stim+win_after_onset+stim_len(stims(s)))/1000));

        ssrateearly(s) = mean(rates(indsearly));   % First 100 ms
        ssratelate(s) = mean(rates(indslate));   % Last 100 ms
        
        if (ssrateearly(s)+ssratelate(s))~=0 
            adaptratio(s) =(ssrateearly(s)-ssratelate(s))/(ssrateearly(s)+ssratelate(s));
        else 
            adaptratio(s) = NaN;   % both are zero, not well driven
        end
        if baseline ~= 0 
            nss(s) = ssratelate(s)/baseline;   
        else
            nss(s) = NaN;
        end
    end
end

if plotornot
    figure
    plot(stims, adaptratio, 'o-');
end

