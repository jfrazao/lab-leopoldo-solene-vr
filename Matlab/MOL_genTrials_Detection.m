%% Define parameters:
par.number_trials   = 2000;

protocoldir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';

% par.textures        = {'stimA' 'stimB' 'stimC' 'stimD'};
% par.tex_BG          = 'fwn1_25';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Only full contrast: 
par.contrasts       = [1]; %

trials.contrast     = par.contrasts(randi(length(par.contrasts),par.number_trials,1));

%% trials.reward
trials.RewardTrial = trials.contrast > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_trialseq_detection_maxonly.csv')

%% Psychometric 5 levels including 0 contrast: 
% trials.contrast
par.contrasts       = [0 0.02 0.05 0.1 0.25 0.7]; %

% trials.contrast = randsample(par.contrasts,par.number_trials,true)';

trials.contrast = par.contrasts(randi(length(par.contrasts),par.number_trials,1))';

trials.contrast(1) = par.contrasts(end); %make first trial max saliency

%% trials.reward
trials.RewardTrial = trials.contrast > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_5levels.csv'))

