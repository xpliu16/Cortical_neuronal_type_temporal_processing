function  [spike_avg, spike_t_shifted, spike_t_shifted2, spike_count] = average_spike2(spk_ms, traces, t, SR_ms, stimindices, repindices, pre_stim, post_stim, stim_len, options)
% average_spike2.m Computes average spike waveform

% Inputs:
%   options     : a struct containing 
%       multispikes   : 1 to allow spikes with adjacent spikes, 0 for only isolated spikes
%       plotornot     : plot outputs for debugging and checking, turn off for batch
%
% Outputs:
%   spike_avg        : average spike waveform (vector)
%   spike_t_shifted  : spike_t_shifted  : time shifted traces of each qualifying spike, filtered 1 Hz to 10 kHz (matrix)
%   spike_t_shifted2 : shifted traces of each spike, filtered 100 Hz to 5 kHz (matrix)
%   spike_count      : number of qualifying spikes (scalar)

% Set window around the peak
file_n = size(traces,1);
align_win = options.align_win;
multispikes = options.multispikes;
ms_before_peak = options.ms_before_peak;     % for TTP
ms_before_peak_nospike = options.ms_before_peak_nospike;
ms_after_peak_nospike = options.ms_after_peak_nospike
if options.long == 1
    ms_before_peak = options.ms_before_peak_long;     
    ms_before_peak_nospike = options.ms_before_peak_nospike_long;
end    
    
spike_count = 0;

if ~exist('SR_ms','var') && exist('sp_wave','var')
    SR_ms = 24.4140;   % Forced to be this by earlier check
end
Spike_filter = [1 10000];
Spike_filter_narrow = [100 5000];
B_Spike = fir1(256,[Spike_filter./(SR_ms*1000/2)]);    % Should be linear phase
B_Spike2 = fir1(256,[Spike_filter_narrow./(SR_ms*1000/2)]);


for i = 1:length(stimindices)
    for f = 1:file_n
         for j = 1:length(repindices)
            spk_ms_sub = spk_ms{f}(spk_ms{f}(:,1)==stimindices(i) & spk_ms{f}(:,2) == repindices(j),:);
            
            tr = traces{f,i}(j, :);
            nonspike_mask = ones(1,length(tr));   % to calculate normal dV/dt excursion that did not spike

            % Check there isn't a preceding spike within 20 ms
            % (burst) for dV/dt. Preceding spikes can affect waveform,
            % postceding spikes get averaged in and distort AHP. Really
            % should do this across spike channels, but spk_ms is
            % already filtered by channel
            isi = diff([0 spk_ms_sub(:,4)' (pre_stim+stim_len(i)+post_stim)]);
            peakmag = 0;   % Need this value later for missed trigger rejection, even if no spikes are found
            mode = -50; % Default in case no spikes
            for k = 1:size(spk_ms_sub,1)            
                [val, ind] = min(abs(t{i} - spk_ms_sub(k,4))); 
                % Make sure there is enough trace before and after this
                % spike to put into average, otherwise, exclude
                nonspike_mask(max(1,round(ind-20*SR_ms)): min(round(ind+20*SR_ms), length(nonspike_mask))) = 0;    % mask 20 ms before and after spike, even if at beginning or end of sweep and hence too cropped for averaging into spike waveform
              
                if multispikes == 1
                    postnospike = 0;      % Post spikes permitted (for seeing bursts on bursting neurons)
                else
                    postnospike = ms_after_peak_nospike;   % no following spikes within x ms (better for calculating PTP)
                end
                
                if (isi(k)>ms_before_peak_nospike) && (isi(k+1)>postnospike) && (spk_ms_sub(k,4)>ms_before_peak) && (spk_ms_sub(k,4)< (t{i}(end)-ms_after_peak_nospike))    
                    spike_t = t{i}(ind-round(ms_before_peak*SR_ms): ind+round(ms_after_peak_nospike*SR_ms));
                    % Check that there aren't multiple spikes in this window
                    
                    tr_filt = filtfilt(B_Spike,1,tr);    % Zero phase
                    tr_filt2 = filtfilt(B_Spike2,1,tr);    % Narrower
                    spike_seg = tr_filt(ind-round(align_win*SR_ms): ind+round(align_win*SR_ms));
                    
                    % Align by max slope
                    [maxdifftemp,ind2] = max(diff(spike_seg));
                    [mindifftemp,ind3] = min(diff(spike_seg));

                    ind_shift_up = ceil(length(spike_seg)/2)-ind2;
                    ind_shift_down = ceil(length(spike_seg)/2)-ind3;
                    if ((ind-round(ms_before_peak*SR_ms)-ind_shift_up) <= 0) || ((ind-round(ms_before_peak*SR_ms)-ind_shift_down) <= 0) ...
                            || (ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_up)>length(tr_filt) || (ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_down>length(tr_filt)) 
                        continue
                    end
                    if multispikes == 0
                        % Check for missed triggers that are actually
                        % second spike within the window
                        [N,X] = hist(spike_seg, 30);
                        [Y,I] = max(N);
                        mode = X(I);
                        % Do this segment adaptively too
                        try
                            [peakinds, peakmagup] = peakfinder(spike_seg, (max(spike_seg)-min(spike_seg))/3, min(spike_seg), 1,0); 
                            [peakinds, peakmagdown] = peakfinder(spike_seg, (max(spike_seg)-min(spike_seg))/3, max(spike_seg), -1,0);
                        catch
                            continue   % weird morphology
                        end
                        if abs(max(peakmagup)-mode)>abs(min(peakmagdown)-mode)   % inverted "up" spike
                            if length(peakmagup)>1    % multiple spikes
                                continue
                            end
                        else % non-inverted "down" spike
                            if length(peakmagdown)>1    % multiple spikes
                                continue
                            end 
                        end
                    end
                    spike_count = spike_count + 1;

                    maxdiff(spike_count) = maxdifftemp;
                    mindiff(spike_count) = mindifftemp;

                    spike_t_shifted_up(spike_count,:) = tr_filt(ind-round(ms_before_peak*SR_ms)-ind_shift_up: ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_up);                        
                    spike_t_shifted_down(spike_count,:) = tr_filt(ind-round(ms_before_peak*SR_ms)-ind_shift_down: ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_down);                        
                    
                    spike_t_shifted_up2(spike_count,:) = tr_filt2(ind-round(ms_before_peak*SR_ms)-ind_shift_up: ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_up);                        
                    spike_t_shifted_down2(spike_count,:) = tr_filt2(ind-round(ms_before_peak*SR_ms)-ind_shift_down: ind+round(ms_after_peak_nospike*SR_ms)-ind_shift_down);                        
                end
            end    
        end
    end
end
    
if spike_count~=0   % spike count of qualifying spikes, not total spikes
    maxdiffinds = find((maxdiff<(mean(maxdiff)+2*std(maxdiff)))&(maxdiff>(mean(maxdiff)-2*std(maxdiff))));    % screen out outliers, e.g., spikes from other unit in same recording
    spike_t_shifted_up = spike_t_shifted_up(maxdiffinds,:);
    mindiffinds = find((mindiff<(mean(mindiff)+2*std(mindiff)))&(mindiff>(mean(mindiff)-2*std(mindiff)))); 
    spike_t_shifted_down = spike_t_shifted_down(mindiffinds,:);
    spike_avg_up = mean(spike_t_shifted_up, 1);
    spike_avg_down = mean(spike_t_shifted_down,1);
    % Pick the better alignment - on up or down slope
    if abs(mean(maxdiff(maxdiffinds))) > abs(mean(mindiff(mindiffinds)))     % whichever direction has sharper diff stroke or larger amplitude
        spike_avg = spike_avg_up;
        spike_t_shifted = spike_t_shifted_up;
        spike_t_shifted2 = spike_t_shifted_up2;
        spike_count = size(spike_t_shifted_up,1);
    else
        spike_avg = spike_avg_down;
        spike_t_shifted = spike_t_shifted_down;
        spike_t_shifted2 = spike_t_shifted_down2;
        spike_count = size(spike_t_shifted_down,1);
    end
else
    spike_avg = NaN;
    spike_t_shifted = [];
    spike_t_shifted2 = [];
end

