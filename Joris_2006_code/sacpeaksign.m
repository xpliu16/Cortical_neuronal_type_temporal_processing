function [p, BinCenters, Ppdf, Pcdf, Nco] = SACPeakSign(Spt, CorBinWidth, NTrials, dur)
%SACPEAKSIGN - SAC peak significance
%   p = SACPeakSign(Spt, BinWidth, NTrials, Dur) evaluates the statistical significance
%   of the peak value of the shuffled autocorrelogram (SAC; see SPTCORR) 
%   derived from spiketrain collection Spt. 
%   Input args:
%     Spt:        cell array of spike time vectors; each vector is "repetition"
%     BinWidth:   width of coincidence window
%     Ntrials:    # simulations in Monte Carlo simulation (see below)
%     Dur:        duration of analysis window used to extract the spikes (see Anwin).
%   Spt, BinWidth, and Dur must be specified in the same time units (e.g. ms).
%
%   Let Nco be the count of lag-zero coincidences from spike train collection Spt. 
%   Then the significance of Nco is computed by a bootstrap method as follows:
%   the returned value p is the fraction of "random spike trains" having 
%   the same dimension as Spt that have correlation index <= Nco.
%   The random spike trains are obtained from Spt by random permutation
%   of the inter-spike intervals. BinWidth is the binwidth of the correlogram
%   and NTrials is the # trials on which the estimate of p is based.
%   
%   For spike trains without a significant second-order temporal structure,
%   p = 0.5 is expected. A value of p=0.999 means that 99.9% of the random
%   spike trains has a lower SAC peak value, strongly suggesting a temporal 
%   structure in the spike train collection.
%
%   [p, BinCenters, Ppdf, Pcdf, Nco] = SACPeakSign(Spt, BinWidth, NTrials) also returns the
%   probability density function(PDF) and the cumulative distribution function(CDF)
%   of the Nco values as estimated from the trials. BinCenters contains the bin centers
%   of these functions, e.g., BAR(Nco,Ppdf) will produce a graph of the pdf.
%
%   See also SPTCORR.

%B. Van de Sande 10-09-2004; modified by Marcel van der Heijden, Oct 2005, Mar 2005

%Checking input arguments ...
if (nargin <= 0), error('Wrong number of input arguments.');
elseif ~iscell(Spt) | ~all(cellfun('isclass', Spt, 'double')), error('First argument should be cell array of vectors containing spiketimes.');
elseif ~isnumeric(CorBinWidth) | (length(CorBinWidth) ~= 1) | (CorBinWidth < 0), error('Second argument should be positive scalar specifying correlation binwidth.');
elseif ~isnumeric(NTrials) | (length(NTrials) ~= 1) | (NTrials <= 0), error('Third argument should be positive scalar specifying number of trials.'); end

if nargin<4,
   error('Dur argument not specified.');
end

%Assemble a PDF and a CDF for the number of coincidences at zero delay using
%a Monte Carlo approach ...
Nco = zeros(1, NTrials); NRep = length(Spt); ScrSpt = cell(1, NRep);
for n = 1:NTrials,
   %n
   %Remove all information of higher order differences ...
   for i = 1:NRep, ScrSpt{i} = ScrambleSpkTr(Spt{i}, dur); end
   %Calculate the number of coincidences at zero delay ...
   Nco(n) = SPTCORR(ScrSpt, 'nodiag', 0, CorBinWidth);
end
Edges = linspace(min(Nco), max(Nco), NTrials); BinWidth = diff(Edges([1 2])); 
BinCenters = Edges([1:end-1])+BinWidth/2;
Npdf = histc(Nco, Edges); Npdf(end) = [];
Ppdf = Npdf/NTrials; Pcdf = cumsum(Ppdf);

% Compute the true Nco of Spt and look where it is in the collection.
Spt_Nco = SPTCORR(Spt, 'nodiag', 0, CorBinWidth);
p0 = sum(Nco<=Spt_Nco)/NTrials;
p1 = sum(Nco<Spt_Nco)/NTrials;
p = (p0+p1)/2;

%--------------------------------------------------------------------------------------------------
function SpkOut = ScrambleSpkTr(SpkIn,Dur)
% shuffle spike train by randomizing the ISI's
if isempty(SpkIn)
    SpkOut = SpkIn;
else
    NInt = length(SpkIn); 
    SpkIn = sort(SpkIn); % sort to make sure diff gives the ISI's
    span = diff(SpkIn([1 end])); % first-to-last spike interval
    D = diff(SpkIn); 
    margin = Dur-span; % margin to shift the whole train within the total duration
    SpkOut = margin*rand+cumsum([0 D(randperm(NInt-1))]);
end
%--------------------------------------------------------------------------------------------------



