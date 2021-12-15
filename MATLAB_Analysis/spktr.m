function [outputs, centers, N, centers2,N2,log_ISI_list,prestim_total_time,...
    nint] = spktr(D,file,ch,stims,reps,binsize_ms,min_intervals,ana_period,calc_params,plotornot,ac_shift)
% spktr.m Spike train autocorrelation and other spike timing analyses
% 
% Inputs:
%   D              : data and info from evaluating data file name (struct)
%   file           : filename (string)
%   ch             : MSD spike trigger channel (scalar)
%   stims          : stimulus numbers to use (vector)
%   reps           : repetition numbers to use (vector)
%   binsize_ms     : bin size for ISI analysis  (scalar)
%   min_intervals  : minimum number of ISI's to qualify for analysis (scalar)
%   ana_period     : what portion to analyze: 'all', 'pre','stim', or 'post'
%   calc_params    : do not calculate if pooling first (logical)
%   plotornot      : make plots or not (for batch processing) (logical)
%   ac_shift       : shift autocorrelogram bins for better visualization 


% Centers2 and N2 are x and y for log(ISI) histogram

ISI_list = [];
autocorr_list = []; % Only calculating within range_ms window saves time for files with lots of spikes
range_ms = 200;

data = D.data;

if (isempty(diff(reps))) || isequal(unique(diff(reps)),1)    
    % consecutive, vast majority of cases    
    notconsec = 0;
    reps_all{1} = reps;
elseif isequal(unique(diff(reps)),[1,2]) && (length(find(diff(reps)==2))==1)  
    % a single missing rep in the middle, often due to artifact, acceptable for discontinuity
    missing = reps(find(diff(reps)==2))+1;
    reps_all{1} = [min(reps):missing-1];
    reps_all{2} = [missing+1:max(reps)];
    notconsec = 0;
else
    notconsec = 1;
end

if D.data_format == 5      % Data format 4 doesn't use 7 as rep marker and doesn't have continuous time
    data_rep_mark = data(data(:,3)==7,:);    
    % assumes consecutive, if not consecutive, nonconsec will NaN out the run
end

[spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, ...
                last_rep_complete, last_rep_stims, stimulus_ch1_f, reps]...
                =get_spikes_xpl(file, ch, stims, reps);
prestim_total_time = 0;
for i = 1:length(reps_all)
    minrep(i) = min(reps_all{i});
    minrept(i) = data_rep_mark(min(find(data_rep_mark(:,2)==minrep(i))),4);
    maxrep(i) = max(reps_all{i});
    prestim_total_time = prestim_total_time + (maxrep(i)-minrep(i)+1)*pre_stim*length(stims);     
    if maxrep(i) == max(data_rep_mark(:,2))
        maxrept(i) = data(end,4)+1;   % Plus one because of inequality
    else
        try
        maxrept(i) = data_rep_mark(min(find(data_rep_mark(:,2)==maxrep(i)+1)),4);
        catch
            error('Last rep has no complete sweeps');   
            % Did not even get to a single stim start marker on the last run, should run with 1 less rep
        end
    end
end
            
switch ana_period
    case 'all'        
        % Check for off screen artifacts
        meanrateonscreen = length(find((spk_ms(:,4)>0) & (spk_ms(:,4)<pre_stim+post_stim+max(stim_len))))/length(reps)/(pre_stim+post_stim+max(stim_len))*1000/length(stims);
        meanratenegativetimes = length(find((spk_ms(:,4)<0)))/length(reps)/(pre_stim+post_stim+max(stim_len))*1000/length(stims);
        if meanratenegativetimes>3.5*meanrateonscreen
            % Flag for inspection, likely artifacts
            disp(['Check for possible trigger artifacts in ' file 'ch' num2str(ch)]);
            pause
        end
        data_sub = data(data(:,3)==ch,:);
        spk_ms_cont = data_sub(:,4);
        temp = [];
        for i = 1:length(minrept)
            temp = [temp; spk_ms_cont((spk_ms_cont>=minrept(i)) & spk_ms_cont<maxrept(i))];
        end
        spk_ms_cont = (100000/97656.25) *temp/1000;
        spk_count = length(spk_ms_cont);  
        tot_time = max(spk_ms_cont);
        rolledover = ~issorted(spk_ms_cont);
        if rolledover
            error('Buffer rolled over')
        end

        % ISI Histogram
        for i = 1:length(spk_ms_cont)
            indstop = i-1+find(spk_ms_cont(i:end)>(spk_ms_cont(i)+range_ms),1);
            if i < length(spk_ms_cont)
                ISI_list = [ISI_list, spk_ms_cont(i+1)-spk_ms_cont(i)];
                if isempty(indstop)
                    autocorr_list = [autocorr_list, spk_ms_cont(i:end)'-spk_ms_cont(i)];
                else
                    autocorr_list = [autocorr_list, spk_ms_cont(i+1:indstop)'-spk_ms_cont(i)];    
                    % Excludes spike to itself or 0 bin of autocorr
                end
            end   
        end
       
    case {'pre','stim','post'}
        n = 0;
        tot_time = 0;
        switch ana_period
            case 'pre'
                lower = zeros(max(stims),1);
                upper = pre_stim*ones(max(stims),1);
            case 'stim'
                lower = pre_stim*ones(max(stims),1);
                upper = pre_stim + stim_len;
            case 'post'
                lower = pre_stim + stim_len + 100;
                upper = pre_stim + stim_len + post_stim;
        end
        spk_count = 0;
            for r = reps
                for s = stims
                    spk_ms_sub = spk_ms(spk_ms(:,1)==s & spk_ms(:,2) == r,4);
                    spk_ms_sub = spk_ms_sub((spk_ms_sub>lower(s)) & (spk_ms_sub<upper(s)));
                    spk_count = spk_count + length(spk_ms_sub);
                    ISI_list = [ISI_list, spk_ms_sub(2:end)'-spk_ms_sub(1:end-1)'];
                    alldiffs = spk_ms_sub-spk_ms_sub';   
                    autocorr_list = [autocorr_list, alldiffs(:)'];
                    tot_time = tot_time + (upper(s)-lower(s));
                end
            end
            autocorr_list = autocorr_list(autocorr_list>=0);
            min_intervals = 0;     % Since we will pool across files, check this later
end
nint = length(ISI_list);

if (nint < min_intervals) || (notconsec == 1)
    outputs.yautocorr = NaN;
    outputs.xautocorr = NaN;
    outputs.acmetric = NaN;
    outputs.peakmsISI = NaN;
    outputs.intraburstfreq = NaN;
    outputs.p2mISI = NaN;
    outputs.fracmeanISI = NaN;
    outputs.refract = NaN;
    outputs.CV = NaN;
    outputs.reg_parikh = NaN;
    outputs.ISImetric = NaN;
    outputs.mean_burst_length = NaN;
    outputs.max_burst_length = NaN;
    outputs.percburst = NaN;
    outputs.percISI5 = NaN;
    outputs.dip_p_value = NaN;
    outputs.dip = NaN;
    outputs.percISI5ratio = NaN;
    outputs.logISIdrop = NaN;
    outputs.centers2 = NaN;
    outputs.N2 = NaN;
    outputs.logISIskewness = NaN;
    return
end
    
edges = 0:binsize_ms:range_ms;
[N,edges] = histcounts(ISI_list,edges);
centers = mean([edges(1:end-1);edges(2:end)]);

log_ISI_list = log(ISI_list);
edges2 = 0:0.1:10;   
[N2,edges2] = histcounts(log_ISI_list,edges2);
centers2 = mean([edges2(1:end-1);edges2(2:end)]);

if calc_params == 0  
    % Don't calculate these before pooling across files, 
    % since each ana_period likely has inadequate intervals
    outputs.yautocorr = NaN;
    outputs.xautocorr = NaN;
    outputs.acmetric = NaN;
    outputs.peakmsISI = NaN;
    outputs.intraburstfreq = NaN;
    outputs.p2mISI = NaN;
    outputs.fracmeanISI = NaN;
    outputs.refract = NaN;
    outputs.CV = NaN;
    outputs.reg_parikh = NaN;
    outputs.ISImetric = NaN;
    outputs.mean_burst_length = NaN;
    outputs.max_burst_length = NaN;
    outputs.percburst = NaN;
    outputs.percISI5 = NaN;
    outputs.dip_p_value = NaN;
    outputs.dip = NaN;
    outputs.percISI5ratio = NaN;
    outputs.logISIdrop = NaN;
    outputs.logISIskewness = NaN;
    return
end

if plotornot
    figure
    bar(centers, N);
    xlim([0 100]);
    xlabel('ISI (ms)');
    figure
    bar(centers,N);
    xlabel('ISI (ms)');
    
    figure
    bar(centers2, N2);
    xlim([0 log(4)]);
    xlabel('Log ISI (ms)');
    figure
    bar(centers2,N2);
    xlabel('Log ISI (ms)');
end

yy = smooth(centers2,N2,5,'sgolay',3);

[yypeak,indpeak] = max(yy(find((centers2<log(5)) & (centers2>log(1)))));
ind10 = min(find(centers2>log(10)));
ind16 = max(find(centers2<log(16)));

yy10to16 = mean(yy(ind10:ind16));
logISIdrop = (yypeak-yy10to16)/(yypeak+yy10to16);   

maxN = max(N(edges<80));
maxN2 = max(N2(edges2<log(80)));
inds = find(N2(edges2<log(80))==maxN2);
peakmsISI = exp(centers2(round(mean(inds))));       

meanISI = mean(ISI_list);
p2mISI = peakmsISI/meanISI;
fracmeanISI = length(find(ISI_list<0.05*meanISI))/length(ISI_list);    
% From Parikh et al. 2018

% Coefficient of variation
CV = std(ISI_list)/meanISI;

reg_parikh = regularity(ISI_list);
% From Parikh et al. 2018

if length(unique(N(centers<10)))>1
    [intraburstval, ind]= max(N(centers<10));
    centerscrop = centers(centers<10);
    intraburstint = centerscrop(ind);
    intraburstfreq = 1000/intraburstint;
else  % All the same, e.g., all 0. MATLAB will still return the first index as max.
    intraburstfreq = NaN;
end

% Refractory period
zero_thresh = maxN/200;

nonzero_inds = find(N>zero_thresh);
[ind,indind] = min(nonzero_inds);

try
    while (N(ind+1)<zero_thresh)
        nonzero_inds(indind)=NaN;
        [ind,indind] = min(nonzero_inds);
    end
    refract = centers(ind);
catch
    refract = NaN;  % e.g., never finds two consecutive nonzero bins
end

% Log ISI metric
inds1 = find(centers2>0 & centers2<2);
inds2 = find(centers2>3.5 & centers2<4.5);
A = mean(N2(inds1));
B = mean(N2(inds2));
ISImetric = (A-B)/(A+B);

% Burst length  
% Katai et al., 2010 - minimum ISI < 5 ms, max < 2.5 times the minimum ISI

% Variant: consecutive ISI between 0.5 and 1.5 peakmsISI.

burstlen = [];
bursti = 1;

start1 = strfind([0,(ISI_list < 10)],[0 1]);
end1 = strfind([(ISI_list < 10),0],[1 0]);

cutofflow = peakmsISI*0.5;
cutoffhigh = peakmsISI*1.5;

start1 = strfind([0,((ISI_list < cutoffhigh)&(ISI_list > cutofflow))],[0 1]);
end1 = strfind([((ISI_list < cutoffhigh)&(ISI_list > cutofflow)),0],[1 0]);
burst_lengths = end1 - start1 + 1 + 1;   
% 1 is due to offset from adding 0 to beginning of start1 search list, 1 due to 1 ISI being 2 spikes
%burst_lengths = burst_lengths(burst_lengths>1); 
mean_burst_length = mean(burst_lengths);
if plotornot
    figure
    histogram(burst_lengths);
    title('burst lengths');
end
if isempty(burst_lengths)
    max_burst_length = NaN;
else
    max_burst_length = max(burst_lengths);
end

%length(find(burst_lengths>2))/length(find(burst_lengths==2))

% Percent in bursts
percburst = sum(burst_lengths)/spk_count;  

%length(find((ISI_list>10)&(ISI_list<40)))/spk_count

% Percent of ISI less than 5 ms (Katai et al., 2010)

percISI5 = length(find(ISI_list<5))/length(ISI_list);
% Normalized to perc expected for poisson with equal rate 
% (e.g., Trainito et al., 2019)
lamda = spk_count/sum(ISI_list)*1000;
percISI5poiss = 1-exp(-lamda*0.005);
percISI5ratio = percISI5/percISI5poiss;

% Hartigan's Dip Test
nboot = 10000;   % was 1500, but want fewer 0's
xpdf = sort(log_ISI_list);
if length(xpdf)==0
    dip_p_value = NaN;
    dip = NaN;
else
    [dip, dip_p_value, xlow,xup]=HartigansDipSignifTest(xpdf,nboot);
end
logISIskewness = (mean(log_ISI_list)-median(log_ISI_list))/std(log_ISI_list);

% Autocorrelogram
%edges = 1/2*binsize_ms:binsize_ms:range_ms;
edges = ac_shift*binsize_ms:binsize_ms:range_ms;
autocorr_list = autocorr_list(autocorr_list~=0);
[N_ac,edges] = histcounts(autocorr_list(:),edges);

%yautocorr = N_ac/((spk_count/(tot_time/1000))^2);    
yautocorr = N_ac; 
xautocorr = mean([edges(1:end-1);edges(2:end)]);
%[foo,zerobin] = find(xautocorr == 0);
%yautocorr(zerobin) = 0;    

if plotornot
    figure
    bar(xautocorr,yautocorr);
    ylabel('Normalized autocorrelation');
    xlabel('Time delay (ms)');
end
    
% Per Onorato et al., 2019, time of autocorrelation peak in the range under
% 60 ms can distinguish bursters (typically peak below 6 ms)
inds = find(xautocorr<=60);
ind60 = max(inds);
acorrcrop = yautocorr(1:ind60);
xacorrcrop = xautocorr(1:ind60);
[val,indpeak] = max(acorrcrop); 
acorrpeak = xacorrcrop(indpeak);

% Autocorrelogram metric
indsshort = find(xautocorr<8);
indslong = find(xautocorr>35 & xautocorr<80);

A = mean(yautocorr(indsshort));
B = mean(yautocorr(indslong));
acmetric = (A-B)/(A+B);

outputs.yautocorr = yautocorr;
outputs.xautocorr = xautocorr;
outputs.acmetric = acmetric;
outputs.peakmsISI = peakmsISI;
outputs.intraburstfreq = intraburstfreq;
outputs.p2mISI = p2mISI;
outputs.fracmeanISI = fracmeanISI;
outputs.refract = refract;
outputs.CV = CV;
outputs.reg_parikh = reg_parikh;
outputs.ISImetric = ISImetric;
outputs.mean_burst_length = mean_burst_length;
outputs.max_burst_length = max_burst_length;
outputs.percburst = percburst;
outputs.percISI5 = percISI5;
outputs.dip_p_value = dip_p_value;
outputs.dip = dip;
outputs.percISI5ratio = percISI5ratio;
outputs.logISIdrop = logISIdrop;
outputs.logISIskewness = logISIskewness;

% Based on Rohan Parikh (2018) Appendix
% Regularity - variance of the ratio between consecutive ISIs
function reg = regularity(isiArray)
r = isiArray(1:end-1) ./ (isiArray(2:end) + isiArray(1:end-1));
reg = var(r);
