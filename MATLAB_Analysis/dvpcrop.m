function [dist_stims] = dvpcrop(x_spikes, target, trains_stims, resplen, pre_resp, cost)
% 1) Crop response to a section as long as shortest stimulus, centered on peak response
% 2) Then calculate Victor and Purpura spike distance
% 3) Assign to the class with the closest distances
%
% Inputs: 
%   x_spikes        : spike times, each row is one spike train (matrix)
%   target          : labels of the actual stimulus # for each
%                     corresponding spike train (vector)
%   trains_stims    : spike trains pooled across reps, during stimulus
%                     duration only - used for centering on max response
%   resplen         : length of each spike train within response window in ms
%   pre_resp        : time from beginning of recording to beginning of
%                     response window
%   cost            : q parameter for VP spike distance

stims = unique(target);
nstims = length(unique(target));
nreps = length(target)/nstims;

pre_resp = pre_resp/1000;
resplen = resplen/1000;

min_len_all_stims = min(resplen);

nospikes = zeros(1,length(x_spikes));

% Crop to segment centered on histogram peak
win_min = NaN(1,nstims);
win_max = NaN(1,nstims);

for j = 1:nstims
    trains_stims_s{j} = trains_stims{j}/1000;
    if isempty(trains_stims{j})    % no reps have any spikes, will be discarded anyway
        center = pre_resp + 0.5*resplen(j*nreps);
    else
        [f,xi] = ksdensity(trains_stims_s{j});
        [val, ind] = max(f);
        center = xi(ind);
        if center < pre_resp + 0.5*min_len_all_stims
            center = pre_resp + 0.5*min_len_all_stims;
        elseif center > pre_resp+resplen(j*nreps)-0.5*min_len_all_stims
            center = pre_resp+resplen(j*nreps)-0.5*min_len_all_stims;
        end
    end
    win_min(j) = center-0.5*min_len_all_stims;
    win_max(j) = center+0.5*min_len_all_stims;
end

for i = 1:length(x_spikes)   
    x_spikes_s{i} = x_spikes{i}/1000;
    stimind = find(stims==target(i));
    x_spikes_s{i} = x_spikes_s{i}-win_min(stimind);
    x_spikes_s{i} = x_spikes_s{i}((x_spikes_s{i}>0) & (x_spikes_s{i} <min_len_all_stims));
    if isempty(x_spikes_s{i})
        nospikes(i) = 1;
    end
end

dist=NaN(length(x_spikes_s),length(x_spikes_s));

for i = 1:length(x_spikes_s)
    for j = 1:length(x_spikes_s)         
         if i ~= j
              dist(i,j) = spkdvp(x_spikes_s{i},x_spikes_s{j},cost);   % Symmetric, so don't need to recalculate but simpler to do so
         end
    end
end

dist_stims=NaN(length(x_spikes_s),nstims);

for st_ind = 1:nstims   
    % Power law per Victor and Purpura - improves classification and reduces vertical bands in confusion matrices
    dist_stims(:,st_ind) = (nanmean(dist(:,find(target==stims(st_ind))).^-3,2)).^(-1/3);    
end

end
