function [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, last_rep_complete, last_rep_stims, stimulus_ch1, reps, stimulus_ch2] = get_spikes_xpl (spike_filename, channel, stims, reps)

% Enter negative stim number to process all stims
% Last_rep_stims eliminates incomplete stim on last rep, any stims not run
% on last rep, also does not include stims not on the stims list

try
    D = eval (spike_filename);
catch
    spike_filename_m = strcat(spike_filename, '.m');
    D=header_reader_mfile(spike_filename_m);    % If file is incomplete so data matrix is irregular shaped, use this alternative reader, ignores final incomplete data line
end

spk_all_data = D.data;
stim_len = D.stimulus_ch1(:,5);
stimulus_ch1 = D.stimulus_ch1;
stimulus_ch2 = D.stimulus_ch2;
pre_stim = D.pre_stimulus_record_time;
post_stim = D.post_stimulus_record_time;
nstim = D.nstim;
stim_file = D.analysis_type (7:end);   % is this true for user call?
analysis_type = D.analysis_type;

last_rep_complete = strcmp(D.trial_complete,'true');

if max(reps)< max(spk_all_data(:,2))    % If there are 5 reps and last one is incomplete, but you're only running reps 1:4, then you're all good
    last_rep_complete = 1;
end
last_rep_complete     % display
if ~last_rep_complete      % throw away last rep-stim because incomplete
    last_rep_stim = spk_all_data(end,1);
    spk_all_data = spk_all_data(spk_all_data(:,1) ~= last_rep_stim | spk_all_data(:,2) ~= max(reps),:);
end

if strcmp(class(stims),'char')
    stims = eval(stims);
elseif    stims < 0      % Enter negative stim number to process all stims
    stims = 1:nstim;
end

if strcmp(class(reps),'char')
    reps = eval(reps);
elseif  reps < 0      % Enter negative stim number to process all stims
    reps = 1:max(spk_all_data(:,2));
end

%if strcmp(D.analysis_type, 'Noise_adapt') 
%    fg_list_index = max(find(D.stimulus_ch1(1,:) ~=0 & D.stimulus_ch1(1,:) ~= 1 & D.stimulus_ch1(1,:)~=-1))+1;
%    noise_adapt_fg_pattern = D.stimulus_ch1(:,fg_list_index:end);
%else noise_adapt_fg_pattern = [];
%end

if D.data_format < 5 %non-continuous, not time corrected
% Four columns:    stim , rep , MSD channel, sample (-1 is beginning of trial-channel, looks like 80 is end of block)
    
    %last_rep_spks = spk_all_data(spk_all_data(:,2)==max(reps),:);
    %last_rep_complete = (length(unique(last_rep_spks(:,1))) == nstim)
        
    spk_channel_only = spk_all_data(spk_all_data (:,3)==channel, :); 
    spk_stims_only = spk_channel_only(ismember(spk_channel_only(:,1),stims),:);
    spk_reps_only = spk_stims_only(ismember(spk_stims_only (:,2),reps),:);   
    last_rep_stims = unique(spk_reps_only(spk_reps_only(:,2)== max(reps), 1));     % Make sure that you do last_rep_stims on indicator containing format - if there are no spikes, but stim was run, it should register
    spk_noindicators = spk_reps_only(spk_reps_only (:,4)>0 & spk_reps_only (:,4)~=80, :);
    
    format long g
    spk_ms (:,4) = (100000/97656.25) *spk_noindicators(:,4)/1000;  % SR in hertz, output in ms
    spk_ms (:,1:3) = spk_noindicators(:,1:3);

else %continuous and already time-corrected. Need to reformat
        %timing information to be trial-based. Inactive channels are not
        %recorded, so don't filter by channel.
        %last_rep_spks = spk_all_data(spk_all_data(:,2)==max(reps),:);
        %last_rep_complete = (length(unique(last_rep_spks(:,1))) == nstim)
        spk_stims_only = spk_all_data(ismember(spk_all_data(:,1),stims),:);    
        spk_reps_only = spk_stims_only(ismember(spk_stims_only (:,2),reps),:);
        
        last_rep_stims = unique(spk_reps_only(spk_reps_only(:,2)== max(reps), 1));
        
        stimulus_deliveries_indices = find(spk_reps_only(:,3) == 7);       % Channel = 7 is the indicator for stim start time - not including prestim. Times outputed are re: beginning of trial (including prestim)
        stimulus_deliveries = spk_reps_only(spk_reps_only(:,3) == 7,:);
        for i = 1:size(stimulus_deliveries,1)
            spk_reps_only(spk_reps_only(:,1) == stimulus_deliveries(i,1) & spk_reps_only(:,2) == stimulus_deliveries(i,2),4)...
                = spk_reps_only(spk_reps_only(:,1) == stimulus_deliveries(i,1) & spk_reps_only(:,2) == stimulus_deliveries(i,2),4)...
                - (stimulus_deliveries(i,4) - D.pre_stimulus_record_time*1000);
        end
        spk_ms = spk_reps_only(spk_reps_only(:,3) ~=7,1:4);
        spk_ms = spk_ms(spk_ms (:,3)==channel, :);    % Filter by channel after conversion, otherwise you'll lose ch 7 stim initiation time markers 
        spk_ms (:,4) = spk_ms(:,4) / 1000;
        % not sure if we need this
        % spk_ms (:,4) = spk_ms(:,4)* 100000/97656.25;
end
