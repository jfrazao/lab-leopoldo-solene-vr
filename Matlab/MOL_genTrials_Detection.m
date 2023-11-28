%% Define parameters:
par.number_trials   = 2000;

protocoldir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';
% protocoldir = 'C:\Users\EphysPC\Desktop\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';

% par.textures        = {'stimA' 'stimB' 'stimC' 'stimD'};
% par.tex_BG          = 'fwn1_25';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Only full signal: 
par.signals       = [100]; %
trials.signal     = par.signals(randi(length(par.signals),par.number_trials,1));
par.fraction0       = 0.15;
trials.signal(randsample(par.number_trials,round(par.fraction0*par.number_trials))) = 0;

D = diff([0; trials.signal])==0;
trials.signal(D==1);
trials.signal(trials.signal==0);
trials.signal(D==1 & trials.signal==0) = 100;


%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_maxonly.csv'))

%% Psychometric 5 levels including 0 signal: 
par.signals       = [0 5 15 30 50 100]; %

trials.signal = par.signals(randi(length(par.signals),par.number_trials,1))';

trials.signal(1) = par.signals(end); %make first trial max saliency

%set consecutive catch trials to max: 
D = diff([0; trials.signal])==0;
trials.signal(D==1);
trials.signal(trials.signal==0);
trials.signal(D==1 & trials.signal==0) = 100;

%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_5levels.csv'))

%% Only full signal: 
par.centersignal    = 15; %
par.stdsignal       = 15; %
par.fraction0       = 0.1;
par.fraction100     = 0.3;
par.fractionnoise   = 1 - par.fraction0 - par.fraction100;

temp = [repmat(0,ceil(par.fraction0*par.number_trials),1); ...
    repmat(100,ceil(par.fraction100*par.number_trials),1);
    repmat(par.centersignal,ceil(par.fractionnoise*par.number_trials),1)];

temp = temp(1:par.number_trials);
idx = temp == par.centersignal;
temp(idx) = temp(idx) + (rand(sum(idx),1)-0.5)*par.stdsignal;

trials.signal       = temp(randperm(par.number_trials));

D = diff([0; trials.signal])==0;
trials.signal(D==1);
trials.signal(trials.signal==0);
trials.signal(D==1 & trials.signal==0) = 100;

%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_center15_noise15.csv'))

