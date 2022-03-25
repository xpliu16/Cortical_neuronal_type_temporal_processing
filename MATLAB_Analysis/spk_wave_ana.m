function [output] = spk_wave_ana (filename, stims, reps, ch, options, sp_input)

% spk_wave_ana.m Runs spike waveform analysis
% Inputs:
%   filename     : filenames of .ad2 files (cell array)
%   stims        : stimulus numbers to use (vector)
%   reps         : repetition numbers to use (vector)
%   ch           : channel of spike trigger to use (scalar) 
%   options      : (struct) 
%       multispikes        : 1 to allow spikes with adjacent spikes, 0 for only isolated spikes
%       plotornot          : plot outputs for debugging and checking, turn off for batch
%   sp_input     : previously processed avg spike waveform (struct)
%       sp_wave            : avg spike waveform
%       sp_wave_count      : number of spikes averaged in 'sp_wave'
%       sp_wave_long       : avg spike waveform long segment
%       sp_wave_count_long : number of spikes averaged in 'sp_wave_long'

options.align_win = 2.5;  % Look within ms of registered spike time for max rate AP alignment
options.ms_before_peak = 5;  % Segment surrounding each spike to crop
options.ms_before_peak_nospike = 5;  % If multispikes ==0, enforce no other spikes
options.ms_after_peak_nospike = 6;  % Segment to crop and no other spikes
options.ms_before_peak_long = 12.1;  % Longer baseline segment (for FFT subtraction)
options.ms_before_peak_nospike_long = 10; % Longer segment no other spikes
options.search_win = 2.5;  % Search window for AP peaks (for AP parameter extraction)

if exist('sp_input','var')
    spike_avg = sp_input.sp_wave;
    spike_avg_long = sp_input.sp_wave_long;
    spike_count = sp_input.sp_wave_count;
    spike_count_long = sp_input.sp_wave_count_long;
    spike_t_shifted = [];
    % spike_t_shifted has all individual spikes aligned, 
    % only needed for plotting individual spikes
else
    [traces, t, SR_ms, spk_ms, pre_stim, post_stim, stim_len, spont_rate] = get_traces (filename, stims, reps, ch); 
    
    options.long = 0;
    [spike_avg, spike_t_shifted, spike_t_shifted2, spike_count] ...
        = average_spike2(spk_ms, traces, t, SR_ms, stims, reps, pre_stim, ...
        post_stim, stim_len, options);
        
    options.long = 1;
    [spike_avg_long, spike_t_shifted_long, spike_t_shifted_long2, spike_count_long] ...
        = average_spike2(spk_ms, traces, t, SR_ms, stims, reps, pre_stim, ...
        post_stim, stim_len, options);    
        % Want longer for FFT
    
    if SR_ms ~= 24.414
        pause
        error(['Sampling rate not 24414 Hz (', filename{:}, ')']);
    end
end
    
[output] = spk_wave_params (spike_avg, spike_t_shifted, spike_t_shifted2, spike_count, spike_avg_long, SR_ms, options) 

 output.sp_wave = spike_avg;
 output.sp_wave_long = spike_avg_long;
 output.sp_wave_count = spike_count;
 output.sp_wave_count_long = spike_count_long;
 
 output.spont_rate = spont_rate;
