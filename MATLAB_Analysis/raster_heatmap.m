function [r,f,centers,bf] = raster_heatmap (spk_ms, D, stim_len, pre_stim, post_stim, channel, stims, reps, t_binsize, t_alignment, level, bf_recenter, ana_window, normalize, plotornot)
% raster_heatmap.m Calculate and plot heatmap of smoothed average response, 

% Inputs:
%   spk_ms       : timestamps of each spike taken from lab 
%                  standard format (matrix in cell array)
%                  columns are: 
%                       stimulus, repetition, MSD channel, time
%   D            : spike times all data and header (struct)
%   stim_len     : stimulus duration in ms (scalar)
%   pre_stim     : pre-stimulus time in ms (scalar)
%   post_stim    : post-stimulus time in ms (scalar)
%   channel      : channel of spike trigger to use (scalar) 
%   stims        : stimulus numbers to use (vector)
%   reps         : repetition numbers to use (vector)
%   t_binsize    : time bin for histogram in ms (scalar)
%   t_alignment  : align responses to stimulus 'onset' or 'offset'
%   level        : use only stimuli with this sound level (scalar)
%   bf_recenter  : recenter to best frequency (logical)
%   ana_window   : analysis window [ms after start of stimulus, ms after end] 
%   normalize    : scale peak rate at BF to 1 (logical)
%   plotornot    : make figures or suppress for batch (logical)


% For BF recentered, f returned are ratios to BF, with f = 1 being BF

% If FRA, extract particular sound level response from it
attn_col = find(strcmp(D.stimulus_tags_ch1, 'attn(dB)'));
stims = intersect(stims, D.stimulus_ch1((D.stimulus_ch1(:,attn_col)==level),1));
if size(stims, 1) ==0
    error(sprintf('No reps with %d dB attn in file %s', level, eval(['D.ch' num2str(channel) '_unit_id'])));
end

nstims = length(stims);
nreps = length(reps);
t_binsize_s = t_binsize/1000;
f = D.stimulus_ch1(stims, strcmp(D.stimulus_tags_ch1, ' tone Hz'));

% Binned counts
if strcmp(t_alignment, 'onset')
    offset = -1*pre_stim;
    offset = repmat(offset, nstims,1);
elseif strcmp(t_alignment, 'offset')
    offset = -1*(pre_stim+stim_len(stims));
end
spk_ms(:,4) = (spk_ms(:,4)+offset(spk_ms(:,1)))/1000;

lastbin = max(pre_stim+stim_len(spk_ms(:,1))+post_stim+offset(spk_ms(:,1)))/1000;

edges = 0+min(offset)/1000 : t_binsize_s: lastbin;	
centers = mean([edges(1:end-1); edges(2:end)],1);

for i = 1:nstims
   spk_ms_stim = spk_ms(find(spk_ms(:,1)==stims(i)), 4);
   r(i,:) = (histcounts(spk_ms_stim,edges)) / (nreps*t_binsize_s);
   resp(i) = length(find((spk_ms_stim > (pre_stim+offset(i)+10)/1000)& (spk_ms_stim < (pre_stim+150+offset(i))/1000)))/(nreps*(stim_len(stims(i))+ana_window(2)-ana_window(1))/1000);
end

if bf_recenter
    [max_rate,ind] = max(resp); 
    bf = f(ind);
    f = f/bf;    % dividing normalization makes it possible to pool across different BFs 
end

if plotornot
    figure
    h1 = heatmap(centers, flipud(f(:)), flipud(r));
    h1.GridVisible = 'off';
    % 0 is an edge not a center, but heatmap aligns labels with centers,
    % for fine temporal bins, the slight offset of the label is okay
    labels = repmat({''},length(centers),1);
    [Y,I] = min(abs(centers-0));
    labels{I} = '0';
    h1.XDisplayLabels = labels;
end

if normalize
    r = r./max(max(max(r)));
end
