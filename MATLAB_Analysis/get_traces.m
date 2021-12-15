function [traces, t, SR_ms, spk_ms, pre_stim, post_stim, stim_len, spont_rate, id_str] = get_traces (filename, stimindices, repindices, ch)

% get_traces.m Reads raw traces from lab standard ad2 binary format
%
% Inputs:
%   filename     : filenames of .ad2 files (struct)
%   stimindices  : stimulus numbers to use (vector)
%   repindices   : repetition numbers to use (vector)
%   ch           : channel of spike trigger to use (scalar) 
%
% Outputs:
%   traces       : file x stimulus (cell array)
%   SR_ms        : sampling rate in samples / ms (scalar)
%   spk_ms       : matrix with timestamps of each spike taken from lab 
%                  standard format (matrix in cell array)
%                  columns are: 
%                       stimulus, repetition, MSD channel, time     
%   pre_stim     : pre-stimulus time in ms (scalar)
%   post_stim    : post-stimulus time in ms (scalar)
%   stim_len     : stimulus duration in ms (scalar)
%   spont_rate   : spontaneous firing rate (spk/s)
%   id_str       : file name and datetime (array of strings)
%


if iscell(filename)
    file_n = max(size(filename));
else
    file_n = 1;
end
stim_n = length(stimindices);
traces = cell(file_n, stim_n, 1);
t = cell(stim_n,1);

spont_count = 0;

for f = 1:file_n
    filename_bits = strread(filename{f}, '%s', 'delimiter', '\\');
    spike_filename{f} = filename_bits{end}(1:end-4);
    spike_filename_short{f} = strcat(filename_bits{end}(end-7:end-4),'_'); % for figure naming
    
    [ad2_data,ad2_SR,ad2_stim_order,ad2_header{f},prestimduration, stimduration, dateandtime{f}] = zero_get_ad2(filename{f});
    SR_ms = ad2_SR(1)/1000;
    for i = 1:stim_n
        for j = 1:length(repindices)
            tracetemp = (ad2_data{1}{stimindices(i)});    
            % note: first cell index is input channel (raw or LFP), 
            % second is stim number, within this cell 
            % there are columns for each rep
            traces{f,i}(j,:) = tracetemp(repindices(j),:)/32768*1000;   
            % Maps 10 V to 1 V - if head stage gain is set to 1 for a 0.1 headstage.
            % 16 bit signed
            % Change V to mV
            t{i} = 0:1/(ad2_SR(1)):(length(traces{f,i})-1)*1/(ad2_SR(1));       
            t{i} = t{i}*1000;    % change to ms
        end
    end
   
    [spk_ms{f}, D{f}, stim_len, pre_stim, post_stim, stims, stim_file, ...
        analysis_type{f}, last_rep_complete, last_rep_stims{f}] ...
        = get_spikes_xpl (spike_filename{f}, ch, stimindices, repindices);     % not filtered by stimindices
    
    % Check that protocols appear to be same if pooling    
    stim_desc1{f} = D{f}.stimulus_ch1;
    stim_desc2{f} = D{f}.stimulus_ch2;
    
    spk_ms_sub = spk_ms{f}(ismember(spk_ms{f}(:,1),stimindices) & ismember(spk_ms{f}(:,2), repindices), :);
    spont_count = spont_count + length(find((spk_ms_sub(:,4) < pre_stim)& (spk_ms_sub(:,4) > 0)));    % ASSUMES ALL REPS COMPLETE...
end

if file_n > 0
    spont_rate = spont_count / (stim_n*file_n*length(repindices)*pre_stim/1000);
end

for f = 2:file_n
    if not(isempty(find(stim_desc1{f}~=stim_desc1{f-1}))) || not(isempty(find(stim_desc2{f}~=stim_desc2{f-1}))) || not(strcmp(analysis_type{f}, analysis_type{f-1}))
        error ('Protocols of two files appear to be different');     % doesn't check for matching prestim/poststim or SR
    end
end

id_str = cell(file_n*2,1);
for f = 1:file_n
    if exist('dateandtime')
        id_str{f*2-1} = filename{f};
        id_str{f*2} = dateandtime{f};
    end
end

if exist('last_rep_complete') && (~last_rep_complete)
    display('Warning: Last rep not complete, spontaneous rate incorrect');
end

function varargout = zero_get_ad2(varargin)
%
% GET_AD2 Function
% From zero analysis package
% Written on 1/27/04 by S. Eliades based on the original extract_AD2 files written by T. Lu
%
% This function will extract raw data from AD2 files.
% This updated version allows reading of both old (single channel) and new
% (multi-channel) AD2 data.
%
% Input arguments:
%
%   ... get_ad2(FILE,MODE)
%   ... get_ad2(FILE,MODE,Channel)
%   ... get_ad2(FILE,MODE,Channel,Stimulus)
%   ... get_ad2(FILE,MODE,Channel,Stimulus,Trial)
%
%  FILE is a text string specifying the file name.  Channel designates which channel
%  to extract (can be either scalar of vector).  If not specified, all channels extracted.
%  Stimulus specifies which stimulus numbers to return (scalar/vector).  Trial specifies
%  which trial for a given stimulus number to extract.
%  MODE is a text flag that specifies whether to return data as an array or a continuous stream.
%       'std' returns an array, 'cts' returns a vector (unspecified defaults to array mode).
%       'hdr' returns no data, but the entire header instead ('short' returns limited info)
%
% Output arguments:
%
%  data = get_ad2(..) returns only the digitized signal.
%  [data,sr] = get_ad2(..) returns both the signal and sample rate.
%  [data,sr,x] = get_ad2(..) also returns the order of stimulus presentation
%
%  The format of data depends on the input specificatons.  Multiple channels will be
% returned as elements of a cell array, as will multiple stimuli. Multiple trials
% will be returned as elements of standard array.
%
% Sample Uses:
%       data = get_ad2(FNAME);          This will return the entire, parsed AD2 file.
%       data = get_ad2(FNAME,'cts');    This will return continous streams of AD2 data.
%       data = get_ad2(FNAME,'std',1,4);      This will return all reps of stimulus 4 on channel 1
%       data = get_ad2(FNAME,'std',1,4,3);    This will return only rep 3 of stim 4 on channel 1
%       data = get_ad2(FNAME,'hdr');    This will return an array containing the text file header.
%
%

%-------------Data Format --------------
%<D1>  <D2>  <D3>  <D4>  <D5>
%D1 = Stimulus Number
%D2 = Stimulus Presentation
%D3 = ET1 Channel Number
%D4 = Time of Event (in microseconds)
%D5 = Attenuation (in dB)

%Get filename
filename = varargin{1};

%First open file
fid=fopen(filename,'rb');
if fid == -1
    error('File not found');
end

%Read in the header block
str=fgetl(fid);
i = 1;
while (isempty(findstr(str,'END_HEADER')))
    hdr{i} = str; i=i+1;
    str=fgetl(fid);
end

%Now search the header for the number of channels, stimuli, trials etc.
[ad2ver,nch,on_ch,nstim,nrep,sr,dur,ds,stdur,dateandtime,pre_stimulus_duration] = local_getheaderinfo(hdr);
if ~isempty(ds) %downsample factor
    for i = 1:length(on_ch)
        new_sr(i) = sr/ds(on_ch(i));
    end
else
    new_sr = sr.*ones(1,nch);
end
sr = new_sr;

if nstim > 20000
    nstim = nstim - 20000;
end

%Get rest of input arguments
if nargin > 1
    mode = varargin{2};
else
    mode = 'std';
end
if nargin > 2
    chans = varargin{3};
else
    chans = on_ch;
end
if nargin > 3
    stims = varargin{4};
else
    stims = 1:nstim;
end
if nargin > 4
    trials = varargin{5};
else
    trials  =1:nrep;
end

%Error handling
if max(chans)>max(on_ch)
    error('Selected channel(s) do not exist.');
end
if max(stims)>nstim
    error('Select stimulus/stimuli do not exist.');
end
if max(trials)>nrep
    error('Selected trial(s) do not exist');
end

%Skip data segment if header info alone is requested
switch mode
    case 'hdr'
        quit = 2;
    case 'short'
        quit = 2;
    otherwise
        quit=0;
end

%Start reading in data until found all the desired data
for i = 1:length(chans)
    data{i}{length(stims)}=[];
    %*
    % 	for j = 1:length(stims)
    % 		data{i}{j} = zeros(91,4000);
    % 	end %for j stim
    %*
end
data_info = [];
needed_data = length(chans)*length(stims)*length(trials);  %Counter keeps track if done
got_data = 0;

%Stim Info formats
%  Stimulus # (2bytes), Presentation # (2bytes), npts (4bytes), 16 bit data (2bytes*npts)...
%  Stimulus # (2bytes), Presentation # (2bytes), AD2 Channel # (1 byte), npts (4bytes), 16 bit data (2bytes*npts)...

while ~quit
    stim = fread(fid,1,'integer*2');
    if stim > 600 | stim < 1
        return
        % 		stim = dec2bin(stim);
        % 		ind = find(stim == '/');
        % 		stim(ind) = '1';
        % 		stim = stim(end-8:end);
        % 		stim = bin2dec(stim);
    end

    if ~isempty(stim)
        rep = fread(fid,1,'integer*2');
        if rep > 3000 | rep < 1
            return
            % 			rep = dec2bin(rep);
            % 			ind = find(rep == '/');
            % 			rep(ind) = '1';
            % 			rep = rep(end-8:end);
            % 			rep = bin2dec(rep);
        end
        
        DigBufferLen = 2.5e6;
        
        if ad2ver > 2
            %The index of the stimulus delivery, since AD2 data is not
            %initialized at the beginning of the pre-stim interval.
            %stim_point = fread(fid,1,'integer*4');
            for i = 1: length(chans)    % XPL stim_point is stored separately for each channel, e.g., if one is decimated, otherwise two channel data fread goes out of register
                stim_point(i) = fread(fid,1,'int32');
                if stim_point(i) > DigBufferLen     % buffer rollover correction wrongly applied because end of buffer rolled over, but stim point hadn't rolled over
                    stim_point(i) = stim_point(i) - (DigBufferLen+1);
                end
            end
        end
        %{
        if ad2ver > 2
            %The index of the stimulus delivery, since AD2 data is not
            %initialized at the beginning of the pre-stim interval.
            stim_point = fread(fid,1,'integer*4');
        end
        %}

        if ad2ver >= 2
            ch = fread(fid,1,'integer*1');
            if ch > 10 | ch < 1
                return
                % 				ch = dec2bin(ch);
                % 				ind = find(ch == '/');
                % 				ch(ind) = '1';
                % 				ch = ch(end-3:end);
                % 				ch = bin2dec(ch);
            end
        else
            ch = 1;
        end
        ad2len = fread(fid,1,'integer*4');
%{
        if ad2len > 1000000 | ad2len < 50 %This 40 second limit may not be appropriate in certain behavior conditions.
            %Trials may actually last longer than 40 seconds. Try running
            %some behavior files with a breakpoint here
            return
            % 			ad2len = dec2bin(ad2len);
            % 			ind = find(ad2len == '/');
            % 			ad2len(ind) = '1';
            % 			ad2len_old = ad2len;
            % 			ad2len = ad2len(end-19:end);
            % 			ad2len = bin2dec(ad2len);
        end
%}
        ad2data = fread(fid,ad2len,'integer*2');

        %disp(['Stim ' num2str(stim) ', rep ' num2str(rep)]);
        %drawnow

        data_info = [data_info; ch stim rep ad2len];

        trialnum = 1;
        if nargin==5 %only if user requested rep, otherwise let program run till end
            trialnum = find(trials == rep);
        end
        stimnum = find(stims == stim);
        chnum = find(chans == ch);
        try
            if ad2ver > 2
                %updated local get header so that it can output prestim
                if stim_point(ch)-floor((pre_stimulus_duration/1000)*new_sr(ch)) < 1
                    ad2data = [ad2data(1)*ones(1+floor((pre_stimulus_duration/1000)*new_sr(ch))-stim_point(ch),1); ad2data];
                    stim_point(ch) = stim_point(ch)+(1+floor((pre_stimulus_duration/1000)*new_sr(ch))-stim_point(ch));
                end
                ad2data = ad2data(stim_point(ch)-floor((pre_stimulus_duration/1000)*new_sr(ch)):end); %cut off data before pre stim.
                ad2data = ad2data(1:round((dur(stim)/1000)*new_sr(ch))); %cut off data after post stim.
            end
        catch
            disp(['ad2 fail:' num2str(data_info(end,:))]);
        end

        if length(trialnum)>0 & length(stimnum)>0 & length(chnum)>0
            switch mode
                case 'std'
                    len_diff = length(ad2data)-max(size(data{chnum}{stimnum},2));
                    if len_diff > 0 %zero pad data up to this point (not sure if this is necessary anymore after cutting off data after post stim)
                        data{chnum}{stimnum} = [data{chnum}{stimnum} [zeros(size(data{chnum}{stimnum},1),len_diff)]];
                    elseif len_diff < 0  %zero pad data that will be added (not sure if this is necessary anymore after cutting off data after post stim)
                        ad2data = [ad2data; zeros(-len_diff,1)];
                    end %if
                    data{chnum}{stimnum} = [data{chnum}{stimnum}; ad2data(1:end)'];
                    %*
                    % data{chnum}{stimnum}(round(50*rand(1,1))+1,1:length(ad2data(1:end))) = [ad2data(1:end)'];
                    %*
                case 'cts'
                    data{chnum}{1} = [data{chnum}{1}; ad2data(1:end)];
            end %switch
            got_data = got_data+1;          %Increment counter

        end	%if stim
        %* Just read till the end of the file regardless
        %         if got_data == needed_data          %Check if all data gathered is present
        %             quit = 1;
        %         end

    else
        quit = 1;
    end
end
fclose(fid);


if isempty(got_data ~= needed_data & quit ~= 2)
    disp('****** stims and reps not all found ******')
end

%* this block double commented by ei
% % %Consolidate data if appropriate
% % if length(chans) == 1 & length(stims) == 1
% % 	data = data{1}{1};
% % elseif length(chans) == 1
% % 	data = data{1};
% % elseif length(stims) == 1
% % 	for i=1:length(chans)
% % 		data{i}=data{i}{1};
% % 	end
% % end
%* this block double commented by ei

%Now set outputs
switch mode
    case 'std'              %Standard mode
        varargout{1} = data;
    case 'cts'
        if length(chans) == 1
            data = data{1};
        else
            for i=1:length(chans)
                data{i}=data{i}{1};
            end
        end
        varargout{1} = data;
    case 'hdr'
        varargout{1} = hdr;
    case 'short'
        varargout{1} = [ad2ver;nch;nstim;nrep;sr;dur];
end %switch

%Output sampling rate if requested
if nargout > 1
    varargout{2} = sr;
end

%Output presentation order if requested
if nargout > 2
    varargout{3} = data_info;
end

%Output header in addition to everything else if requested
if nargout > 3
    varargout{4} = hdr;
end

varargout{5} = pre_stimulus_duration;
varargout{6} = stdur;
varargout{7} = dateandtime;

return
%End get_ad2

function [ad2ver,nch,on_ch,nstim,nrep,sr,dur,ds,stdur,dateandtime_s,varargout] = local_getheaderinfo(hdr)

% Get Header Info Fxn:  Searches the header for relevant info

%First find the ad2 version (original/new), look on line 3
[s,r]=strtok(hdr{3},'% ');
if strcmpi(s,'Data')
    [t,s] = strtok(r,'=');
    s = strrep(s,'=','');
    s = str2num(s);
    if s >= 2.04 && s < 5
        ad2ver = 2;             %New version, multichan etc
    elseif s >= 5
        ad2ver = 3;
    end
else
    ad2ver = 1;             %Old version, singlechan
end

%Now scan the rest of the header
nch = []; nstim =[]; nrep = []; sr = []; stdur = []; ds = []; datetime = [];
for i=1:length(hdr)

    %Check line to see if its a stimulus designation
    [s,r]=strtok(hdr{i},'% ');               %HERE
    if strcmp(s,'Stimulus')
        %Get stim number
        [str,r]=strtok(r); t = str2num(str);
        if length(t) > 0
            nstim = t;
            if t==1                     %Get rep number
                for j=1:3
                    [str,r]=strtok(r);
                end
                nrep = str2num(str);

                %Get duration
                [str,r]=strtok(r);
                stdur = [stdur; str2num(str)];
            else
                %Get duration
                for j=1:4
                    [str,r]=strtok(r);
                end
                stdur = [stdur; str2num(str)];
            end
        end

    end

    %Check to see if it specifies the number of channels
    if strcmp(s,'#')
        nch = str2num(r(29));
    end

    %Check to see if it specifies on channels
    if findstr(r,'On Flags')
        [s,r]=strtok(r,'=');[s,r]=strtok(r);
        on_ch = str2num(r);
        on_ch = find(on_ch == 1);
    end

    %Check to see if it specifies sampling rate
    if strcmpi(s,'Analog')
        [s,r]=strtok(r,'=');[s,r]=strtok(r);
        sr = str2num(r);
    end

    %Check to see if it specifies pre/post stim record time
    if strcmpi(s,'Pre-stimulus')
        [s,r]=strtok(r,'=');[s,r]=strtok(r);
        pretime = str2num(r);
    end
    if strcmpi(s,'Post-stimulus')
        [s,r]=strtok(r,'=');[s,r]=strtok(r);
        posttime = str2num(r);
    end

    % Check for downsample factor
    if strcmpi(s,'Downsample')
        [s,r]=strtok(r,'=');[s,r]=strtok(r);
        ds = str2num(r);
    end
    
    % Check if it describes current date and time, first token is "Current"
    % XPL 10/3/2016
    if strcmpi(s,'Current')       
        [s,r] = strtok(r,'=');[s,r]=strtok(r);
        dateandtime_s = r;
    end
end

dur = stdur+posttime+pretime;
varargout{1} = pretime;

if ad2ver == 1
    nch =1;
    on_ch=1;
end

return
%End local_getheaderinfo
