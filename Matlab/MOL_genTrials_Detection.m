%% Define parameters:
par.number_trials   = 2000;

protocoldir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';
protocoldir = 'C:\Users\EphysPC\Desktop\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';

% par.textures        = {'stimA' 'stimB' 'stimC' 'stimD'};
% par.tex_BG          = 'fwn1_25';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Only full contrast: 
par.contrasts       = [100]; %
trials.contrast     = par.contrasts(randi(length(par.contrasts),par.number_trials,1));
par.fraction0       = 0.15;
trials.contrast(randsample(par.number_trials,round(par.fraction0*par.number_trials))) = 0;

D = diff([0; trials.contrast])==0;
trials.contrast(D==1);
trials.contrast(trials.contrast==0);
trials.contrast(D==1 & trials.contrast==0) = 100;


%% trials.reward
trials.RewardTrial = trials.contrast > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_maxonly.csv'))

%% Psychometric 5 levels including 0 contrast: 
par.contrasts       = [0 5 15 30 50 100]; %

trials.contrast = par.contrasts(randi(length(par.contrasts),par.number_trials,1))';

trials.contrast(1) = par.contrasts(end); %make first trial max saliency

%set consecutive catch trials to max: 
D = diff([0; trials.contrast])==0;
trials.contrast(D==1);
trials.contrast(trials.contrast==0);
trials.contrast(D==1 & trials.contrast==0) = 100;

%% trials.reward
trials.RewardTrial = trials.contrast > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_5levels.csv'))

