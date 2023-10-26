%% Define parameters:
par.number_trials   = 2000;
par.stim_loc_int    = [60 90]; %start loc;

par.contrasts       = [0.02 0.05 0.1 0.25 0.7]; %

% par.textures        = {'stimA' 'stimB' 'stimC' 'stimD'};
% par.tex_BG          = 'fwn1_25';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% trials.contrast
trials.contrast = randsample(par.contrasts,par.number_trials,true)';

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_trialseq_detection_5levels.csv')
