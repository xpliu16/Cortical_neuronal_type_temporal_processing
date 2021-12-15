function [output] = spk_wave_params (spike_avg, spike_t_shifted, spike_t_shifted2, spike_count, spike_avg_long, SR_ms, options)
% spk_wave_params.m Extracts spike waveform features from average spike 
%
% Inputs:
%   spike_avg        : average spike waveform (vector)
%   spike_t_shifted  : time shifted traces of each qualifying spike, filtered 1 Hz to 10 kHz (matrix)
%   spike_t_shifted2 : shifted traces of each spike, filtered 100 Hz to 5 kHz
%   spike_count      : number of qualifying spikes (scalar)
%   spike_avg_long   : average spike, longer segment, for FFT baseline
%   SR_ms            : a scalar describing sampling rate (samples/ms) 
%
% Outputs:
%   output           : spike waveform parameters (struct)

search_win = options.search_win;   % Look for peaks within +/- this window (ms)
ms_before_peak = options.ms_before_peak;
ms_before_peak_long = options.ms_before_peak_long;
search_seg = spike_avg(round((ms_before_peak-search_win)*SR_ms):round((ms_before_peak+search_win)*SR_ms));
plotornot = options.plotornot;
halfampptp = 0;

if plotornot    % For plotting sample of individual spikes
    display_rows = 4;
    display_columns = 6;
end

if isempty(spike_avg)
    output.spupdown = NaN;
    output.ptp_amp = NaN;
    output.ptp_ms = NaN;
    output.ptp2_ms = NaN;
    output.ttp_ms = NaN;
    output.f = NaN;
    output.pxx_spike = NaN;
    output.centroid = NaN;
    output.spectralpeak = NaN;
    output.f50 = NaN;
    output.fspsp = NaN;
    output.halfampdur = NaN;
    output.sp_wave = NaN;
    output.sp_wave_long = NaN;
    output.sp_wave_count = NaN;
    output.sp_wave_count_long = NaN;
    output.t_shifted = NaN;
    output.SNR = NaN;
    output.SNR_avg = NaN;
    return;     
end    
 
peakindsdown = [];
peakindsup = [];
nanparams = 0;
peakind = 50; % default value for plotting alignment if neither up nor down peaks cannot be identified

[N,X] = hist(spike_avg, 30);
[Y,I] = max(N);
mode = X(I);

f = 2;
while isempty(peakindsdown)
    [peakindsdown, peakmagdown] = peakfinder(search_seg, (max(search_seg)-min(search_seg))/f,max(search_seg),-1,0);
    f = f+2;
    if f > 25
        nanparams = 1;
        break;
    end
end
f = 2;
while isempty(peakindsup)
    [peakindsup, peakmagup] = peakfinder(search_seg, (max(search_seg)-min(search_seg))/f,min(search_seg),1,0);
    f = f+2;
    if f > 25
        nanparams = 1;
        break;
    end
end

if (abs(min(peakmagdown)-mode) > abs(max(peakmagup)-mode))
    output.spupdown = -1;    
elseif abs(min(peakmagdown)-mode) < abs(max(peakmagup)-mode)
    output.spupdown = 1;
elseif ~isempty(peakmagdown) && isempty(peakmagup)
    output.spupdown = -1;   
elseif isempty(peakmagdown) && ~isempty(peakmagup)
    output.spupdown = 1;
else
    output.spupdown = NaN;
end

if nanparams
    output.ptp_amp = NaN;
    output.ptp_ms = NaN;
    output.halfampdur = NaN;
else
    [peakvaldown, inddown] = min(peakmagdown);   
    [peakvalup, indup] = max(peakmagup); 
    output.ptp_amp = peakvalup-peakvaldown;
    output.ptp_ms = abs(peakindsup(indup)-peakindsdown(inddown))/SR_ms;
end
ind0 = peakind+round((ms_before_peak-2.5)*SR_ms)-1;
t_shifted = 0-(ind0-1)/SR_ms:1/SR_ms:(length(spike_avg)-ind0)/SR_ms;
t_shifted_long = max(t_shifted):-1/SR_ms:-2-ms_before_peak_long;
t_shifted_long = fliplr(t_shifted_long(1:length(spike_avg_long)));
output.t_shifted = t_shifted;
pre_baseline = mean(spike_avg((t_shifted < -1) & (t_shifted > -2)));

if plotornot
   figure
   plot(t_shifted, spike_avg);
   xlim([-4 4]);  % optional to see close up timescale
end

peakind = [];
if output.spupdown == -1    % non-inverted 'down' spike, downstroke larger than upstroke, should be same as TTP for non inverted spikes
    [peakvaldown, inddown] = min(peakmagdown);  
    peakinddown = peakindsdown(inddown);
    search_seg2 = search_seg(peakinddown+1:end);
    f = 2;
    while isempty(peakind)
        [peakindsup2, peakmagup2] = peakfinder(search_seg2, (max(search_seg2)-min(search_seg2))/f,min(search_seg2),1,0);
        f = f+2;
        peakind = min(peakindsup2);
        if f >25
            nanparams = 1;
            break;   % And NaN everything
        end
    end
    if nanparams
        output.ptp2_ms = NaN;      % From largest magnitude peak to subsequent peak of opposite sign
    else
        output.ptp2_ms = peakind/SR_ms; 
    end
    % Half-amplitude duration
    xq = 0:0.1:length(search_seg);
    s10x = spline(1:length(search_seg),search_seg,xq);
    if plotornot
        figure
        plot(search_seg,'o');
        hold on
        plot(xq,s10x,'.r');
    end
    if halfampptp == 1   % Calculate based on PTP and only for noninverted spikes)
        halfamp = peakvaldown+output.ptp_amp/2;   
    else
        halfamp = peakvaldown+(pre_baseline-peakvaldown)/2;     % Calculate for negative peak back to baseline
    end
    [val,peakinddown10x] = min(s10x); 
    [val1, ind1] = min(abs(s10x(1:peakinddown10x)-halfamp));
    interpind1 = xq(ind1);
    [val2, temp] = min(abs(s10x(peakinddown10x+1:peakinddown10x+1+SR_ms*10)-halfamp));    % Limited to 1 ms
    ind2 = temp+peakinddown10x;
    interpind2 = xq(ind2);
    if ~isnan(val1) && ~isnan(val2)
        output.halfampdur = (interpind2-interpind1)/SR_ms;
    end
elseif output.spupdown == 1
    [peakvalup, indup] = max(peakmagup);  
    peakindup = peakindsup(indup);
    [peakvaldown, inddown] = min(peakmagdown);
    peakinddown = peakindsdown(inddown);
    search_seg2 = search_seg(peakindup+1:end);
    f = 2;
    while isempty(peakind)
        [peakindsdown2, peakmagdown2] = peakfinder(search_seg2, (max(search_seg2)-min(search_seg2))/f,max(search_seg2),-1,0);
        f = f+2;
        peakind = min(peakindsdown2);
        if f >25
            nanparams = 1;
            break;   % And NaN everything
        end
    end
    if nanparams
        output.ptp2_ms = NaN;      % From largest magnitude peak to subsequent peak of opposite sign
    else
        output.ptp2_ms = peakind/SR_ms; 
    end
    
    % Half-amplitude duration
    xq = 0:0.05:length(search_seg);
    s10x = spline(1:length(search_seg),search_seg,xq);
    if plotornot
        figure
        plot(search_seg,'o');
        hold on
        plot(xq,s10x,'.r');
    end
    if halfampptp == 1   % Calculate based on PTP and only for noninverted spikes)
        output.halfampdur = NaN;       
    elseif ~isempty(peakvaldown) & (peakinddown > peakindup) & (peakvaldown < pre_baseline)  % Make sure you pick the right down peak, should be after peak up for inverted spike
        halfamp = peakvaldown+(pre_baseline-peakvaldown)/2;     % Calculate for negative peak back to baseline
        [val,peakinddown10x] = min(s10x); 
        [val1, ind1] = min(abs(s10x(1:peakinddown10x)-halfamp));
        interpind1 = xq(ind1);
        [val2, temp] = min(abs(s10x(peakinddown10x+1:peakinddown10x+1+SR_ms*10)-halfamp));    % Limit HAD to less than 1 ms - otherwise, occasionally if trace goes downward again due to noise, the second crossing could be closer to the halfamp value
        ind2 = temp+peakinddown10x;
        interpind2 = xq(ind2);
        if ~isnan(val1) && ~isnan(val2)
            output.halfampdur = (interpind2-interpind1)/SR_ms;
        end
    else
        output.halfampdur = NaN;
    end
else
    output.ptp2_ms = NaN;
    output.halfampdur = NaN;
end

 % Trough-to-peak
[troughval,ind] = min(peakmagdown);
troughind = peakindsdown(ind);
if isempty(troughind) || ((output.spupdown == 1)&&(peakinddown < peakindup))
    output.ttp_ms = NaN;
else
    peakind = [];
    f = 2;
    search_seg2 = search_seg(troughind+1:end);
    try   % fails in rare case of smooth curve without peak where deriv never changes sign
        while isempty(peakind)
            [peakindsup, peakmagup] = peakfinder(search_seg2, (max(search_seg2)-min(search_seg2))/f,min(search_seg2),1,0);
            f = f+2;
            okinds = find(peakmagup > (peakmagdown+(pre_baseline-peakmagdown)/2));     % Conservative sanity check for multiphasic spikes triggering on minipeaks
            peakind = min(peakindsup(okinds));
            if f >25
                nanparams = 1;
                break;   % And NaN everything
            end           
        end
    catch
        nanparams = 1;
    end

    if nanparams || isempty(peakind)
        output.ttp_ms = NaN;
    else
        output.ttp_ms = (peakind)/SR_ms; 
    end
end

ind_max_backg = min(find(t_shifted>min(t_shifted)+ms_before_peak-3));

% Signal-to-noise
if ~exist('sp_wave','var')   % Computing from file, not from collated avg spike
    output.SNR = 20*log10(mean(max(spike_t_shifted2,[],2)-min(spike_t_shifted2,[],2))/mean(std(spike_t_shifted2(:,1:ind_max_backg),0,2)));    
    % Peak-to-peak amplitude of spike divided by STD of background,
    % filtered 100 Hz to 5 kHz
end
output.SNR_avg = 20*log10(output.ptp_amp/std(spike_avg(1:ind_max_backg)));

% Spike spectrum
spk_seg_fft = spike_avg_long((t_shifted_long>-2) & (t_shifted_long<6));
wind = hann(length(spk_seg_fft));
Y = fft(spk_seg_fft.*wind',4*length(wind));      % zero pad
L = 4*length(spk_seg_fft);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = SR_ms*1000*(0:(L/2))/L;
if plotornot
    figure
    plot(f,P1,'o-') 
    xlim([0 4000]);
    title('Single-Sided Amplitude Spectrum of Spike')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
end

nospk_seg_fft = spike_avg_long(t_shifted_long<-2);
nospk_seg_fft = nospk_seg_fft(1:length(spk_seg_fft));
nospk_seg_fft = nospk_seg_fft(length(nospk_seg_fft)-length(spk_seg_fft)+1:end);

Yn = fft(nospk_seg_fft.*wind',4*length(wind));
L = 4*length(nospk_seg_fft);
P2n = abs(Yn/L);
P1n = P2n(1:L/2+1);
P1n(2:end-1) = 2*P1n(2:end-1);

f = SR_ms*1000*(0:(L/2))/L;
if plotornot
    figure
    plot(f,P1n,'o-') 
    xlim([0 4000]);
    title('Single-Sided Amplitude Spectrum of Noise')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
end

pxx_spike = P1-P1n;
output.f = f;
output.pxx_spike = pxx_spike;

if plotornot
    figure
    plot(f,pxx_spike,'o-') 
    xlim([0 4000]);
    ylim([0 1.1*max(pxx_spike)]); 
    title('Single-Sided Amplitude Spectrum of Spike minus Spectrum of Noise')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
end

output.centroid = sum(pxx_spike.*f)/sum(pxx_spike);
ind = length(find(f<4000));

inds = find(f > 400);   % Greater than ~400 Hz - often weird noise peaks below that
pxx_spike_crop = pxx_spike(inds);
f_crop = f(inds);
[val,ind2] = max(pxx_spike_crop); 
peakamp = val;
output.spectralpeak = f_crop(ind2);
ind3 = min(find(pxx_spike_crop(ind2+1:end) < 0.5*peakamp));
output.f50 = f_crop(ind2+ind3)

[peakinds, peakmag] = peakfinder(pxx_spike_crop, (max(pxx_spike_crop)-min(pxx_spike_crop))/8, min(pxx_spike_crop), 1);
spectralpeaks = f_crop(peakinds)

% Spectrum of the FFT spectrum (to detect periodicity in burster spectra)
f_res = SR_ms*1000/L;
Ys = fft(pxx_spike,2*length(pxx_spike));      % zero pad
Ls = 2*length(pxx_spike);
P2s = abs(Ys/Ls);
P1s = P2s(1:Ls/2+1);
P1s(2:end-1) = 2*P1s(2:end-1);
fs = 1/f_res*(0:(Ls/2))/Ls;

if plotornot
    figure
    plot(fs,P1s, '-o');
    title('Spectrum of Spike Spectrum')
    xlabel('f')
    ylabel('Amplitude')
end
fshigh = 1/200;
fslow = 1/1000;
[val,ind] = max(P1s(fs>fslow & fs<fshigh));
fscrop = fs(fs>fslow & fs<fshigh);
foo = fscrop(ind);
output.fspsp = 1/foo;

% Plot aligned example spikes
if plotornot
    figure
    plot_every_nth = ceil(spike_count/(display_rows*display_columns));    % These spike counts are for averaged in spikes, which eliminates many candidate spikes, so don't use to get firing rate
    for spike_i = 1:plot_every_nth:spike_count-1
       % plot every nth to get 4 x 6 spikes max
        subplot(display_rows, display_columns, ceil(spike_i/plot_every_nth));
        plot(t_shifted, spike_t_shifted(spike_i,:));
        axis('tight');
        V = axis;
        V(3) = 1.1*V(3);
        V(4) = 1.1*V(4);
        axis(V);
    end
end
