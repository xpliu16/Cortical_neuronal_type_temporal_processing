function [q_opt, perc_correct_opt, perc_correct, z, H] =  call_classify (spk_ms, D, stim_len, pre_stim, post_stim, stims, reps, q, resp_stims, plotornot)
% Classify call responses based on VP distance implemented in dvpcrop.m

win_after_onset = 10;      % Analysis window
win_after_offset = 50;     

nshuffles = 100;   % For significance calculation

if exist('resp_stims')
    stims = intersect(resp_stims,stims);
end
 
nstims = length(stims);
nreps = length(reps);

i = 1;

for j = 1:nstims 
    for r = 1:nreps
        trains_stims{j} = spk_ms(spk_ms(:,1)==stims(j),:); 
        trains_all{i} = trains_stims{j}(trains_stims{j}(:,2)==reps(r),4); 
        trains_stims{j} = trains_stims{j}(:,4); 
        trains_stims{j} = trains_stims{j}(trains_stims{j}>((pre_stim+win_after_onset)));
        try
        trains_stims{j} = trains_stims{j}(trains_stims{j}<(pre_stim+stim_len(stims(j))+win_after_offset));
        catch
            display('foo');
        end 
        i = i+1;
    end
end

target = repmat(stims(:),1,nreps)';
target = target(:);   % Actual stimulus numbers
targetinds = repmat((1:nstims)',1,nreps)';
targetinds = targetinds(:);   % Relative stimulus numbers
resplen = repmat(stim_len(stims)-win_after_onset+win_after_offset,1,nreps)';
resplen = resplen(:);
output = zeros(nreps*nstims,200);
perc_correct = NaN(length(q),nhsims);
    
for s = 1:length(q)
        cost = q(s);
        perc_correct_temp = NaN(1,nhsims);
        conf_after_elim_temp = zeros(nstims,nstims,nhsims);
        eliminatedstims = cell(1,nhsims);

        [dist, eliminatedstimstmp] = dvpcrop(trains_all,target,trains_stims, resplen, pre_stim+win_after_onset,cost);
        conf = zeros(nstims);

        for i = 1:length(trains_all)
            val = min(dist(i,:));   % If multiple equal minimums, MATLAB "min" will take only first index, but we want to distribute credit evenly   
            inds = find(dist(i,:)==val);
            for k = 1:length(inds)
                conf(targetinds(i), inds(k)) = conf(targetinds(i), inds(k))+1/length(inds);
            end
        end

        conf_after_elim_temp(:,:,hsim) = conf(~ismember(stims,eliminatedstimstmp),~ismember(stims,eliminatedstimstmp));
        eliminatedstims{hsim} = eliminatedstimstmp;
       
        % Abramson 1963 transmitted information from confusion matrix
        tmp = 0;
        C = conf_after_elim_temp(:,:,hsim);
        C = C+0.0001;
        for a = 1:nstims
            for b = 1:nstims
                tmp = tmp + C(a,b)*(log(C(a,b))-log(sum(C(a,:)))-log(sum(C(:,b)))+log(length(trains_all)));
            end
        end
        H(s) = 1/length(trains_all)* tmp;
        perc_correct_temp(hsim) = trace(conf_after_elim_temp(:,:,hsim))/sum(sum(conf_after_elim_temp(:,:,hsim)));    

        eliminatedstims = eliminatedstims{1};
        conf_after_elim(:,:,s) = mean(conf_after_elim_temp,3);
        if plotornot
               figure
               heatmap(stims(~ismember(stims,eliminatedstims)), stims(~ismember(stims,eliminatedstims)), conf_after_elim(:,:,s));
               ylabel('Actual stimulus');
               xlabel('Assigned stimulus');
               title(['q=' num2str(q(s))]); 
        end   
        perc_correct(s,:) = perc_correct_temp;    % confirmed get the same from doing trace/sum(sum) on the averaged confusion matrix
        
       if cost == 1
           idx = eye(size(conf_after_elim(:,:,s)));
           [indsi,indsj] = find(conf_after_elim(:,:,s).*(1-idx)/length(reps)>0.2);    % High confusion pairs when mostly based on rate
           inds2 = find(conf_after_elim(:,:,s).*(1-idx)/length(reps)>0.2);
           indscorr = union(indsi,indsj);                                           % Compare to correct classifications on same set of stims
       end
end

for s = 1:length(q)
    slice = conf_after_elim(:,:,s);
    err = sum(slice(inds2))/length(inds2)/10;
    temp = diag(slice);
    corr = sum(temp(indscorr))/length(indscorr)/10;
    pairconf(s) = err/corr;
end
       
if plotornot
    figure;
    plot(q, pairconf);
end
    
perc_correct = mean(perc_correct,2)';

if plotornot
    figure
    plot(q, perc_correct)
    xlabel('cost(q)')
end

[val, ind] = max(perc_correct);   % If multiple equivalent values, it picks the first which is unfair
inds = find(perc_correct == val);
indtemp = median(inds);
perc_correct_opt = val;

if ~isequal(indtemp,round(indtemp)) % if inds is even, this version of MATLAB averages the two middle values for median, resulting possibly in fractional index
    ind(1)= floor(indtemp);
    ind(2)= ceil(indtemp);
else
    ind = indtemp;
end

    for sh = 1:nshuffles
       for i = 1:length(ind)
            conf_temp = conf_after_elim(randperm(size(conf_after_elim(:,:,ind(i)),1)),:,ind(i));
            perc_corr_shuff(sh,i) = trace(conf_temp)/sum(sum(conf_temp));
       end
    end

    for i = 1:length(ind)
        shuffmean(i) = mean(perc_corr_shuff(:,i));
        shuffstdev(i) = std(perc_corr_shuff(:,i));
        z(i) = (perc_correct_opt-shuffmean(i))/shuffstdev(i);
        if plotornot
            figure
            histogram(perc_corr_shuff(:,i));
            hold on
            line([perc_correct_opt, perc_correct_opt],[0 5], 'Color', 'r');
        end
        z = mean(z);
    end

perc = 2*(1-normcdf(z));
if perc > 0.05 || isnan(perc_correct_opt)
    q_opt = 'Poor Classification';
else
    q_opt = mean(q(ind));
end

