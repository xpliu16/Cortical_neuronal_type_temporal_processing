function [x, BC, NC] = SPTCORR(spt1, spt2, maxlag, binwidth, dur, normStr)
% SPTCORR - spike time correlogram
%    H = SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH), where SPT1 and SPT2 are vectors
%    containing spiketimes, returns the histogram of the spike-time differences 
%    between the spike pairs from SPT1 and SPT2. The histogram is restricted
%    to intervals DT between -maxlag and maxlag. BINWIDTH is the bin width
%    of the histogram. All arguments must be specified in the same time unit,
%    e.g. ms. The middle bin is centered around zero lag. If maxlag=0, a single
%    number is returned signifying the correlation at lag zero.
%
%    The convention of time order matches that of XCORR: if
%    t1 and t2 are spike times from SPT1 and SPT2, respectively, then t1>t2 
%    will count as a positive interval.
%
%    [H, BC] = SPTCORR(...) also returns the position of the bin centers in H.
%    plot(BC,H) plots the correlogram.
%
%    If SPT1 and SPT2 are cell arrays, the elements of these arrays are considered
%    as "repetitions," that is, each cell is a spike train from the same
%    stimulus. Spike times from the different cells are merged prior to
%    to the computation: SPTCORR(SPT1,SPT2, ...) = SPTCORR([SPT1{:}],SPT2[SPT1{:}], ...).
%
%    If SPT is a cell array whose elements are spike time vectors, then 
%    SPTCORR(SPT, 'nodiag', ...) returns the autocorrelation with the
%    digonal terms removed, i.e., the histogram is compiled only across
%    different repetitions. This is the "shuffled autocorrelogram" (SAC)
%    introduced by Joris, J. NeuroSci. (2003). 
%    Note: an autocorrelogram without this correction ("unshuffled")  
%    is obtained by SPTCORR(SPT, SPT, ...).
%
%    [H, BC, N] = = SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH, DUR) returns a struct N 
%    containing various parameters relevant to the normalization. DUR is the duration of
%    the analysis window; DUR does not affect the unnormalized correlogram itself,
%    but is needed to compute the normalization constants.
%    The field "LouageNorm" is the normalization constant that leads to a 
%    dimensionless curve with unity assymptotes (Louage et al, J. NeuroPhysiol, 2004).
%
%    SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH, DUR, 'LouageNorm') directly applies 
%    the above-mentioned normalization. In this case, the center bin of the
%    correlogram (at lag zero) equals the "correlation index" (CI) introduced
%    in (Louage et al, J. NeuroPhysiol, 2004).
%
%    See also XCORR.

%Marcel van der Heijden 20-08-2004, adjusted by Bram Van de Sande

if nargin<5, dur = nan; end; % don't know duration (so cannot apply normalization)
if nargin<6, normStr = ''; end; % default: unnormalized coincidence counts

% if spt1 and/or spt2 are cell arrays, use recursive call(s) to sptcorr.
if iscell(spt1) & iscell(spt2)
   % grand correlogram: merge all spikes of each set. Apply no normalization yet
   [x, BC, NC] = SPTCORR([spt1{:}], [spt2{:}], maxlag, binwidth, dur, '');
   % evaluate normalization and apply if requested
   Nrep1 = length(spt1); Nrep2 = length(spt2); % cells are "repetitions" (see help text)
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   return;
elseif iscell(spt1)
   gEr=1; % pessimistic default
   gEr = ~isequal('nodiag',lower(spt2));
   if gEr, error('If SPT1 is a cell array, SPT2 must be either a cell array or the string "nodiag".'); end
   % non-diagonal autocorr; apply no normalization yet
   [x, BC, NC] = SPTCORR([spt1{:}], [spt1{:}], maxlag, binwidth, dur, '');
   Nrep1 = length(spt1); Nrep2 = nan;
   for irep=1:length(spt1) % subtract diagonal terms
      x = x - SPTCORR(spt1{irep}, spt1{irep}, maxlag, binwidth, dur, '');
   end
   % evaluate normalization and apply if requested
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   return;
end

% from here, spt1 & spt2 are single vectors. Delegate number crunching to MEX function (DLL).
[x, BC] = sptcorrmex(spt1, spt2, maxlag, binwidth);
% compute normalization stuff
Nspike1 = length(spt1); Nspike2 = length(spt2);
NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur);
% apply normalization if requested
x = localApplyNorm(x, NC, normStr);

%==========================================================================
%-------------------------------locals-------------------------------------
function NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur, Nrep1, Nrep2)
%Compute normalization coefficients from stimulus parameters & input spike counts
if nargin<5, Nrep1 = 1; end
if nargin<6, Nrep2 = 1; end
Rate1 = (1e-10+Nspike1)/dur/Nrep1; % innocent 1e-10 to prevent divide-by-zero warning
Rate2 = (1e-10+Nspike2)/dur/Nrep2;
if isnan(Nrep2) % autocorr w/o diag ("shuffled")
   NF = dur*(Nrep1*(Nrep1-1));
   Rate2 = Rate1;
else % cross corr
   NF = dur*Nrep1*Nrep2;
end
LouageNorm = NF*Rate1*Rate2*binwidth;
NC = CollectInStruct(Nspike1, Nspike2, Rate1, Rate2, Nrep1, Nrep2, dur, binwidth, NF, LouageNorm);

%--------------------------------------------------------------------------
function x = localApplyNorm(x, NC, normStr)
%Apply normalization
if ~isempty(normStr)
   if ~isfield(NC, normStr), error(['"' normStr '" is not a known normalization mode.']); end;
   NormVal = getfield(NC, normStr);
   x = x/NormVal; 
end

%--------------------------------------------------------------------------
function S = CollectInStruct(varargin);
% CollectInStruct - collect variables in struct
%   CollectInStruct(X,Y,...) is s struct with field names 
%   'X', 'Y', ... and respective field values X,Y,...
%   All arguments must be variables, not anonymous values.
%
%   See also STRUCT, FIELDNAMES, GETFIELD, SETFIELD.
Nvar = length(varargin);
S = [];
for ivar=1:Nvar
   FN = inputname(ivar);
   if isempty(FN)
      error(['arg #' num2str(ivar) ' has no name'])
   end
   S = setfield(S,FN,varargin{ivar});
end
%--------------------------------------------------------------------------


