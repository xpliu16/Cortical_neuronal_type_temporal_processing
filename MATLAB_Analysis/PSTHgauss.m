function [psthsmooth,t,meanrate,meandrivenrate, min_latency] = PSTHgauss (spk_ms,stims,reps,ch,min_t,max_t,sig_ms)
% PSTHgauss.m Returns one Gaussian-smoothed peri-stimulus time histogram per stimulus
%   spk_ms       : matrix with timestamps of each spike taken from lab 
%                  standard format (matrix in cell array)
%                  columns are: 
%                       stimulus, repetition, MSD channel, time   
%   stims        : stimulus numbers to use (vector)
%   reps         : repetition numbers to use (vector)
%   ch           : channel of spike trigger to use (scalar) 
%   min_t        : minimum time (assumes this is beginning of stimulus)
%   max_t        : maximum_time (if using standard analysis window, not ideal for offset responses)
%   sig_ms       : sigma for Gaussian in ms (scalar)

min_t = min_t/1000;
max_t = max_t/1000;
spk_ms(:,4) = spk_ms(:,4)/1000;
sig = sig_ms/1000;
t_res = sig/10;
t_res2 = 0.001;   
stimstart = 0.2;   % time of start of stimulus
min_latency = nan(length(stims),1);

t2 = -3.5*sig:t_res:3.5*sig;
gauss = 1/(sig)/sqrt(2*pi)*exp(-1/2*(((t2)/(sig)).^2));

if length(min_t) ==1
    min_t = min_t*ones(max(stims),1);
end

if length(max_t) ==1
    max_t = max_t*ones(max(stims),1);
end

for si = 1:length(stims)
    t{si} = min_t(stims(si))-3.5*sig:t_res:max_t(stims(si))+3.5*sig;    % extending beyond time range prevents downward edge effect
    t_wprestim = [fliplr(min_t(stims(si))-3.5*sig:-t_res:0), t{si}(2:end)];
    t_wprestim2 = 0:t_res2:max_t(stims(si))+3.5*sig;
    spk_ms_sub = spk_ms(spk_ms(:,1)==stims(si),:);
    spk_ms_sub = spk_ms_sub(spk_ms_sub(:,3)==ch,:);
    N = histcounts(spk_ms_sub(:,4),t_wprestim)';
    rate = N/length(reps)/(t_res);
    psthsmooth_wprestim = conv(rate,gauss,'same')*t_res;    % times tres to maintain area, gaussian has area 1, but delta function has area 1*tres
    ind = find(t_wprestim == t{si}(1));
    ind2 = min(find(t_wprestim > stimstart));
    psthsmooth{si} = psthsmooth_wprestim(ind:end);
    spk_ms_sub2 = spk_ms_sub((spk_ms_sub(:,4)> min_t(stims(si))) & (spk_ms_sub(:,4)<= max_t(stims(si))),:);
    meanrate(si) = size(spk_ms_sub2,1)/((max_t(stims(si))-min_t(stims(si))))/length(reps);
    
    temp = histcounts(spk_ms_sub(:,4),t_wprestim2)';
    N2 = movsum(temp,5);
    ind4 = min(find(t_wprestim2>stimstart));
    N2_pre = N2(1:ind4-1);
    lambdahat = poissfit(N2_pre);
    events_per_bin = 0:1:max(N2);
    p = exp(-1*lambdahat).*lambdahat.^events_per_bin./factorial(events_per_bin);
    ind = min(find(p<0.05));
    thresh = events_per_bin(ind);
    ind_cross = min(find(N2(ind4:end)>=thresh));
    if ~isempty(ind_cross)
        min_latency(si) = (t_wprestim2(ind4+ind_cross-1)-stimstart)*1000;
    end
end

spont_rate = size(spk_ms((spk_ms(:,4)>0)&(spk_ms(:,4)<= min_t(1)),:),1)/min_t(1)/length(reps)/length(stims);
meandrivenrate = meanrate-spont_rate;

        
        