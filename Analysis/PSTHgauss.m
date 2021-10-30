function [psthsmooth,t,meanrate,meandrivenrate] = PSTHgauss (spk_ms,stims,reps,min_t,max_t, sig_ms)
% Returns one smoothed psth per stimulus

min_t = min_t/1000;
max_t = max_t/1000;
spk_ms(:,4) = spk_ms(:,4)/1000;
sig = sig_ms/1000;
t_res = sig/10;

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
    spk_ms_sub = spk_ms(spk_ms(:,1)==stims(si),:);
    N = histcounts(spk_ms_sub(:,4),t{si})';
    rate = N/length(reps)/(t_res);
    psthsmooth{si} = conv(rate,gauss,'same')*t_res;    % times tres to maintain area, gaussian has area 1, but delta function has area 1*tres
    spk_ms_sub = spk_ms_sub((spk_ms_sub(:,4)> min_t(stims(si))) & (spk_ms_sub(:,4)<= max_t(stims(si))),:);
    meanrate(si) = size(spk_ms_sub,1)/((max_t(stims(si))-min_t(stims(si))))/length(reps);
end

% Assumes "min_t" is beginning of stimulus and prestim period is the same for all stims, does not examine poststimulus time
spont_rate = size(spk_ms((spk_ms(:,4)>0)&(spk_ms(:,4)<= min_t(1)),:),1)/min_t(1)/length(reps)/length(stims);
meandrivenrate = meanrate-spont_rate;

        
        