function Pooledanalyses (ana_type, ploth)

% Pooledanalyses.m Final data analysis pooling multiple subjects
%
% Select analysis mode with ana_type, options are:
%    ana_type = 'Neuron type classification';
%    ana_type = 'SAM rate';
%    ana_type = 'Vocalization responses';
%    ana_type = 'Vocalization pop decode';
%    ana_type = 'Neuron type properties';
%    ana_type = 'Neuron type properties subpanel';
%    ana_type = 'Duration';
%
% Pass in optional plot handle

data_log_dir = 'C:/Users/Ping/Desktop/AC_type_project';
data_log_file = {[data_log_dir '/data/M7E_unit_log.xlsx']...
                ,[data_log_dir './data/M117B_unit_log.xlsx']};
decode_dir = 'C:/Users/Ping/Desktop/Analysis_practice/';      

mat_dir = 'C:/Users/Ping/Desktop/Analysis_practice/';
figdir = 'C:/Users/Ping/Desktop/Wang_lab/Paper_writing/Figures/';
xlsrange = {'A1:JZ657','A1:JZ400'};
animalID = {'M7E', 'M117B'};

clear eval;

pool_protocols = 1;    % Pool up to first 5 protocols per unit for AP waveform 
        
defcolors = [0, 0.4470, 0.7410; 0.95, 0.3250, 0.0980];
global RSColor FSColor BuColor PBuColor BuColorBright BuColor1 Bu1Color Bu2Color;
RSColor = [0.6350    0.0780    0.1840];
%FSColor = [0    0.4470    0.7410];
FSColor = [0    0.4    0.7410];
FSColor2 = [61 126 255]/255;
BuColor1 = [0.3725    0.5294    0.0549];
BuColor = [0.2392    0.5608    0.0784];
PBuColor = [0.7    0.84    0.4];
BuColorBright = [0.3    0.7608    0.0392];
nBuColor = [0.4940    0.1840    0.4940];

Bu1Color = BuColor;
Bu2Color = PBuColor;

figparams.fsize = 7;
figparams.res = 300;   % DPI
figparams.fontchoice = 'Arial';
set(0, 'DefaultAxesFontName', figparams.fontchoice);
fontstr = {'FontSize',figparams.fsize,'FontWeight','bold','FontName',figparams.fontchoice};
fontstr_l = {'FontSize',figparams.fsize+2,'FontWeight','bold','FontName',figparams.fontchoice};

switch ana_type
    case 'Neuron type classification'
        T_var = {'filestart',                   'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num';...
                    'spont_recalc',             'col_SpontRecalc',              'num';...
                    'acmetric',                 'col_acorrmetric',              'num';...
                    'peakmsISI',                'col_peakmsISI',                'num';...
                    'F50',                      'col_F50',                      'num';...
                    'TTP',                      'col_TTP',                      'num';...
                    'fracmeanISI',              'col_fracmean',                 'num';...
                    'refract',                  'col_refract',                  'num';...
                    'reg_parikh',               'col_reg_parikh',               'num';...
                    'ISImetric',                'col_ISImetric',                 'num';...
                    'percISI5',                 'col_percISI5',                 'num';...
                    'dip_pval',                 'col_dip_p',                    'num';...
                    'percISI5ratio',            'col_percISI5ratio',            'num';...
                    'logISIdrop',               'col_logISIdrop',               'num';...
                    'groupIDcrit',              'col_groupIDcrit',              'string';...
                    'CImax',                    'col_CImax',                    'num';...
                    'mean_burst_length',        'col_mean_burst_len',           'num';...
                    'max_burst_length',         'col_max_burst_len',            'num';...        
                    'max_firing_rate',          'col_max_firing_rate',          'num';...
                    'HAD',                      'col_HAD',                      'num';...
                    'burster_prestim',          'col_logISIdropBurst_prestim',  'num';...
                    'CV',                       'col_CV',                       'num';...
                    'intraburst_freq',          'col_intraburst_freq',          'num';...
                    'groupnumcrit',             'col_groupnumcrit',             'num';...
                    'TTP_pooled',               'col_TTP_p',                    'num';...
                    'HAD_pooled',               'col_HAD_p',                    'num';...
                    'F50_pooled',               'col_F50_p',                    'num';...
                    'SNR_avg',                  'col_SNR',                      'num';...
                    'logISIdrop_prestim',       'col_logISIdrop_prestim',       'num';...
                    'dip_pval_cropped',         'col_dip_p_cropped',            'num';...
                    'adaptratio',               'col_adaptratio',               'num';...
                    'latency',                  'col_latency',                  'num';...
                    'latency_calc',             'col_latency_calc',             'num';...
                    'BRR',                      'col_BRR',                      'num';...
                    'ramp_slope',               'col_rampslope',                'num';...
                    'intraburst_freq_p',        'col_intraburst_freq_p',        'num';...
                    'depth',                    'col_depth',                    'num'};
   
    case 'SAM rate'
        T_var =     {'filestart',               'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num';...
                    'groupIDcrit',              'col_groupIDcrit',              'string';...
                    'groupIDgmm',               'col_groupIDgmm',               'string';...
                    'burster_prestim',          'col_logISIdropBurst_prestim',  'num';...
                    'VS',                       'col_VS',                       'vector';...
                    'rayleigh',                 'col_rayleigh',                 'vector';...
                    'maxVS',                    'col_maxVS',                    'num';...
                    'meanVS',                   'col_meanVS',                   'num';...
                    'maxsync',                  'col_maxsync',                  'num';...
                    'SAMtype4Hz',               'col_SAMtype4Hz',               'string';...
                    'SAMtype16Hz',              'col_SAMtype16Hz',              'string';...
                    'perhist',                  'col_perhist',                  'vector';...
                    'groupnumcrit',             'col_groupnumcrit',             'num';...
                    'intraburst_freq',          'col_intraburst_freq',          'num';...
                    'intraburst_freq_p',        'col_intraburst_freq_p',        'num';...
                    'SAM_driven',               'col_SAM_driven',               'vector';...
                    'Bu_sub',                   'col_Bu_sub',                   'num'};
               
    case 'Vocalization responses'
        T_var =     {'filestart',               'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num';...
                    'groupIDcrit',              'col_groupIDcrit',              'string';...
                    'groupIDgmm',               'col_groupIDgmm',               'string';...
                    'burster_prestim',          'col_logISIdropBurst_prestim',  'num';...
                    'SAMtype4Hz',               'col_SAMtype4Hz',               'string';...
                    'groupnumcrit',             'col_groupnumcrit',             'num';...
                    'q_opt',                    'col_q_opt',                    'num';...
                    'qs',                       'col_qs',                       'vector';...
                    'perc_corr',                'col_perc_corr',                'vector';...
                    'z_score',                  'col_z_score',                  'num';...
                    'q_opt_ctl',                'col_q_opt_ctl',                'num';...
                    'qs_ctl',                   'col_qs_ctl',                   'vector';...
                    'perc_corr_ctl',            'col_perc_corr_ctl',            'vector';...
                    'z_score_ctl',              'col_z_score_ctl',              'num';...
                    'CImax',                    'col_CImax',                    'num';...
                    'q_opt_tw',                 'col_q_opt_tw',                 'num';...
                    'qs_tw',                    'col_qs_tw',                    'vector';...
                    'perc_corr_tw',             'col_perc_corr_tw',             'vector';...
                    'z_score_tw',               'col_z_score_tw',               'num';...
                    'pairconf',                 'col_pairconf',                 'vector';...
                    'H',                        'col_H',                        'vector';...
                    'intraburst_freq_p',        'col_intraburst_freq_p',        'num';...
                    'Bu_sub',                   'col_Bu_sub',                   'num';...
                    'resp_stims_rate_len'       'col_rs_rate',                  'num';...
                    'resp_stims_PSTH_len'       'col_rs_PSTH',                  'num'};
                
    case 'Vocalization pop decode'
        T_var =     {'filestart',               'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num'};
                
    case 'Neuron type properties'
        T_var =     {'filestart',               'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num';...
                    'groupIDcrit',              'col_groupIDcrit',              'string';...
                    'groupIDgmm',               'col_groupIDgmm',               'string';...
                    'burster_prestim',          'col_logISIdropBurst_prestim',  'num';...
                    'groupnumcrit',             'col_groupnumcrit',             'num';...
                    'spont_recalc',             'col_SpontRecalc',              'num';...
                    'acmetric',                 'col_acorrmetric',              'num';...
                    'peakmsISI',                'col_peakmsISI',                'num';...
                    'F50',                      'col_F50',                      'num';...
                    'TTP',                      'col_TTP',                      'num';...
                    'fracmeanISI',              'col_fracmean',                 'num';...
                    'refract',                  'col_refract',                  'num';...
                    'reg_parikh',               'col_reg_parikh',               'num';...
                    'ISImetric',                'col_ISImetric',                'num';...
                    'percISI5',                 'col_percISI5',                 'num';...
                    'dip_pval',                 'col_dip_p',                    'num';...
                    'percISI5ratio',            'col_percISI5ratio',            'num';...
                    'logISIdrop',               'col_logISIdrop',               'num';...
                    'mean_burst_length',        'col_mean_burst_len',           'num';...
                    'max_burst_length',         'col_max_burst_len',            'num';...
                    'max_firing_rate',          'col_max_firing_rate',          'num';...
                    'spike_amp',                'col_spike_amp',                'num';...
                    'latency',                  'col_latency',                  'num';...
                    'p2mISI',                   'col_p2mISI',                   'num';...
                    'CV',                       'col_CV',                       'num';...
                    'MI',                       'col_MI',                       'num';...
                    'dip_pval_cropped',         'col_dip_p_cropped',            'num';...
                    'intraburst_freq',          'col_intraburst_freq',          'num'};
                
    case 'Neuron type properties subpanel'
        T_var =    {'filestart',                'col_fs_UM',                    'num';...
                    'channel',                  'col_ch_UM',                    'num';...
                    'groupIDcrit',              'col_groupIDcrit',              'string';...
                    'groupIDgmm',               'col_groupIDgmm',               'string';...
                    'groupnumcrit',             'col_groupnumcrit',             'num';...
                    'bf',                       'col_bf',                       'num';...
                    'depth',                    'col_depth',                    'num'};
        
    case 'Duration'
        T_var =   {'filestart',                 'col_fs_UM',                    'num';...
                   'channel',                   'col_ch_UM',                    'num';...
                   'groupIDcrit',               'col_groupIDcrit',              'string';...
                   'groupIDgmm',                'col_groupIDgmm',               'string';...
                   'burster_prestim',           'col_logISIdropBurst_prestim',  'num';...
                   'durations',                 'col_durations',                'vector';...
                   'PSTH_time1',                'col_PSTH_time1',               'vector';...
                   'PSTH_duration1',            'col_PSTH_duration1',           'vector';...
                   'PSTH_time2',                'col_PSTH_time2',               'vector';...
                   'PSTH_duration2',            'col_PSTH_duration2',           'vector';...
                   'PSTH_time3',                'col_PSTH_time3',               'vector';...
                   'PSTH_duration3',            'col_PSTH_duration3',           'vector';...
                   'PSTH_time4',                'col_PSTH_time4',               'vector';...    
                   'PSTH_duration4',            'col_PSTH_duration4',           'vector';...
                   'durations_ext',             'col_durations_ext',            'vector';...
                   'PSTH_time1_ext',            'col_PSTH_time1_ext',           'vector';...
                   'PSTH_duration1_ext',        'col_PSTH_duration1_ext',      'vector';...
                   'PSTH_time2_ext',            'col_PSTH_time2_ext',           'vector';...
                   'PSTH_duration2_ext',        'col_PSTH_duration2_ext',       'vector';...
                   'PSTH_time3_ext',            'col_PSTH_time3_ext',           'vector';...
                   'PSTH_duration3_ext',        'col_PSTH_duration3_ext',       'vector';... 
                   'PSTH_time4_ext',            'col_PSTH_time4_ext',           'vector';...
                   'PSTH_duration4_ext',        'col_PSTH_duration4_ext',       'vector';... 
                   'PSTH_time5_ext',            'col_PSTH_time5_ext',           'vector';...
                   'PSTH_duration5_ext',        'col_PSTH_duration5_ext',       'vector';... 
                   'PSTH_time6_ext',            'col_PSTH_time6_ext',           'vector';...
                   'PSTH_duration6_ext',        'col_PSTH_duration6_ext',       'vector';...
                   'adaptratio',                'col_adaptratio',               'num';...
                   'dur_mean_driven_rate_ext',  'col_dur_mean_driven_rate_ext', 'vector';...
                   'PSTH_time_ramp',            'col_PSTH_time_ramp',           'vector';...
                   'PSTH_ramprate1',            'col_PSTH_ramprate1',           'vector';...
                   'PSTH_ramprate2',            'col_PSTH_ramprate2',           'vector';...
                   'PSTH_ramprate3',            'col_PSTH_ramprate3',           'vector';...
                   'PSTH_ramprate4',            'col_PSTH_ramprate4',           'vector';...
                   'PSTH_ramprate5',            'col_PSTH_ramprate5',           'vector';...
                   'intraburst_freq',           'col_intraburst_freq',          'num';...
                   'Bu_sub',                    'col_Bu_sub',                   'num'};  
end

T_var = array2table(T_var,'VariableNames',{'varname','colnames','vartype'});

for i = 1:length(T_var.varname)
        switch T_var.vartype{i}
            case 'num'
                eval([T_var.varname{i} '= [];']);
            case 'string'
                eval([T_var.varname{i} '= {};']);
            case 'vector'
                eval([T_var.varname{i} '= [];']);
        end
end       
        
animal = [];
for i = 1:length(data_log_file)
    [dlUM_num, dlUM_txt, dlUM_raw{i}] = xlsread(data_log_file{i}, 'UnitMetaExtracellular', xlsrange{i});
    col_hole = find(cellfun (@(x) strcmp('hole',x), dlUM_raw{i}(1,:)));
    col_track = find(cellfun (@(x) strcmp('track',x), dlUM_raw{i}(1,:)));
    col_fs_UM = find(cellfun (@(x) strcmp('startFile',x), dlUM_raw{i}(1,:)));
    col_ch_UM = find(cellfun (@(x) strcmp('ch',x), dlUM_raw{i}(1,:)));
    col_rs = find(cellfun (@(x) strcmp('Responsive_Stims_Excited',x), dlUM_raw{i}(1,:)));
    col_rs_rate = find(cellfun (@(x) strcmp('Rate_resp_stims_exc',x), dlUM_raw{i}(1,:)));
    col_rs_PSTH = find(cellfun (@(x) strcmp('PSTH_resp_stims_exc',x), dlUM_raw{i}(1,:)));
    col_latency_UM = find(cellfun (@(x) strcmp('latency',x), dlUM_raw{i}(1,:)));    
    col_CImax = find(cellfun (@(x) strcmp('CImax',x), dlUM_raw{i}(1,:)));
    col_CIavg = find(cellfun (@(x) strcmp('CIavg',x), dlUM_raw{i}(1,:)));
    col_SpontCalc = find(cellfun (@(x) strcmp('SpontCalc',x), dlUM_raw{i}(1,:)));
    col_SpontRecalc = find(cellfun (@(x) strcmp('Spont_recalc',x), dlUM_raw{i}(1,:)));
    col_Sigma_Opt = find(cellfun (@(x) strcmp('Sigma_Opt',x), dlUM_raw{i}(1,:)));
    col_logISIdrop_prestim = find(cellfun (@(x) strcmp('logISIdrop_prestim',x), dlUM_raw{i}(1,:)));
    col_logISIdropBurst_prestim = find(cellfun (@(x) strcmp('logISIdropBurst_prestim',x), dlUM_raw{i}(1,:)));
    col_groupIDcrit = find(cellfun (@(x) strcmp('groupIDcriteria',x),dlUM_raw{i}(1,:)));
    col_groupnumcrit = find(cellfun (@(x) strcmp('groupnumcriteria',x),dlUM_raw{i}(1,:)));
    col_groupIDgmm = find(cellfun (@(x) strcmp('groupIDgmm',x), dlUM_raw{i}(1,:)));     % GMM written back to Excel from the GMM mode of this script
    col_BRR = find(cellfun (@(x) strcmp('Best ramp rate',x), dlUM_raw{i}(1,:)));
    col_rampslope = find(cellfun (@(x) strcmp('Ramp tuning slope',x), dlUM_raw{i}(1,:)));
    col_VS = find(cellfun (@(x) strcmp('Vector strength',x),dlUM_raw{i}(1,:)));
    col_maxVS = find(cellfun (@(x) strcmp('Max vector strength',x),dlUM_raw{i}(1,:)));
    col_meanVS = find(cellfun (@(x) strcmp('Mean vector strength',x),dlUM_raw{i}(1,:)));
    col_maxsync = find(cellfun (@(x) strcmp('Max Sync Frequency',x),dlUM_raw{i}(1,:)));
    col_SAMtype4Hz = find(cellfun (@(x) strcmp('SAM response type 4 Hz',x),dlUM_raw{i}(1,:)));
    col_SAMtype16Hz = find(cellfun (@(x) strcmp('SAM response type 16 Hz',x),dlUM_raw{i}(1,:)));
    col_perhist = find(cellfun (@(x) strcmp('Period histogram 2 Hz',x),dlUM_raw{i}(1,:)));
    col_SAM_driven = find(cellfun (@(x) strcmp('Driven rates',x),dlUM_raw{i}(1,:)));
    col_acorrmetric = find(cellfun (@(x) strcmp('Autocorr_metric',x),dlUM_raw{i}(1,:)));
    col_peakmsISI = find(cellfun (@(x) strcmp('Peak_ISI',x),dlUM_raw{i}(1,:)));
    col_F50 = find(cellfun (@(x) strcmp('Spike_F50',x),dlUM_raw{i}(1,:)));
    col_TTP = find(cellfun (@(x) strcmp('Trough-to-peak_ms',x),dlUM_raw{i}(1,:)));
    col_fracmean = find(cellfun (@(x) strcmp('Frac_mean_ISI',x),dlUM_raw{i}(1,:)));
    col_refract = find(cellfun (@(x) strcmp('Refractory_period',x),dlUM_raw{i}(1,:)));
    col_reg_parikh = find(cellfun (@(x) strcmp('Regularity',x),dlUM_raw{i}(1,:)));
    col_ISImetric = find(cellfun (@(x) strcmp('ISImetric',x),dlUM_raw{i}(1,:)));
    col_percISI5 = find(cellfun (@(x) strcmp('Percent_lt_5ms',x),dlUM_raw{i}(1,:)));
    col_dip_p = find(cellfun (@(x) strcmp('Hartigans_dip_pval',x),dlUM_raw{i}(1,:)));
    col_dip_p_cropped = find(cellfun (@(x) strcmp('Hartigans_dip_pval_cropped',x),dlUM_raw{i}(1,:)));
    col_percISI5ratio = find(cellfun (@(x) strcmp('Percent_lt_5ms_re_poisson',x),dlUM_raw{i}(1,:)));
    col_logISIdrop = find(cellfun (@(x) strcmp('Log(ISI)_drop',x),dlUM_raw{i}(1,:)));
    col_mean_burst_len = find(cellfun (@(x) strcmp('Mean_burst_length',x),dlUM_raw{i}(1,:)));
    col_max_burst_len = find(cellfun (@(x) strcmp('Max_burst_length',x),dlUM_raw{i}(1,:)));
    col_max_firing_rate = find(cellfun (@(x) strcmp('max_mean_firing_rate',x),dlUM_raw{i}(1,:)));
    col_HAD = find(cellfun (@(x) strcmp('Half_amplitude_duration',x),dlUM_raw{i}(1,:)));
    col_CV = find(cellfun (@(x) strcmp('Coefficient_of_variation',x),dlUM_raw{i}(1,:)));
    col_intraburst_freq = find(cellfun (@(x) strcmp('Intraburst_frequency',x),dlUM_raw{i}(1,:)));
    col_q_opt = find(cellfun (@(x) strcmp('q_Opt',x),dlUM_raw{i}(1,:)));
    col_qs = find(cellfun (@(x) strcmp('qs_tested',x),dlUM_raw{i}(1,:)));
    col_perc_corr = find(cellfun (@(x) strcmp('Perc_Correct_All',x),dlUM_raw{i}(1,:)));
    col_z_score = find(cellfun (@(x) strcmp('z-score',x),dlUM_raw{i}(1,:)));
    col_q_opt_ctl = find(cellfun (@(x) strcmp('q_Opt_calltype',x),dlUM_raw{i}(1,:)));
    col_qs_ctl = find(cellfun (@(x) strcmp('qs_tested_calltype',x),dlUM_raw{i}(1,:)));
    col_perc_corr_ctl = find(cellfun (@(x) strcmp('Perc_Correct_All_calltype',x),dlUM_raw{i}(1,:)));
    col_z_score_ctl = find(cellfun (@(x) strcmp('z-score_calltype',x),dlUM_raw{i}(1,:)));
    col_q_opt_tw = find(cellfun (@(x) strcmp('q_Opt_twitter',x),dlUM_raw{i}(1,:)));
    col_qs_tw = find(cellfun (@(x) strcmp('qs_tested_twitter',x),dlUM_raw{i}(1,:)));
    col_perc_corr_tw = find(cellfun (@(x) strcmp('Perc_Correct_All_twitter',x),dlUM_raw{i}(1,:)));
    col_z_score_tw = find(cellfun (@(x) strcmp('z-score_twitter',x),dlUM_raw{i}(1,:)));
    col_spike_amp = find(cellfun (@(x) strcmp('Peak-to-peak_ampl',x),dlUM_raw{i}(1,:)));
    col_latency = find(cellfun (@(x) strcmp('latency',x),dlUM_raw{i}(1,:)));
    col_latency_calc = find(cellfun (@(x) strcmp('latency_calc',x),dlUM_raw{i}(1,:)));
    col_p2mISI = find(cellfun (@(x) strcmp('Peak_to_mean_ISI',x),dlUM_raw{i}(1,:)));
    col_MI = find(cellfun (@(x) strcmp('Monotonicity Index',x),dlUM_raw{i}(1,:)));
    col_TTP_p = find(cellfun (@(x) strcmp('TTP_ms_pooled',x),dlUM_raw{i}(1,:)));
    col_HAD_p = find(cellfun (@(x) strcmp('HAD_pooled',x),dlUM_raw{i}(1,:)));
    col_F50_p = find(cellfun (@(x) strcmp('F50_pooled',x),dlUM_raw{i}(1,:)));
    col_SNR = find(cellfun (@(x) strcmp('SNR_avg_spike',x),dlUM_raw{i}(1,:)));
    col_dur_mean_driven_rate_ext = find(cellfun (@(x) strcmp('Durations mean driven rate extended',x),dlUM_raw{i}(1,:))); 
    col_durations = find(cellfun (@(x) strcmp('Durations',x),dlUM_raw{i}(1,:)));
    col_PSTH_time1 = find(cellfun (@(x) strcmp('PSTH_time1',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration1 = find(cellfun (@(x) strcmp('PSTH_duration1',x),dlUM_raw{i}(1,:)));
    col_PSTH_time2 = find(cellfun (@(x) strcmp('PSTH_time2',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration2 = find(cellfun (@(x) strcmp('PSTH_duration2',x),dlUM_raw{i}(1,:)));
    col_PSTH_time3 = find(cellfun (@(x) strcmp('PSTH_time3',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration3 = find(cellfun (@(x) strcmp('PSTH_duration3',x),dlUM_raw{i}(1,:)));
    col_PSTH_time4 = find(cellfun (@(x) strcmp('PSTH_time4',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration4 = find(cellfun (@(x) strcmp('PSTH_duration4',x),dlUM_raw{i}(1,:)));
    col_durations_ext = find(cellfun (@(x) strcmp('Durations_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time1_ext = find(cellfun (@(x) strcmp('PSTH_time1_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration1_ext = find(cellfun (@(x) strcmp('PSTH_duration1_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time2_ext = find(cellfun (@(x) strcmp('PSTH_time2_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration2_ext = find(cellfun (@(x) strcmp('PSTH_duration2_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time3_ext = find(cellfun (@(x) strcmp('PSTH_time3_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration3_ext = find(cellfun (@(x) strcmp('PSTH_duration3_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time4_ext = find(cellfun (@(x) strcmp('PSTH_time4_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration4_ext = find(cellfun (@(x) strcmp('PSTH_duration4_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time5_ext = find(cellfun (@(x) strcmp('PSTH_time5_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration5_ext = find(cellfun (@(x) strcmp('PSTH_duration5_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_time6_ext = find(cellfun (@(x) strcmp('PSTH_time6_extended',x),dlUM_raw{i}(1,:)));
    col_PSTH_duration6_ext = find(cellfun (@(x) strcmp('PSTH_duration6_extended',x),dlUM_raw{i}(1,:)));
    col_adaptratio = find(cellfun (@(x) strcmp('Adaptratio_all',x),dlUM_raw{i}(1,:)));
    col_pairconf = find(cellfun (@(x) strcmp('Pair_confusion_ratio',x),dlUM_raw{i}(1,:)));   
    col_H = find(cellfun (@(x) strcmp('H_information',x),dlUM_raw{i}(1,:)));   
    col_intraburst_freq_p = find(cellfun (@(x) strcmp('Intraburst_freq_prestim',x),dlUM_raw{i}(1,:)));
    col_PSTH_time_ramp = find(cellfun (@(x) strcmp('PSTH_time_ramp',x),dlUM_raw{i}(1,:)));
    col_PSTH_ramprate1 = find(cellfun (@(x) strcmp('PSTH_ramprate1',x),dlUM_raw{i}(1,:)));
    col_PSTH_ramprate2 = find(cellfun (@(x) strcmp('PSTH_ramprate2',x),dlUM_raw{i}(1,:)));
    col_PSTH_ramprate3 = find(cellfun (@(x) strcmp('PSTH_ramprate3',x),dlUM_raw{i}(1,:)));
    col_PSTH_ramprate4 = find(cellfun (@(x) strcmp('PSTH_ramprate4',x),dlUM_raw{i}(1,:)));
    col_PSTH_ramprate5 = find(cellfun (@(x) strcmp('PSTH_ramprate5',x),dlUM_raw{i}(1,:)));
    col_Bu_sub = find(cellfun (@(x) strcmp('Bu_sub',x),dlUM_raw{i}(1,:)));
    col_depth = find(cellfun (@(x) strcmp('depthRel',x),dlUM_raw{i}(1,:)));
    col_rayleigh = find(cellfun (@(x) strcmp('Rayleigh statistic',x),dlUM_raw{i}(1,:)));
    col_bf = find(cellfun (@(x) strcmp('bf',x),dlUM_raw{i}(1,:)));
    
    for j = 1:length(T_var.varname)
        toappend = eval(['dlUM_raw{i}(2:end,' T_var.colnames{j} ')']);   % first two rows is column heading
        
        switch T_var.vartype{j}
            case 'num'
                toappend(cellfun(@(x) ~isnumeric(x), toappend)) = {NaN};              
                toappend = cell2mat(toappend);
                try
                eval([T_var.varname{j} '= [' T_var.varname{j} '; toappend]' ]);
                catch
                    display('foo')
                end
            case 'string'
                eval([T_var.varname{j} '= [' T_var.varname{j} '; toappend]' ]);
            case 'vector'
                k = 1;
                nvector =[];
                while isempty(nvector)
                    try
                        temp = str2num(toappend{k});
                        if ~isempty(temp)
                            nvector = length(temp);
                        end
                        k = k+1
                    catch
                        k = k+1;
                    end
                end
                NaNvec = num2str(NaN(1,nvector));
                    
                toappend(cellfun(@(x) ~ischar(x), toappend)) = {NaNvec};
                toappend(cellfun(@(x) isempty(str2num(x)),toappend))={NaNvec};      % Deals with header line
                foo = cellfun(@(x) str2num(x),toappend,'UniformOutput',false);
                try
                    toappend = cell2mat(foo);
                catch
                    display('foo');
                end
                eval([T_var.varname{j} '= [' T_var.varname{j} '; toappend]' ]);
        end
                
    end
    
    animal = [animal; repmat({animalID{i}},size(filestart,1),1)];
    
    if strcmp(ana_type,'Vocalization pop decode')
        callhist_all = [];
        callhist_type_all = [];
        for i = 1:length(animalID)
            f = fullfile(decode_dir,[animalID{i},'_batch'],'decode_10ms.mat');
            load(f);
            callhist_all = cat(4,callhist_all, callhist);
            callhist_type_all = [callhist_type_all, callhist_type];
            clear('callhist');
            clear('callhist_type');
        end
    end
end

switch ana_type
    %% Simple population decoding
    case 'Vocalization pop decode'
       
        conf_all = popdecode(callhist_all, size(callhist_all,4), 0);
    
        % Subset Bu units
        
        n_units = [5,10,25,50,54];

        callhist_bu = [];
        for i = 1:size(callhist_all,4)
            if any(strcmp(callhist_type_all{i}, {'Burster_h','Burster_l'}))
                callhist_bu = cat(4,callhist_bu, callhist_all(:,:,:,i));
            end
        end
        temp = mean(callhist_bu(7,:,:,:),2);
        temp = squeeze(temp);
        figure;
        heatmap(temp');
            
        for k = 1:length(n_units)
            conf_bu = popdecode(callhist_bu, n_units(k), 0);
        end
        
        % Ended up going to Python
        % Load outputs from Python to make consistent figures in MATLAB
        load('C:\Users\Ping\Desktop\AC_type_project\MAT\decode_figdata.mat');
        decode_fig = figure;
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [12*0.3937, 11*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 12*0.3937, 11*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 12*0.3937, 11*0.3937]);
        lmargin = 0.1;
        rmargin = 0.05;
        intercol = 0.15;
        height = 0.35;
        width = height;
        intermini = 0.025;
       
        axd_A1 = axes(decode_fig,'Position',...
            [lmargin+0.04,0.55+(height-intermini)/2+intermini,...
            (width-intermini)/2,(height-intermini)/2]);
        imagesc(conf54_RS_mcc);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        set(gca,'XTick',[]);
        set(gca,'YTick',[1,10,20]);
        set(gca,'xaxisLocation','top');
        ylA1 = text('String','Actual','FontSize',figparams.fsize+1,...
            'FontName',figparams.fontchoice,'FontWeight','bold',...
            'Position',[-10, 23.0, 1.0],'Rotation',90,...
            'HorizontalAlignment','center');
        ylA1.Position(2)=23;
        xlabel('MCC');
        ylabel('RS');
        th1 = text('Units','normalized','Position', [-0.65,1.3],'String','A',fontstr_l{:});
        
        axd_A2 = axes(decode_fig,'Position',...
            [lmargin+(width-intermini)/2+intermini+0.04,...
            0.55+(height-intermini)/2+intermini,...
            (width-intermini)/2,(height-intermini)/2]);
        imagesc(conf54_RS_lda);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        set(gca,'xaxisLocation','top');
        xlabel('LDA');
          
        axd_A3 = axes(decode_fig,'Position',...
            [lmargin+0.04,0.55,...
            (width-intermini)/2,(height-intermini)/2]);
        imagesc(conf54_bu_mcc);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        set(gca,'XTick',[1,10,20]);
        set(gca,'YTick',[1,10,20]);
        %set(gca,'xaxisLocation','top');
        ylabel('Bu');
        xlh = text('String','Predicted','FontSize',figparams.fsize+1,...
            'FontName',figparams.fontchoice,'FontWeight','bold',...
            'Position',[23.0000,30,1.0],'HorizontalAlignment','center');
        
        axd_A4 = axes(decode_fig,'Position',...
            [lmargin+(width-intermini)/2+intermini+0.04,...
            0.55,...
            (width-intermini)/2,(height-intermini)/2]);
        imagesc(conf54_bu_lda);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        set(gca,'XTick',[1,10,20]);
        set(gca,'YTick',[]);
        
        axd_B = axes(decode_fig,'Position',...
            [lmargin+width+intercol+0.06,0.55,...
            width-0.02, height]);
        nunits_list = [10, 25, 54, 110, 160]
        hold on
        formatstr = {'-o','LineWidth',1.5,'MarkerSize',5};
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        plot(nunits_list(1:length(accu_bu)),accu_bu,formatstr{:},'Color',BuColor);
        plot(nunits_list(1:length(accu_RS)),accu_RS,formatstr{:},'Color',RSColor);
        plot(nunits_list(1:length(accu_mixed)),accu_mixed,formatstr{:},'Color',nBuColor);
        leg = legend({'Bu only', 'RS only', 'Mixed'},'Location','southeast',...
            'FontSize',figparams.fsize+1,'FontName',figparams.fontchoice);
        set(leg,'Box','off');
        yl = ylabel('Accuracy','FontSize',figparams.fsize+1,'FontWeight','bold',...
            'FontName',figparams.fontchoice,'Units','normalized',...
            'VerticalAlignment','middle');
        set(ylA1,'Units','normalized');
        yl.Position(1) = ylA1.Position(1)*axd_A1.Position(3)/axd_B.Position(3);
        xl = xlabel('Number of units','FontSize',figparams.fsize+1,'FontWeight','bold',...
            'FontName',figparams.fontchoice);
        set(xl,'Units','normalized','VerticalAlignment','middle');
        set(xlh,'Units','normalized');
        xl.Position(2)=xlh.Position(2)*axd_A3.Position(4)/axd_B.Position(4);
        xlim([0,170]);
        ylim([0,1]);
        desiredypos = th1.Position(2)*axd_A1.Position(4)+axd_A1.Position(2);
        th2 = text('Units','normalized','Position', [-0.31,(desiredypos-axd_B.Position(2))/axd_B.Position(4),0],'String','B',fontstr_l{:});
        
        axd_C = axes(decode_fig,'Position',...
            [lmargin+0.04,0.14,...
            width, height-0.12]);
        bar([1,2,3],[accu_RS(3),accu_RS_t_collapse(3),accu_RS_unit_collapse],...
            0.7,'FaceAlpha',0.6,'FaceColor',RSColor,'EdgeColor','none');
        hold on
        bar([5,6,7],[accu_bu(3),accu_bu_t_collapse(3),accu_bu_unit_collapse],...
            0.7,'FaceAlpha',0.6,'FaceColor',BuColor,'EdgeColor','none');
        yl = ylabel('Accuracy','FontSize',figparams.fsize+1,'FontWeight','bold',...
            'FontName',figparams.fontchoice,'VerticalAlignment','middle',...
            'Units','normalized');
        yl.Position(1) = ylA1.Position(1)*axd_A1.Position(3)/axd_C.Position(3);
        set(gca,'XTick',[1,2,3,5,6,7]);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        xticklabels({'Original','Avg time','Avg units','Original','Avg time','Avg units'});
        xtickangle(45);
        text(0.7, 0.95, 'Bu','FontSize',figparams.fsize,'FontName',figparams.fontchoice,...
            'FontWeight','bold','HorizontalAlignment','left','Color',BuColor);
        text(0.7, 0.85, 'RS','FontSize',figparams.fsize,'FontName',figparams.fontchoice,...
            'FontWeight','bold','HorizontalAlignment','left','Color',RSColor);
        desiredxpos = th1.Position(1)*axd_A1.Position(3)+axd_A1.Position(1);
        th3 = text('Units','normalized','Position', [(desiredxpos-axd_C.Position(1))/axd_C.Position(3),1.15,0],'String','C',fontstr_l{:});
        xlim([0.5 7.5]);
        
        axd_D = axes(decode_fig,'Position',...
            [lmargin+width+intercol+0.06,0.14,...
            width-0.02, height-0.12]);
        plot([5,10,25,50], [accu_bu5ms,accu_bu(3),accu_bu25ms,accu_bu50ms],...
            '-o','Color',BuColor,'LineWidth',1.5,'MarkerSize',5);
        hold on
        plot([5,10,25,50], [accu_RS5ms,accu_RS(3),accu_RS25ms,accu_RS50ms],...
            '-o','Color',RSColor,'LineWidth',1.5,'MarkerSize',5);
        set(gca,'FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        yl = ylabel('Accuracy','FontSize',figparams.fsize+1,'FontWeight','bold',...
            'FontName',figparams.fontchoice,'VerticalAlignment','middle',...
            'Units','normalized');
        yl.Position(1) = ylA1.Position(1)*axd_A1.Position(3)/axd_D.Position(3);
        xl = xlabel('Time bin (ms)','FontSize',figparams.fsize+1,'FontWeight','bold',...
            'FontName',figparams.fontchoice,'Units','normalized',...
            'VerticalAlignment','middle');
        xl.Position(2)=xlh.Position(2)*axd_A3.Position(4)/axd_D.Position(4);
        set(gca,'XTick',[5,10,25,50]);
        th4 = text('Units','normalized','Position', [-0.31,1.15,0],'String','D',fontstr_l{:});
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'box','off',...
            'TickDir','out');
        
        % Fig 8 is now fig 7, fig 9 is now fig 8
        print('C:\Users\Ping\Desktop\Wang_lab\Paper_writing\Figures\Fig 9\Fig9.tif','-dtiff',['-r' num2str(figparams.res)]);
        
    %% Neuron type classification
    case 'Neuron type classification'
    
    if pool_protocols
        TTP = TTP_pooled;
        F50 = F50_pooled;
        HAD = HAD_pooled;
    end
    for i = 1:length(filestart)
        if ~isnan(acmetric(i))
            a = sum([(acmetric(i) > 0.5), (peakmsISI(i) < 10), logISIdrop(i)>0.2]);
            if a==3
                burster(i) = 1;  
            elseif a <= 1
                burster(i) = 0;     
            elseif a ==2
                burster(i) = -1;    
            else
                burster(i) = NaN;   
            end
        else
            burster(i) = NaN;
        end

        if burster(i)==1     
            if intraburst_freq(i)>500
                groupIDcrit{i} = 'Burster_h';
                groupnumcrit(i) = 2;
            elseif intraburst_freq(i)<=500
                groupIDcrit{i} = 'Burster_l';
                groupnumcrit(i) = 6;
            else
                groupIDcrit{i} = 'Unclassified';
                groupnumcrit(i) = 4;
            end
        elseif isnan(burster(i))
            groupIDcrit{i} = 'Insufficient spikes';   
            % May also be it didn't have tone tuning protocol
            groupnumcrit(i) = 5;
        elseif burster(i) == -1
            %groupIDcrit{i} = 'Bursting ambiguous';
            groupIDcrit{i} = 'Unclassified';
            groupnumcrit(i) = 4;
        elseif (burster(i)==0) &(burster_prestim(i) == 1)    
            % contradiction - inspection shows at least many of these are missed bursters
            %groupIDcrit{i} = 'Bursting ambiguous';
            burster(i) = -1;
            groupIDcrit{i} = 'Unclassified';
            groupnumcrit(i) = 4;
        else     
            scoreFS = (TTP_pooled(i)<0.5) + (F50_pooled(i)>2000) + (spont_recalc(i)>5);   
            scoreRS = (TTP_pooled(i)>0.5) + (F50_pooled(i)<2000) + (spont_recalc(i)<3);
            if scoreFS >= 2
                groupIDcrit{i} = 'FS';
                groupnumcrit(i) = 1;
            elseif scoreRS >= 2
                groupIDcrit{i} = 'RS';
                groupnumcrit(i) = 3;
            else
                %groupIDcrit{i} = 'FS/RS ambiguous';
                groupIDcrit{i} = 'Unclassified';
                groupnumcrit(i) = 4;
            end
        end
    end

    % Find next blank column
    k = 1;
    for i = 1:length(data_log_file)
        nextColUM = max(find(cellfun(@(x)max(~isnan(x)), dlUM_raw{i}(1,:))))+1;
        while min(cellfun(@(x) max(isnan(x)), dlUM_raw{i}(:,nextColUM))) == 0
            nextColUM = nextColUM+1;
        end  
        dlUM_raw{i}{1,nextColUM+1} = 'groupIDcriteria';
        dlUM_raw{i}{1,nextColUM+2} = 'groupnumcriteria';
        for j = 2:length(dlUM_raw{i}(:,nextColUM))
            dlUM_raw{i}{j,nextColUM+1} = groupIDcrit{k};
            dlUM_raw{i}{j,nextColUM+2} = groupnumcrit(k);
            if isnan(dlUM_raw{i}{j,1})
                dlUM_raw{i}{j,nextColUM+1} = '';
                dlUM_raw{i}{j,nextColUM+2} = NaN;
            end
            k = k+1;    % Animals are concatenated for GMM input
        end
        
        formatOut = 'yyyymmdd';
        str = datestr(now,formatOut);
        str = [str '_batch_pooled_GMM'];
        if length(str)>25
            str_trunc = str(1:21);
        else
            str_trunc = str(1:end-5);
        end
        new_data_log = [data_log_file{i}(1:end-5) '_MATLAB_' str_trunc '.xlsx'];
        xlswrite(new_data_log, dlUM_raw{i},'UnitMetaExtracellular'); 
    end
    
    TTP_nb_len = length(find(~isnan(TTP(burster==0))));
    omitted_nb_len = length(find((TTP(burster==0)>1.6)));
    omitted_perc = omitted_nb_len/TTP_nb_len; 
    TTP(find(isoutlier(TTP)));    % Median Absolute Deviation
    
    inds1 = find((burster_prestim==1) & (intraburst_freq_p>500));
    inds2 = find((burster_prestim==1) & (intraburst_freq_p<=500));
    Buinds_prestim = union(inds1,inds2);
    Buinds = find((groupnumcrit == 2) | (groupnumcrit == 6));
    groupIDcrit_plusprestim = [groupIDcrit; repmat({'Prestim burster1'},length(inds1),1)];
    groupIDcrit_plusprestim = [groupIDcrit_plusprestim; repmat({'Prestim burster2'},length(inds2),1)];
    groupIDcrit_plusprestim(cellfun(@(x) ~ischar(x),groupIDcrit_plusprestim)) = {''};  
    CImax_plusprestim = [CImax; CImax(inds1); CImax(inds2)];
    groupnumcrit_plusprestim = [groupnumcrit; 7*ones(length(find((burster_prestim==1))),1)]; 
    
    supp_spont = figure;
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [17.2*0.3937, 5.5*0.3937]);
    set(gcf,'PaperPositionMode','manual')
    set(gcf,'PaperPosition', [0 0 17.2*0.3937, 5.5*0.3937]);
    set(gcf,'Units','inches');
    set(gcf,'Position',[0 0 17.2*0.3937, 5.5*0.3937]);
    lmargin = 0.06;
    rmargin = 0.05;
    intercol = 0.075;
    
    ax2_1 = axes(supp_spont,'Position',[lmargin,0.2,(1-lmargin-rmargin-3*intercol)/4, 0.65]);
    plot_raster ({'M117B0636'}, 4, '11:26', '1:10', '', '', '', 'single', 1, 0, 0, [], ax2_1, 1,'diamond',1);
    ax2_1.Position(4) = 0.8*ax2_1.Position(4); 
    rectangle('Position',[520,(24-11)+0.1*(7-1)-0.2,40,0.1+0.4],'EdgeColor',RSColor,'LineWidth',1);
    rectangle('Position',[509,(22-11)+0.1*(5-1)-0.2,40,0.1+0.4],'EdgeColor',FSColor,'LineWidth',1);
    ylabel('Frequency (kHz)');
    
    ax2_2 = axes(supp_spont,'Position',[ax2_1.Position(1), ax2_1.Position(2)+ax2_1.Position(4)+0.05,ax2_1.Position(3)*0.45, ax2_1.Position(4)*0.15/0.8]);
    plot_raster({'M117B0636'}, 4, '24', '7', '', '', '', 'single', 1, 0, 0, [], ax2_2, 1,'vertical tick',0.5);
    xlim([534 546]);
    ylim([0.2 0.6]);
    ax2_2.XColor = RSColor;
    ax2_2.YColor = RSColor;
    set(ax2_2,'xtick',[]);
    set(ax2_2,'ytick',[]);
    ax2_2.LineWidth = 1;
    box on
    %rectangle('Position',[534,(24-11)+0.1*7,12,0.1]);
    
    ax2_3 = axes(supp_spont,'Position',[ax2_1.Position(1)+ax2_1.Position(3)*0.55, ax2_1.Position(2)+ax2_1.Position(4)+0.05,ax2_1.Position(3)*0.45, ax2_1.Position(4)*0.15/0.8]);
    plot_raster({'M117B0636'}, 4, '22', '5', '', '', '', 'single', 1, 0, 0, [], ax2_3, 1,'vertical tick',0.5);
    xlim([523 535]);
    ylim([0.2 0.6]);
    plot([529 534],[0.25 0.25],'-k','LineWidth',2);
    text(mean([529, 534]), 0.35, '5 ms','FontName',figparams.fontchoice,'FontSize',figparams.fsize-1,'HorizontalAlignment','center');
    ax2_3.XColor = FSColor;
    ax2_3.YColor = FSColor;
    set(ax2_3,'xtick',[]);
    set(ax2_3,'ytick',[]);
    ax2_3.LineWidth = 1;
    box on
    
    mfilename = 'M117B0636';
    D = eval (mfilename);
    ch = 4;
    stims = 1:31;
    reps = 1:10;
    axes(ax2_1);
    col_freq = find(strcmp(D.stimulus_tags_ch1,' tone Hz'));
    freqs = D.stimulus_ch1(11:26,col_freq);
    yticks(0.5:5:19.5);
    yticklabels(round(freqs(1:5:20)/100)/10);
    
    [outputs, centers, N, centers2,N2,log_ISI_list,prestim_total_time,...
    nint] = spktr(D,mfilename,ch,stims,reps,0.2,50,'all',1,0,0); 
    ax2_4 = axes(supp_spont,'Position',[lmargin+ax2_1.Position(3)+intercol, 0.2,(1-lmargin-rmargin-ax2_1.Position(3))/3-0.05, 0.65]); 
    %bar(centers,N, 1,'FaceColor',FSColor,'FaceAlpha',0.7,'EdgeColor','none');
    bar([-1*fliplr(outputs.xautocorr) outputs.xautocorr],[fliplr(outputs.yautocorr) outputs.yautocorr],...
        1,'FaceColor',FSColor,'FaceAlpha',0.7,'EdgeColor','none');
    xlim([-20 20]);
    xticks(0:10:20);
    %yl = ylim;
    %ylim([yl(1) yl(2)*1.15]);
    xlabel('Time (ms)');
    ylabel('Counts');
    title('All epochs');
    [peaks(1),peakinds(1)] = max(outputs.yautocorr);
    
    [outputs, centers, N, centers2,N2,log_ISI_list,prestim_total_time,...
    nint] = spktr(D,mfilename,ch,stims,reps,0.2,50,'pre',1,0,0); 
    ax2_5 = axes(supp_spont,'Position',[lmargin+2*ax2_1.Position(3)+2*intercol, 0.2,(1-lmargin-rmargin-ax2_1.Position(3))/3-0.05, 0.65]); 
    bar([-1*fliplr(outputs.xautocorr) outputs.xautocorr],[fliplr(outputs.yautocorr) outputs.yautocorr],...
        1,'FaceColor',FSColor,'FaceAlpha',0.7,'EdgeColor','none');
    %xlim([0 log(16)]);
    xlim([-20 20]);
    xticks(0:10:20);
    %yl = ylim;
    %ylim([yl(1) yl(2)*1.15]);
    xlabel('Time (ms)');
    title('Pre-stimulus only');
    [peaks(2),peakinds(2)] = max(outputs.yautocorr);
    
    mfilename = 'M117B0645';
    D = eval (mfilename);
    stims = 1;
    reps = 1:10;
    [outputs, centers, N, centers2,N2,log_ISI_list,prestim_total_time,...
    nint] = spktr(D,mfilename,ch,stims,reps,0.2,50,'all',1,0,0); 
    ax2_6 = axes(supp_spont,'Position',[lmargin+3*ax2_1.Position(3)+3*intercol+0.01, 0.2,(1-lmargin-rmargin-ax2_1.Position(3))/3-0.05, 0.65]); 
    bar([-1*fliplr(outputs.xautocorr) outputs.xautocorr],[fliplr(outputs.yautocorr) outputs.yautocorr],...
       1,'FaceColor',FSColor,'FaceAlpha',0.7,'EdgeColor','none');
    %xlim([0 log(16)]);
    xlim([-20 20]);
    xticks(0:10:20);
    %yl = ylim;
    %ylim([yl(1) yl(2)*1.15]);
    xlabel('Time (ms)');
    title('100 s spontaneous');
    [peaks(3),peakinds(3)] = max(outputs.yautocorr);
    
    xshift = 0.06;
    yshift = 0.03;
    annotation('textbox',[ax2_1.Position(1)-xshift, 0.2+0.65+yshift, .05, .1],'String','A','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[ax2_4.Position(1)-xshift, ax2_4.Position(2)+ax2_4.Position(4)+yshift, .05, .1],'String','B','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[ax2_5.Position(1)-xshift+0.02, ax2_5.Position(2)+ax2_5.Position(4)+yshift, .05, .1],'String','C','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[ax2_6.Position(1)-xshift+0.01, ax2_6.Position(2)+ax2_6.Position(4)+yshift, .05, .1],'String','D','EdgeColor','none',fontstr_l{:});  
    
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out')
  
    print([figdir 'Supp/spont_burst.tif'],'-dtiff',['-r' num2str(figparams.res)]); 
    
    fig2 = figure;
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [17.2*0.3937, 10.5*0.3937]);
    set(gcf,'PaperPositionMode','manual')
    set(gcf,'PaperPosition', [0 0 17.2*0.3937, 10.5*0.3937]);
    set(gcf,'Units','inches');
    set(gcf,'Position',[0 0 17.2*0.3937, 10.5*0.3937]);
    figparams.msize = 6;
    lmargin = 0.1;
    xexpand = 0;
    yshrink = 0;

    axf2p1 = subplot(2,3,1);
    oldpos = get(axf2p1,'Position');
    xshift = lmargin-oldpos(1);
    set(axf2p1,'Position',oldpos.*[1 1 1 1]+[xshift 0 xexpand yshrink]);
    hold on
    gh1 = scatter(acmetric(burster==1), peakmsISI(burster==1), figparams.msize,'v','MarkerFaceColor','none','MarkerEdgeColor',BuColor);
    gh2 = scatter(acmetric(burster==0), peakmsISI(burster==0), figparams.msize,'o','MarkerFaceColor','none','MarkerEdgeColor',nBuColor);
    gh3 = scatter(acmetric(burster==-1), peakmsISI(burster==-1), figparams.msize,'x','MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);

    lh1 = ylabel('Peak ISI (ms)');
    set(gca,'YScale','log');
    set(gca,'ylim',[0.92 80]);      
    set(gca,'xlim',[-1.02 1.02]);
    set(gca,'XTick',[-1 -0.5 0 0.5 1]);
    set(gca,'YTick',[1 10]);
    set(gca,'TickLength',[0.02 0.025]); 
    xlabel('Autocorrelogram metric');
    set(lh1,'Units','inches');
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    plot([0.5 0.5], yl, '--', 'Color', [0.6 0.6 0.6]);
    plot(xl, [10 10], '--', 'Color', [0.6 0.6 0.6]);
    legend('Bursting','Non-bursting','Location',[0.145+xshift 0.585 0.093 0.086]);
    legend boxoff
    
    axf2p2 = subplot(2,3,2);
    oldpos = get(axf2p2,'Position');
    xshift2 = 0.04;   
    set(axf2p2,'Position',oldpos.*[1 1 1 1]+[xshift+xshift2+xexpand-0.04 0 xexpand yshrink]);
    hold on
    gh4 = scatter(logISIdrop(burster==1), peakmsISI(burster==1), figparams.msize,'v','MarkerFaceColor','none','MarkerEdgeColor',BuColor);
    gh5 = scatter(logISIdrop(burster==0), peakmsISI(burster==0), figparams.msize,'o','MarkerFaceColor','none','MarkerEdgeColor',nBuColor);
    gh6 = scatter(logISIdrop(burster==-1), peakmsISI(burster==-1), figparams.msize,'x','MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
    xlabel('logISIdrop'); 
    set(gca,'YScale','log');
    set(gca,'TickLength',[0.02 0.025]);  
    set(gca,'ylim',[0.92 80]);
    set(gca,'YTick',[1 10]);
    set(gca,'xlim',[-1.02 1.02]);
    set(gca,'XTick',[-1 -0.5 0 0.5 1]);
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    plot([0.2 0.2], yl, '--', 'Color', [0.6 0.6 0.6]);
    plot(xl, [10 10], '--', 'Color', [0.6 0.6 0.6]);
    
    oldpos = get(axf2p2,'Position');
    axf2p2b = axes(gcf,'Position',[oldpos(1)+oldpos(3)+0.02, oldpos(2), 0.22*oldpos(3), oldpos(4)]);
    edges = log(0.92):0.1:log(150);
    h = histogram(log(peakmsISI(burster==1)),edges,'DisplayStyle','stairs','EdgeColor',BuColor);
    hold on;
    h = histogram(log(peakmsISI(burster==0)),edges,'DisplayStyle','stairs','EdgeColor',nBuColor);
    set(gca,'xlim',[log(0.92) log(80)]);
    view(90,-90);
    [val, indtemp] = find(edges<log(100));
    maxind =max(indtemp);
    set(gca,'ylim',[0 1.1*max(h.Values(1:maxind))]);
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    box off
    
    axf2p3 = subplot(2,3,3);
    oldpos = get(axf2p3,'Position');
    set(axf2p3,'Position',oldpos.*[1 1 1 1]+[xshift+2*xshift2+2*xexpand+0.02 0 xexpand yshrink]);
    hold on
    gh4 = scatter(logISIdrop_prestim(burster==1),logISIdrop(burster==1), figparams.msize,'v','MarkerFaceColor','none','MarkerEdgeColor',BuColor);
    gh5 = scatter(logISIdrop_prestim(burster==0), logISIdrop(burster==0), figparams.msize,'o','MarkerFaceColor','none','MarkerEdgeColor',nBuColor);
    gh6 = scatter(logISIdrop_prestim(burster==-1), logISIdrop(burster==-1), figparams.msize,'x','MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
    lh3 = ylabel('logISIdrop');
    xlabel('logISIdrop pre-stimulus');  
    set(gca,'TickLength',[0.02 0.025]);
    set(gca, 'ylim',[-1.02 1.02]);
    set(gca, 'xlim',[-1.02 1.02]);
    yl = get(gca,'ylim');
    xl = get(gca,'xlim');
    plot([0.3 0.3], yl, '--', 'Color', [0.6 0.6 0.6]);
    plot(xl, [0.2 0.2], '--', 'Color', [0.6 0.6 0.6]);
    
    an = annotation('arrow');
    an.HeadStyle = 'cback1';
    arrowsize = 4;
    an.HeadLength = arrowsize;
    an.HeadWidth = arrowsize;
    an.LineWidth = 1.5;
    an.Color = [0.5 0.5 0.5];
    an.X = [0.91 0.97];
    an.Y = [0.72 0.72];
    an2 = annotation('textbox','String','PBu','Position',[0.9150 0.6200 0.1000 0.1000],'Color',[0.5 0.5 0.5],'EdgeColor','none','FontName',figparams.fontchoice,'FontSize',figparams.fsize);  
    
    R = corrcoef(logISIdrop_prestim, logISIdrop,'Rows','complete');
    r = R(1,2)   
    
    indsboth = find(~isnan(burster')& ~isnan(burster_prestim)& (burster'~=-1));
    length(indsboth)
    length(find(burster(indsboth)'==burster_prestim(indsboth)))
    temp = (burster(indsboth)'+burster_prestim(indsboth));
    length(find(temp==1))  
    
    ax(1) = subplot(2,3,4);
    lh4 = ylabel('Number of units');
    hold on
    oldpos = get(ax(1),'Position');
    set(ax(1),'Position',oldpos.*[1 1 0.4 0.4]+[xshift oldpos(4)*0.6+yshrink xexpand/2+0.02 yshrink]);
    edges = 0:1/14:2.2;
    h=histogram(TTP(burster==0),edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    set(gca,'xtick',[0 1 2]);
    set(ax(1),'XMinorTick','on');
    ax(1).XAxis.MinorTickValues = [0.5 1.5];
    set(gca,'TickLength',[0.05 0.025]);
    set(gca,'xlim',[0 2]); 
    set(gca,'ylim',[0 1.2*max(h.Values)]);
    set(lh4,'Units','inches');
    set(h,'EdgeColor','none');
    set(h,'FaceColor',nBuColor);
    set(h,'FaceAlpha', 0.45);    
    yl = get(gca,'ylim');
    plot([0.5 0.5], yl, '--', 'Color', [0.6 0.6 0.6]);
    
    [f,xi] = ksdensity(TTP(burster==0),centers,'Bandwidth',0.06);
    ph = plot(xi,f*h.BinWidth*sum(h.Values),'-r','LineWidth',1);
    ph.Color(4) = 0.5;
    
    nboot = 10000;   
    xpdf = sort(TTP(burster==0));
    xpdf = xpdf(~isnan(xpdf));
    [dip, dip_p_value_TTP_nb, xlow,xup]=HartigansDipSignifTest(xpdf,nboot);   
    
    oldpos = get(ax(1),'Position');
    ax(2) = axes('Position', oldpos-[0 0.2 0 0]);
    h2 = histogram(TTP(burster==1),edges);
    xlabel('{\it t}_T_T_P (ms)');
    set(gca,'xtick',[0 1 2]);
    set(ax(2),'XMinorTick','on');
    ax(2).XAxis.MinorTickValues = [0.5 1.5];
    set(gca,'xlim',[0 2]);
    set(gca,'ylim',[0 1.2*max(h2.Values)]);
    set(h2,'EdgeColor','none');
    set(h2,'FaceColor',BuColor);
    set(h2,'FaceAlpha', 0.45);
    set(gca,'TickLength',[0.05 0.025]);
    hold on
    
    [f,xi] = ksdensity(TTP(burster==1),centers,'Bandwidth',0.06);
    ph = plot(xi,f*h2.BinWidth*sum(h2.Values),'r-','LineWidth',1);
    ph.Color(4) = 0.5;
    
    xpdf = sort(TTP(burster==1));
    xpdf = xpdf(~isnan(xpdf));
    [dip, dip_p_value_TTP_b, xlow,xup]=HartigansDipSignifTest(xpdf,nboot);
    
    ax2(1) = axes('Position', oldpos+[0.14 0 0 0]);
    edges = 0:1/8:5;
    h3=histogram(F50(burster==0)/1000,edges);
    centers = (edges(1:end-1)+edges(2:end))/2;
    set(gca,'xtick',[0 2 4]);
    set(gca,'XMinorTick','on');
    ax2(1).XAxis.MinorTickValues = [1 3];
    set(gca,'xlim',[0 4.7]); 
    set(gca,'ylim',[0 1.2*max(h3.Values)]);
    set(h3,'EdgeColor','none');
    set(h3,'FaceColor',nBuColor);
    set(h3,'FaceAlpha', 0.45);
    set(gca,'TickLength',[0.05 0.025]);
    hold on
    yl = get(gca,'ylim');
    plot([2 2], yl, '--', 'Color', [0.6 0.6 0.6]);
    
    [f,xi] = ksdensity(F50(burster==0)/1000,centers,'Bandwidth',0.15);
    ph = plot(xi,f*h3.BinWidth*length(h3.Data),'r-','LineWidth',1);
    ph.Color(4) = 0.5;
    
    xpdf = sort(F50(burster==0));
    xpdf = xpdf(~isnan(xpdf));
    [dip, dip_p_value_F50_nb, xlow,xup]=HartigansDipSignifTest(xpdf,nboot);   
        
    oldpos = get(ax2(1),'Position');
    ax2(2) = axes('Position', oldpos-[0 0.2 0 0]);
    h4 = histogram(F50(burster==1)/1000,edges);
    xlabel('{\it f}_5_0 (kHz)');
    set(gca,'xtick',[0 2 4]);
    set(gca,'XMinorTick','on');
    ax2(2).XAxis.MinorTickValues = [1 3];
    set(gca,'xlim',[0 4.7]);
    set(gca,'ylim',[0 1.2*max(h4.Values)]);
    set(h4,'EdgeColor','none');
    set(h4,'FaceColor',BuColor);
    set(h4,'FaceAlpha', 0.45);
    set(gca,'TickLength',[0.05 0.025]);
    hold on
    
    [f,xi] = ksdensity(F50(burster==1)/1000,centers,'Bandwidth',0.15);
    ph = plot(xi,f*h4.BinWidth*length(h4.Data),'r-','LineWidth',1);    
    ph.Color(4) = 0.5;
    
    xpdf = sort(F50(burster==1));
    xpdf = xpdf(~isnan(xpdf));
    [dip, dip_p_value_F50_b, xlow,xup]=HartigansDipSignifTest(xpdf,nboot);   
    
    axf2p5 = subplot(2,3,5);
    oldpos = get(axf2p5,'Position');
    set(axf2p5,'Position',oldpos.*[1 1 1 1]+[xshift+xshift2+xexpand+0.03 yshrink xexpand yshrink]);
    TTPres = 0.0205;
    TTPjitter = TTP+0.5*TTPres*(1-2*rand(length(TTP),1));
    HADres = 0.0021/2;
    HADjitter = HAD+0.5*HADres*(1-2*rand(length(HAD),1));
    scatter(HADjitter(burster==0),TTPjitter(burster==0),figparams.msize,'MarkerFaceColor','none','MarkerFaceAlpha',0.3,'MarkerEdgeColor',nBuColor);
    xlabel('Half-amplitude duration (ms)');
    lh5 = ylabel('Trough-to-peak time (ms)');
    set(gca,'ylim',[0 1.4]);   
    set(gca,'xlim',[0 0.7]);
    set(gca,'TickLength',[0.02 0.025]); 
    xl = get(gca,'xlim');
    hold on
    
    axf2p6 = subplot(2,3,6);
    oldpos = get(axf2p6,'Position');
    set(axf2p6,'Position',oldpos.*[1 1 1 1]+[xshift+2*xshift2+2*xexpand+0.02 yshrink xexpand yshrink]);
    F50res = 15.65;
    F50jitter = F50+0.5*F50res*(1-2*rand(length(F50),1));
    scatter(F50jitter(burster==0)/1000,TTPjitter(burster==0),figparams.msize,'MarkerFaceColor','none','MarkerFaceAlpha',1,'MarkerEdgeColor',nBuColor);
    xlabel('{\it f}_5_0 (kHz)');
    lh6 = ylabel('Trough-to-peak time (ms)');
    set(gca,'ylim',[0 1.4]);
    set(gca,'xlim',[0 5]);
    set(gca,'TickLength',[0.02 0.025]); 
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off')
    xl = get(gca,'xlim');
    yl = get(gca,'ylim');
    hold on
    pause(2)
    
    posaxf2p4_1 = get(ax(1),'Position');
    posaxf2p1 = get(axf2p1,'Position');    
    posaxf2p4_1(1) = posaxf2p1(1); 
    set(ax(1),'Position',posaxf2p4_1);
    
    oldpos_label = get(lh4,'Position');
    oldpos_label(2) = -0.18;
    oldpos_label(1)= lh1.Position(1);
    set(lh4,'Position',oldpos_label);
    
    lh5.Units = 'normalized';
    lh3.Units = 'normalized';
    lh6.Units = 'normalized';
    newoffset = lh5.Position(1);
    lh5.Position(1) = newoffset;
    lh3.Position(1) = newoffset;
    lh6.Position(1) = newoffset;
    
    axf2p1.XRuler.TickLabelGapOffset = -0.5;
    
    annotation('textbox',[0.01 0.86 .05 .1],'String','A','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[.325 0.86 .05 .1],'String','B','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[.675 0.86 .05 .1],'String','C','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[.01 (posaxf2p4_1(2)+posaxf2p4_1(4))+(0.86-(posaxf2p1(2)+posaxf2p1(4))) .05 .1],'String','D','EdgeColor','none',fontstr_l{:});
    ha = annotation('textbox',[.355 (posaxf2p4_1(2)+posaxf2p4_1(4))+(0.86-(posaxf2p1(2)+posaxf2p1(4))) .05 .1],'String','E','EdgeColor','none',fontstr_l{:});
    annotation('textbox',[.67173 (posaxf2p4_1(2)+posaxf2p4_1(4))+(0.86-(posaxf2p1(2)+posaxf2p1(4))) .05 .1],'String','F','EdgeColor','none',fontstr_l{:});
    
    print([figdir 'Fig 2/Fig2open.tif'],'-dtiff',['-r' num2str(figparams.res)]); 
    
    fig4 = figure
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [17.2*0.3937, 11*0.3937]);
    set(gcf,'PaperPositionMode','manual')
    set(gcf,'PaperPosition', [0 0 17.2*0.3937, 11*0.3937]);
    set(gcf,'Units','inches');
    set(gcf,'Position',[0 0 17.2*0.3937, 11*0.3937]);
    figparams.msize = 2;
    figparams.res = 300;   % DPI
    lmargin = 0.075;
    xexpand = 0.04;
    yexpand = 0.01;
    
    X = [log(spont_recalc+0.005), acmetric, log(peakmsISI+0.001), F50, percISI5,logISIdrop, max_burst_length,log(max_firing_rate+0.01)]; 
    % Standardize
    X = X-mean(X,1,'omitnan');   
    X = X./std(X,1,'omitnan');
    ptsymb = {'s','^','o','x','+','d'};
    ptcolor = [[0 0 1];[1 0 0];[1 0 1];[0 0.7 0];[0 1 1]];
    ptfcolor = [FSColor;BuColor;RSColor;[0.7 0.7 0.7];[0 1 1];BuColor];   % Marker face color for makers with filling
    ptecolor = {'none','none','none',[0.7 0.7 0.7],'none','none'};   % Marker edge color
    regval = 0.001;

    T = array2table([groupnumcrit,X,(latency-nanmean(latency))/nanstd(latency)]);
    T.Properties.VariableNames = {'groupnumcrit','log_spont','acorr_metric','log_peakmsISI','F50','percISI5','logISIdrop','max_burst_length','log_max_firing_rate','latency'};  
    %currentFile = mfilename('fullpath');
    %[pathstr,~,~] = fileparts(currentFile);  
    cd(data_log_dir);
    writetable(T,'X_classify.csv');  
    
    % Use a bunch of random seeds, take seed with best AIC
    rng(0,'twister'); 
    [coeff,score,latent,tsquared,explained] = pca(X, 'Algorithm', 'als');
    coeff1 = coeff(:,1);
    coeff2 = coeff(:,2);
    coeff3 = coeff(:,3);
    pc1coord = X*coeff1;     
    pc2coord = X*coeff2;    
    pc3coord = X*coeff3; 
    
    figure(fig4);
    ax(1) = axes('Position',[0.0850, 0.528, 0.32, 0.432]);
    varname = {'Spont','Acorr metric','Peak ISI','{\it f}_5_0','Perc ISI < 5 ms','logISIdrop','Burst length','Max firing rate'};
    bp = biplot(coeff(:,1:2),'VarLabels',varname);
    set(findobj(bp,'tag','varline'),'Color',FSColor);
    set(findobj(bp,'tag','varmarker'),'Color',FSColor);
    xl = get(gca,'xlim');
    xl(2) = xl(2)*1.2;
    set(gca,'xlim',xl);
    set(findall(gca,'type','text'),'fontSize',figparams.fsize);
    xlabel('PC1',fontstr{:});
    lh = ylabel('PC2',fontstr{:});
    lh.Position(1) = -0.662;
    
    figure(fig4);
    ax(2) = axes('Position',[0.0850, 0.087, 0.15, 0.238]);
    plot(explained,'o-k','LineWidth',1.5,'MarkerSize',figparams.msize);
    set(ax(2),'ytick',[0 20 40 60 80 100]);
    set(ax(2),'yticklabels',{0 0.2 0.4 0.6 0.8 1});
    ylabel('Var explained',fontstr{:});
    xlabel('PCA component',fontstr{:});
    set(gca,'ylim',[0 100]);
    set(gca,'xlim',[0.5000    7.5000]);
    set(gca,'xtick',1:7);
    hold on
    plot(cumsum(explained),'o-','Color', [0.7 0.7 0.7],'LineWidth',1.5,'MarkerSize',figparams.msize);
    text(2.5,60,'Component',fontstr{:});
    text(2.5,50,'Cumulative','Color',[0.8 0.8 0.8],fontstr{:});
    
    Xred = [pc1coord,pc2coord,pc3coord];
   
    options = statset('MaxIter',5000,'TolFun',1e-7);
   
    AIC = zeros(1,20);
    for i = 1:20
        rng(i);
        GMModel_PCA = fitgmdist(Xred,3, 'Replicates',10,'RegularizationValue', regval,'Options',options);
        AIC(i) = GMModel_PCA.AIC;
        BIC(i) = GMModel_PCA.BIC;
    end
    [~,rngindex] = min(AIC);
    [~,rngindex2] = min(BIC);
    rng(rngindex);
    GMModel_PCA_AIC = fitgmdist(Xred,3,'Replicates',10,'RegularizationValue',regval,'Options', options);

    figure(fig4);
    ax(3) = axes('Position',[0.51, 0.45, 0.455, 0.543]);
    hold on
    firstgroup1 = min(find(groupnumcrit==1));
    firstgroup2 = min(find(groupnumcrit==2));
    firstgroup3 = min(find(groupnumcrit==3));
    firstgroup4 = min(find(groupnumcrit==4));   % Unclassified
    firstgroup6 = min(find(groupnumcrit==6));   % After burster split
    
    ptmsize = 10;
    for i = 1: length(pc1coord)
        if ~isnan(groupnumcrit(i))
            if i == firstgroup1
                hgroup1 = scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
                group1ID = groupIDcrit{i};
            elseif i == firstgroup2
                hgroup2 = scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
                group2ID = groupIDcrit{i};
            elseif i == firstgroup3
                hgroup3 = scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
                group3ID = groupIDcrit{i};
            elseif i == firstgroup4
                hgroup4 = scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
                group4ID = groupIDcrit{i};
            elseif i == firstgroup6
                hgroup6 = scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
                group6ID = groupIDcrit{i};
            else
                scatter3(pc1coord(i), pc2coord(i), pc3coord(i), ptmsize, ptsymb{groupnumcrit(i)},'MarkerFaceColor',ptfcolor(groupnumcrit(i),:),'MarkerEdgeColor',ptecolor{groupnumcrit(i)},'MarkerFaceAlpha',0.5);
            end
        end
    end
            
    height1 = (2*pi)^(-3/2)*(det(GMModel_PCA_AIC.Sigma(:,:,1)))^(-1/2);
    f1 = @(x,y,z) mvnpdf([x,y,z],GMModel_PCA_AIC.mu(1,:),GMModel_PCA_AIC.Sigma(:,:,1))-0.5*height1;
    interval = [-10 10 -10 10 -10 10];
    fp = fimplicit3(f1,interval,'EdgeColor','none','FaceAlpha',.25);
    
    height2 = (2*pi)^(-3/2)*(det(GMModel_PCA_AIC.Sigma(:,:,2)))^(-1/2);
    f2 = @(x,y,z) mvnpdf([x,y,z],GMModel_PCA_AIC.mu(2,:),GMModel_PCA_AIC.Sigma(:,:,2))-0.5*height2;
    interval = [-10 10 -10 10 -10 10];
    fp2 = fimplicit3(f2,interval,'EdgeColor','none','FaceAlpha',.25);
    
    height3 = (2*pi)^(-3/2)*(det(GMModel_PCA_AIC.Sigma(:,:,3)))^(-1/2);
    f3 = @(x,y,z) mvnpdf([x,y,z],GMModel_PCA_AIC.mu(3,:),GMModel_PCA_AIC.Sigma(:,:,3))-0.5*height3;
    interval = [-10 10 -10 10 -10 10];
    fp3 = fimplicit3(f3,interval,'EdgeColor','none','FaceAlpha',.25)
    
    set(gca,'xlim',[min(pc1coord) max(pc1coord)]);
    set(gca,'ylim',[min(pc2coord) max(pc2coord)]);
    set(gca,'zlim',[min(pc3coord) max(pc3coord)]);
    view(-165, -78);
    
    hleglines = [hgroup3,hgroup1,hgroup2,hgroup4];
    [h,icons] = legend(hleglines, group3ID, group1ID, group2ID, group4ID,'Location','Best');
    
    pos = h.Position;
    pos(1)=pos(1)+0.5*pos(3);
    h1 = annotation(fig4,'textbox',pos,'String',{'RS'},'Color',RSColor,'LineStyle','none','Units','normalized',fontstr{:});
    pos(2)=pos(2)-0.02;
    h2 = annotation(fig4,'textbox',pos,'String',{'FS'},'Color',FSColor,'LineStyle','none','Units','normalized',fontstr{:});
    pos(2)=pos(2)-0.02;
    h3 = annotation(fig4,'textbox',pos,'String',{'Bu'},'Color',BuColor,'LineStyle','none','Units','normalized',fontstr{:});
    pos(2)=pos(2)-0.02;
    h4 = annotation(fig4,'textbox',pos,'String',{'Unclassified'},'Color',[0.7 0.7 0.7],'LineStyle','none','Units','normalized',fontstr{:});
    delete(h);
        
    xlabel('PC1',fontstr{:});
    ylabel('PC2',fontstr{:});
    zlabel('PC3',fontstr{:});
    
    P = posterior(GMModel_PCA_AIC, Xred);
    
    uncategorized = zeros(size(P,1),1);
    
    for i = 1:size(P,1)
        [val,ind] = max(P(i,:));
        if any(isnan(P(i,:)))
            Y_PCA_AIC(i) = NaN;
        elseif val >= 2*max(P(i,setdiff(1:end,ind)))
            Y_PCA_AIC(i) = ind;
        else
            Y_PCA_AIC(i) = NaN;
            uncategorized(i) =1;     
        end
    end
    
    n_uncat = length(find(uncategorized))
    Bu1_2_inds = find(~cellfun(@(x) isempty(x), regexp(groupIDcrit,'Burster*')));
    
    figure
    subplot(3,1,1)
    histogram(Y_PCA_AIC(strcmp(groupIDcrit,'FS')),[0.5,1.5,2.5,3.5]);   
    set(gca,'xtick',[1,2,3]);
    ylabel('FS',fontstr{:});
    mean(Y_PCA_AIC(strcmp(groupIDcrit,'FS')))
    subplot(3,1,2)
    histogram(Y_PCA_AIC(Bu1_2_inds),[0.5,1.5,2.5,3.5]);   
    set(gca,'xtick',[1,2,3]);
    ylabel('Burster',fontstr{:});
    subplot(3,1,3)
    mean(Y_PCA_AIC(Bu1_2_inds))
    histogram(Y_PCA_AIC(strcmp(groupIDcrit,'RS')),[0.5,1.5,2.5,3.5]);   
    set(gca,'xtick',[1,2,3]);
    mean(Y_PCA_AIC(strcmp(groupIDcrit,'RS')))
    ylabel('RS',fontstr{:});
    xlabel('GMM assigned group',fontstr{:});
    p = GMModel_PCA_AIC.ComponentProportion
    
    [N,edges] = histcounts(Y_PCA_AIC(strcmp(groupIDcrit,'FS')),[0.5,1.5,2.5,3.5]);
    [~,FS_GMM_num] = max(N);

    [N,edges] = histcounts(Y_PCA_AIC(Bu1_2_inds),[0.5,1.5,2.5,3.5]);
    [~,Bu_GMM_num] = max(N);

    [N,edges] = histcounts(Y_PCA_AIC(strcmp(groupIDcrit,'RS')),[0.5,1.5,2.5,3.5]);
    [~,RS_GMM_num] = max(N);
    
    corr = length(find(Y_PCA_AIC(strcmp(groupIDcrit,'FS'))==FS_GMM_num))...
        +length(find(Y_PCA_AIC(Bu1_2_inds)==Bu_GMM_num))...
        +length(find(Y_PCA_AIC(strcmp(groupIDcrit,'RS'))==RS_GMM_num));   
    incorr = length(find(ismember(Y_PCA_AIC(strcmp(groupIDcrit,'FS')),[Bu_GMM_num,RS_GMM_num])))...
        +length(find(ismember(Y_PCA_AIC(Bu1_2_inds),[FS_GMM_num,RS_GMM_num])))...
        +length(find(ismember(Y_PCA_AIC(strcmp(groupIDcrit,'RS')),[Bu_GMM_num, FS_GMM_num])));
    accu_best_AIC = corr/(corr+incorr)      
    
    % First index is criteria label, Second index is
    % GMM label
    conf = [];
    conf(1,1) = length(find(Y_PCA_AIC(groupnumcrit==3)==RS_GMM_num));
    conf(1,2) = length(find(Y_PCA_AIC(groupnumcrit==3)==FS_GMM_num));
    conf(1,3) = length(find(Y_PCA_AIC(groupnumcrit==3)==Bu_GMM_num));
    conf(2,1) = length(find(Y_PCA_AIC(groupnumcrit==1)==RS_GMM_num));
    conf(2,2) = length(find(Y_PCA_AIC(groupnumcrit==1)==FS_GMM_num));
    conf(2,3) = length(find(Y_PCA_AIC(groupnumcrit==1)==Bu_GMM_num));
    conf(3,1) = length(find(Y_PCA_AIC(groupnumcrit==2)==RS_GMM_num));
    conf(3,2) = length(find(Y_PCA_AIC(groupnumcrit==2)==FS_GMM_num));
    conf(3,3) = length(find(Y_PCA_AIC(groupnumcrit==2)==Bu_GMM_num));
    
    conf_norm = conf./repmat(sum(conf,2),[1,3]);
    figure(fig4);
    ax(6) = axes('Position',[0.0850+0.24*3, 0.087, 0.21, 0.18]); 
    colormap('cool');
    imagesc(conf_norm);
    colorbar;
    set(gca,'XTick',[1,2,3],'XTickLabels',{'RS', 'FS', 'Bu'},fontstr{:});
    set(gca,'YTick',[1,2,3]);
    set(gca,'YTickLabels',{'RS', 'FS', 'Bu'},fontstr{:});
    set(gca,'xaxisLocation','top');
    xlabel('Labeled by GMM',fontstr{:});
    ylabel('Labeled by criteria',fontstr{:});
       
    % Burster separation 
    regval = 0.01;
   
    X_bur = [intraburst_freq(Buinds), logISIdrop(Buinds), latency(Buinds)];
    X_bur = X_bur-mean(X_bur,1,'omitnan');   % Standardize
    X_bur = X_bur./std(X_bur,1,'omitnan');
    Y_bur = [];

    for i = 1:20
        rng(i);
        GMModel_bur = fitgmdist(X_bur,2, 'Replicates',10,'RegularizationValue', regval,'Options',options);
        AIC(i) = GMModel_bur.AIC;
    end
    [~,rngindex] = min(AIC);
    rng(rngindex);
    GMModel_bur = fitgmdist(X_bur,2,'Replicates',10,'RegularizationValue',regval,'Options', options);

    P_bur = posterior(GMModel_bur, X_bur);
    
    for i = 1:size(P_bur,1)
        [val,ind] = max(P_bur(i,:));
        if val >= 2*max(P_bur(i,setdiff(1:end,ind)))
            Y_bur(i) = ind;
        else
            Y_bur(i) = NaN;
        end
    end
    Bu_sub = nan(length(latency),1);
    Bu_sub(Buinds)=Y_bur;
    
    if mean(intraburst_freq(Bu_sub==1)) < mean(intraburst_freq(Bu_sub==2))    % Invert labels for consistency with criteria-based classification
       Bu_sub = 3-Bu_sub; 
    end
    
    k = 1;
    % Find next blank column
    for i = 1:length(data_log_file)
        nextColUM = max(find(cellfun(@(x)max(~isnan(x)), dlUM_raw{i}(1,:))))+1;
        while min(cellfun(@(x) max(isnan(x)), dlUM_raw{i}(:,nextColUM))) == 0
            nextColUM = nextColUM+1;
        end  
        dlUM_raw{i}{1,nextColUM} = 'groupIDgmm';
        dlUM_raw{i}{1,nextColUM+1} = 'groupIDcriteria';
        dlUM_raw{i}{1,nextColUM+2} = 'groupnumcriteria';
        dlUM_raw{i}{1,nextColUM+3} = 'Bu_sub';
        for j = 2:length(dlUM_raw{i}(:,nextColUM))
            if Y_PCA_AIC(k)==RS_GMM_num
                dlUM_raw{i}{j,nextColUM} = 'RS';
            elseif Y_PCA_AIC(k)==FS_GMM_num
                dlUM_raw{i}{j,nextColUM} = 'FS';
            elseif Y_PCA_AIC(k)==Bu_GMM_num
                dlUM_raw{i}{j,nextColUM} = 'Burster';
            else
                dlUM_raw{i}{j,nextColUM} = 'Unclassified';
            end
            dlUM_raw{i}{j,nextColUM+1} = groupIDcrit{k};
            dlUM_raw{i}{j,nextColUM+2} = groupnumcrit(k);
            dlUM_raw{i}{j,nextColUM+3} = Bu_sub(k);
            if isnan(dlUM_raw{i}{j,1})
                dlUM_raw{i}{j,nextColUM} = '';
                dlUM_raw{i}{j,nextColUM+1} = '';
                dlUM_raw{i}{j,nextColUM+2} = NaN;
                dlUM_raw{i}{j,nextColUM+3} = NaN;
            end
            k = k+1;    % Animals are concatenated for GMM input
        end
        
        formatOut = 'yyyymmdd';
        str = datestr(now,formatOut);
        str = [str '_batch_pooled_GMM'];
        if length(str)>25
            str_trunc = str(1:21);
        else
            str_trunc = str(1:end-5);
        end
        new_data_log = [data_log_file{i}(1:end-5) '_MATLAB_' str_trunc '.xlsx'];
        xlswrite(new_data_log, dlUM_raw{i},'UnitMetaExtracellular'); 
    end
    
    rng(0,'twister'); 
    [coeff,score,latent,tsquared,explained,mu] = pca(X, 'Algorithm', 'als');
    
    coeff1 = coeff(:,1);
    coeff2 = coeff(:,2);
    coeff3 = coeff(:,3); 

    pc1coord = X*coeff1;
    pc2coord = X*coeff2;
    pc3coord = X*coeff3;

    Xred = [pc1coord,pc2coord,pc3coord];
    nreps = 50;
    temp =nan(1,nreps);
    temp2 =nan(1,nreps);
    for ncomp = 1:7
        for rep = 1:nreps
            
            GMModel_PCA = fitgmdist(Xred,ncomp, 'Replicates',10,'RegularizationValue', regval,'Options',options);
            temp(rep) = GMModel_PCA.BIC;
            temp2(rep) = GMModel_PCA.AIC;
       
            s = randsample(size(Xred,1),floor(size(Xred,1)/2));
            Xred_train = Xred(s,:);
            testinds = find(~ismember(1:size(Xred,1),s));
            testinds = testinds(1:length(s));  % Make same size, if there is an odd number of total points
            Xred_test = Xred(testinds,:);
            GMModel_PCA = fitgmdist(Xred_train,ncomp, 'Replicates',10,'RegularizationValue', regval,'Options',options);
            [P,nlogL_test(rep)] = posterior(GMModel_PCA, Xred_test);
            [P,nlogL_train(rep)] = posterior(GMModel_PCA, Xred_train);
        end
        BIC(ncomp) = mean(temp);
        AIC(ncomp) = mean(temp2);
  
        avg_nlogL_test(ncomp) = mean(nlogL_test);
        avg_nlogL_train(ncomp) = mean(nlogL_train);
    end
    
    ncomp = 1:7;
    figure(fig4);
    ax(4) = axes('Position',[0.0850+0.24, 0.087, 0.15, 0.238]); 
    hold on
    plot (ncomp, AIC(ncomp),'o-.','LineWidth',1.5,'MarkerSize',figparams.msize,'Color',[0.7 0.7 0.7]);
    set(gca,'xtick',ncomp);
    set(gca,'xlim',[0.5, 7.5]);
    xlabel('Number of clusters',fontstr{:});
    ylabel('Model AIC/BIC',fontstr{:});
    ax = gca;
    ax.YAxis.Exponent = 3;
    
    plot (ncomp, BIC(ncomp),'o-','LineWidth',1.5,'MarkerSize',figparams.msize,'Color','k');
    text(0.78,0.9,'BIC','Units','normalized',fontstr{:});
    text(0.78,0.8,'AIC','Color',[0.8 0.8 0.8],'Units','normalized',fontstr{:});
    
    ax(5) = axes('Position',[0.0850+0.24*2, 0.087, 0.158, 0.238]); 
    hold on
    plot(ncomp, avg_nlogL_train(ncomp),'o-k','LineWidth',1.5,'MarkerSize',figparams.msize);
    plot(ncomp, avg_nlogL_test(ncomp),'o-','LineWidth',1.5,'MarkerSize',figparams.msize,'Color',[0.7 0.7 0.7]);
    set(gca,'xtick',ncomp);
    set(gca,'xlim',[0.5, 7.5]);
    set(gca,'ylim',[min(avg_nlogL_train)-0.1*(max(avg_nlogL_train)-min(avg_nlogL_train)), max(avg_nlogL_train)+0.1*(max(avg_nlogL_train)-min(avg_nlogL_train))]);
    xlabel('Number of clusters',fontstr{:});
    ylabel('Neg log-likelihood',fontstr{:});
    text(0.41,0.9,'Training set','Units','normalized',fontstr{:});
    text(0.58,0.8,'Test set','Color',[0.8 0.8 0.8],'Units','normalized',fontstr{:});
    ax = gca;
    ax.YAxis.Exponent = 3;
    %legend('Training set', 'Test set');
    %legend boxoff
    
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off','TickLength',[0.04 0.025]);
    axes(ax(1));
    set(gca,'TickLength',[0.0200    0.0250]);
    
    haA = annotation(fig4,'textbox',[0.0087 0.9394 0.0507 0.0723],'String',{'A'},'LineStyle','none','Units','normalized',fontstr_l{:});
    haB = annotation(fig4,'textbox',[0.4989 0.9394 0.0507 0.0723],'String',{'B'},'LineStyle','none','Units','normalized',fontstr_l{:});
    haC = annotation(fig4,'textbox',[0.0087 0.32 0.05180 0.0723],'String',{'C'},'LineStyle','none','Units','normalized',fontstr_l{:});
    haD = annotation(fig4,'textbox',[0.2475 0.32 0.05180 0.0723],'String',{'D'},'LineStyle','none','Units','normalized',fontstr_l{:});
    haE = annotation(fig4,'textbox',[0.4864 0.32 0.05180 0.0723],'String',{'E'},'LineStyle','none','Units','normalized',fontstr_l{:});
    haF = annotation(fig4,'textbox',[0.7285 0.32 0.05180 0.0723],'String',{'F'},'LineStyle','none','Units','normalized',fontstr_l{:});
    
    print([figdir 'Fig 4/Fig4.tif'],'-dtiff',['-r' num2str(figparams.res)]);
        
    %% Response properties for Sinusoidal Amplitude Modulation
    case 'SAM rate'
    
    RSinds = strcmp(groupIDcrit,'RS');
    FSinds = strcmp(groupIDcrit,'FS');
    Bu1inds = strcmp(groupIDcrit,'Burster_h');
    Bu2inds = strcmp(groupIDcrit,'Burster_l');
    Buinds = (Bu1inds|Bu2inds);

    RSinds_gmm = strcmp(groupIDgmm,'RS');
    FSinds_gmm = strcmp(groupIDgmm,'FS');
    Buinds_gmm = strcmp(groupIDgmm,'Burster');
    Uncinds_gmm = strcmp(groupIDgmm,'Unclassified');
   
    inds1 = find((burster_prestim==1) & (intraburst_freq_p>500));
    inds2 = find((burster_prestim==1) & (intraburst_freq_p<=500));
    inds = [inds1; inds2];
   
    groupIDcrit(cellfun(@(x) ~ischar(x),groupIDcrit)) = {''}; 
    groupIDcrit_plusprestim = [groupIDcrit; repmat({'Prestim burster'},length(inds),1)];
    groupIDcrit_plusprestim = [groupIDcrit_plusprestim; repmat({'Burster_crit'},length(find(Buinds)),1)];
    groupIDcrit_plusprestim(cellfun(@(x) ~ischar(x),groupIDcrit_plusprestim)) = {''}; 
    groupIDgmm_plusprestim = [groupIDgmm; repmat({'Prestim burster'},length(inds),1)];
    groupIDgmm_plusprestim = [groupIDgmm_plusprestim; repmat({'Burster_crit'},length(find(Buinds)),1)];
    groupIDgmm_plusprestim(cellfun(@(x) ~ischar(x),groupIDgmm_plusprestim)) = {''}; 
    maxVS_plusprestim = [maxVS; maxVS(inds); maxVS(Buinds)];
    meanVS_plusprestim = [meanVS; meanVS(inds); meanVS(Buinds)];
    maxsync_plusprestim = [maxsync; maxsync(inds); maxsync(Buinds)];
    SAMtype4Hz_plusprestim = [SAMtype4Hz; SAMtype4Hz(inds); SAMtype4Hz(Buinds)];
    SAMtype16Hz_plusprestim = [SAMtype16Hz; SAMtype16Hz(inds); SAMtype16Hz(Buinds)];
    VS_plusprestim = [VS; VS(inds,:); VS(Buinds,:)];
    perhist_plusprestim = [perhist; perhist(inds,:); perhist(Buinds,:)];
    [~,max_nsync] = max(SAM_driven,[],2);
    max_nsync_plusprestim = [max_nsync; max_nsync(inds,:); max_nsync(Buinds,:)];
    Bu_sub_plusprestim = [Bu_sub; Bu_sub(inds); Bu_sub(Buinds)];
    
    PBuinds = find(strcmp(groupIDcrit_plusprestim,'Prestim burster'));
    Buinds_crit = find(strcmp(groupIDcrit_plusprestim,'Burster_crit'));
    
    nFS_ch_maxVS = length(find(~isnan(maxVS_plusprestim(FSinds))));    
    nRS_ch_maxVS = length(find(~isnan(maxVS_plusprestim(RSinds)))); 
    nBu2_ch_maxVS = length(find(~isnan(maxVS_plusprestim(Bu2inds))));
    nBu1_ch_maxVS = length(find(~isnan(maxVS_plusprestim(Bu1inds))));
    npreburst_maxVS = length(find(~isnan(maxVS_plusprestim(PBuinds))));
    
    SAMrates = [2,4,8,16,32,64,128,256,512];
    edges = linspace(0,2*pi,20);     % for period histogram
    centers = mean([edges(1:end-1);edges(2:end)]);
    
    maxVS_RS = maxVS_plusprestim(RSinds);
    maxVS_FS = maxVS_plusprestim(FSinds);
    maxVS_Bu1 = maxVS_plusprestim(Bu1inds);
    maxVS_Bu2 = maxVS_plusprestim(Bu2inds);
    
    % Levene test for equal variance (reject null)
    p = vartestn(maxVS(1:length(groupIDgmm)),groupIDgmm,'TestType','LeveneAbsolute')
    A = [groupIDcrit_plusprestim, groupIDgmm_plusprestim, num2cell(maxVS_plusprestim)];
    T = array2table(A);
    T.Properties.VariableNames = {'Group_crit','Group_gmm','maxVS'};
    %currentFile = mfilename('fullpath');
    %[pathstr,~,~] = fileparts(currentFile);  
    cd(data_log_dir);
    writetable(T,'maxVS.csv');     % Process in Python for Welch's ANOVA and Games-Howell post-hoc
       
    p1 = 0.001;
    p2 = 0.001;
    p3 = 0.0475;
    
    fig6 = figure;
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [17.2*0.3937, 14*0.3937]);
    set(gcf,'PaperPositionMode','manual')
    set(gcf,'PaperPosition', [0 0 17.2*0.3937, 14*0.3937]);
    set(gcf,'Units','inches');
    set(gcf,'Position',[0 0 17.2*0.3937, 14*0.3937]);
    figparams.fsize = 7;
    figparams.msize = 7;
    figparams.res = 300;  
    figparams.fontchoice = 'Arial';
    xshift = 0.05;
    xshift2 = -0.04;
    
    figure(fig6);
    ax1 = subplot(3,3,1);
    ax1.Position(3) = ax1.Position(3)*0.9;
    ax1.Position(1) = ax1.Position(1)+xshift2;
    violinplot(maxVS_plusprestim,groupIDcrit_plusprestim,'GroupOrder',{'RS','FS','Burster_h','Burster_l','Prestim burster','Unclassified','Insufficient spikes'});
    set(gca, 'YScale', 'linear');
    set(gca, 'xlim',[0.5,4.5]);
    ylabel('Maximum vector strength');
    set(gca, 'xticklabels',{'RS','FS','Bu1','Bu2', 'PBu', 'Unclassified'});
    set(gca, 'ylim',[-0.05 1.35]);
    hold on
    sigstar({[1 3],[2 3],[3 4]},[p1 p2 p3]);   
    set(findobj(ax1,'type','Scatter'),'SizeData',8);
    q = findobj(ax1,'type','Patch');   
    q(14).FaceColor = RSColor;
    q(12).FaceColor = FSColor;
    q(10).FaceColor = Bu1Color;
    q(8).FaceColor = Bu2Color;
    q(6).FaceColor = PBuColor;
    q2 = findobj(ax1,'type','Scatter'); 
    q2(28).MarkerFaceColor = RSColor;
    q2(24).MarkerFaceColor = FSColor;
    q2(20).MarkerFaceColor = Bu1Color;
    q2(16).MarkerFaceColor = Bu2Color;
    q2(12).MarkerFaceColor = BuColor;    
    q3 = findobj(ax1,'type','Line');
    q3(1).LineWidth = 1;
    q3(2).LineWidth = 1;
    q3(3).LineWidth = 1;
    q3(4).LineWidth = 1;
    q3(5).LineWidth = 1;
    
    nFS_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'FS'))),'Sync')));
    nRS_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'RS'))),'Sync')));
    nBu2_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_l'))),'Sync')));
    nBu1_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_h'))),'Sync')));
    nPBu_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Prestim burster'))),'Sync')));
    nFS_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'FS'))),'nSync')));
    nRS_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'RS'))),'nSync')));
    nBu2_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_l'))),'nSync')));
    nBu1_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_h'))),'nSync')));
    nPBu_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Prestim burster'))),'nSync')));

    fFS_sync = nFS_sync/(nFS_sync+nFS_nsync);
    fFS_nsync = nFS_nsync/(nFS_sync+nFS_nsync);
    fRS_sync = nRS_sync/(nRS_sync+nRS_nsync);
    fRS_nsync = nRS_nsync/(nRS_sync+nRS_nsync);
    fBu2_sync = nBu2_sync/(nBu2_sync+nBu2_nsync);
    fBu2_nsync = nBu2_nsync/(nBu2_sync+nBu2_nsync);
    fBu1_sync = nBu1_sync/(nBu1_sync+nBu1_nsync);
    fBu1_nsync = nBu1_nsync/(nBu1_sync+nBu1_nsync);
    fPBu_sync = nPBu_sync/(nPBu_sync+nPBu_nsync);
    fPBu_nsync = nPBu_nsync/(nPBu_sync+nPBu_nsync);
    
    nFS_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'FS'))),'Sync')));
    nRS_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'RS'))),'Sync')));
    nBu2_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_l'))),'Sync')));
    nBu1_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_h'))),'Sync')));
    nBu1_gmm_sync = length(find(strcmp(SAMtype16Hz_plusprestim(Bu_sub==1),'Sync')));
    nBu2_gmm_sync = length(find(strcmp(SAMtype16Hz_plusprestim(Bu_sub==2),'Sync'))); 
    nPBu_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Prestim burster'))),'Sync')));
    nFS_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'FS'))),'nSync')));
    nRS_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'RS'))),'nSync')));
    nBu2_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_l'))),'nSync')));
    nBu1_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Burster_h'))),'nSync')));
    nPBu_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDcrit_plusprestim,'Prestim burster'))),'nSync')));
    nBu1_gmm_nsync = length(find(strcmp(SAMtype16Hz_plusprestim(Bu_sub==1),'nSync')));
    nBu2_gmm_nsync = length(find(strcmp(SAMtype16Hz_plusprestim(Bu_sub==2),'nSync'))); 
    
    fFS_sync16 = nFS_sync16/(nFS_sync16+nFS_nsync16);
    fFS_nsync16 = nFS_nsync16/(nFS_sync16+nFS_nsync16);
    fRS_sync16 = nRS_sync16/(nRS_sync16+nRS_nsync16);
    fRS_nsync16 = nRS_nsync16/(nRS_sync16+nRS_nsync16);
    fBu2_sync16 = nBu2_sync16/(nBu2_sync16+nBu2_nsync16);
    fBu2_nsync16 = nBu2_nsync16/(nBu2_sync16+nBu2_nsync16);
    fBu1_sync16 = nBu1_sync16/(nBu1_sync16+nBu1_nsync16);
    fBu1_nsync16 = nBu1_nsync16/(nBu1_sync16+nBu1_nsync16);
    fPBu_sync16 = nPBu_sync16/(nPBu_sync16+nPBu_nsync16);
    fPBu_nsync16 = nPBu_nsync16/(nPBu_sync16+nPBu_nsync16);
    fBu1_gmm_sync16 = nBu1_gmm_sync/(nBu1_gmm_sync+nBu1_gmm_nsync);
    fBu2_gmm_sync16 = nBu2_gmm_sync/(nBu2_gmm_sync+nBu2_gmm_nsync);
    
    figure(fig6);
    ax4 = subplot(3,3,4);
    ax4.Position(3) = ax4.Position(3)*0.9; 
    ax4.Position(1) = ax4.Position(1)+xshift2;
    hold on
    y = [fRS_sync; fFS_sync; fBu1_sync; fBu2_sync; fPBu_sync];  
    H = bar([1,2,3,4,5],y,0.4);
    H.FaceColor = 'flat';
    H.CData = [RSColor;FSColor;Bu1Color; Bu2Color; PBuColor];
    H.FaceAlpha = 0.4;
    H.EdgeColor = [0.5 0.5 0.5];    
    set(gca,'XTick',[1,2,3,4,5],'xticklabels',{'RS','FS','Bu1','Bu2','PBu','Unclassified'});
    lh1 = ylabel('Fraction sync units (\geq 4Hz)');
    set(gca,'xlim',[0.5 4.5]);
    set(gca,'ylim',[0 1]);
    set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1]);
    ax4.Position(4) = 0.97*ax4.Position(4);
    
    figure(fig6);
    ax5 = subplot(3,3,5);
    ax5.Position(3) = ax5.Position(3)*0.9;
    ax5.Position(1) = ax5.Position(1)+xshift+xshift2;
    hold on
    y2 = [fRS_sync16; fFS_sync16; fBu1_sync16; fBu2_sync16; fPBu_sync16];  
    H2 = bar([1,2,3,4,5],y2,0.4);    
    H2.FaceColor = 'flat';
    H2.CData = [RSColor;FSColor;Bu1Color;Bu2Color;PBuColor];
    H2.FaceAlpha = 0.5;
    H2.EdgeColor = [0.5 0.5 0.5];
    set(gca,'XTick',[1,2,3,4,5]);
    set(gca,'ylim',[0 1]);
    set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1]);
    set(gca,'Xticklabels',{'RS','FS','Bu1','Bu2','PBu','Unclassified'});
    lh2 = ylabel('Fraction sync units (\geq16 Hz)');
    set(gca,'xlim',[0.5 4.5]);
    set(gca,'ylim',[0 1]);
    ax5.Position(4) = 0.97*ax5.Position(4);
   
    % tBMF
    [val,ind] = max(VS,[],2);
    %ind(val<=13.8) = NaN;   % Nonsignificant
    %ptfcolor = [FSColor;Bu1Color;RSColor;[1 1 1];[1 1 1];Bu2Color];
    ptfcolor = {FSColor;Bu1Color;RSColor;'none';'none';Bu2Color};
    VS_sig = nan(size(VS));
    tBMF = nan(size(rayleigh,1),1);
    for i = 1:length(ind)
        if length(rayleigh(i,~isnan(rayleigh(i,:)))>=13.8)>2
            VS_sig(i,rayleigh(i,:)>=13.8)=VS(i,rayleigh(i,:)>=13.8);
            indmin = max(ind(i)-1,1);
            indmax = min(ind(i)+1,length(SAMrates));
            weights{i} = VS_sig(i,indmin:indmax);
            %weighted = nan(1,length(VS_sub{i}));
            SAMind = indmin:indmax;
            %weights = VS_sub{i}(~isnan(VS_sub{i}));
            weighted = SAMind.*weights{i};
            indBMF(i) = sum(weighted,'omitnan')/sum(weights{i},'omitnan');
            tBMF(i) = 2^(indBMF(i));
        else
            tBMF(i) = NaN;
        end
        if~isnan(groupnumcrit(i))
            scatter(tBMF(i),maxsync(i),'MarkerFaceColor',ptfcolor{groupnumcrit(i)},'MarkerEdgeColor',[1 1 1]);
        end
        hold on
    end
    
    nanmean(tBMF(RSinds))
    nanstd(tBMF(RSinds))/sqrt(length(find(RSinds)))
    nanmean(tBMF(FSinds))
    nanstd(tBMF(FSinds))/sqrt(length(find(FSinds)))
    nanmean(tBMF(Bu1inds))
    nanstd(tBMF(Bu1inds))/sqrt(length(find(Bu1inds)))
    nanmean(tBMF(Bu2inds))
    nanstd(tBMF(Bu2inds))/sqrt(length(find(Bu2inds)))
    
    nanstd(tBMF(RSinds))/sqrt(length(find(~isnan(tBMF(RSinds)))))
    nanstd(tBMF(FSinds))/sqrt(length(find(~isnan(tBMF(FSinds)))))
    nanstd(tBMF(Bu1inds))/sqrt(length(find(~isnan(tBMF(Bu1inds)))))
    nanstd(tBMF(Bu2inds))/sqrt(length(find(~isnan(tBMF(Bu2inds)))))
    
    rayleigh_RS = rayleigh(RSinds & strcmp(SAMtype4Hz,'Sync'),:);
    rayleigh_FS = rayleigh(FSinds & strcmp(SAMtype4Hz,'Sync'),:);
    rayleigh_Bu1 = rayleigh(Bu1inds & strcmp(SAMtype4Hz,'Sync'),:);
    rayleigh_Bu2 = rayleigh(Bu2inds & strcmp(SAMtype4Hz,'Sync'),:);
     
    % Vector strength
    VS_RS = mean(VS_plusprestim(RSinds_gmm,:),1,'omitnan');
    VS_FS = mean(VS_plusprestim(FSinds_gmm,:),1,'omitnan');
    VS_Bu1 = mean(VS_plusprestim(Buinds_gmm &(Bu_sub==1),:),1,'omitnan');
    VS_Bu2 = mean(VS_plusprestim(Buinds_gmm &(Bu_sub==2),:),1,'omitnan');
    
    maxsync_RS = maxsync_plusprestim(RSinds);
    maxsync_FS = maxsync_plusprestim(FSinds);
    maxsync_Bu1 = maxsync_plusprestim(Bu1inds);
    maxsync_Bu2 = maxsync_plusprestim(Bu2inds);
    maxsync_PBu = maxsync_plusprestim(PBuinds);     
    
    VS_RS = mean(VS_plusprestim(RSinds,:),1,'omitnan');
    VS_FS = mean(VS_plusprestim(FSinds,:),1,'omitnan');
    VS_Bu2 = mean(VS_plusprestim(Bu2inds,:),1,'omitnan');
    VS_Bu1 = mean(VS_plusprestim(Bu1inds,:),1,'omitnan');
    VS_PBu = mean(VS_plusprestim(PBuinds,:),1,'omitnan');
    
    VS_RS_n = length(find(any(~isnan(VS_plusprestim(RSinds,:)),2)));      
    % You can have a NaN in a VS in any column due to absence of spikes; if absence of protocol, whole row is NaN
    VS_FS_n = length(find(any(~isnan(VS_plusprestim(FSinds,:)),2)));
    VS_Bu2_n = length(find(any(~isnan(VS_plusprestim(Bu2inds,:)),2)));
    VS_Bu1_n = length(find(any(~isnan(VS_plusprestim(Bu1inds,:)),2)));
    VS_PBu_n = length(find(any(~isnan(VS_plusprestim(PBuinds,:)),2)));
    
    VS_RS_stderr = std(VS_plusprestim(RSinds,:),'omitnan')/sqrt(VS_RS_n);    % std return standard dev on each column
    VS_FS_stderr = std(VS_plusprestim(FSinds,:),'omitnan')/sqrt(VS_FS_n);
    VS_Bu2_stderr = std(VS_plusprestim(Bu2inds,:),'omitnan')/sqrt(VS_Bu2_n);
    VS_Bu1_stderr = std(VS_plusprestim(Bu1inds,:),'omitnan')/sqrt(VS_Bu1_n);
    VS_PBu_stderr = std(VS_plusprestim(PBuinds,:),'omitnan')/sqrt(VS_PBu_n);
    
    figure(fig6);
    ax2 = subplot(3,3,2);
    ax2.Position(3) = ax2.Position(3)*0.9;
    ax2.Position(1) = ax2.Position(1)+xshift+xshift2;
    hold on
    errorbar(SAMrates,VS_RS,VS_RS_stderr,'-','Color',RSColor,'CapSize',3,'LineWidth',1);
    set(gca,'XScale','log');
    xlabel('SAM rate (Hz)','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    ylabel('Vector strength','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    
    errorbar(SAMrates,VS_FS,VS_FS_stderr,'-','Color',FSColor,'CapSize',3,'LineWidth',1);
    errorbar(SAMrates,VS_Bu2,VS_Bu2_stderr,'-','Color',Bu2Color,'CapSize',3,'LineWidth',1);
    errorbar(SAMrates,VS_Bu1,VS_Bu1_stderr,'-','Color',Bu1Color,'CapSize',3,'LineWidth',1);
   
    text('Units','normalized','Position',[0.67,0.93,0],'HorizontalAlignment','left','String',['RS (' num2str(VS_RS_n) ')'],'Color',RSColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.67,0.84,0],'HorizontalAlignment','left','String',['FS (' num2str(VS_FS_n) ')'],'Color',FSColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.67,0.75,0],'HorizontalAlignment','left','String',['Bu1 (' num2str(VS_Bu1_n) ')'],'Color',Bu1Color,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.67,0.66,0],'HorizontalAlignment','left','String',['Bu2 (' num2str(VS_Bu2_n) ')'],'Color',PBuColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    set(gca,'XTick',[1E0 1E1 1E2 1E3]);
    set(gca,'xlim',[1E0 1E3]);
    set(gca,'ylim',[-0.05 0.8]);

    figure(supp_Bu1_2)
    axes('Position',[0.1+2*(0.22+0.11), 0.6, 0.22, 0.35]);  
        
    VS_RS = mean(VS_plusprestim(RSinds_gmm,:),1,'omitnan');
    VS_FS = mean(VS_plusprestim(FSinds_gmm,:),1,'omitnan');
    VS_Bu1 = mean(VS_plusprestim(Bu_sub==1,:),1,'omitnan');
    VS_Bu2 = mean(VS_plusprestim(Bu_sub==2,:),1,'omitnan');
    
    VS_RS_n = length(find(any(~isnan(VS_plusprestim(RSinds_gmm,:)),2)));      
    VS_FS_n = length(find(any(~isnan(VS_plusprestim(FSinds_gmm,:)),2)));
    VS_Bu1_n = length(find(any(~isnan(VS_plusprestim(Bu_sub==1,:)),2)));
    VS_Bu2_n = length(find(any(~isnan(VS_plusprestim(Bu_sub==2,:)),2)));
     
    VS_RS_stderr = std(VS_plusprestim(RSinds,:),'omitnan')/sqrt(VS_RS_n);
    VS_FS_stderr = std(VS_plusprestim(FSinds,:),'omitnan')/sqrt(VS_FS_n);
    VS_Bu1_stderr = std(VS_plusprestim(Bu_sub==1,:),'omitnan')/sqrt(VS_Bu1_n);
    VS_Bu2_stderr = std(VS_plusprestim(Bu_sub==2,:),'omitnan')/sqrt(VS_Bu2_n);
    
    hold on
    errorbar(SAMrates,VS_RS,VS_RS_stderr,'-','Color',RSColor,'CapSize',3,'LineWidth',1.2);
    set(gca,'XScale','log');
    xlabel('SAM rate (Hz)','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    ylabel('Vector strength','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    
    errorbar(SAMrates,VS_FS,VS_FS_stderr,'-','Color',FSColor,'CapSize',3,'LineWidth',1.2);
    errorbar(SAMrates,VS_Bu2,VS_Bu2_stderr,'-','Color',Bu2Color,'CapSize',3,'LineWidth',1.2);
    errorbar(SAMrates,VS_Bu1,VS_Bu1_stderr,'-','Color',Bu1Color,'CapSize',3,'LineWidth',1.2);
    
    set(gca,'XTick',[1E0 1E1 1E2 1E3])
    set(gca,'xlim',[1E0 1E3]);
    yl = [-0.05 0.8];
    set(gca,'ylim',yl);
    inc = (yl(2)-yl(1))/0.5 *0.05;
    
    text(100,0.75,['RS (' num2str(VS_RS_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor);
    text(100,0.75-inc,['FS (' num2str(VS_FS_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor2);
    text(100,0.75-2*inc,['Bu1 (' num2str(VS_Bu1_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color);
    text(100,0.75-3*inc,['Bu2 (' num2str(VS_Bu2_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color);
    text('Units','normalized','Position',[-0.31,1+0.1*0.15/0.35],'String','C');
    
    axes('Position',[0.1, 0.1, 0.22, 0.35]);  
    hold on
    y2 = [fRS_sync16; fFS_sync16; fBu1_gmm_sync16; fBu2_gmm_sync16];  
    H2 = bar([1,2,3,4],y2,0.6);    
    H2.FaceColor = 'flat';
    H2.CData = [RSColor;FSColor;Bu1Color;Bu2Color];
    H2.FaceAlpha = 0.5;
    H2.EdgeColor = [0.5 0.5 0.5];
    set(gca,'XTick',[1,2,3,4],'XTickLabels',{'RS','FS','Bu1','Bu2'});
    set(gca,'ylim',[0 1]);
    set(gca,'xlim',[0.5 4.5]);
    set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1]);
    lh3 = ylabel('Fraction sync (\geq16 Hz)');
    lh3.Position(2) = 0.45;
    
    th1 = text(1,fRS_sync16+0.07,num2str(nRS_sync16+nRS_nsync16),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor,'HorizontalAlignment','center');
    th2 = text(2,fFS_sync16+0.07,num2str(nFS_sync16+nFS_nsync16),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor,'HorizontalAlignment','center');
    th3 = text(3,fBu1_gmm_sync16+0.07,num2str(nBu1_gmm_sync+nBu1_gmm_nsync),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color,'HorizontalAlignment','center');
    th4 = text(4,fBu2_gmm_sync16+0.07,num2str(nBu2_gmm_sync+nBu2_gmm_nsync),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color,'HorizontalAlignment','center');
    text('Units','normalized','Position',[-0.31,1+0.1*0.15/0.35],'String','D');
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');
    
    A = [groupIDcrit_plusprestim, groupIDgmm_plusprestim, num2cell(maxsync_plusprestim)];
    T = array2table(A);
    T.Properties.VariableNames = {'Group_crit','Group_gmm','msf'};
    %currentFile = mfilename('fullpath');
    %[pathstr,~,~] = fileparts(currentFile);    
    cd(data_log_dir);
    writetable(T,'maxsync.csv');     % Process in Python for Welch's ANOVA and Games-Howell post-hoc
    % Levene test for equal variance (reject null)
    p = vartestn(maxsync(1:length(groupIDgmm)),groupIDgmm,'TestType','LeveneAbsolute')  
    
    p9 = 0.0277;
    p10 = 0.0079;
    p11 = 0.0214;
    
    figure(fig6);
    ax3 = subplot(3,3,3);
    ax3.Position(3) = ax3.Position(3)*0.9; 
    ax3.Position(1) = ax3.Position(1)+2*xshift+xshift2;
    violinplot(maxsync_plusprestim,groupIDcrit_plusprestim,'GroupOrder',{'RS','FS','Burster_h','Burster_l','Prestim burster','Unclassified','Insufficient spikes'});
    set(gca, 'YScale', 'linear');
    set(gca, 'xlim',[0.5,4.5]);
    ylabel('Max Sync Rate (Hz)','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
    ax3.FontSize = figparams.fsize;
    xticklabels({'RS','FS','Bu1','Bu2', 'PBu', 'Unclassified'});
    yl = get(gca,'ylim');
    yl(2) = yl(2)*1.25;
    set(gca,'ylim',yl);
    hold on
    sigstar({[3 4],[1 3],[1 2]},[p9 p10 p11]);    
    set(findobj(ax3,'type','Scatter'),'SizeData',8);
    q = findobj(ax3,'type','Patch');   
    q(14).FaceColor = RSColor;
    q(12).FaceColor = FSColor;
    q(10).FaceColor = Bu1Color;
    q(8).FaceColor = Bu2Color;
    q(6).FaceColor = PBuColor;
    q2 = findobj(ax3,'type','Scatter'); 
    q2(28).MarkerFaceColor = RSColor;
    q2(24).MarkerFaceColor = FSColor;
    q2(20).MarkerFaceColor = Bu1Color;
    q2(16).MarkerFaceColor = Bu2Color;
    q2(12).MarkerFaceColor = BuColor;    
    q3 = findobj(ax3,'type','Line');
    q3(1).LineWidth = 1;
    q3(2).LineWidth = 1;
    q3(3).LineWidth = 1;
    q3(4).LineWidth = 1;
    q3(5).LineWidth = 1;
    
    perhist_RS = mean(perhist_plusprestim(RSinds,:),1,'omitnan');
    perhist_FS = mean(perhist_plusprestim(FSinds,:),1,'omitnan');
    perhist_Bu2 = mean(perhist_plusprestim(Bu2inds,:),1,'omitnan');
    perhist_Bu1 = mean(perhist_plusprestim(Bu1inds,:),1,'omitnan');
    perhist_PBu = mean(perhist_plusprestim(PBuinds,:),1,'omitnan');

    figure(fig6);
    ax6 = subplot(3,3,6);   % Dummy axis
    ax6.Position(3) = ax6.Position(3)*0.9; 
    ax6.Position(1) = ax6.Position(1)+2*xshift+xshift2;
    hold on
    intercol = 0.04;
    interrow = 0.06;
    
    ax6sub(4) = axes(fig6,'Position',[ax6.Position(1)+(ax6.Position(3)-intercol)/2+intercol, ax6.Position(2), (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_Bu2(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 9]);
    set(gca,'XTick',[0 pi 2*pi]);
    xticklabels({'0','\pi','2\pi'})
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','Bu2','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(3) = axes(fig6,'Position',[ax6.Position(1), ax6.Position(2), (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_Bu1(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    lh_rad = xlabel('Period (Rad)');
    set(gca,'ylim',[0 8]);
    set(gca,'XTick',[0 pi 2*pi]);
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    lh_ns = ylabel('Number of spikes','FontSize',figparams.fsize);
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','Bu1','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(2) = axes(fig6,'Position',[ax6.Position(1)+(ax6.Position(3)-intercol)/2+intercol, ax6.Position(2)+(ax6.Position(4)-interrow)/2+interrow, (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_FS(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 30]);
    set(gca,'XTick',[0 pi 2*pi]);
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','FS','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(1) = axes(fig6,'Position',[ax6.Position(1), ax6.Position(2)+(ax6.Position(4)-interrow)/2+interrow, (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_RS(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 6]);
    set(gca,'XTick',[0 pi 2*pi]);
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','RS','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');  
    
    linkaxes(ax6sub,'x');
    set(gca,'xlim',[0 2*pi]);
    
    units_all = {'M7E0133ch1', 'M7E1468ch1', 'M117B2357ch4', 'M117B3169ch4'};
    ax7d = subplot(3,3,7);   % Dummy axes
    ax7d.Position(3) = ax7d.Position(3)*0.9; 
    ax7d.Position(1) = ax7d.Position(1)+xshift2
    intracol = 0.03;
    width = ((ax6.Position(1)+ax6.Position(3)-ax4.Position(1))-3*intracol)/4;
    
    ax7 = axes(fig6,'Position',[ax4.Position(1) ax7d.Position(2)-0.03 width ax7d.Position(4)*0.85]); 
    unit = units_all{1};
    stims = '1:9';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig6, 1,'vertical tick',0.8);
    set(gca,'xlim',[400,1600]);
    set(gca,'YTick',0.5:1:8.5);
    set(gca,'yticklabels',num2cell(SAMrates(1,:)));
    ylabel('SAM rate (Hz)');
    set(gca,'XTick',[500,1500]);
    xlabel('Time (ms)');
    text('Position',[1700 11.8 0],'String','Synchronized (Bu1)','HorizontalAlignment','center','FontName',figparams.fontchoice,'FontSize',figparams.fsize+1,'FontWeight','bold');
    txh = text(0.5,1.1,{'Unit M7E0123ch1', 'BF 13.9 kHz, 48 dB'},'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
    
    ax8 = axes(fig6,'Position',[ax4.Position(1)+width+intracol ax7d.Position(2)-0.03 width ax7d.Position(4)*0.85]);
    unit = units_all{2};
    stims = '1:9';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig6, 1,'vertical tick',0.8);
    set(gca,'xlim',[400,1600]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[500,1500]);
    xlabel('Time (ms)');
    txh = text(0.5,1.1,{'Unit M7E1459ch1', 'BF 8.0 kHz, 48 dB'},'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center');  
    
    ax9 = axes(fig6,'Position',[ax4.Position(1)+2*(width+intracol) ax7d.Position(2)-0.03 width ax7d.Position(4)*0.85]); 
    unit = units_all{3};
    stims = '1:9';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig6, 1,'vertical tick',0.8);
    set(gca,'xlim',[400,1600]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[500,1500]);
    xlabel('Time (ms)');
    text('Position',[1700 11.8 0],'String','Non-synchronized tuned (RS)','HorizontalAlignment','center','FontName',figparams.fontchoice,'FontSize',figparams.fsize+1,'FontWeight','bold');
    txh = text(0.5,1.1,{'Unit M117B2351ch4', 'BF 1.0 kHz, 48 dB'},'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center');  
    
    ax10 = axes(fig6,'Position',[ax4.Position(1)+3*(width+intracol) ax7d.Position(2)-0.03 width ax7d.Position(4)*0.85]); 
    unit = units_all{4};
    stims = '1:9';
    plot_raster ({unit(1:end-3)}, str2num(unit(end)), stims, '1:10', '', '', '', 'single', 0, 0, 0, '', fig6, 1,'vertical tick',0.8);
    set(gca,'xlim',[400,1600]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[500,1500]);
    xlabel('Time (ms)');
    txh = text(0.5,1.1,{'Unit M117B3149ch4', 'BF 1.6 kHz, 48 dB'},'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center');  
    
    delete(ax7d);
    
    axes(ax1);
    txh = text('Units','normalized','Position',[-0.4 1.1 0],'String','A', fontstr_l{:});
    axes(ax2);
    txh2 = text('Units','normalized','Position',[-0.4 1.1 0],'String','B',fontstr_l{:});
    axes(ax3);
    txh3 = text('Units','normalized','Position',[-0.4 1.1 0],'String','C',fontstr_l{:});
    axes(ax4);
    txh4 = text('Units','normalized','Position',[-0.4 1.1 0],'String','D',fontstr_l{:});
    axes(ax5);
    txh5 = text('Units','normalized','Position',[-0.4 1.1 0],'String','E',fontstr_l{:});
    axes(ax6);
    txh6 = text('Units','normalized','Position',[-0.4 1.1 0],'String','F',fontstr_l{:});
    axes(ax7);
    txh7 = text('Units','normalized','Position',[-0.39*ax6.Position(3)/ax7.Position(3) 1.2 0],'String','G',fontstr_l{:});
      
    set(ax6,'Visible','off');
    delta = ax4.Position(2)-ax6sub(4).Position(2);
    ax4.Position(2) = ax6sub(4).Position(2);
    ax4.Position(4) = ax4.Position(4)+delta;
    ax5.Position(2) = ax6sub(4).Position(2);
    ax5.Position(4) = ax5.Position(4)+delta;
    ax1.Position(4) = ax1.Position(4)+delta;
    ax1.Position(2) = ax1.Position(2)-delta;
    ax2.Position(4) = ax2.Position(4)+delta;
    ax2.Position(2) = ax2.Position(2)-delta;
    ax3.Position(4) = ax3.Position(4)+delta;
    ax3.Position(2) = ax3.Position(2)-delta;
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'box','off','TickDir','out');
 
    lh1.Position(2) = 0.45;
    lh2.Position(2) = 0.45;
    lh_ns.Position(2) = 10.5;
    lh_rad.Position(1) = 8;
    
    print([figdir 'Fig 6/Fig6.tif'],'-dtiff',['-r' num2str(figparams.res)]);
    
    suppl = figure;  
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [17.2*0.3937, 9*0.3937]);
    set(gcf,'PaperPositionMode','manual')
    set(gcf,'PaperPosition', [0 0 17.2*0.3937, 9*0.3937]);
    set(gcf,'Units','inches');
    set(gcf,'Position',[0 0 17.2*0.3937, 9*0.3937]);
    figparams.fsize = 7;
    figparams.msize = 7;
    figparams.res = 300;   % DPI
    figparams.fontchoice = 'Arial';
    BuColorGMM = BuColorBright;
    BuColorCrit = BuColor;

    maxVS_RS = maxVS_plusprestim(RSinds_gmm);
    maxVS_FS = maxVS_plusprestim(FSinds_gmm);
    maxVS_Bu = maxVS_plusprestim(Buinds_gmm);
    maxVS_PBu = maxVS_plusprestim(PBuinds);
    maxVS_Bu_crit = maxVS_plusprestim(Buinds_crit);
   
    p1 = 0.001;
    p2 = 0.001;
    
    figure(suppl);
    ax1 = subplot(2,3,1);
    violinplot(maxVS_plusprestim,groupIDgmm_plusprestim,'GroupOrder',{'RS','FS','Burster','Prestim burster','Burster_crit'});
    set(gca, 'YScale', 'linear');
    set(gca,'xlim',[0.5,5.5]);
    ylabel('Maximum vector strength');
    nFS_ch_maxVS = length(find(~isnan(maxVS(FSinds_gmm))));    
    nRS_ch_maxVS = length(find(~isnan(maxVS_plusprestim(RSinds_gmm)))); 
    nBu_ch_maxVS = length(find(~isnan(maxVS_plusprestim(Buinds_gmm))));
    npreburst_maxVS = length(find(~isnan(maxVS_plusprestim(PBuinds))));
    nburst_maxVS = length(find(~isnan(maxVS_plusprestim(Buinds_crit))));
    xticklabels({'RS','FS','Bu','PBu','Bu_c_r_i_t'});
    set('ylim',[-0.05 1.35]);
    hold on
    sigstar({[2 3],[1 3]},[p1 p2]);   
    set(findobj(ax1,'type','Scatter'),'SizeData',8);
    q = findobj(ax1,'type','Patch');   
    q(10).FaceColor = RSColor;
    q(8).FaceColor = FSColor;
    q(6).FaceColor = BuColorGMM;
    q(4).FaceColor = PBuColor;
    q(2).FaceColor = BuColorCrit;
    q2 = findobj(ax1,'type','Scatter'); 
    q2(20).MarkerFaceColor = RSColor;
    q2(16).MarkerFaceColor = FSColor;
    q2(12).MarkerFaceColor = BuColorGMM;
    q2(8).MarkerFaceColor = PBuColor;
    q2(4).MarkerFaceColor = BuColorCrit;    
    q3 = findobj(ax1,'type','Line');
    q3(1).LineWidth = 1;
    q3(2).LineWidth = 1;
    q3(3).LineWidth = 1;
    q3(4).LineWidth = 1;
    q3(5).LineWidth = 1;
       
    nFS_sync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'FS'))),'Sync')));
    nRS_sync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'RS'))),'Sync')));
    nBu_sync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'Burster'))),'Sync')));
    nFS_nsync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'FS'))),'nSync')));
    nRS_nsync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'RS'))),'nSync')));
    nBu_nsync_gmm = length(find(strcmp(SAMtype4Hz(find(strcmp(groupIDgmm,'Burster'))),'nSync')));
    nPBu_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Prestim burster'))),'Sync')));
    nPBu_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Prestim burster'))),'nSync')));
    nBuCrit_sync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Burster_crit'))),'Sync')));
    nBuCrit_nsync = length(find(strcmp(SAMtype4Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Burster_crit'))),'nSync')));
    
    fFS_sync_gmm = nFS_sync_gmm/(nFS_sync_gmm+nFS_nsync_gmm);
    fFS_nsync_gmm = nFS_nsync_gmm/(nFS_sync_gmm+nFS_nsync_gmm);
    fRS_sync_gmm = nRS_sync_gmm/(nRS_sync_gmm+nRS_nsync_gmm);
    fRS_nsync_gmm = nRS_nsync_gmm/(nRS_sync_gmm+nRS_nsync_gmm);
    fBu_sync_gmm = nBu_sync_gmm/(nBu_sync_gmm+nBu_nsync_gmm);
    fBu_nsync_gmm = nBu_nsync_gmm/(nBu_sync_gmm+nBu_nsync_gmm);
    fPBu_sync = nPBu_sync/(nPBu_sync+nPBu_nsync);
    fPBu_nsync = nPBu_nsync/(nPBu_sync+nPBu_nsync);
    fBuCrit_sync = nBuCrit_sync/(nBuCrit_sync+nBuCrit_nsync);
    fBuCrit_nsync = nBuCrit_nsync/(nBuCrit_sync+nBuCrit_nsync);

    nFS_sync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'FS'))),'Sync')));
    nRS_sync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'RS'))),'Sync')));
    nBu_sync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'Burster'))),'Sync')));
    nPBu_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Prestim burster'))),'Sync')));
    nBuCrit_sync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Burster_crit'))),'Sync')));
    nFS_nsync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'FS'))),'nSync')));
    nRS_nsync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'RS'))),'nSync')));
    nBu_nsync16_gmm = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm,'Burster'))),'nSync')));
    nPBu_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Prestim burster'))),'nSync')));
    nBuCrit_nsync16 = length(find(strcmp(SAMtype16Hz_plusprestim(find(strcmp(groupIDgmm_plusprestim,'Burster_crit'))),'nSync')));
    
    fFS_sync16_gmm = nFS_sync16_gmm/(nFS_sync16_gmm+nFS_nsync16_gmm);
    fFS_nsync16_gmm = nFS_nsync16_gmm/(nFS_sync16_gmm+nFS_nsync16_gmm);
    fRS_sync16_gmm = nRS_sync16_gmm/(nRS_sync16_gmm+nRS_nsync16_gmm);
    fRS_nsync16_gmm = nRS_nsync16_gmm/(nRS_sync16_gmm+nRS_nsync16_gmm);
    fBu_sync16_gmm = nBu_sync16_gmm/(nBu_sync16_gmm+nBu_nsync16_gmm);
    fBu_nsync16_gmm = nBu_nsync16_gmm/(nBu_sync16_gmm+nBu_nsync16_gmm);
    fPBu_sync16 = nPBu_sync16/(nPBu_sync16+nPBu_nsync16);
    fPBu_nsync16 = nPBu_nsync16/(nPBu_sync16+nPBu_nsync16);
    fBuCrit_sync16 = nBuCrit_sync16/(nBuCrit_sync16+nBuCrit_nsync16);
    fBuCrit_nsync16 = nBuCrit_nsync16/(nBuCrit_sync16+nBuCrit_nsync16);

    figure(suppl);
    ax4 = subplot(2,3,4);
    hold on
    y = [fRS_sync_gmm; fFS_sync_gmm; fBu_sync_gmm; fPBu_sync; fBuCrit_sync];  
    H = bar([1,2,3,4,5],y,0.4);
    H.FaceColor = 'flat';
    H.CData = [RSColor;FSColor;BuColorGMM; PBuColor;BuColorCrit];
    H.FaceAlpha = 0.5;
    H.EdgeColor = [0.5 0.5 0.5];    
    set(gca,'XTick',[1,2,3,4,5]);
    xticklabels({'RS','FS','Bu','PBu','Bu_c_r_i_t'});
    lh1 = ylabel('Fraction sync units (\geq 4Hz)');
    set(gca,'xlim',[0.5 5.5]);
    set(gca,'ylim',[0 1]);
    set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1]);
    
    figure(suppl);
    ax5 = subplot(2,3,5);
    hold on
    y2 = [fRS_sync16_gmm; fFS_sync16_gmm; fBu_sync16_gmm; fPBu_sync16; fBuCrit_sync16];  
    H2 = bar([1,2,3,4,5],y2,0.4);    
    H2.FaceColor = 'flat';
    H2.CData = [RSColor;FSColor;BuColorGMM;PBuColor;BuColorCrit];
    H2.FaceAlpha = 0.5;
    H2.EdgeColor = [0.5 0.5 0.5];
    set(gca,'XTick',[1,2,3,4,5]);
    xticklabels({'RS','FS','Bu','PBu','Bu_c_r_i_t'});
    lh2 = ylabel('Fraction sync units (\geq16 Hz)');
    set(gca,'xlim',[0.5 5.5]);
    set(gca,'ylim',[0 1]);
    set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1]);
   
    VS_RS = mean(VS_plusprestim(RSinds_gmm,:),1,'omitnan');
    VS_FS = mean(VS_plusprestim(FSinds_gmm,:),1,'omitnan');
    VS_Bu = mean(VS_plusprestim(Buinds_gmm,:),1,'omitnan');
    VS_PBu = mean(VS_plusprestim(PBuinds,:),1,'omitnan');
    VS_BuCrit = mean(VS_plusprestim(Buinds_crit,:),1,'omitnan');
    
    VS_RS_n = length(find(max(~isnan(VS_plusprestim(RSinds_gmm,:)),[],2)));      
    VS_FS_n = length(find(max(~isnan(VS_plusprestim(FSinds_gmm,:)),[],2)));
    VS_Bu_n = length(find(max(~isnan(VS_plusprestim(Buinds_gmm,:)),[],2)));
    VS_PBu_n = length(find(max(~isnan(VS_plusprestim(PBuinds,:)),[],2)));
    VS_BuCrit_n = length(find(max(~isnan(VS_plusprestim(Buinds_crit,:)),[],2)));
    
    VS_RS_stderr = std(VS_plusprestim(RSinds_gmm,:),'omitnan')/sqrt(VS_RS_n);
    VS_FS_stderr = std(VS_plusprestim(FSinds_gmm,:),'omitnan')/sqrt(VS_FS_n);
    VS_Bu_stderr = std(VS_plusprestim(Buinds_gmm,:),'omitnan')/sqrt(VS_Bu2_n);
    VS_PBu_stderr = std(VS_plusprestim(PBuinds,:),'omitnan')/sqrt(VS_PBu_n);
    VS_BuCrit_stderr = std(VS_plusprestim(Buinds_crit,:),'omitnan')/sqrt(VS_BuCrit_n);
    
    figure(suppl);
    ax2 = subplot(2,3,2);
    hold on
    errorbar(SAMrates,VS_RS,VS_RS_stderr,'-','Color',RSColor,'CapSize',3,'LineWidth',1);
    set(gca,'XScale','log');
    xlabel('SAM rate (Hz)');
    ylabel('Vector strength');
    
    errorbar(SAMrates,VS_FS,VS_FS_stderr,'-','Color',FSColor,'CapSize',3,'LineWidth',1);
    errorbar(SAMrates,VS_Bu,VS_Bu_stderr,'-','Color',BuColorGMM,'CapSize',3,'LineWidth',1);
    errorbar(SAMrates,VS_PBu,VS_PBu_stderr,'-','Color',PBuColor,'CapSize',3,'LineWidth',1);
    errorbar(SAMrates,VS_BuCrit,VS_BuCrit_stderr,'-','Color',BuColorCrit,'CapSize',3,'LineWidth',1);
   
    text('Units','normalized','Position',[0.84,0.93,0],'HorizontalAlignment','right','String','RS','Color',RSColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.84,0.84,0],'HorizontalAlignment','right','String','FS','Color',FSColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.84,0.75,0],'HorizontalAlignment','right','String','Bu','Color',BuColorGMM,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.84,0.66,0],'HorizontalAlignment','right','String','PBu','Color',PBuColor,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    text('Units','normalized','Position',[0.84,0.57,0],'HorizontalAlignment','right','String','Bu_c_r_i_t','Color',BuColorCrit,'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
    set(gca,'XTick',[1E0 1E1 1E2 1E3]);
    set(gca,'xlim',[1E0 1E3]);
    set(gca,'ylim',[-0.05 0.6]);
   
    maxsync_RS = maxsync_plusprestim(RSinds_gmm);
    maxsync_FS = maxsync_plusprestim(FSinds_gmm);
    maxsync_Bu = maxsync_plusprestim(Buinds_gmm);
    maxsync_PBu = maxsync_plusprestim(PBuinds);
    maxsync_BuCrit = maxsync_plusprestim(Buinds_crit);
    
    p9 = 0.0356;
    
    figure(suppl);
    ax3 = subplot(2,3,3);
    violinplot(maxsync_plusprestim,groupIDgmm_plusprestim,'GroupOrder',{'RS','FS','Burster','Prestim burster','Burster_crit'});
    set(gca, 'YScale', 'linear');
    set(gca,'xlim',[0.5,5.5]);
    ylabel('Max Sync Rate (Hz)');
    xticklabels({'RS','FS','Bu','PBu', 'Bu_c_r_i_t'});
    yl = get(gca,'ylim');
    yl(2) = yl(2)*1.15;
    set(gca,'ylim',yl);
    hold on
    sigstar({[1 2]},p9);    
    set(findobj(ax3,'type','Scatter'),'SizeData',8);
    q = findobj(ax3,'type','Patch');   
    q(10).FaceColor = RSColor;
    q(8).FaceColor = FSColor;
    q(6).FaceColor = BuColorGMM;
    q(4).FaceColor = PBuColor;
    q(2).FaceColor = BuColorCrit;
    q2 = findobj(ax3,'type','Scatter'); 
    q2(20).MarkerFaceColor = RSColor;
    q2(16).MarkerFaceColor = FSColor;
    q2(12).MarkerFaceColor = BuColorGMM;
    q2(8).MarkerFaceColor = PBuColor;
    q2(4).MarkerFaceColor = BuColorCrit;      
    q3 = findobj(ax3,'type','Line');
    q3(1).LineWidth = 1;
    q3(2).LineWidth = 1;
    q3(3).LineWidth = 1;
    q3(4).LineWidth = 1;
    q3(5).LineWidth = 1;
    
    perhist_RS_gmm = mean(perhist(RSinds_gmm,:),1,'omitnan');
    perhist_FS_gmm = mean(perhist(FSinds_gmm,:),1,'omitnan');
    perhist_Bu_gmm = mean(perhist(Buinds_gmm,:),1,'omitnan');
    perhist_PBu = mean(perhist_plusprestim(PBuinds,:),1,'omitnan');

    figure(suppl);
    ax6 = subplot(2,3,6);   % Dummy axis
    hold on
    intercol = 0.04;
    interrow = 0.06;
    
    ax6sub(4) = axes(suppl,'Position',[ax6.Position(1)+(ax6.Position(3)-intercol)/2+intercol, ax6.Position(2), (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_PBu(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 9]);
    set(gca,'XTick',[0 pi 2*pi]);
    xticklabels({'0','\pi','2\pi'})
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','PBu','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(3) = axes(suppl,'Position',[ax6.Position(1), ax6.Position(2), (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_Bu_gmm(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'XTick',[0 pi 2*pi]);
    lh_rad = xlabel('Period (Rad)');
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    lh_ns = ylabel('Number of spikes','FontSize',figparams.fsize);
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','Bu','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(2) = axes(suppl,'Position',[ax6.Position(1)+(ax6.Position(3)-intercol)/2+intercol, ax6.Position(2)+(ax6.Position(4)-interrow)/2+interrow, (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_FS_gmm(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 30]);
    xticks([0 pi 2*pi]);
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','FS','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');
    
    ax6sub(1) = axes(suppl,'Position',[ax6.Position(1), ax6.Position(2)+(ax6.Position(4)-interrow)/2+interrow, (ax6.Position(3)-intercol)/2, (ax6.Position(4)-interrow)/2]); 
    bar(centers,perhist_RS_gmm(1:end-1),'FaceColor','none','BarWidth',1,'LineWidth',0.5,'EdgeColor',[0.5 0.5 0.5]);
    set(gca,'ylim',[0 6]);
    xticks([0 pi 2*pi]);
    set(gca,'Xticklabels',{'0','\pi','2\pi'},'FontSize',figparams.fsize)
    yt = yticks;
    set(gca,'Yticklabels',yt,'fontsize',figparams.fsize);
    text('Units','normalized','Position',[0.94,0.88,0],'String','RS','HorizontalAlignment','right','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','bold');  
    
    linkaxes(ax6sub,'x');
    set(gca,'xlim',[0 2*pi]);
    
    axes(ax1);
    txh = text('Units','normalized','Position',[-0.34 1.1 0],'String','A', fontstr_l{:});
    axes(ax2);
    txh2 = text('Units','normalized','Position',[-0.34 1.1 0],'String','B',fontstr_l{:});
    axes(ax3);
    txh3 = text('Units','normalized','Position',[-0.34 1.1 0],'String','C',fontstr_l{:});
    axes(ax4);
    txh4 = text('Units','normalized','Position',[-0.34 1.1 0],'String','D',fontstr_l{:});
    axes(ax5);
    txh5 = text('Units','normalized','Position',[-0.34 1.1 0],'String','E',fontstr_l{:});
    axes(ax6);
    txh6 = text('Units','normalized','Position',[-0.34 1.1 0],'String','F',fontstr_l{:});
       
    set(ax6,'Visible','off');
    delta = ax4.Position(2)-ax6sub(4).Position(2);
    ax4.Position(2) = ax6sub(4).Position(2);
    ax4.Position(4) = ax4.Position(4)+delta;
    ax5.Position(2) = ax6sub(4).Position(2);
    ax5.Position(4) = ax5.Position(4)+delta;
    ax1.Position(4) = ax1.Position(4)+delta;
    ax1.Position(2) = ax1.Position(2)-delta;
    ax2.Position(4) = ax2.Position(4)+delta;
    ax2.Position(2) = ax2.Position(2)-delta;
    ax3.Position(4) = ax3.Position(4)+delta;
    ax3.Position(2) = ax3.Position(2)-delta;
    set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'box','off','TickDir','out');
 
    lh1.Position(2) = 0.45;
    lh2.Position(2) = 0.45;
    lh_ns.Position(2) = 10.5;
    lh_rad.Position(1) = 8;
    
    print([figdir 'Supp/SAM.tif'],'-dtiff',['-r' num2str(figparams.res)]);
    
    %% Correlation Index and Victor-Purpura Call Classification    
    case 'Vocalization responses'
        PBuinds = find(burster_prestim==1); 
        groupIDcrit_plusprestim = [groupIDcrit; repmat({'Prestim burster'},length(PBuinds),1)];
        groupIDcrit_plusprestim(cellfun(@(x) ~ischar(x),groupIDcrit_plusprestim)) = {''};     
        groupIDgmm_plusprestim = [groupIDgmm; repmat({'Prestim burster'},length(PBuinds),1)];
        groupIDgmm_plusprestim(cellfun(@(x) ~ischar(x),groupIDgmm_plusprestim)) = {''};  
        CImax_plusprestim = [CImax; CImax(PBuinds)];
        Bu1inds = strcmp(groupIDcrit_plusprestim,'Burster_h');
        Bu2inds = strcmp(groupIDcrit_plusprestim,'Burster_l');
        RSinds = strcmp(groupIDcrit_plusprestim,'RS');
        FSinds = strcmp(groupIDcrit_plusprestim,'FS');
        
        fig8 = figure;

        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [17.2*0.3937, 15.3*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 17.2*0.3937, 15.3*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 17.2*0.3937, 15.3*0.3937]);
        figparams.fsize = 7;
        figparams.msize = 7;
        figparams.res = 300;
        figparams.fontchoice = 'Arial';
        lmargin = 0.075;
        tmargin = 0.958;
        xwidth = 0.285;
        ywidth = 0.21;
        ywidthsp = 0.14;
        interrow = 0.03;
        intercol = 0.03;
        
        axf8p1 = axes(fig8,'Position',[lmargin tmargin-ywidth 0.245 ywidth]);
        
        resp_len_RS = resp_stims_rate_len(RSinds)/20;
        resp_len_FS = resp_stims_rate_len(FSinds)/20;
        resp_len_Bu1 = resp_stims_rate_len(Bu1inds)/20;
        resp_len_Bu2 = resp_stims_rate_len(Bu2inds)/20;
        resp_len2_RS = resp_stims_PSTH_len(RSinds)/20;
        resp_len2_FS = resp_stims_PSTH_len(FSinds)/20;
        resp_len2_Bu1 = resp_stims_PSTH_len(Bu1inds)/20;
        resp_len2_Bu2 = resp_stims_PSTH_len(Bu2inds)/20;
        
        hold on
        error_format = {'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3};
        bar(1, nanmean(resp_len_RS),0.7,'FaceColor',RSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(1,nanmean(resp_len_RS),nanstd(resp_len_RS)/sqrt(length(find(~isnan(resp_len_RS)))),error_format{:});
        bar(5.5, nanmean(resp_len2_RS),0.7,'FaceColor',RSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(5.5,nanmean(resp_len2_RS),nanstd(resp_len2_RS)/sqrt(length(find(~isnan(resp_len2_RS)))),error_format{:});    
        bar(2, nanmean(resp_len_FS),0.7,'FaceColor',FSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(2,nanmean(resp_len_FS),nanstd(resp_len_FS)/sqrt(length(find(~isnan(resp_len_FS)))),error_format{:});
        bar(6.5, nanmean(resp_len2_FS),0.7,'FaceColor',FSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(6.5,nanmean(resp_len2_FS),nanstd(resp_len2_FS)/sqrt(length(find(~isnan(resp_len2_FS)))),error_format{:});    
        bar(3, nanmean(resp_len_Bu1),0.7,'FaceColor',Bu1Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(3,nanmean(resp_len_Bu1),nanstd(resp_len_Bu1)/sqrt(length(find(~isnan(resp_len_Bu1)))),error_format{:});
        bar(7.5, nanmean(resp_len2_Bu1),0.7,'FaceColor',Bu1Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(7.5,nanmean(resp_len2_Bu1),nanstd(resp_len2_Bu1)/sqrt(length(find(~isnan(resp_len2_Bu1)))),error_format{:}); 
        bar(4, nanmean(resp_len_Bu2),0.7, 'FaceColor',Bu2Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(4,nanmean(resp_len_Bu2),nanstd(resp_len_Bu2)/sqrt(length(find(~isnan(resp_len_Bu2)))),error_format{:});
        bar(8.5, nanmean(resp_len2_Bu2),0.7,'FaceColor',Bu2Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar(8.5,nanmean(resp_len2_Bu2),nanstd(resp_len2_Bu2)/sqrt(length(find(~isnan(resp_len2_Bu2)))),error_format{:});

        lh1 = ylabel('Fraction calls responsive');   % Clarify rate responsive
        set(gca,'xlim',[0.5 9],'xtick',[1,2,3,4,5.5,6.5,7.5,8.5],'xticklabels',{'RS','FS','Bu1','Bu2','RS','FS','Bu1','Bu2'},...
            'ytick',[0 0.1 0.2 0.3 0.4 0.5]);
        xl1 = xlabel('Mean rate              PSTH   ',fontstr{:});
        
        axf8p2 = axes(fig8,'Position',[lmargin+axf8p1.Position(3)+2*(intercol+0.011) tmargin-ywidth axf8p1.Position(3) ywidth]);
          
        CImax_RS = CImax_plusprestim(RSinds);
        hb1 = bar(1, mean(CImax_RS,'omitnan'),0.7);
        set(hb1,'FaceColor',RSColor,'FaceAlpha',0.5,'EdgeColor','none');
        hold on
        errorbar (1, mean(CImax_RS,'omitnan'),std(CImax_RS,'omitnan')/sqrt(length(find(~isnan(CImax_RS)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_FS = CImax_plusprestim(FSinds);
        hb2 = bar(2, mean(CImax_FS,'omitnan'),0.7);
        set(hb2,'FaceColor',FSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (2, mean(CImax_FS,'omitnan'),std(CImax_FS,'omitnan')/sqrt(length(find(~isnan(CImax_FS)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_Bu1 = CImax_plusprestim(Bu1inds);
        hb3 = bar(3, mean(CImax_Bu1,'omitnan'),0.7);
        set(hb3,'FaceColor',Bu1Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (3, mean(CImax_Bu1,'omitnan'),std(CImax_Bu1,'omitnan')/sqrt(length(find(~isnan(CImax_Bu1)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_Bu2 = CImax_plusprestim(Bu2inds);
        hb4 = bar(4, mean(CImax_Bu2,'omitnan'),0.7);
        set(hb4,'FaceColor',Bu2Color,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (4, mean(CImax_Bu2,'omitnan'),std(CImax_Bu2,'omitnan')/sqrt(length(find(~isnan(CImax_Bu2)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_PBu = CImax_plusprestim(PBuinds);
        hb5 = bar(5, mean(CImax_PBu,'omitnan'),0.7);
        set(hb5,'FaceColor',PBuColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (5, mean(CImax_PBu,'omitnan'),std(CImax_PBu,'omitnan')/sqrt(length(find(~isnan(CImax_PBu)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        [h,p] = kstest2(CImax_RS,CImax_Bu1)
        [h,p] = kstest2(CImax_RS,[CImax_Bu1; CImax_Bu2])
        
        A = [groupIDcrit_plusprestim, groupIDgmm_plusprestim(1:length(groupIDcrit_plusprestim)), num2cell(CImax_plusprestim)];
        T = array2table(A);
        T.Properties.VariableNames = {'Group_crit','Group_gmm','CI'};
        %currentFile = mfilename('fullpath');
        %[pathstr,~,~] = fileparts(currentFile);
        cd(data_log_dir);
        writetable(T,'CImax.csv');     % Process in Python for Welch's ANOVA and Games-Howell post-hoc
        anova1(CImax(ismember(groupnumcrit,[3,1,2,6])),groupnumcrit(ismember(groupnumcrit,[3,1,2,6])));
        % Levene test for equal variance (reject null)
        p = vartestn(CImax,groupIDgmm,'TestType','LeveneAbsolute')
        p = vartestn(log(CImax),groupIDgmm,'TestType','LeveneAbsolute')

        test1 = [CImax(ismember(groupnumcrit,[3,1,2,6])&~isnan(CImax)) groupnumcrit(ismember(groupnumcrit,[3,1,2,6])&~isnan(CImax))]
        test1(test1(:,2)==6,2) = 4;
        welchanova(test1,0.05);

        figure(fig8)
        % From Python Pingouin Games-Howell post-hoc test
        p1 = 0.0088;
        p2 = 0.0178;
        p3 = 0.0011;
        p4 = 0.0038;
        sigstar({[2 3],[1 3],[2 4],[1 2]},[p1 p2 p3 p4]);

        CImax_RS_GMM = CImax(strcmp(groupIDgmm_plusprestim,'RS'));
        hb7 = bar(6.5, mean(CImax_RS_GMM,'omitnan'),0.7);
        set(hb7,'FaceColor',RSColor,'FaceAlpha',0.5,'EdgeColor','none');
        hold on
        errorbar (6.5, mean(CImax_RS_GMM,'omitnan'),std(CImax_RS_GMM,'omitnan')/sqrt(length(find(~isnan(CImax_RS_GMM)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_FS_GMM = CImax(strcmp(groupIDgmm_plusprestim,'FS'));
        hb8 = bar(7.5, mean(CImax_FS_GMM,'omitnan'),0.7);
        set(hb8,'FaceColor',FSColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (7.5, mean(CImax_FS_GMM,'omitnan'),std(CImax_FS_GMM,'omitnan')/sqrt(length(find(~isnan(CImax_FS_GMM)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        CImax_Bu_GMM = CImax(strcmp(groupIDgmm_plusprestim,'Burster'));
        hb9 = bar(8.5, mean(CImax_Bu_GMM,'omitnan'),0.7);
        set(hb9,'FaceColor',BuColor,'FaceAlpha',0.5,'EdgeColor','none');
        errorbar (8.5, mean(CImax_Bu_GMM,'omitnan'),std(CImax_Bu_GMM,'omitnan')/sqrt(length(find(~isnan(CImax_Bu_GMM)))),'Color',[0.45 0.45 0.45],'LineWidth',0.8,'CapSize',3);

        p4 = 0.001;
        p5 = 0.001;
        p6 = 0.001;

        sigstar({[6.5 8.5],[6.5 7.5],[7.5 8.5]},[p4 p5 p6]);

        ylabel('CI_M_A_X',fontstr{:});
        set(gca,'Xtick',[1,2,3,4,5,6.5,7.5,8.5],'XTickLabel',{'RS', 'FS', 'Bu1', 'Bu2', 'PBu', 'RS', 'FS', 'Bu'},fontstr{:});
        set(gca,'xlim',[0.5,9]);
        xlabel('   Criteria                      GMM  ',fontstr{:});

        % Doesn't fit on shortest bars
        %{
        text(1,3,num2str(length(find(~isnan(CImax_RS)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        text(2,3,num2str(length(find(~isnan(CImax_FS)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        text(3,3,num2str(length(find(~isnan(CImax_Bu1)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        text(4,3,num2str(length(find(~isnan(CImax_Bu2)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        text(5,3,num2str(length(find(~isnan(CImax_PBu)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);

        text(7,3,num2str(length(find(~isnan(CImax_RS_GMM)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);   
        text(8,3,num2str(length(find(~isnan(CImax_FS_GMM)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        text(9,3,num2str(length(find(~isnan(CImax_Bu_GMM)))),'FontSize',figparams.fsize-1,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
        %}
        
        axf8p3 = axes(fig8,'Position',[lmargin+axf8p1.Position(3)+axf8p2.Position(3)+3*(intercol+0.025) tmargin-ywidth 0.26 ywidth]);
        [B,CImaxsortind] = sort(CImax,'descend','MissingPlacement','last');

        groupnumsorted = groupnumcrit(CImaxsortind);
        maxind = max(find(~isnan(CImax(CImaxsortind))));
        cumRS = cumsum(groupnumsorted(1:maxind)==3);
        cumRS_n = cumRS(end);
        cumFS = cumsum(groupnumsorted(1:maxind)==1);
        cumFS_n = cumFS(end);
        cumBu1 = cumsum(groupnumsorted(1:maxind)==2);
        cumBu1_n = cumBu1(end);
        cumBu2 = cumsum(groupnumsorted(1:maxind)==6);
        cumBu2_n = cumBu2(end);

        cumRS= cumRS/max(cumRS)*100;
        cumFS= cumFS/max(cumFS)*100;
        cumBu1= cumBu1/max(cumBu1)*100;
        cumBu2= cumBu2/max(cumBu2)*100;

        hold on
        p1 = stairs(cumRS,'Color', RSColor);
        p2 = stairs(cumFS,'Color', FSColor);
        p3 = stairs(cumBu1,'Color', BuColor);
        p4 = stairs(cumBu2,'Color', PBuColor);

        ylabel('Cumulative % of units');
        xlabel('CI_M_A_X Rank');    
        set(gca,'xlim',[0 280]);

        axf8p1.XAxis.FontWeight = 'normal'; 
        
        
        suppl = figure;

        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11.4*0.3937, 4*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 11.4*0.3937, 4*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 11.4*0.3937, 4*0.3937]);
        figparams.fsize = 7;
        figparams.msize = 7;
        figparams.res = 300;  
        figparams.fontchoice = 'Arial';
        lmargin = 0.06;
        tmargin = 0.92;
        xwidth = 0.285;
        ywidth = 0.68;
        ywidthsp = 0.14;
        interrow = 0.03;
        intercol = 0.13;

        % Schematic of CI

        axsp1= axes(suppl, 'Position', [0.07, tmargin-ywidth-0.02, 0.21, ywidth+0.02]);
        plot_raster({'M7E0523'}, 1, '2','[3,4,7]','','','','single',0,0,0,'',suppl,1,'vertical tick',0.8);
        set(gca,'xlim',[410 427]);
        set(gca,'ylim',[0.2 0.85]);
        lh = xlabel('Time',fontstr{:});
        set(gca,'XColor','none');
        arrowsize = 3;

        an = annotation('doublearrow');
        an.Head1Style = 'cback1';
        an.Head2Style = 'cback1';
        an.Head1Length = arrowsize;
        an.Head1Width = arrowsize;
        an.Head2Length = arrowsize;
        an.Head2Width = arrowsize;
        an.LineWidth = 2;
        an.X = [0.0774 0.24]*axsp1.Position(3)+[axsp1.Position(1) axsp1.Position(1)];
        an.Y = [0.655 0.655]*axsp1.Position(4)+[axsp1.Position(2) axsp1.Position(2)];

        an2 = annotation('doublearrow');
        an2.Head1Style = 'cback1';
        an2.Head2Style = 'cback1';
        an2.Head1Length = arrowsize;
        an2.Head1Width = arrowsize;
        an2.Head2Length = arrowsize;
        an2.Head2Width = arrowsize;
        an2.LineWidth = 2;
        an2.X = [0.0774 0.7226]*axsp1.Position(3)+[axsp1.Position(1) axsp1.Position(1)];
        an2.Y = [0.585 0.585]*axsp1.Position(4)+[axsp1.Position(2) axsp1.Position(2)];

        an3 = annotation('doublearrow');
        an3.Head1Style = 'cback1';
        an3.Head2Style = 'cback1';
        an3.Head1Length = arrowsize;
        an3.Head1Width = arrowsize;
        an3.Head2Length = arrowsize;
        an3.Head2Width = arrowsize;
        an3.LineWidth = 2;
        an3.X = [0.0774 0.205]*axsp1.Position(3)+[axsp1.Position(1) axsp1.Position(1)];
        an3.Y = [0.34 0.34]*axsp1.Position(4)+[axsp1.Position(2) axsp1.Position(2)];

        an4 = annotation('doublearrow');
        an4.Head1Style = 'cback1';
        an4.Head2Style = 'cback1';
        an4.Head1Length = arrowsize;
        an4.Head1Width = arrowsize;
        an4.Head2Length = arrowsize;
        an4.Head2Width = arrowsize;
        an4.LineWidth = 2;
        an4.X = [0.0774 0.4645]*axsp1.Position(3)+[axsp1.Position(1) axsp1.Position(1)];
        an4.Y = [0.27 0.27]*axsp1.Position(4)+[axsp1.Position(2) axsp1.Position(2)];

        an5 = annotation('doublearrow');
        an5.Head1Style = 'cback1';
        an5.Head2Style = 'cback1';
        an5.Head1Length = arrowsize;
        an5.Head1Width = arrowsize;
        an5.Head2Length = arrowsize;
        an5.Head2Width = arrowsize;
        an5.LineWidth = 2;
        an5.X = [0.0774 0.8774]*axsp1.Position(3)+[axsp1.Position(1) axsp1.Position(1)];
        an5.Y = [0.20 0.20]*axsp1.Position(4)+[axsp1.Position(2) axsp1.Position(2)];

        set(gca,'YTick',[0.25 0.5 0.75]);
        yticklabels({'3','2','1'});
        set(gca,'YColor','none');
        text(408, 0.75, '1',fontstr{:});
        text(408, 0.5, '2',fontstr{:});
        th = text(408, 0.25, '3',fontstr{:});
        line([410, 427],[0.25, 0.25]);  % Grid lines end up under rectangle
        line([410, 427],[0.5, 0.5]);
        line([410, 427],[0.75, 0.75]);
        th2 = text(407,0.83,'Rep',fontstr{:});

        file = 'M117B0646';
        ch = 4;
        stims = 3;
        reps = 1:10;

        axsp2= axes(suppl, 'Position', [0.07+0.21+intercol, tmargin-ywidth, 0.22, ywidth]);
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]);

        axsp3= axes(suppl, 'Position', [0.07+0.21+0.22+2*intercol-0.02, tmargin-ywidth, 0.22, ywidth]);
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]);
        inputs = struct;
        inputs.file = file;
        inputs.ch = ch;
        inputs.stims = stims;
        inputs.reps = reps;
        inputs.ana_window = params.ana_window;
        inputs.binsize = params.t_binsize;
        inputs.response_type = 'excited';
        inputs.plotornot = 1;
        inputs.ax = [axsp2,axsp3];
        [CI_max, CI_avg, CI_log, baseline_rate_mean, responsive_stims] = mSAC(inputs);
        hold on
        ah = annotation('arrow');
        xl = get(gca,'xlim');
        pos(1) = axsp3.Position(1)+log(0.5/xl(1))/log(xl(2)/xl(1))*axsp3.Position(3);
        pos(2) = axsp3.Position(2)+49/60*axsp3.Position(4);
        pos(3) = 0;
        pos(4) = -0.04;
        set(ah,'position',pos,'headStyle','cback1','LineWidth',2,'Color','k','HeadLength',5,'HeadWidth',6);
        set(gca,'ylim',[0 60]);

        axes(axsp2);
        set(gca,'xlim',[0 7]);
        set(gca,'XTick',[0 5]);
        axes(axsp3);
        set(gca,'YTick',[0 20 40 60]);
        axsp3.Children.MarkerSize = 3;
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off','TickLength',[0.03 0.025]);

        axes(axsp1);
        text(-0.25,1.072,'A','Units','normalized',fontstr_l{:});  
        axes(axsp2);
        text(-0.42,1.072,'B','Units','normalized',fontstr_l{:});  
        axes(axsp3);
        text(-0.38,1.072,'C','Units','normalized',fontstr_l{:});  

        print([figdir 'Supp/CI.tif'],'-dtiff',['-r' num2str(figparams.res)]);
        
        zthresh = 3;
        
        q = nanmean(qs,1)';
        
        RS_perc_corr = perc_corr((groupnumcrit == 3) & (z_score>zthresh),:);
        Bu1_perc_corr = perc_corr((groupnumcrit == 2) & (z_score>zthresh),:);
        FS_perc_corr = perc_corr((groupnumcrit == 1) & (z_score>zthresh),:);  
        RS_perc_corr_mean = nanmean(RS_perc_corr,1);
        Bu1_perc_corr_mean = nanmean(Bu1_perc_corr,1);
        FS_perc_corr_mean = nanmean(FS_perc_corr,1);
        RS_perc_corr_n = length(find(~isnan(RS_perc_corr(:,1))));    
        Bu1_perc_corr_n = length(find(~isnan(Bu1_perc_corr(:,1))));
        FS_perc_corr_n = length(find(~isnan(FS_perc_corr(:,1))));
        RS_perc_corr_se = nanstd(RS_perc_corr,[],1)/sqrt(RS_perc_corr_n);   
        Bu1_perc_corr_se = nanstd(Bu1_perc_corr,[],1)/sqrt(Bu1_perc_corr_n);   
        FS_perc_corr_se = nanstd(FS_perc_corr,[],1)/sqrt(FS_perc_corr_n);       
                
        ywidth = 0.2;
        ywidth2 = 0.23;
        xwidthr = 0.2052; 
        xwidth = 0.265;
        bmargin = 0.08;
        lmargin = 0.075;
        intercol = 0.03;
        intercol2 = 0.06;
        interrow = 0.12;
        
        r1= [255,0,0]/255;
        r2 = [194,9,81]/255;
        g2=  [133 195 10]/255;
        g1=  [0,132,55]/255;
        
        figure(fig8);   
        
        [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, last_rep_complete, last_rep_stims, stimulus_ch1,reps, stimulus_ch2] = get_spikes_xpl ('M117B0334', 4, 1:20, 1:10);

        [q_opt_334, perc_correct_opt, pc_334, z_334, H_334] =  call_classify (spk_ms, D, stim_len, pre_stim, post_stim,  1:20, 1:10,params.q,1:20,0)

        axvp2 = axes(fig8,'Position',[lmargin, bmargin, xwidth, ywidth])

        h1 = plot(params.q,H_334/max(H_334),'-','LineWidth', 1,'Color', r1);
        set(gca, 'XScale', 'log');
        hold on
      
        [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, last_rep_complete, last_rep_stims, stimulus_ch1,reps, stimulus_ch2] = get_spikes_xpl ('M7E1425', 1, 1:20, 1:10);
        [q_opt_1425, perc_correct_opt, pc_1425, z_1425, H_1425] =  call_classify (spk_ms, D, stim_len, pre_stim, post_stim,  1:20, 1:10,params.q,1:20,0)

        h2 = plot(params.q,H_1425/max(H_1425), '-','LineWidth', 1,'Color',r2);

        [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, last_rep_complete, last_rep_stims, stimulus_ch1,reps, stimulus_ch2] = get_spikes_xpl ('M117B0760', 5, 1:20, 1:10);

        [q_opt_760, perc_correct_opt, pc_760, z_760, H_760] =  call_classify (spk_ms, D, stim_len, pre_stim, post_stim,  1:20, 1:10,params.q,1:20,0)

        h3 = plot(params.q,H_760/max(H_760), '-','LineWidth', 1,'Color',g2)

        [spk_ms, D, stim_len, pre_stim, post_stim, stims, stim_file, analysis_type, last_rep_complete, last_rep_stims, stimulus_ch1,reps, stimulus_ch2] = get_spikes_xpl ('M117B0646', 4, 1:20, 1:10);

        [q_opt_646, perc_correct_opt, pc_646, z_646, H_646] =  call_classify (spk_ms, D, stim_len, pre_stim, post_stim,  1:20, 1:10,params.q,1:20,0)

        h4 = plot(params.q,H_646/max(H_646), '-','LineWidth', 1,'Color',g1)

        set(gca,'xlim',[1 256]);
        set(gca,'ylim',[0.5 1]);
        lh3 = ylabel('Rel Decoding Information');
        xlabel('Cost (q)');
        set(gca,'XTick',[1 10 100]);
        set(gca,'YTick',[0.6 0.8 1]);
        ti = title('Example Units');
        ti.Position(2) = 1.03;
        text(1.3,0.7,'Unit A',fontstr{:},'Color',g1)
        text(1.3,0.65,'Unit B',fontstr{:},'Color',g2);
        text(1.3,0.6,'Unit C',fontstr{:},'Color',r1);
        text(1.3,0.55,'Unit D',fontstr{:},'Color',r2);
        box off;
        
        axvp1(1) = axes('Position',[lmargin,bmargin+ywidth+interrow+0.01,xwidthr,ywidth2]);
        plot_raster({'M117B0646'}, 4, '1:20','1:10','','','','single',1,0,1,'',axvp1(1),1,'dot');
        xlabel({'Unit A','(Bu1)'},'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',g1);
        lh2 = ylabel({'Mixed Vocalizations'});
        lh2.Position(1) = -460;
        text(0.5,1.05,['Unit M117B0636ch4'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
        txh1n = text(-100,0.4,'1n','FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','right','FontWeight','bold'); 
        txh1r = text(-100,1.5,'1r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
        txh20n = text(-100,18.5,'10n','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
        txh20r = text(-100,19.7,'10r','HorizontalAlignment','right','FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
        set(gca,'Ytick',[0.5, 1.5, 18.5, 19.5]);
        set(gca,'YTickLabels',{});
        
        axvp1(2) = axes('Position',[lmargin+xwidthr+intercol,bmargin+ywidth+interrow+0.01,xwidthr,ywidth2]);
        plot_raster({'M117B0760'}, 5, '1:20','1:10','','','','single',1,0,1,'',axvp1(2),1,'dot');
        set(gca,'YTick',[]);
        xlabel({'Unit B','(PBu)'},'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',g2);
        text(0.5,1.05,['Unit M117B0728ch5'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
     
        axvp1(3) = axes('Position',[lmargin+2*xwidthr+2*intercol,bmargin+ywidth+interrow+0.01,xwidthr,ywidth2]);
        plot_raster({'M117B0334'}, 4, '1:20','1:10','','','','single',1,0,1,'',axvp1(3),1,'dot');
        set(gca,'YTick',[]);
        xlabel({'Unit C','(RS)'},'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',r1);
        text(0.5,1.05,['Unit M117B0320ch4'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
        
        axvp1(4) = axes('Position',[lmargin+3*xwidthr+3*intercol,bmargin+ywidth+interrow+0.01,xwidthr,ywidth2]);
        plot_raster({'M7E1425'}, 1, '1:20','1:10','','','','single',1,0,1,'',axvp1(4),1,'dot');
        set(gca,'YTick',[]);
        xlabel({'Unit D','(RS)'},'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',r2);
        text(0.5,1.05,['Unit M7E1420ch1'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
        
        RS_H = H((groupnumcrit == 3) & (z_score>zthresh),:);
        Bu1_H = H((groupnumcrit == 2) & (z_score>zthresh),:);
        Bu2_H = H((groupnumcrit == 6) & (z_score>zthresh),:);
        FS_H = H((groupnumcrit == 1) & (z_score>zthresh),:);   
        RS_H_norm = RS_H./repmat(max(RS_H,[],2),1,size(RS_H,2));   % Normalize by max value
        Bu1_H_norm = Bu1_H./repmat(max(Bu1_H,[],2),1,size(Bu1_H,2));
        Bu2_H_norm = Bu2_H./repmat(max(Bu2_H,[],2),1,size(Bu2_H,2));
        FS_H_norm = FS_H./repmat(max(FS_H,[],2),1,size(FS_H,2)); 
        RS_H_norm_mean = nanmean(RS_H_norm,1);
        Bu1_H_norm_mean = nanmean(Bu1_H_norm,1);
        Bu2_H_norm_mean = nanmean(Bu2_H_norm,1);
        FS_H_norm_mean = nanmean(FS_H_norm,1);
        RS_H_norm_n = length(find(~isnan(RS_H_norm(:,1))));    
        Bu1_H_norm_n = length(find(~isnan(Bu1_H_norm(:,1))));
        Bu2_H_norm_n = length(find(~isnan(Bu2_H_norm(:,1))));
        FS_H_norm_n = length(find(~isnan(FS_H_norm(:,1))));
        RS_H_norm_se = nanstd(RS_H_norm,[],1)/sqrt(RS_H_norm_n);  
        Bu1_H_norm_se = nanstd(Bu1_H_norm,[],1)/sqrt(Bu1_H_norm_n);
        Bu2_H_norm_se = nanstd(Bu2_H_norm,[],1)/sqrt(Bu2_H_norm_n);
        FS_H_norm_se = nanstd(FS_H_norm,[],1)/sqrt(FS_H_norm_n);         
             
        axvp3 = axes(fig8,'Position',[lmargin+xwidth+intercol2, bmargin, xwidth, ywidth])
        h3 = plot(q(2:end),FS_H_norm_mean(2:end),'Color',FSColor2,'LineWidth',1,'Parent', axvp3);
        hold on
        fill([q(2:end);flipud(q(2:end))],[FS_H_norm_mean(2:end)'-FS_H_norm_se(2:end)';flipud(FS_H_norm_mean(2:end)'+FS_H_norm_se(2:end)')],FSColor2,'linestyle','none','Parent', axvp3);
                alpha(0.5);
        h1 = plot(q(2:end),RS_H_norm_mean(2:end),'Color',RSColor,'LineWidth',1,'Parent', axvp3);
        fill([q(2:end);flipud(q(2:end))],[RS_H_norm_mean(2:end)'-RS_H_norm_se(2:end)';flipud(RS_H_norm_mean(2:end)'+RS_H_norm_se(2:end)')],RSColor,'linestyle','none','Parent', axvp3);
                alpha(0.5);
        h2 = plot(q(2:end),Bu1_H_norm_mean(2:end),'Color',Bu1Color,'LineWidth',1,'Parent', axvp3);
        fill([q(2:end);flipud(q(2:end))],[Bu1_H_norm_mean(2:end)'-Bu1_H_norm_se(2:end)';flipud(Bu1_H_norm_mean(2:end)'+Bu1_H_norm_se(2:end)')],Bu1Color,'linestyle','none','Parent', axvp3);
   
        h4 = plot(q(2:end),Bu2_H_norm_mean(2:end),'Color',Bu2Color,'LineWidth',1,'Parent', axvp3);
        fill([q(2:end);flipud(q(2:end))],[Bu2_H_norm_mean(2:end)'-Bu2_H_norm_se(2:end)';flipud(Bu2_H_norm_mean(2:end)'+Bu2_H_norm_se(2:end)')],Bu2Color,'linestyle','none','Parent', axvp3);
   
        alpha(0.5);     
        set(gca,'xlim',[1 256]);
        set(gca,'ylim',[0.5 1]);
        set(gca,'YTick',[0.6 0.8 1]);
        set(gca,'Xscale','log');
        ti = title('Labeled by criteria');
        ti.Position(2) = 1.03;
        xlabel('Cost (q)');
        text(1.3,0.70,['RS (' num2str(RS_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor);
        text(1.3,0.65,['FS (' num2str(FS_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor2);
        text(1.3,0.60,['Bu1 (' num2str(Bu1_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color);
        text(1.3,0.55,['Bu2 (' num2str(Bu2_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color);
        box off;
        
        axvp4 = axes(fig8,'Position',[lmargin+2*xwidth+2*intercol2, bmargin, xwidth, ywidth]);   
        hold on
        RS_H_gmm = H(strcmp(groupIDgmm,'RS') & (z_score>zthresh),:);
        Bu_H_gmm = H(strcmp(groupIDgmm,'Burster') & (z_score>zthresh),:);
        FS_H_gmm = H(strcmp(groupIDgmm,'FS') & (z_score>zthresh),:);  
        RS_H_norm_gmm = RS_H_gmm./repmat(max(RS_H_gmm,[],2),1,size(RS_H_gmm,2));   % Normalize by max value
        Bu_H_norm_gmm = Bu_H_gmm./repmat(max(Bu_H_gmm,[],2),1,size(Bu_H_gmm,2)); 
        FS_H_norm_gmm = FS_H_gmm./repmat(max(FS_H_gmm,[],2),1,size(FS_H_gmm,2));
        RS_H_norm_gmm_n = length(find(~isnan(RS_H_norm_gmm(:,1))));
        Bu_H_norm_gmm_n = length(find(~isnan(Bu_H_norm_gmm(:,1))));
        FS_H_norm_gmm_n = length(find(~isnan(FS_H_norm_gmm(:,1))));
        RS_H_norm_mean_gmm = nanmean(RS_H_norm_gmm,1);
        Bu_H_norm_mean_gmm = nanmean(Bu_H_norm_gmm,1);
        FS_H_norm_mean_gmm = nanmean(FS_H_norm_gmm,1);
        RS_H_norm_se_gmm = nanstd(RS_H_norm_gmm,[],1)/sqrt(RS_H_norm_gmm_n);  
        Bu_H_norm_se_gmm = nanstd(Bu_H_norm_gmm,[],1)/sqrt(Bu_H_norm_gmm_n);  
        FS_H_norm_se_gmm = nanstd(FS_H_norm_gmm,[],1)/sqrt(FS_H_norm_gmm_n);        
        
        h6 = plot(q(2:end),FS_H_norm_mean_gmm(2:end),'Color',FSColor2,'LineWidth',1);
        fill([q(2:end);flipud(q(2:end))],[FS_H_norm_mean_gmm(2:end)'-FS_H_norm_se_gmm(2:end)';flipud(FS_H_norm_mean_gmm(2:end)'+FS_H_norm_se_gmm(2:end)')],FSColor2,'linestyle','none');
                alpha(0.5);
        h4 = plot(q(2:end),RS_H_norm_mean_gmm(2:end),'Color',RSColor,'LineWidth',1);
        fill([q(2:end);flipud(q(2:end))],[RS_H_norm_mean_gmm(2:end)'-RS_H_norm_se_gmm(2:end)';flipud(RS_H_norm_mean_gmm(2:end)'+RS_H_norm_se_gmm(2:end)')],RSColor,'linestyle','none');
                alpha(0.5);
        h5 = plot(q(2:end),Bu_H_norm_mean_gmm(2:end),'Color',BuColor1,'LineWidth',1);
        fill([q(2:end);flipud(q(2:end))],[Bu_H_norm_mean_gmm(2:end)'-Bu_H_norm_se_gmm(2:end)';flipud(Bu_H_norm_mean_gmm(2:end)'+Bu_H_norm_se_gmm(2:end)')],BuColor1,'linestyle','none');
                alpha(0.5);
        set(gca,'Xscale','log');
        set(gca,'xlim',[1 256]);
        set(gca,'ylim',[0.5 1]);
        set(gca,'YTick',[0.6 0.8 1]);
       
        ti = title('Labeled by GMM');
        ti.Position(2) = 1.03;
        xlabel('Cost (q)');
        set(gca,'Xscale','log');
        text(1.3,0.66,['RS (' num2str(RS_H_norm_gmm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor);
        text(1.3,0.61,['FS (' num2str(FS_H_norm_gmm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor2);
        text(1.3,0.56,['Bu (' num2str(Bu_H_norm_gmm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',BuColor1);
         
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off','TickLength',[0.03 0.025]);
  
        lh1.Position(2) = 0.23;
        lh1.Position(1) = -0.95;
        lh3.Position(1) = 0.435;
        axes(axf8p1);
        tif8p1 = text(-0.30,1.072,'A','Units','normalized',fontstr_l{:}); 
        axes(axf8p2);
        tif8p2 = text(tif8p1.Position(1)*axf8p1.Position(3)/axf8p2.Position(3),1.072,'B','Units','normalized',fontstr_l{:});  
        axes(axf8p3);
        tif8p3 = text(tif8p1.Position(1)*axf8p1.Position(3)/axf8p3.Position(3),1.072,'C','Units','normalized',fontstr_l{:});  
        axes(axvp1(1));
        text(tif8p1.Position(1)*axf8p1.Position(3)/axvp1(1).Position(3),1.072,'D','Units','normalized',fontstr_l{:});  
        axes(axvp2);
        text(tif8p1.Position(1)*axf8p1.Position(3)/axvp2.Position(3),1.15,'E','Units','normalized',fontstr_l{:}); 
        axes(axvp3);
        text(tif8p1.Position(1)*axf8p1.Position(3)/axvp3.Position(3)*0.7,1.15,'F','Units','normalized',fontstr_l{:});
        axes(axvp4);
        text(tif8p1.Position(1)*axf8p1.Position(3)/axvp4.Position(3)*0.7,1.15,'G','Units','normalized',fontstr_l{:}); 
        
        print([figdir 'Fig 8/Fig8.tif'],'-dtiff',['-r' num2str(figparams.res)]);    
         
        figure(supp_Bu1_2);
        axes('Position',[0.1+0.22+0.11, 0.1, 0.22, 0.35]);
        CImax_RS = CImax_plusprestim(strcmp(groupIDcrit_plusprestim,'RS'));
        hb1 = bar(1, mean(CImax_RS,'omitnan'),0.6);
        set(hb1,'FaceColor',RSColor,'FaceAlpha',0.5,'EdgeColor',[0.5 0.5 0.5]);
        hold on
        errorbar (1, mean(CImax_RS,'omitnan'),std(CImax_RS,'omitnan')/sqrt(length(find(~isnan(CImax_RS)))),'Color',[0.5 0.5 0.5],'LineWidth',0.8,'CapSize',3);

        CImax_FS = CImax_plusprestim(strcmp(groupIDcrit_plusprestim,'FS'));
        hb2 = bar(2, mean(CImax_FS,'omitnan'),0.6);
        set(hb2,'FaceColor',FSColor,'FaceAlpha',0.5,'EdgeColor',[0.5 0.5 0.5]);
        errorbar (2, mean(CImax_FS,'omitnan'),std(CImax_FS,'omitnan')/sqrt(length(find(~isnan(CImax_FS)))),'Color',[0.5 0.5 0.5],'LineWidth',0.8,'CapSize',3);

        CImax_Bu1 = CImax_plusprestim(Bu_sub==1);
        hb3 = bar(3, mean(CImax_Bu1,'omitnan'),0.6);
        set(hb3,'FaceColor',Bu1Color,'FaceAlpha',0.5,'EdgeColor',[0.5 0.5 0.5]);
        errorbar (3, mean(CImax_Bu1,'omitnan'),std(CImax_Bu1,'omitnan')/sqrt(length(find(~isnan(CImax_Bu1)))),'Color',[0.5 0.5 0.5],'LineWidth',0.8,'CapSize',3);

        CImax_Bu2 = CImax_plusprestim(Bu_sub==2);
        hb4 = bar(4, mean(CImax_Bu2,'omitnan'),0.6);
        set(hb4,'FaceColor',Bu2Color,'FaceAlpha',0.5,'EdgeColor',[0.5 0.5 0.5]);
        errorbar (4, mean(CImax_Bu2,'omitnan'),std(CImax_Bu2,'omitnan')/sqrt(length(find(~isnan(CImax_Bu2)))),'Color',[0.5 0.5 0.5],'LineWidth',0.8,'CapSize',3);

        th = text(1,mean(CImax_RS,'omitnan')+8,num2str(length(find(~isnan(CImax_RS)))),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor,'HorizontalAlignment','center');
        th2 = text(2,mean(CImax_FS,'omitnan')+7,num2str(length(find(~isnan(CImax_FS)))),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor,'HorizontalAlignment','center');
        th3 = text(3,mean(CImax_Bu1,'omitnan')+20,num2str(length(find(~isnan(CImax_Bu1)))),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color,'HorizontalAlignment','center');
        th4 = text(4,mean(CImax_Bu2,'omitnan')+11,num2str(length(find(~isnan(CImax_Bu2)))),'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color,'HorizontalAlignment','center');
        
        ylabel('CI_M_A_X',fontstr{:});
        set(gca,'XTick',[1,2,3,4],'XTickLabel',{'RS', 'FS', 'Bu1', 'Bu2'},fontstr{:});
        set(gca,'xlim',[0.5,4.5]);        
        text('Units','normalized','Position',[-0.31,1+0.1*0.15/0.35],'String','E');
        
        figure(supp_Bu1_2);
        axes('Position',[0.1+2*(0.22+0.11), 0.1, 0.22, 0.35]);
        RS_H = H((groupnumcrit == 3) & (z_score>zthresh),:);
        Bu1_H = H((Bu_sub==1) & (z_score>zthresh),:);
        Bu2_H = H((Bu_sub==2) & (z_score>zthresh),:);
        FS_H = H((groupnumcrit == 1) & (z_score>zthresh),:);   
        RS_H_norm = RS_H./repmat(max(RS_H,[],2),1,size(RS_H,2));   
        Bu1_H_norm = Bu1_H./repmat(max(Bu1_H,[],2),1,size(Bu1_H,2));
        Bu2_H_norm = Bu2_H./repmat(max(Bu2_H,[],2),1,size(Bu2_H,2));
        FS_H_norm = FS_H./repmat(max(FS_H,[],2),1,size(FS_H,2));
 
        RS_H_norm_mean = nanmean(RS_H_norm,1);
        Bu1_H_norm_mean = nanmean(Bu1_H_norm,1);
        Bu2_H_norm_mean = nanmean(Bu2_H_norm,1);
        FS_H_norm_mean = nanmean(FS_H_norm,1);
        RS_H_norm_n = length(find(~isnan(RS_H_norm(:,1))));    
        Bu1_H_norm_n = length(find(~isnan(Bu1_H_norm(:,1))));
        Bu2_H_norm_n = length(find(~isnan(Bu2_H_norm(:,1))));
        FS_H_norm_n = length(find(~isnan(FS_H_norm(:,1))));
        RS_H_norm_se = nanstd(RS_H_norm,[],1)/sqrt(RS_H_norm_n);  
        Bu1_H_norm_se = nanstd(Bu1_H_norm,[],1)/sqrt(Bu1_H_norm_n);
        Bu2_H_norm_se = nanstd(Bu2_H_norm,[],1)/sqrt(Bu2_H_norm_n);
        FS_H_norm_se = nanstd(FS_H_norm,[],1)/sqrt(FS_H_norm_n);         
             
        h3 = plot(q(2:end),FS_H_norm_mean(2:end),'Color',FSColor2,'LineWidth',1.2);
        hold on
        fill([q(2:end);flipud(q(2:end))],[FS_H_norm_mean(2:end)'-FS_H_norm_se(2:end)';flipud(FS_H_norm_mean(2:end)'+FS_H_norm_se(2:end)')],FSColor2,'linestyle','none');
                alpha(0.5);
        h1 = plot(q(2:end),RS_H_norm_mean(2:end),'Color',RSColor,'LineWidth',1.2);
        fill([q(2:end);flipud(q(2:end))],[RS_H_norm_mean(2:end)'-RS_H_norm_se(2:end)';flipud(RS_H_norm_mean(2:end)'+RS_H_norm_se(2:end)')],RSColor,'linestyle','none');
                alpha(0.5);
        h2 = plot(q(2:end),Bu1_H_norm_mean(2:end),'Color',Bu1Color,'LineWidth',1.2);
        fill([q(2:end);flipud(q(2:end))],[Bu1_H_norm_mean(2:end)'-Bu1_H_norm_se(2:end)';flipud(Bu1_H_norm_mean(2:end)'+Bu1_H_norm_se(2:end)')],Bu1Color,'linestyle','none');
   
        h4 = plot(q(2:end),Bu2_H_norm_mean(2:end),'Color',Bu2Color,'LineWidth',1.2);
        fill([q(2:end);flipud(q(2:end))],[Bu2_H_norm_mean(2:end)'-Bu2_H_norm_se(2:end)';flipud(Bu2_H_norm_mean(2:end)'+Bu2_H_norm_se(2:end)')],Bu2Color,'linestyle','none');
   
        alpha(0.5);    
        set(gca,'xlim',[1 256]);
        set(gca,'ylim',[0.5 1]);
        set(gca,'YTick',[0.6 0.8 1]);
        set(gca,'Xscale','log');
        xlabel('Cost (q)');
        lh3 = ylabel('Rel Decoding Information');
        text(1.3,0.70,['RS (' num2str(RS_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor);
        text(1.3,0.65,['FS (' num2str(FS_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor2);
        text(1.3,0.60,['Bu1 (' num2str(Bu1_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color);
        text(1.3,0.55,['Bu2 (' num2str(Bu2_H_norm_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color);
        box off;
        
        text('Units','normalized','Position',[-0.31,1+0.1*0.15/0.35],'String','F');
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');
        
        print([figdir 'Supp/Supp_Bu1_2.tif'],'-dtiff',['-r' num2str(figparams.res)]);

    %% Basic properties of types 
    case 'Neuron type properties'
        inds = find(burster_prestim==1);
        groupIDcrit_plusprestim = [groupIDcrit; repmat({'Prestim burster'},length(inds),1)];
        inds2 = find(strcmp(groupIDcrit_plusprestim,'Burster_l') | strcmp(groupIDcrit_plusprestim,'Burster_h'));
        groupIDcrit_plusprestim = [groupIDcrit_plusprestim; repmat({'Burster'},length(inds2),1)];
        groupIDcrit_plusprestim(cellfun(@(x) ~ischar(x),groupIDcrit_plusprestim)) = {''};  % make NaN's into chars
        spont_plusprestim = [spont_recalc; spont_recalc([inds; inds2])];
        peakmsISI_plusprestim = [peakmsISI; peakmsISI([inds; inds2])];
        acmetric_plusprestim = [acmetric; acmetric([inds; inds2])];
        ISImetric_plusprestim = [ISImetric; ISImetric([inds; inds2])];
        dip_pval_plusprestim = [dip_pval; dip_pval([inds; inds2])];
        logISIdrop_plusprestim = [logISIdrop; logISIdrop([inds; inds2])];
        TTP_plusprestim = [TTP; TTP([inds; inds2])];
        F50_plusprestim = [F50; F50([inds; inds2])];
        max_firing_rate_plusprestim = [max_firing_rate; max_firing_rate([inds; inds2])];
        spike_amp_plusprestim = [spike_amp; spike_amp([inds; inds2])];
        latency_plusprestim = [latency; latency([inds; inds2])];
        refract_plusprestim = [refract; refract([inds; inds2])];
        percISI5_plusprestim = [percISI5; percISI5([inds; inds2])];
        percISI5ratio_plusprestim = [percISI5ratio; percISI5ratio([inds; inds2])];
        max_burst_length_plusprestim = [max_burst_length; max_burst_length([inds; inds2])];
        fracmeanISI_plusprestim = [fracmeanISI; fracmeanISI([inds; inds2])];
        p2mISI_plusprestim = [p2mISI; p2mISI([inds; inds2])];
        CV_plusprestim = [CV; CV([inds; inds2])];
        reg_parikh_plusprestim = [reg_parikh; reg_parikh([inds; inds2])];
        MI_plusprestim = [MI; MI([inds; inds2])];
        split_bu = 1;

        groupinds.RSinds = strcmp(groupIDcrit_plusprestim,'RS');
        groupinds.FSinds = strcmp(groupIDcrit_plusprestim,'FS');
        groupinds.Bu2inds = strcmp(groupIDcrit_plusprestim,'Burster_l');
        groupinds.Bu1inds = strcmp(groupIDcrit_plusprestim,'Burster_h');
        groupinds.PBuinds = strcmp(groupIDcrit_plusprestim,'Prestim burster');
        groupinds.Buinds = strcmp(groupIDcrit_plusprestim,'Burster');
        figheight_tot = 15;
        
        fig3 = figure;
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [17.2*0.3937, figheight_tot*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 17.2*0.3937, figheight_tot*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 17.2*0.3937, figheight_tot*0.3937]);
        figparams.fsize = 7;
        figparams.msize = 3;
        figparams.res = 300;
        figparams.fontchoice = 'Arial Narrow';
        hmargin = 0.05;
        vmargin = 0.05;
        figwidth = 0.28;
        figheight = 1.8/figheight_tot;
       
        groupord = {'RS','FS','Burster','Prestim burster','Burster_h','Burster_l','Unclassified','Insufficient spikes',};
        groupcolors = [RSColor; FSColor; BuColor; PBuColor; BuColor1; BuColorBright];
        nrows = 5;

        s1 = axes(fig3, 'Position',[hmargin, vmargin+(nrows-1)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s1;
        ct_properties_subplot(peakmsISI_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors, 'linear', 'Peak ISI (ms)', figparams);
        hold on
        xl = get(gca,'xlim');
        set(gca,'ylim',[0 85]);
        plot(xl, [10 10], '--', 'Color', [0.7 0.7 0.7]);
        s1.Title.Units = 'normalized';
        s1.Title.VerticalAlignment = 'top';
        s1.Title.Position=[0.5 1.2 0];

        s2 = axes(fig3, 'Position',[hmargin+1*(1-2*hmargin)/2.8, vmargin+(nrows-1)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s2;
        ct_properties_subplot(acmetric_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Autocorrelation metric', figparams);
        hold on
        xl = get(gca,'xlim');
        plot(xl, [0.5 0.5], '--', 'Color', [0.7 0.7 0.7]);
        s2.Title.Units = 'normalized';
        s2.Title.VerticalAlignment = 'top';
        s2.Title.Position=[0.5 1.2 0];
              
        s3 = axes(fig3, 'Position',[hmargin+2*(1-2*hmargin)/2.8, vmargin+(nrows-1)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s3;
        ct_properties_subplot(logISIdrop_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'log(ISI)drop', figparams);
        set(gca,'ylim',[-1 1.15]);
        hold on
        xl = get(gca,'xlim');
        plot(xl, [0.3 0.3], '--', 'Color', [0.7 0.7 0.7]);
        plot(xl, [0.2 0.2], '-.', 'Color', [0.7 0.7 0.7]);
        s3.Title.Units = 'normalized';
        s3.Title.VerticalAlignment = 'top';
        s3.Title.Position=[0.5 1.2 0];
        
        s4 = axes(fig3, 'Position', [hmargin, vmargin+(nrows-2)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s4;
        ct_properties_subplot(TTP_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'Trough-to-peak (ms)', figparams);
        set(gca,'ylim',[0 2.2]);
        hold on
        xl = get(gca,'xlim');
        plot(xl, [0.5 0.5], '--', 'Color', [0.7 0.7 0.7]);
        %plot(xlim, [0.45 0.45], '--', 'Color', [0.7 0.7 0.7]);
        %plot(xlim, [0.55 0.55], '-.', 'Color', [0.7 0.7 0.7]);
        s4.Title.Units = 'normalized';
        s4.Title.VerticalAlignment = 'top';
        s4.Title.Position=[0.5 1.2 0];
        
        s5 = axes(fig3, 'Position', [hmargin+1*(1-2*hmargin)/2.8, vmargin+(nrows-2)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s5;
        ct_properties_subplot(F50_plusprestim/1000, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Spike spectrum {\it f}_5_0 (kHz)', figparams);
        set(gca,'ylim',[0 4.6]);
        hold on
        xl = get(gca,'xlim');
        plot(xl, [2.000 2.000], '--', 'Color', [0.7 0.7 0.7]);
        s5.Title.Units = 'normalized';
        s5.Title.VerticalAlignment = 'top';
        s5.Title.Position=[0.5 1.2 0];
        
        s6 = axes(fig3, 'Position', [hmargin+2*(1-2*hmargin)/2.8, vmargin+(nrows-2)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s6;
        ct_properties_subplot(spont_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'Spontaneous rate (spk/s)', figparams);
        hold on
        xl = get(gca,'xlim');
        plot(xl, [log10(3) log10(3)], '--', 'Color', [0.7 0.7 0.7]);
        plot(xl, [log10(5) log10(5)], '-.', 'Color', [0.7 0.7 0.7]);
        s6.Title.Units = 'normalized';
        s6.Title.VerticalAlignment = 'top';
        s6.Title.Position=[0.5 1.2 0];
        
        s7 = axes(fig3, 'Position', [hmargin, vmargin+(nrows-3)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s7;
        ct_properties_subplot(max_firing_rate_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Max driven rate', figparams);
        s7.Title.Units = 'normalized';
        s7.Title.VerticalAlignment = 'top';
        s7.Title.Position=[0.5 1.2 0];

        s8 = axes(fig3, 'Position', [hmargin+1*(1-2*hmargin)/2.8, vmargin+(nrows-3)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s8;
        ct_properties_subplot(latency_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Latency (ms)', figparams);
        set(gca,'ylim',[0 180]);
        s8.Title.Units = 'normalized';
        s8.Title.VerticalAlignment = 'top';
        s8.Title.Position=[0.5 1.2 0];
        
        s9 = axes(fig3, 'Position', [hmargin+2*(1-2*hmargin)/2.8, vmargin+(nrows-3)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s9;
        ct_properties_subplot(refract_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'Refractory period (ms)', figparams);      
        set(gca,'ylim',[0 20]);
        s9.Title.Units = 'normalized';
        s9.Title.VerticalAlignment = 'top';
        s9.Title.Position=[0.5 1.2 0];
        
        s10 = axes(fig3, 'Position', [hmargin, vmargin+(nrows-4)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s10;
        ct_properties_subplot(percISI5_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Percent ISI < 5 ms', figparams);      
        s10.Title.Units = 'normalized';
        s10.Title.VerticalAlignment = 'top';
        s10.Title.Position=[0.5 1.2 0];
        set(gca,'YTick',[0 0.2 0.4 0.6]);
        yt = yticks;
        yticklabels({'0','20','40','60'});
                
        s11 = axes(fig3, 'Position', [hmargin+1*(1-2*hmargin)/2.8, vmargin+(nrows-4)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s11;
        ct_properties_subplot(dip_pval_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Hartigans'' dip{\it p}-value', figparams);
        hold on
        xl = get(gca,'xlim');
        s11.Title.Units = 'normalized';
        s11.Title.VerticalAlignment = 'top';
        s11.Title.Position=[0.5 1.2 0];

        s12 = axes(fig3, 'Position', [hmargin+2*(1-2*hmargin)/2.8, vmargin+(nrows-4)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
        figparams.s = s12;
        ct_properties_subplot(max_burst_length_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'Max burst length', figparams);
        s12.Title.Units = 'normalized';
        s12.Title.VerticalAlignment = 'top';
        s12.Title.Position=[0.5 1.2 0];
        set(gca,'ylim',[0 25]);

        if split_bu
            s13 = axes(fig3, 'Position', [hmargin, vmargin+(nrows-5)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
            figparams.s = s13;
            ct_properties_subplot(percISI5ratio_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors,'linear', 'Percent ISI < 5 ms re: Poisson', figparams);
            set(gca,'ylim',[0 250]);
            s13.Title.Units = 'normalized';
            s13.Title.VerticalAlignment = 'top';
            s13.Title.Position=[0.5 1.2 0];

            s14 = axes(fig3, 'Position', [hmargin+1*(1-2*hmargin)/2.8, vmargin+(nrows-5)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
            figparams.s = s14;
            ct_properties_subplot(fracmeanISI_plusprestim, groupIDcrit_plusprestim, groupinds,groupord, groupcolors, 'linear', 'Parikh Burstiness', figparams);      
            s14.Title.Units = 'normalized';
            s14.Title.VerticalAlignment = 'top';
            s14.Title.Position=[0.5 1.2 0];

            s15 = axes(fig3, 'Position', [hmargin+2*(1-2*hmargin)/2.8, vmargin+(nrows-5)*(1-2*vmargin)/(0.95*nrows), figwidth, figheight]);
            figparams.s = s15;
            ct_properties_subplot(reg_parikh_plusprestim, groupIDcrit_plusprestim, groupinds, groupord, groupcolors, 'linear', 'Parikh Regularity', figparams);
            s15.Title.Units = 'normalized';
            s15.Title.VerticalAlignment = 'top';
            s15.Title.Position=[0.5 1.2 0];
            set(gca,'ylim',[0 0.25]);  
        end
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','box','off');
        
        if split_bu
            print([figdir 'Supp/Properties.tiff'],'-dtiff',['-r' num2str(figparams.res)]);
        else
           print([figdir 'Fig 3/fig3.tiff'],'-dtiff',['-r' num2str(figparams.res)]);  
        end
        
        mean_burst_freq = mean(intraburst_freq(strcmp(groupIDcrit,'Burster')));  
        min_burst_freq = min(intraburst_freq(strcmp(groupIDcrit,'Burster')));
        max_burst_freq = max(intraburst_freq(strcmp(groupIDcrit,'Burster')));

        mean_burst_freq2 = mean(1000./peakmsISI(strcmp(groupIDcrit,'Burster')))
        
        mean_burster_burst_length = nanmean(max_burst_length(strcmp(groupIDcrit,'Burster')))
        stdev_burster_burst_length = nanstd(max_burst_length(strcmp(groupIDcrit,'Burster')))
        max_burst_length_percent = length(find(max_burst_length(strcmp(groupIDcrit,'Burster'))<=5))/length(find(~isnan(max_burst_length(strcmp(groupIDcrit,'Burster')))))        
    
    %% Duration tuning
    case 'Duration'
        
        groupIDcrit(cellfun(@(x) ~ischar(x),groupIDcrit)) = {''};
        inds = find(burster_prestim==1);
        groupIDcrit_plusprestim = [groupIDcrit; repmat({'Prestim burster'},length(inds),1)];
        adaptratio = [adaptratio; adaptratio(inds)];  
        
        RSinds = strcmp(groupIDcrit_plusprestim,'RS');
        FSinds = strcmp(groupIDcrit_plusprestim,'FS');
        Bu1inds = strcmp(groupIDcrit_plusprestim,'Burster_h');
        Bu2inds = strcmp(groupIDcrit_plusprestim,'Burster_l');
        
        dur_rate_norm = dur_mean_driven_rate_ext./max(dur_mean_driven_rate_ext,[],2);
        RS_dur_rate = mean(dur_rate_norm(RSinds,:),1,'omitnan');
        FS_dur_rate = mean(dur_rate_norm(FSinds,:),1,'omitnan');
        Bu1_dur_rate = mean(dur_rate_norm(Bu1inds,:),1,'omitnan');
        Bu2_dur_rate = mean(dur_rate_norm(Bu2inds,:),1,'omitnan');
        
        RS_dur_rate_n = length(find(max(~isnan(dur_rate_norm(RSinds,:)),[],2))); 
        FS_dur_rate_n = length(find(max(~isnan(dur_rate_norm(FSinds,:)),[],2)));
        Bu1_dur_rate_n = length(find(max(~isnan(dur_rate_norm(Bu1inds,:)),[],2)));
        Bu2_dur_rate_n = length(find(max(~isnan(dur_rate_norm(Bu2inds,:)),[],2)));
    
        RS_dur_rate_stderr = std(dur_rate_norm(RSinds,:),'omitnan')/sqrt(RS_dur_rate_n);
        FS_dur_rate_stderr = std(dur_rate_norm(FSinds,:),'omitnan')/sqrt(FS_dur_rate_n);
        Bu1_dur_rate_stderr = std(dur_rate_norm(Bu1inds,:),'omitnan')/sqrt(Bu1_dur_rate_n);
        Bu2_dur_rate_stderr = std(dur_rate_norm(Bu2inds,:),'omitnan')/sqrt(Bu2_dur_rate_n);
    
        durations = mean(durations,1,'omitnan');
        durations_ext = mean(durations_ext,1,'omitnan');
        
        RS_t1 = [];    
        RS_t2 = [];
        RS_t3 = [];
        RS_t4 = [];
        
        FS_t1 = [];
        FS_t2 = [];
        FS_t3 = [];
        FS_t4 = [];
        
        Bu2_t1 = [];
        Bu2_t2 = [];
        Bu2_t3 = [];
        Bu2_t4 = [];
        
        Bu1_t1 = [];
        Bu1_t2 = [];
        Bu1_t3 = [];
        Bu1_t4 = [];
        
        RS_adaptratio = [];
        FS_adaptratio = [];
        Bu2_adaptratio = [];
        Bu1_adaptratio = [];
        PBu_adaptratio = [];
        PSTH.RS = {[],[],[],[],[],[]};
        PSTH.FS = {[],[],[],[],[],[]};
        PSTH.Bu1 = {[],[],[],[],[],[]};
        PSTH.Bu2 = {[],[],[],[],[],[]};
        PSTH.Bu1_GMM =  {[],[],[],[],[],[]};
        PSTH.Bu2_GMM =  {[],[],[],[],[],[]};
        PSTH.RS_avg = {[],[],[],[],[],[]};
        PSTH.FS_avg = {[],[],[],[],[],[]};
        PSTH.Bu1_avg = {[],[],[],[],[],[]};
        PSTH.Bu2_avg = {[],[],[],[],[],[]};
       
        Bu1_r_burst_freq = [];
        Bu2_r_burst_freq = [];
        
        PSTH_ramp_t = [];
        PSTHramp.RS = {[],[],[],[],[]};
        PSTHramp.FS = {[],[],[],[],[]};
        PSTHramp.Bu1 = {[],[],[],[],[]};
        PSTHramp.Bu2 = {[],[],[],[],[]};
        PSTHramp.Bu1_GMM = {[],[],[],[],[]};
        PSTHramp.Bu2_GMM = {[],[],[],[],[]};
        PSTHramp.RSavg = {[],[],[],[],[]};
        PSTHramp.FSavg = {[],[],[],[],[]};
        PSTHramp.Bu1avg = {[],[],[],[],[]};
        PSTHramp.Bu2avg = {[],[],[],[],[]};
        PSTHramp.Bu1avg_GMM = {[],[],[],[],[]};
        PSTHramp.Bu2avg_GMM = {[],[],[],[],[]};
        
        ramprates = 5:30:125;
        
        for i = 1:length(groupIDcrit_plusprestim)
            if isempty (PSTH_ramp_t) && ~isnan(PSTH_time1(i,1))
                    PSTH_ramp_t = PSTH_time_ramp(i,:);
            end
            if strcmp(groupIDcrit_plusprestim{i},'RS')
                if isempty (RS_t1) && ~isnan(PSTH_time1(i,1))
                    RS_t1 = PSTH_time1(i,:);
                    RS_t2 = PSTH_time2(i,:);
                    RS_t3 = PSTH_time3(i,:);
                    RS_t4 = PSTH_time4(i,:);
                end
                for d = 1:length(durations)
                    eval(['PSTH.RS{d} = [PSTH.RS{d};PSTH_duration' num2str(d) '(i,:)];']);
                end
                RS_adaptratio = [RS_adaptratio adaptratio(i)];
                for d = 1:length(ramprates)
                    eval(['PSTHramp.RS{d} = [PSTHramp.RS{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                end
                
            elseif strcmp(groupIDcrit_plusprestim{i},'FS')
                if isempty (FS_t1) && ~isnan(PSTH_time1(i,1))
                    FS_t1 = PSTH_time1(i,:);
                    FS_t2 = PSTH_time2(i,:);
                    FS_t3 = PSTH_time3(i,:);
                    FS_t4 = PSTH_time4(i,:);
                end
                for d = 1:length(durations)
                    eval(['PSTH.FS{d} = [PSTH.FS{d};PSTH_duration' num2str(d) '(i,:)];']);
                end
                FS_adaptratio = [FS_adaptratio adaptratio(i)];
                for d = 1:length(ramprates)
                    eval(['PSTHramp.FS{d} = [PSTHramp.FS{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                end
            elseif strcmp(groupIDcrit_plusprestim{i},'Prestim burster')
                PBu_adaptratio = [PBu_adaptratio adaptratio(i)];    
            elseif any(strcmp(groupIDcrit_plusprestim{i},{'Burster_l','Burster_h'}))   % Some kind of burster - split either by intraburst freq alone or with sub-cluster (in "neuron type classification")           
                if strcmp(groupIDcrit_plusprestim{i},'Burster_l')
                    if isempty (Bu2_t1) && ~isnan(PSTH_time1(i,1))
                        Bu2_t1 = PSTH_time1(i,:);
                        Bu2_t2 = PSTH_time2(i,:);
                        Bu2_t3 = PSTH_time3(i,:);
                        Bu2_t4 = PSTH_time4(i,:);
                    end
                    for d = 1:length(durations)
                        eval(['PSTH.Bu2{d} = [PSTH.Bu2{d};PSTH_duration' num2str(d) '(i,:)];']);
                    end
                    Bu2_adaptratio = [Bu2_adaptratio adaptratio(i)];
                    Bu2_r_burst_freq = [Bu2_r_burst_freq, intraburst_freq(i)];
                    for d = 1:length(ramprates)
                        eval(['PSTHramp.Bu2{d} = [PSTHramp.Bu2{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                    end
                elseif strcmp(groupIDcrit_plusprestim{i},'Burster_h')
                    if isempty (Bu1_t1) && ~isnan(PSTH_time1(i,1))
                        Bu1_t1 = PSTH_time1(i,:);
                        Bu1_t2 = PSTH_time2(i,:);
                        Bu1_t3 = PSTH_time3(i,:);
                        Bu1_t4 = PSTH_time4(i,:);
                    end
                    
                    for d = 1:length(durations)
                        eval(['PSTH.Bu1{d} = [PSTH.Bu1{d};PSTH_duration' num2str(d) '(i,:)];']);
                    end
                    Bu1_adaptratio = [Bu1_adaptratio adaptratio(i)];
                    Bu1_r_burst_freq = [Bu1_r_burst_freq, intraburst_freq(i)];
                    for d = 1:length(ramprates)
                        eval(['PSTHramp.Bu1{d} = [PSTHramp.Bu1{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                    end
                end
                
                if Bu_sub(i)==1
                    for d = 1:length(durations)
                        eval(['PSTH.Bu1_GMM{d} = [PSTH.Bu1_GMM{d};PSTH_duration' num2str(d) '(i,:)];']);
                    end
                    for d = 1:length(ramprates)
                        eval(['PSTHramp.Bu1_GMM{d} = [PSTHramp.Bu1_GMM{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                    end
                elseif Bu_sub(i)==2
                    for d = 1:length(durations)
                        eval(['PSTH.Bu2_GMM{d} = [PSTH.Bu2_GMM{d};PSTH_duration' num2str(d) '(i,:)];']);
                    end
                    for d = 1:length(ramprates)
                        eval(['PSTHramp.Bu2_GMM{d} = [PSTHramp.Bu2_GMM{d};PSTH_ramprate' num2str(d) '(i,:)];']);
                    end
                end
            end
        end
        
        unit_type = {'RS','FS','Bu1','Bu2'};
        
        sub1 = figure;   % Bigger version of mean PSTH traces for PPT
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [9*0.3937, 7.8*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 9*0.3937, 7.8*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 9*0.3937, 7.8*0.3937]);
        figparams.msize = 7;
        figparams.res = 300; 
        
        frac_x = 1;   % Horizontal fraction of full figure for subplot 1
        frac_y = 1;   % Vertical fraction of full figure for subplot 1
        xshift = 0;
  
        for t = 1:length(unit_type)
            for d = 1:length(durations)
                eval(['PSTH.' unit_type{t} '_avg{d} = mean(PSTH.' unit_type{t} '{d},1,''omitnan'');']);
                eval(['PSTH.' unit_type{t} '_max(d) = max(PSTH.' unit_type{t} '_avg{d});']);
                eval(['PSTH.' unit_type{t} '_n(d) = length(find(~isnan(PSTH.' unit_type{t} '{d}(:,1))))']);
                eval(['PSTH.' unit_type{t} '_stderr{d} = std(PSTH.' unit_type{t} '{d},1,''omitnan'')/sqrt(PSTH.' unit_type{t} '_n(d));']);
            end
            eval(['max' unit_type{t} '= max(PSTH.' unit_type{t} '_max)']);
        end
        
        showdurs = [1,3,4];
        showmsmax = [0.45,0.62,0.85];
        prev_shrink = 0;
        for i = 1:length(showdurs)
            ax(i) = subplot(1,length(showdurs),i);
            eval(['t_temp = RS_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.RS_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.RS_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            %eval(['p = plot(RS_t' num2str(showdurs(i)) '(1:end-1),PSTH.RS_avg{' num2str(showdurs(i)) '})']);
            set(p,'LineWidth',1,'Color',RSColor);
            hold on
            plot([0.2 0.2+durations(showdurs(i))/1000],[maxRS*1.45 maxRS*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],RSColor,'linestyle','none'); 
            alpha(0.5);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxRS*1.5]);
            if i ~= 1
                 set(gca,'YColor','none');
            else
                
            end
            set(gca,'xtick',[0.2,0.4,0.6],'Tickdir','out');
            set(gca,'xticklabels',[]);
            if i == 3
                th = text(0.88,maxRS*1.5*0.8,{'RS'},'Color',RSColor,'HorizontalAlignment','left','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end
            if i == 1
                th1 = text('Units','inches','Position', [-0.34, 3.67],'String','A',fontstr_l{:});
            end
            box off
            
            old_pos = get(ax(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y+0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax(i),'Position',old_pos);
        end
        PSTH_RS_n = length(find(~isnan(PSTH.RS{1}(:,1))));
        
        prev_shrink = 0;
        for i = 1:length(showdurs)
            axes(ax(i));
            eval(['t_temp = FS_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.FS_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.FS_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',1,'Color',FSColor);
            hold on
            plot([0.2 0.2+durations(showdurs(i))/1000],[maxFS*1.45 maxFS*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],FSColor,'linestyle','none'); 
            alpha(0.5);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxFS*1.5]);        
            if i ~= 1
                 set(gca,'YColor','none');
            else
                
            end
            set(gca,'xtick',[0.2,0.4,0.6]);
            set(gca,'xticklabels',[]);
            if i ==1
                ylh1 = ylabel('PSTH (spk/s)','FontSize',figparams.fsize);
                pos = get(ylh1,'Position');
                set(ylh1,'Position',[-0.07,25,pos(3)]);
            end
            if i == 3
                text(0.88,maxFS*1.5*0.8,{'FS'},'Color',FSColor,'HorizontalAlignment','left','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end

            %{
            old_pos = get(ax2(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y+0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax2(i),'Position',old_pos);
            %}
        end
        PSTH_FS_n = length(find(~isnan(PSTH.FS{1}(:,1))));
        
        prev_shrink = 0;
        for i = 1:length(showdurs)
            axes(ax(i));
            eval(['t_temp = Bu1_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.Bu1_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.Bu1_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',1,'Color',Bu1Color);
            hold on
            plot([0.2 0.2+durations(showdurs(i))/1000],[maxBu1*1.45 maxBu1*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],Bu1Color,'linestyle','none'); 
            alpha(0.5);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxBu1*1.5]);
            if i ~= 1
                set(gca,'YColor','none');
            else
               
            end
            set(gca,'xtick',[0.2,0.4,0.6]);
            set(gca,'xticklabels',[]);
            
            box off
            
            %{
            old_pos = get(ax3(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y+0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax3(i),'Position',old_pos);
            %}
            if i == 3
                text(0.88,maxBu1*1.5*0.8,{'Bu1'},'Color',Bu1Color,'HorizontalAlignment','left','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end
        end
        PSTH_Bu1_n = length(find(~isnan(PSTH.Bu1{1}(:,1))));
        
        prev_shrink = 0;
        for i = 1:length(showdurs)
            axes(ax(i));
            eval(['t_temp = Bu2_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.Bu2_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.Bu2_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',1,'Color',Bu2Color);
            hold on
            plot([0.2 0.2+durations(showdurs(i))/1000],[maxBu2*1.45 maxBu2*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],Bu2Color,'linestyle','none'); 
            alpha(0.5);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxBu2*1.5]);
            if i ~= 1
                set(gca,'YColor','none');
            else
               
            end
            set(gca,'xtick',[0.2,0.4,0.6]);
            set(gca,'xticklabels',{'200', '400', '600'});
            if i == 2
                lh = xlabel('Time (ms)');
                lh.Position = [0.55 -30 -1]
            end
            
            box off
            
            %{
            old_pos = get(ax4(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y+0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax4(i),'Position',old_pos);
            %}
            if i == 3
                text(0.88,maxBu2*1.5*0.8,{'Bu2'},'Color',Bu2Color,'HorizontalAlignment','left','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end
        end
        PSTH_Bu2_n = length(find(~isnan(PSTH.Bu2{1}(:,1))));
        %linkaxes([ax(1),ax2(1),ax3(1),ax4(1)],'x');
        %linkaxes([ax(2),ax2(2),ax3(2),ax4(2)],'x');
        %linkaxes([ax(3),ax2(3),ax3(3),ax4(3)],'x');
        set(findobj(gcf,'type','axes'), 'TickLength',[0.04 0.025]);
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');      
        print([figdir 'Fig 5/sub1.tif'],'-dtiff',['-r' num2str(figparams.res)]);
        
        fig5 = figure;
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [17.2*0.3937, 17*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 17.2*0.3937, 17*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 17.2*0.3937, 17*0.3937]);
        figparams.msize = 7;
        figparams.res = 300;  
       
        frac_x = 0.5;   % Horizontal fraction of full figure for subplot 1
        frac_y = 0.27;   % Vertical fraction of full figure for subplot 1
        xshift = 0.06;
        
        for t = 1:length(unit_type)
            for d = 1:length(durations)
                eval(['PSTH.' unit_type{t} '_avg{d} = mean(PSTH.' unit_type{t} '{d},1,''omitnan'');']);
                eval(['PSTH.' unit_type{t} '_max(d) = max(PSTH.' unit_type{t} '_avg{d});']);
            end
            eval(['max' unit_type{t} '= max(PSTH.' unit_type{t} '_max)']);
        end
        
        showdurs = [1,3,4];
        showmsmax = [0.45,0.62,0.85];
        prev_shrink = 0;
        for i = 1:length(showdurs)
            ax(i) = subplot(4,length(showdurs),i);
            eval(['t_temp = RS_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.RS_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.RS_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',0.7,'Color',RSColor);
            hold on
            plot([0.2 0.2+durations(showdurs(i))/1000],[maxRS*1.45 maxRS*1.45],'k-','LineWidth',3);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],RSColor,'linestyle','none'); 
            alpha(0.4);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxRS*1.5]);
            if i ~= 1
                 set(gca,'YColor','none');
            end
            ax(i).XAxis.Visible = 'off';
            %set(gca,'xtick',[0.2,0.4,0.6],'Tickdir','out');
            %set(gca,'xticklabels',[]);
            %thdur(i) = text(0.2+0.5*durations(showdurs(i))/1000,maxRS*1.8,[num2str(durations(showdurs(i))) ' ms'],'HorizontalAlignment','center',fontstr{:});
            thdur(i) = text(0.2,maxRS*1.8,[num2str(durations(showdurs(i))) ' ms'],'HorizontalAlignment','left',fontstr{:});
            if i == 3
                th = text(0.66,maxRS*1.5*0.8,'RS','Color',RSColor,...
                    'HorizontalAlignment','left',...
                    'FontName',figparams.fontchoice,...
                    'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end
            if i == 1
                th1 = text('Units','inches','Position', [-0.34, 3.67],'String','A',fontstr_l{:});
            end
            box off
            
            old_pos = get(ax(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift-(i-1)*0.03;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y -0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax(i),'Position',old_pos);
            
        end
      
        prev_shrink = 0;
        for i = 1:length(showdurs)
            ax2(i) = subplot(4,length(showdurs),3+i);
            eval(['t_temp = FS_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.FS_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.FS_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',0.7,'Color',FSColor);
            hold on
            %plot([0.2 0.2+durations(showdurs(i))/1000],[maxFS*1.45 maxFS*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],FSColor,'linestyle','none'); 
            alpha(0.4);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxFS*1.5]);        
            if i ~= 1
                 set(gca,'YColor','none');
            end
            ax2(i).XAxis.Visible = 'off';
            %set(gca,'xtick',[0.2,0.4,0.6]);
            %set(gca,'xticklabels',[]);
            if i ==1
                ylh1 = ylabel('PSTH (spk/s)','FontSize',figparams.fsize);
                pos = get(ylh1,'Position');
                set(ylh1,'Position',[-0.07,25,pos(3)]);
            end
            if i == 3
               text(0.66,maxFS*1.5*0.8,'FS','Color',FSColor,...
                   'HorizontalAlignment','left',...
                   'FontName',figparams.fontchoice,...
                   'FontSize',figparams.fsize,...
                   'FontWeight','Bold'); 
            end

            old_pos = get(ax2(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift-(i-1)*0.03;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y -0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax2(i),'Position',old_pos);
        end
        
        prev_shrink = 0;
        for i = 1:length(showdurs)
            ax3(i) = subplot(4,length(showdurs),6+i);
            eval(['t_temp = Bu1_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.Bu1_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.Bu1_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',0.7,'Color',Bu1Color);
            hold on
            %plot([0.2 0.2+durations(showdurs(i))/1000],[maxBu1*1.45 maxBu1*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],Bu1Color,'linestyle','none'); 
            alpha(0.4);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxBu1*1.5]);
            if i ~= 1
                set(gca,'YColor','none');
            end
            ax3(i).XAxis.Visible = 'off';
            %set(gca,'xtick',[0.2,0.4,0.6]);
            %set(gca,'xticklabels',[]);
            
            box off
            
            old_pos = get(ax3(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift-(i-1)*0.03;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y -0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax3(i),'Position',old_pos);
            if i == 3
                text(0.66,maxBu1*1.5*0.8,'Bu1','Color',BuColor,...
                    'HorizontalAlignment','left',...
                    'FontName',figparams.fontchoice,...
                    'FontSize',figparams.fsize,...
                    'FontWeight','Bold'); 
            end
        end
        
        prev_shrink = 0;
        for i = 1:length(showdurs)
            ax4(i) = subplot(4,length(showdurs),9+i);
            eval(['t_temp = Bu2_t' num2str(showdurs(i)) '(1:end-1)']);
            eval(['resp_temp = PSTH.Bu2_avg{' num2str(showdurs(i)) '}']);
            eval(['stderr_temp = PSTH.Bu2_stderr{' num2str(showdurs(i)) '}']);
            p = plot(t_temp, resp_temp);
            set(p,'LineWidth',0.7,'Color',Bu2Color);
            hold on
            %plot([0.2 0.2+durations(showdurs(i))/1000],[maxBu2*1.45 maxBu2*1.45],'k-','LineWidth',2);
            fill([t_temp';flipud(t_temp')],[resp_temp'-stderr_temp';flipud(resp_temp'+stderr_temp')],Bu2Color,'linestyle','none'); 
            alpha(0.4);
            set(gca,'xlim',[0.150 showmsmax(i)]);
            set(gca,'ylim',[0 maxBu2*1.5]);
            if i ~= 1
                set(gca,'YColor','none');
            end
            ax4(i).XAxis.Visible = 'off';
            set(gca,'xtick',[]);
       
            box off
            
            old_pos = get(ax4(i),'Position');
            temp = old_pos(3);
            old_pos(3) = old_pos(3)*(showmsmax(i)-0.150)/(0.800-0.150);
            old_pos(1) = old_pos(1)-prev_shrink-xshift-(i-1)*0.03;
            prev_shrink = prev_shrink + temp-old_pos(3);
            old_pos(1) = old_pos(1)*frac_x+0.05;
            old_pos(2) = 1-(1-old_pos(2))*frac_y -0.02;
            old_pos(3) = old_pos(3)*frac_x;
            old_pos(4) = old_pos(4)*frac_y;
            set(ax4(i),'Position',old_pos);
            if i == 3
                text(0.66,maxBu2*1.5*0.8,'Bu2',...
                    'Color',BuColor,'HorizontalAlignment','left','FontName',figparams.fontchoice,...
                    'FontSize',figparams.fsize,'FontWeight','Bold'); 
            end
        end
        linkaxes([ax(1),ax2(1),ax3(1),ax4(1)],'x');
        linkaxes([ax(2),ax2(2),ax3(2),ax4(2)],'x');
        linkaxes([ax(3),ax2(3),ax3(3),ax4(3)],'x');
        set(findobj(gcf,'type','axes'), 'TickLength',[0.04 0.025]);
        
        temp = ax4(3).Position;
        temp2 = ax(3).Position;
        ax5 = axes('Position',[temp(1)+temp(3)+0.08, temp(2)+0.03, 0.15, (temp2(2)+temp2(4))-(temp(2)+0.03)]); 
        RS_adaptratio_avg = mean(RS_adaptratio,'omitnan');
        RS_adaptratio_std = std(RS_adaptratio,'omitnan');
        RS_adaptratio_n = length(find(~isnan(RS_adaptratio)));
        RS_adaptratio_stderr = RS_adaptratio_std/sqrt(RS_adaptratio_n);
        
        FS_adaptratio_avg = mean(FS_adaptratio,'omitnan');
        FS_adaptratio_std = std(FS_adaptratio,'omitnan');
        FS_adaptratio_n = length(find(~isnan(FS_adaptratio)));
        FS_adaptratio_stderr = FS_adaptratio_std/sqrt(FS_adaptratio_n);
        
        Bu2_adaptratio_avg = mean(Bu2_adaptratio,'omitnan');
        Bu2_adaptratio_std = std(Bu2_adaptratio,'omitnan');
        Bu2_adaptratio_n = length(find(~isnan(Bu2_adaptratio)));
        Bu2_adaptratio_stderr = Bu2_adaptratio_std/sqrt(Bu2_adaptratio_n);
        
        Bu1_adaptratio_avg = mean(Bu1_adaptratio,'omitnan');
        Bu1_adaptratio_std = std(Bu1_adaptratio,'omitnan');
        Bu1_adaptratio_n = length(find(~isnan(Bu1_adaptratio)));
        Bu1_adaptratio_stderr = Bu1_adaptratio_std/sqrt(Bu1_adaptratio_n);
        
        PBu_adaptratio_avg = mean(PBu_adaptratio,'omitnan');
        PBu_adaptratio_std = std(PBu_adaptratio,'omitnan');
        PBu_adaptratio_n = length(find(~isnan(PBu_adaptratio)));
        PBu_adaptratio_stderr = PBu_adaptratio_std/sqrt(PBu_adaptratio_n);
        
        hold on
        h1 = bar(1,RS_adaptratio_avg,0.8,'FaceColor',RSColor,'FaceAlpha', 0.5,'EdgeColor',[0.5 0.5 0.5]);
        h2 = bar(2,FS_adaptratio_avg,0.8,'FaceColor',FSColor,'FaceAlpha', 0.5,'EdgeColor',[0.5 0.5 0.5]);
        h3 = bar(3,Bu1_adaptratio_avg,0.8,'FaceColor',Bu1Color,'FaceAlpha', 0.5,'EdgeColor',[0.5 0.5 0.5]);
        h4 = bar(4,Bu2_adaptratio_avg,0.8,'FaceColor',Bu2Color,'FaceAlpha', 0.5,'EdgeColor',[0.5 0.5 0.5]);
           
        h5 = errorbar([1 2 3 4],[RS_adaptratio_avg, FS_adaptratio_avg, Bu1_adaptratio_avg, Bu2_adaptratio_avg], [RS_adaptratio_stderr, FS_adaptratio_stderr, Bu1_adaptratio_stderr, Bu2_adaptratio_stderr]);
        h5.LineStyle = 'none';
        h5.LineWidth = 1;
        h5.Color = [0.5 0.5 0.5];
        
        text(1,0.05,num2str(RS_adaptratio_n),'HorizontalAlignment','center','Color',[0.3 0.3 0.3],'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold');
        text(2,0.05,num2str(FS_adaptratio_n),'HorizontalAlignment','center','Color',[0.3 0.3 0.3],'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold');
        text(3,0.05,num2str(Bu1_adaptratio_n),'HorizontalAlignment','center','Color',[0.3 0.3 0.3],'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold');
        text(4,0.05,num2str(Bu2_adaptratio_n),'HorizontalAlignment','center','Color',[0.3 0.3 0.3],'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold');
        ylabel('Adaptation Index');
        set(gca,'xlim',[0.5 4.5]);
        set(gca,'xtick',[1 2 3 4]);
        set(gca,'xticklabels', {'RS','FS','Bu1','Bu2'});
        set(gca,'TickLength',[0.015 0.025]);
        
        A = [groupIDcrit, groupIDgmm, num2cell(adaptratio(1:length(groupIDgmm)))];
        T = array2table(A);
        T.Properties.VariableNames = {'Group_crit','Group_gmm','Adaptindex'};
        %currentFile = mfilename('fullpath');
        %[pathstr,~,~] = fileparts(currentFile);
        cd(data_log_dir);
        writetable(T,'adaptindex.csv');     % Process in Python for Welch's ANOVA and Games-Howell post-hoc
        % Levene test for equal variance (reject null)
        p = vartestn(adaptratio(1:length(groupIDgmm)),groupIDgmm,'TestType','LeveneAbsolute')
      
        figure(fig5)
        
        p1 = 0.001;
        p2 = 0.0098;
        p3 = 0.0037;
        sigstar({[2 3],[1 3],[2,4]},[p1 p2 p3]);
       
        temp2 = ax4(1).Position;
        temp3 = ax5(1).Position;
        ax7 = axes('Position',[temp2(1),temp2(2)-0.2, 0.15, 0.15]); 
        hold on
        errorbar(durations_ext,RS_dur_rate,RS_dur_rate_stderr,'-','Color',RSColor,'CapSize',3,'LineWidth',1);
        errorbar(durations_ext,FS_dur_rate,FS_dur_rate_stderr,'-','Color',FSColor,'CapSize',3,'LineWidth',1);
        errorbar(durations_ext,Bu1_dur_rate,Bu1_dur_rate_stderr,'-','Color',Bu1Color,'CapSize',3,'LineWidth',1);
        errorbar(durations_ext,Bu2_dur_rate,Bu2_dur_rate_stderr,'-','Color',Bu2Color,'CapSize',3,'LineWidth',1);
        xlabel('Duration (ms)');
        ylh2 = ylabel('Rel mean rate');    % Driven rate
        ylh2.Position(2) = 0.9;
        set(gca,'xlim',[0 500]);
        set(gca,'XScale','log');
        set(gca, 'Xtick',durations_ext);
        set(gca, 'TickLength',[0.04 0.025]);
        set(gca, 'XMinorTick','off')
        
        ax8 = axes('Position',[temp2(1)+0.16+0.08+0.05+0.0687,temp2(2)-0.2, 0.15, 0.15]); 
        
        for t = 1:length(unit_type)
            eval(['PSTHramp.' unit_type{t} '_max_all = [];']);
            for d = 1:length(ramprates)
                eval(['PSTHramp.' unit_type{t} '_avg{d} = mean(PSTHramp.' unit_type{t} '{d},1,''omitnan'');']);
                eval(['temp = max(PSTHramp.' unit_type{t} '{d},[],2);']);
                eval(['PSTHramp.' unit_type{t} '_max_all(:,d) = squeeze(temp);']);
                eval(['PSTHramp.' unit_type{t} '_max_mean(d) = nanmean(temp);']);  
                eval(['PSTHramp.' unit_type{t} '_max_std(d) = nanstd(temp);']);
                eval(['PSTHramp.' unit_type{t} '_max_stderr(d) = nanstd(temp)/sqrt(length(find(~isnan(temp))));']);  
            end
            eval(['PSTHramp.' unit_type{t} '_max_n = length(find(~isnan(temp)));']);
            eval(['max' unit_type{t} '= max(PSTH.' unit_type{t} '_max);']);
        end
        hold on
        
        errorbar(ramprates,PSTHramp.RS_max_mean,PSTHramp.RS_max_stderr,'Color',RSColor,'CapSize',3,'LineWidth',1);
        errorbar(ramprates,PSTHramp.FS_max_mean,PSTHramp.FS_max_stderr,'Color',FSColor,'CapSize',3,'LineWidth',1);
        errorbar(ramprates,PSTHramp.Bu2_max_mean,PSTHramp.Bu2_max_stderr,'Color',Bu2Color,'CapSize',3,'LineWidth',1);
        errorbar(ramprates,PSTHramp.Bu1_max_mean,PSTHramp.Bu1_max_stderr,'Color',Bu1Color,'CapSize',3,'LineWidth',1);

        set(gca, 'Xtick', ramprates);
        set(gca, 'TickLength',[0.04 0.025]);
        xlabel('Onset ramp duration (ms)');
        ylabel('Max(PSTH)');
        set(gca,'xlim',[0 135]);
        set(gca,'ylim',[0 125]);
        
        ax8b = axes('Position',[temp2(1)+0.16+0.06,temp2(2)-0.2, 0.05, 0.15]);
        SR = 24414;
        t = 0:1/SR:0.2;
        f = 10000;
        onrdur = ramprates/1000;
        offrdur = [5 5 5 5 5]/1000;
        hold on
        for p = 1:5
            x = sin(2*pi*f*t);
            t_on = 0:1/SR:onrdur(p);
            on_ramp = (1 - cos((2*pi*t_on)./(2*onrdur(p))))./2;
            t_off = 0:1/SR:offrdur(p);
            off_ramp = fliplr((1 - cos((2*pi*t_off)./(2*offrdur(p))))./2);
            x(1:length(on_ramp)) = x(1:length(on_ramp)).*on_ramp;
            x(length(x)-length(off_ramp)+1:length(x)) = x(length(x)-length(off_ramp)+1:length(x)).*off_ramp;
            x=x/max(abs(x))*0.25;
            plot(t,x+p*ones(1,length(x)),'Color',[0.4 0.4 0.4]);
            text(-0.07,p,num2str(onrdur(p)*1000),'HorizontalAlignment','center','FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','Color',[0.4 0.4 0.4]);
        end
        set(gca,'ylim',[0.5 5.5]);
        set(gca,'xTick',[0 0.2],'XTicklabels',{'0','200'});
        xlabel('Time (ms)');
        
        set(ax8b,'YColor','none');
        
        temp = ax4(3).Position;
        temp2 = ax(3).Position;
        
        supp_Bu1_2 = figure;
        set(gcf,'PaperUnits', 'inches');
        set(gcf,'PaperSize', [17.2*0.3937, 9*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 17.2*0.3937, 9*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 17.2*0.3937, 9*0.3937]);
        figparams.msize = 7;
        figparams.res = 300; 
        
        axes('Position',[0.1, 0.8, 0.22, 0.15]);
        PSTH.Bu1_GMM_non_nan = PSTH.Bu1_GMM{4}(~isnan(PSTH.Bu1_GMM{4}(:,1)),:);
        PSTH.Bu2_GMM_non_nan = PSTH.Bu2_GMM{4}(~isnan(PSTH.Bu2_GMM{4}(:,1)),:);
        plot(Bu1_t4(1:end-1),mean(PSTH.Bu1_GMM_non_nan,1),'Color',Bu1Color,'LineWidth',1);
        set(gca,'xlim',[0.150 0.85]); 
        set(gca,'XTickLabel',[]);
        set(gca,'YTick',[0 25 50 75]);
        text('Units','normalized','Position',[-0.3,1.1],'String','A');
        text(0.6,0.8*75,['Bu1 (' num2str(length(find(~isnan(PSTH.Bu1_GMM_non_nan(:,1))))) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color);
        set(gca,'ylim',[0 75]);
        
        axes('Position',[0.1, 0.58, 0.22, 0.15]);
        plot(Bu2_t4(1:end-1),mean(PSTH.Bu2_GMM_non_nan,1),'Color',Bu2Color,'LineWidth',1);
        set(gca,'xlim',[0.150 0.85]); 
        set(gca,'xtick',[0.2,0.4,0.6,0.8]);
        set(gca,'xticklabels',{'200', '400', '600','800'});
        yl = ylabel('PSTH (spk/s)','FontSize',figparams.fsize,'FontName',figparams.fontchoice);
        set(yl, 'Position',[yl.Position(1), 34]);
        xlabel('Time (ms)');
        text(0.6,0.8*30,['Bu2 (' num2str(length(find(~isnan(PSTH.Bu2_GMM_non_nan(:,1))))) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color);
        set(gca,'ylim',[0 30]);     
        
        axes('Position',[0.1+0.22+0.11, 0.6, 0.22, 0.35]);        
        for i = 1:2
            for d = 1:length(ramprates)
                eval(['temp = max(PSTHramp.Bu' num2str(i) '_GMM{d},[],2);']);
                eval(['PSTHramp.Bu' num2str(i) '_max_mean_GMM(d) = nanmean(temp);']);  
                eval(['PSTHramp.Bu' num2str(i) '_max_std_GMM(d) = nanstd(temp);']);
                eval(['PSTHramp.Bu' num2str(i) '_max_stderr_GMM(d) = nanstd(temp)/sqrt(length(find(~isnan(temp))));']);  
            end
            eval(['PSTHramp.Bu' num2str(i) '_max_n_GMM = length(find(~isnan(temp)))']);
        end
        hold on
        errorbar(ramprates,PSTHramp.RS_max_mean,PSTHramp.RS_max_stderr,'Color',RSColor,'CapSize',3,'LineWidth',1.2);
        errorbar(ramprates,PSTHramp.FS_max_mean,PSTHramp.FS_max_stderr,'Color',FSColor,'CapSize',3,'LineWidth',1.2);
        errorbar(ramprates,PSTHramp.Bu2_max_mean,PSTHramp.Bu2_max_stderr_GMM,'Color',Bu2Color,'CapSize',3,'LineWidth',1.2);
        errorbar(ramprates,PSTHramp.Bu1_max_mean,PSTHramp.Bu1_max_stderr_GMM,'Color',Bu1Color,'CapSize',3,'LineWidth',1.2);
        set(gca, 'Xtick', ramprates);
        set(gca, 'TickLength',[0.04 0.025]);
        xlabel('Onset ramp duration (ms)');
        ylabel('Max(PSTH)');
        set(gca,'xlim',[0 135]);
        yl = [0 125];
        set(gca,'ylim',yl);
        inc = (yl(2)-yl(1))/0.5 *0.05;
    
        text(5,10+inc,['RS (' num2str(PSTHramp.RS_max_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',RSColor);
        text(5,10,['FS (' num2str(PSTHramp.FS_max_n) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',FSColor2);
        text(55,10+inc,['Bu1 (' num2str(PSTHramp.Bu1_max_n_GMM) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu1Color);
        text(55,10,['Bu2 (' num2str(PSTHramp.Bu2_max_n_GMM) ')'],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold','Color',Bu2Color);
  
        text('Units','normalized','Position',[-0.31,1+0.1*0.15/0.35],'String','B')
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');
        
        temp = ax4(3).Position;
        temp2 = ax(3).Position;
        
        figure(fig5);
        ax9 = axes('Position',[temp(1)+temp(3)+0.31, ax7.Position(2)-0.24, 0.22, (temp2(2)+temp2(4))-(ax7.Position(2)-0.24)]);  
        % Remove NaN rows
        inds_not_nan1 = find(~isnan(PSTH.Bu1{4}(:,1)));
        Bu1_r_burst_freq_not_nan = Bu1_r_burst_freq(inds_not_nan1);
        PSTH.Bu1_non_nan = PSTH.Bu1{4}(inds_not_nan1,:);

        inds_not_nan2 = find(~isnan(PSTH.Bu2{4}(:,1)));
        Bu2_r_burst_freq_not_nan = Bu2_r_burst_freq(inds_not_nan2);
        PSTH.Bu2_non_nan = PSTH.Bu2{4}(inds_not_nan2,:);
        
        [Bu1_r_burst_freq_desc,I] = sort(Bu1_r_burst_freq_not_nan,'descend');
        PSTH_Bu1_sort = PSTH.Bu1_non_nan(I,:);
        [Bu2_r_burst_freq_desc,I2] = sort(Bu2_r_burst_freq_not_nan,'descend');
        PSTH_Bu2_sort = PSTH.Bu2_non_nan(I2,:);
        indcut = length(Bu1_r_burst_freq_not_nan);
        PSTH_Bu_sort = [PSTH_Bu1_sort;PSTH_Bu2_sort];
        PSTH_Bu_sort = PSTH_Bu_sort./max(PSTH_Bu_sort,[],2); 
        [uniqueValues, ia, ic]=unique([Bu1_r_burst_freq_desc, Bu2_r_burst_freq_desc]);
        Ranks = max(ic)-ic+1; 
        h = heatmap(Bu2_t4(1:end-1),1:size(PSTH_Bu_sort,1),PSTH_Bu_sort);    % Parula for consistency but seems to imbalance the figure
        h.GridVisible = 'off';
        h.NodeChildren(3).FontWeight = 'bold';
        for i = 1:length(h.XDisplayLabels)
             h.XDisplayLabels{i} = '';
        end
        for i = 1:length(h.YDisplayLabels)
             h.YDisplayLabels{i} = num2str(Ranks(i));
        end
        h.FontName = figparams.fontchoice;
        h.FontSize = figparams.fsize;
        yl = get(gca,'ylim');
        xl = get(gca,'xlim');
        ylabel('Intraburst Frequency Rank');
        axline = axes('Position',[temp(1)+temp(3)+0.31, ax7.Position(2)-0.24, 0.22, (temp2(2)+temp2(4))-(ax7.Position(2)-0.24)]);  
        plot([175 200+400-10+150+2*35]/1000,[size(PSTH_Bu_sort,1)-indcut+0.4 size(PSTH_Bu_sort,1)-indcut+0.4],'--','Color',[0.3 0.3 0.3],'LineWidth',1);
        th = text(str2num(xl{1})+0.75*(str2num(xl{2})-str2num(xl{1})),size(PSTH_Bu_sort,1)-indcut+1.0,'500 Hz',fontstr{:},'Color',[0.3 0.3 0.3]);    % was 0.3 0.3 0.3
        axline.Color = 'none';
        axline.YColor = 'none';
        
        set(gca,'xtick',[0.2 0.6],'xticklabels',{'200' '600'});
        lh = xlabel('ms');
        lh.Units = 'normalized';
        lh.Position = [0.94 -0.018 0];
        
        set(axline,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(axline,'xlim',([str2num(xl{1}) str2num(xl{2})]));
        
        % Heatmap different dimensions for PPT
        sub2 = figure;   
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [7*0.3937, 8*0.3937]);
        set(gcf,'PaperPositionMode','manual')
        set(gcf,'PaperPosition', [0 0 7*0.3937, 8*0.3937]);
        set(gcf,'Units','inches');
        set(gcf,'Position',[0 0 7*0.3937, 8*0.3937]);
        
        axsub2 = axes(gcf);
        axsub2.Position(3) = 0.6;
        pos = axsub2.Position;
        h = heatmap(Bu2_t4(1:end-1),1:size(PSTH_Bu_sort,1),PSTH_Bu_sort);    % Parula for consistency but seems to imbalance the figure
        h.GridVisible = 'off';
        h.NodeChildren(3).FontWeight = 'bold';
        for i = 1:length(h.XDisplayLabels)
             h.XDisplayLabels{i} = '';
        end
        for i = 1:length(h.YDisplayLabels)
             h.YDisplayLabels{i} = num2str(Ranks(i));
        end
        h.FontName = figparams.fontchoice;
        h.FontSize = figparams.fsize;
        yl = get(gca,'ylim');
        xl = get(gca,'xlim');
        ylabel('Intraburst Frequency Rank');
        axline = axes('Position', pos);  
        plot([175 200+400-10+150+2*35]/1000,[size(PSTH_Bu_sort,1)-indcut+0.4 size(PSTH_Bu_sort,1)-indcut+0.4],'--','Color',[0.3 0.3 0.3],'LineWidth',1);
        th = text(str2num(xl{1})+0.75*(str2num(xl{2})-str2num(xl{1})),size(PSTH_Bu_sort,1)-indcut+1.0,'500 Hz',fontstr{:},'Color',[0.3 0.3 0.3]);    % was 0.3 0.3 0.3
        axline.Color = 'none';
        axline.YColor = 'none';
        
        set(gca,'xtick',[0.2 0.6],'xticklabels',{'200' '600'});
        lh = xlabel('ms');
        lh.Units = 'normalized';
        lh.Position = [0.94 -0.018 0];
        
        set(axline,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(axline,'xlim',([str2num(xl{1}) str2num(xl{2})]));
       
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');      
        print([figdir 'Fig 5/sub2.tif'],'-dtiff',['-r' num2str(figparams.res)]);
       
        figure(fig5)
        
        temp = ax7.Position
        ax10 = axes('Position',[temp(1),temp(2)-0.24, 0.5, 0.14]); 
        plot_raster({'M7E2262'}, 1, '1:5','1:10','','','','single',1,0,1,'',fig5,1,'vertical tick',1); 
        set(gca,'xlim',[120 480]);
        set(gca,'ylim',[-0.1 5]);
        set(gca, 'yticklabels',{'5','35','65','96','125'});
        ylh3 = ylabel('Ramp duration (ms)');
        set(gca,'TickLength',[0.01 0.025]); 
        hold on
        set(gca,'xtick',([200 400]));
        text(460, -0.79, 'ms','FontSize',figparams.fsize,'FontName',figparams.fontchoice,'FontWeight','bold');
        text(0.5,1.05,['Unit M7E2253ch1, BF 7.0 kHz, 38 dB'],'Units','normalized','Color',[0.4 0.4 0.4],'FontSize',figparams.fsize,'FontName',figparams.fontchoice,'HorizontalAlignment','center'); 
        set( gca, 'YColor', 'k' );  

        max_f_ratio = 32/0.5;
        min_f_ratio = 0.5/32;
        raster_time = -0.1975:0.0050: 0.4975;
        f_full = logspace(log10(min_f_ratio), log10(max_f_ratio), 61);
        f_full = round(f_full,3,'significant');
        centers = -0.1975:0.0050: 0.4975;
        
        % Directly load variables - too many characters for Excel cell
        load([mat_dir 'M7E_batch/M7E_unit_log_blank_MATLAB_20201210_plus_calc_20210215_MATLAB_20210528_batch_BFcalc.mat'], 'dlUM_raw');
        col = find(cellfun(@(x) strcmp(x,'Raster_val'), dlUM_raw(1,:)));
        r = dlUM_raw(2:end,col);
        load([mat_dir 'M117B_batch/M117B_unit_log_20190409_plus_calc_20210129_MATLAB_20210528_batch_BFcalc.mat'], 'dlUM_raw');
        col = find(cellfun(@(x) strcmp(x,'Raster_val'), dlUM_raw(1,:)));
        r = [r;dlUM_raw(2:end,col)];
        
        RS_r = [];
        FS_r = [];
        Bu1_r = [];
        Bu2_r = [];
        Bu1_r_burst_freq = [];
        Bu2_r_burst_freq = [];
        
        for i = 1:length(groupIDcrit)
            if ~isnan(r{i})
                temp1 = str2num(r{i});
                temp2 = reshape(temp1',[length(f_full) length(temp1)/length(f_full)]); 
                if strcmp(groupIDcrit{i},'RS')
                    RS_r = cat(3, RS_r, temp2);
                elseif strcmp(groupIDcrit{i},'FS')
                    FS_r = cat(3, FS_r, temp2);
                elseif strcmp(groupIDcrit{i},'Burster_l')
                    Bu2_r = cat(3, Bu2_r, temp2);
                    Bu2_r_burst_freq = [Bu2_r_burst_freq, intraburst_freq(i)]; 
                elseif strcmp(groupIDcrit{i},'Burster_h')
                    Bu1_r = cat(3, Bu1_r, temp2);
                    Bu1_r_burst_freq = [Bu1_r_burst_freq, intraburst_freq(i)];
                end
            end
        end
        
        RS_r_mean = nanmean(RS_r,3);
        RS_r_n = length(find(~isnan(RS_r(31,1,:))));
        FS_r_mean = nanmean(FS_r,3);
        FS_r_n = length(find(~isnan(FS_r(31,1,:))));
        Bu2_r_mean = nanmean(Bu2_r,3);
        Bu2_r_n = length(find(~isnan(Bu2_r(31,1,:))));
        Bu1_r_mean = nanmean(Bu1_r,3);
        Bu1_r_n = length(find(~isnan(Bu1_r(31,1,:))));
        
        f_ratio_min = 0.25;
        f_ratio_max = 4;
        f_ind_min = find(f_full==f_ratio_min);
        f_ind_max = find(f_full==f_ratio_max);
        
        temp5 = ax7.Position;
        ax12 = axes('Position',[temp5(1),0.04, 0.18, 0.18]); 
        ax12_top = ax12.Position(2)+ax12.Position(4);
        h2 = heatmap(centers(31:end-10), flipud(f_full(f_ind_min:f_ind_max)), flipud(RS_r_mean(f_ind_min:f_ind_max,31:end-10)));
        h2.GridVisible = 'off';
        h2.ColorbarVisible='off';
        c = colormap(gca,parula);
        labels = repmat({''},length(centers(31:end-10)),1);
        h2.XDisplayLabels = labels;
        h2.FontName = figparams.fontchoice;
        h2.FontSize = figparams.fsize;
        h2.NodeChildren(3).FontWeight = 'bold';
        title(['RS (' num2str(RS_r_n) ')']);
        for i = 1:length(h2.YDisplayLabels)
          if ~ismember(str2num(h2.YDisplayLabels{i}),[0.25,0.5,1,2,4])
             h2.YDisplayLabels{i} = '';
          end
        end
        ylabel('Freq / Best Freq');
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        ax12tick = axes('Position',[temp5(1),0.04, 0.18, 0.18]); 
        set(ax12tick,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(ax12tick,'xlim',([str2num(xl{1}) str2num(xl{2})]));
        set(ax12tick,'xTick',[0 0.2],'xTickLabels',{'200','400'});
        ax12tick.Color = 'none';
        ax12tick.YColor = 'none';
        lh12 = xlabel('ms');
        lh12.Position = [0.4 0.1 0];

        ax13 = axes('Position',[temp5(1)+0.18+0.03,0.04, 0.18, 0.18]); 
        h3 = heatmap(centers(31:end-10), flipud(f_full(f_ind_min:f_ind_max)), flipud(FS_r_mean(f_ind_min:f_ind_max,31:end-10)));
        h3.GridVisible = 'off';
        h3.ColorbarVisible='off';
        c = colormap(gca,parula);
        for i = 1:length(h3.YDisplayLabels)
            h3.YDisplayLabels{i}='';
        end
        h3.XDisplayLabels = labels;
        h3.FontName = figparams.fontchoice;
        h3.FontSize = figparams.fsize;
        h3.NodeChildren(3).FontWeight = 'bold';
        title(['FS (' num2str(FS_r_n) ')']);
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        ax13tick = axes('Position',[temp5(1)+0.18+0.03,0.04, 0.18, 0.18]); 
        set(ax13tick,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(ax13tick,'xlim',([str2num(xl{1}) str2num(xl{2})]));
        set(ax13tick,'xTick',[0 0.2],'xTickLabels',{'200','400'});
        ax13tick.Color = 'none';
        ax13tick.YColor = 'none';
        lh13 = xlabel('ms');
        lh13.Position = [0.4 0.1 0];

        ax14 = axes('Position',[temp5(1)+2*0.18+2*0.03,0.04, 0.18, 0.18]);     
        h4 = heatmap(centers(31:end-10), flipud(f_full(f_ind_min:f_ind_max)), flipud(Bu1_r_mean(f_ind_min:f_ind_max,31:end-10)));
        h4.GridVisible = 'off';
        h4.ColorbarVisible='off';
        c = colormap(gca,parula);
        for i = 1:length(h4.YDisplayLabels)
            h4.YDisplayLabels{i}='';
        end
        labels = repmat({''},length(centers(31:end-10)),1);
        h4.XDisplayLabels = labels;
        h4.FontName = figparams.fontchoice;
        h4.FontSize = figparams.fsize;
        h4.NodeChildren(3).FontWeight = 'bold';
        title(['Bu1 (' num2str(Bu1_r_n) ')']);
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        ax14tick = axes('Position',[temp5(1)+2*0.18+2*0.03,0.04, 0.18, 0.18]); 
        set(ax14tick,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(ax14tick,'xlim',([str2num(xl{1}) str2num(xl{2})]));
        set(ax14tick,'xTick',[0 0.2],'xTickLabels',{'200','400'});
        ax14tick.Color = 'none';
        ax14tick.YColor = 'none';
        lh14 = xlabel('ms');
        lh14.Position = [0.4 0.1 0];

        ax15 = axes('Position',[temp5(1)+3*0.18+3*0.03,0.04, 0.18, 0.18]); 
        h5 = heatmap(centers(31:end-10), flipud(f_full(f_ind_min:f_ind_max)), flipud(Bu2_r_mean(f_ind_min:f_ind_max,31:end-10)));
        h5.GridVisible = 'off';
        c = colormap(gca,parula);
        for i = 1:length(h5.YDisplayLabels)
            h5.YDisplayLabels{i}='';
        end
        labels = repmat({''},length(centers(31:end-10)),1);
        h5.XDisplayLabels = labels;
        h5.FontName = figparams.fontchoice;
        h5.FontSize = figparams.fsize;
        h5.NodeChildren(3).FontWeight = 'bold';
        title(['Bu2 (' num2str(Bu2_r_n) ')']);    
        xl = get(gca,'xlim');
        yl = get(gca,'ylim');
        ax15tick = axes('Position',[temp5(1)+3*0.18+3*0.03,0.04, 0.18, 0.18]); 
        set(ax15tick,'ylim',([str2num(yl{1}) str2num(yl{2})]));
        set(ax15tick,'xlim',([str2num(xl{1}) str2num(xl{2})]));
        set(ax15tick,'xTick',[0 0.2],'xTickLabels',{'200','400'});
        ax15tick.Color = 'none';
        ax15tick.YColor = 'none';
        lh15 = xlabel('ms');
        lh15.Position = [0.4 0.1 0];
        
        ylh1.Units = 'centimeters';
        ylh1.Position(1) = -0.74;
        ylh2.Units = 'centimeters';
        ylh2.Position(1) = -0.74;
        ylh3.Units = 'centimeters';
        ylh3.Position(1) = -0.74;
        
        th1 = annotation('textbox','Position',[0.0076445,ax5.Position(2)+ax5.Position(4)-0.008,0.0515,0.04928],'String','A','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th2 = annotation('textbox','Position',[0.375,ax5.Position(2)+ax5.Position(4)-0.008,0.0515,0.04928],'String','B','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th3 = annotation('textbox','Position',[0.612,ax5.Position(2)+ax5.Position(4)-0.008,0.0515,0.04928],'String','C','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th4 = annotation('textbox','Position',[0.0076445,ax7.Position(2)+ax7.Position(4)-0.008,0.0515,0.04928],'String','D','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th5 = annotation('textbox','Position',[ax8b.Position(1)-0.05,ax7.Position(2)+ax7.Position(4)-0.008,0.0515,0.04928],'String','E','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th6 = annotation('textbox','Position',[ax8.Position(1)-0.0774,ax7.Position(2)+ax7.Position(4)-0.008,0.0515,0.04928],'String','F','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th7 = annotation('textbox','Position',[0.0076445,ax10.Position(2)+ax10.Position(4)-0.008,0.0515,0.04928],'String','G','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th8 = annotation('textbox','Position',[0.0076445,ax12_top-0.008,0.0515,0.04928],'String','H','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th9 = annotation('textbox','Position',[0.264,ax12_top-0.008,0.0515,0.04928],'String','I','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th10 = annotation('textbox','Position',[0.264+(0.18+0.03),ax12_top-0.008,0.0515,0.04928],'String','J','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        th11 = annotation('textbox','Position',[0.264+2*(0.18+0.03),ax12_top-0.008,0.0515,0.04928],'String','K','FontSize',figparams.fsize+2,'FontName',figparams.fontchoice, 'FontWeight','Bold','EdgeColor','none');
        
        set(findobj(gcf,'type','axes'),'FontName',figparams.fontchoice,'FontSize',figparams.fsize,'FontWeight','Bold','TickDir','out','box','off');
        
        print([figdir 'Fig 5/Fig5.tif'],'-dtiff',['-r' num2str(figparams.res)]);

    case 'Neuron type properties subpanel'
        figparams.fsize = 7;
        figparams.msize = 3;
        
        groupIDcrit(cellfun(@(x) ~ischar(x),groupIDcrit)) = {''};  % make NaN's into chars
         
        groupinds.RSinds = strcmp(groupIDcrit,'RS');
        groupinds.FSinds = strcmp(groupIDcrit,'FS');
        groupinds.Bu2inds = strcmp(groupIDcrit,'Burster_l');
        groupinds.Bu1inds = strcmp(groupIDcrit,'Burster_h');
        
        groupord = {'RS','FS','Burster_h','Burster_l','Unclassified','Insufficient spikes',};
        groupcolors = [RSColor; FSColor; BuColor; PBuColor; BuColor1; BuColorBright];
        
        p1 = vartestn(bf(ismember(groupnumcrit,[3,1,2,6])),groupnumcrit(ismember(groupnumcrit,[3,1,2,6])),'TestType','LeveneAbsolute');
        % Not significant
        p2 = anova1(bf(ismember(groupnumcrit,[3,1,2,6])),groupnumcrit(ismember(groupnumcrit,[3,1,2,6])));
        % Not significant
        p3 = vartestn(depth(ismember(groupnumcrit,[3,1,2,6])),groupnumcrit(ismember(groupnumcrit,[3,1,2,6])),'TestType','LeveneAbsolute');
        % Not significant
        p4 = anova1(depth(ismember(groupnumcrit,[3,1,2,6])),groupnumcrit(ismember(groupnumcrit,[3,1,2,6])));
       
        figparams.s = ploth(1);
        figparams.boxcolor = [0.3 0.3 0.3];
        ct_properties_subplot(bf, groupIDcrit, groupinds, groupord, groupcolors, 'linear', 'BF (kHz)', figparams);
        hold on
        xlim([0.5 4.5]);
        xticks([1,2,3,4]);
        xticklabels({'RS','FS','Bu1','Bu2'});
        %xl = get(gca,'xlim');
        %set(gca,'ylim',[0 85]);
        %s1.Title.Units = 'normalized';
        %s1.Title.VerticalAlignment = 'top';
        %s1.Title.Position=[0.5 1.2 0];
        h = findobj(ploth(1),'type','Scatter','MarkerFaceColor', [1 1 1],'Marker','o');
        for i = 1:length(h)
            h(i).SizeData = 6;
        end
        
        figparams.s = ploth(2);
        ct_properties_subplot(depth, groupIDcrit, groupinds, groupord, groupcolors, 'linear', 'Depth (um)', figparams);
        hold on
        xlim([0.5 4.5]);
        xticks([1,2,3,4]);
        xticklabels({'RS','FS','Bu1','Bu2'});
        
        h = findobj(ploth(2),'type','Scatter','MarkerFaceColor', [1 1 1],'Marker','o');
        for i = 1:length(h)
            h(i).SizeData = 6;
        end
    end
end

function ct_properties_subplot(prop, groupID, groupinds, groupord, groupcolors, logorlinear, ylabelstr, figparams)
global RSColor FSColor BuColor PBuColor BuColorBright BuColor1 

axes(figparams.s);
if ~isfield(figparams,'boxcolor')
    figparams.boxcolor = [0.5 0.5 0.5];
end
v = violinplot(prop,groupID,'GroupOrder',groupord,'BoxColor',figparams.boxcolor);
set(gca, 'YScale', logorlinear);
set(gca,'xlim',[0.5,6.5]);
th = title(ylabelstr,'FontSize',figparams.fsize);

xticklabels({'RS','FS','Bu','PBu','Bu1','Bu2'});

set(gca,'Fontsize',figparams.fsize,'FontName',figparams.fontchoice);
for i = 1:length(figparams.s.Children)
    if strcmp(get(figparams.s.Children(i), 'Type'),'scatter') && (figparams.s.Children(i).SizeData==36)
        figparams.s.Children(i).SizeData = figparams.msize;
    end
end

set(findobj(gca,'type','Scatter'),'SizeData',figparams.msize);

for i = 1:size(groupcolors,1)
    v(i).ViolinColor = groupcolors(i,:);
end

q3 = findobj(gca,'type','Line');
q3(1).LineWidth = 1;
q3(2).LineWidth = 1;
q3(3).LineWidth = 1;
q3(4).LineWidth = 1;
end


function conf = popdecode(callhist_all, nunits, plotornot)
    nsims = 50;
    nstims = size(callhist_all,1);    
    conf = zeros(nstims,nstims);
        
    for i = 1:nsims   
        % Leave one rep out for each unit
        % Pseudopopulation - select random subset of units
        rand_units = randsample(size(callhist_all,4), nunits);
        rand_rep = randsample(size(callhist_all,2), nunits, true);
        leftout = nan(size(callhist_all,1),1,size(callhist_all,3),nunits);
        leftin = nan(size(callhist_all,1),size(callhist_all,2)-1,size(callhist_all,3),nunits);
        for unit = 1:length(rand_units)
            leftout(:,:,:,unit) = callhist_all(:,rand_rep(unit),:,rand_units(unit));
            %leftout = callhist_all(:,i,:,:);
            temp = callhist_all(:,:,:,rand_units(unit));
            temp(:,rand_rep(unit),:) = [];
            leftin (:,:,:,unit) = temp;
        end
        % Average
        leftin = mean(leftin, 2);   % Should we just average?

        % Vectorize as time-unit features
        leftout = reshape(leftout,[size(leftout,3)*size(leftout,4),size(leftout,1)]);
        leftin = reshape(leftin,[size(leftin,3)*size(leftin,4),size(leftin,1)]);

        % Normalize
        leftout = leftout / norm(leftout);  
        leftin = leftin / norm (leftin);

        % Confusion matrix all units
        dist = nan(nstims,nstims);
        for j = 1:nstims
            for k = 1:nstims
                dist(j,k) = sqrt(sum((leftout(:,j)-leftin(:,k)).^2));
                % Checked against norm(leftout(:,1)-leftin(:,3))
                % dist(j,k) = dtw(leftout(:,j),leftin(:,k));
            end
        end
        if plotornot
            figure;
            colormap('cool');
            imagesc(dist);
            colorbar;
            set(gca,'XTick',1:nstims);
            set(gca,'YTick',1:nstims);
            set(gca,'xaxisLocation','top');
            xlabel('Mean response stimulus #');
            ylabel('Left out trial stimulus #');
        end

        % Find nearest neighbor and assign

        for j = 1:nstims
            val = min(dist(j,:));   
            % If multiple equal minimums, MATLAB "min" will take only first index, but we want to distribute credit evenly   
            inds = find(dist(j,:)==val);
            for k = 1:length(inds)
                conf(j, inds(k)) = conf(j, inds(k))+1/length(inds);
            end
        end
    end
    figure;
    imagesc(conf);
end