function [psthsmooth,t,meanrate,meandrivenrate, min_latency] = PSTHgauss (spk_ms,stims,reps,min_t,max_t, sig_ms)
% Returns one smoothed psth per stimulus

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
%{
baseline_rate = nan(length(stims)*length(reps),1);
i = 1;
spk_ms_sub1 = spk_ms((spk_ms(:,4)<min_t(1))&(spk_ms(:,4)>0),:);
for si = 1:length(stims)
    for r = 1:length(reps)
        spk_ms_sub2 = spk_ms_sub1((spk_ms_sub1(:,1)==stims(si))&(spk_ms_sub1(:,2)==reps(r)),:);
        baseline_count = size(spk_ms_sub2,1);
        baseline_rate(i) = baseline_count/(min_t(1));
        i = i+1;
    end
end

baseline_mean = mean(baseline_rate);
baseline_std = std(baseline_rate);
thresh = baseline_mean + 2*baseline_std;
%}

for si = 1:length(stims)
    t{si} = min_t(stims(si))-3.5*sig:t_res:max_t(stims(si))+3.5*sig;    % extending beyond time range prevents downward edge effect
    t_wprestim = [fliplr(min_t(stims(si))-3.5*sig:-t_res:0), t{si}(2:end)];
    t_wprestim2 = 0:t_res2:max_t(stims(si))+3.5*sig;
    spk_ms_sub = spk_ms(spk_ms(:,1)==stims(si),:);
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
    
    %baseline_mean = mean(N2(1:ind4-1));
    %baseline_std = std(N2(1:ind4-1));
    %thresh = baseline_mean+2*baseline_std;
    %temp = N2(ind4:end)>thresh;
    %temp2 = ismember(temp, [1 1 1]);
    %min_latency = t_wprestim2(min(find(temp2)));
    
    %baseline_mean = mean(psthsmooth_wprestim(1:ind-1));
    %baseline_std = std(psthsmooth_wprestim(1:ind-1));
    %thresh = baseline_mean+2*baseline_std;
    %ind3 = min(find(psthsmooth_wprestim(ind2:end)>thresh));
    %slope = diff(t_wprestim(ind2+ind3-2:ind2+ind3+2);
    %if ~isempty(ind3)
    %    min_latency(si) = t_wprestim(ind2+ind3-1)-stimstart;
    %else
    %    min_latency(si) = NaN;
    %end
end

% Assumes "min_t" is beginning of stimulus and prestim period is the same for all stims, does not examine poststimulus time
spont_rate = size(spk_ms((spk_ms(:,4)>0)&(spk_ms(:,4)<= min_t(1)),:),1)/min_t(1)/length(reps)/length(stims);
meandrivenrate = meanrate-spont_rate;

        
        