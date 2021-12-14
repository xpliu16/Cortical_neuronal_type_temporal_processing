file = 'M7E1224'; ch = 1; stims = 1:31; reps = 1:10;
%file = 'M7E3119'; ch = 3; stims = 1:31; reps = 1:2;
%file = 'M7E3060'; ch = 1; stims = 1:31; reps = 1:10;

%[traces,psth_cells,output] = plotad2 ({['C:\Experiments\' file(1:end-4) '\Ad2\' file '.ad2']}, stims, reps, 'spikes', 0, channel, 8, 0, 'extra', [file 'ch' num2str(channel)], 10, 0,1)           

options = struct('multispikes',0,'ms_after_peak',8,'plotornot',1);

[output] = spk_wave_ana ({['C:\Experiments\' file(1:end-4) '\Ad2\' file '.ad2']}, stims, reps, ch, options)

output
