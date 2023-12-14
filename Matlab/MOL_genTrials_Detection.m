%% Define parameters:
par.number_trials   = 2000;

protocoldir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';
protocoldir = 'C:\Users\EphysPC\Desktop\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';
% protocoldir = 'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\VR_Detection\';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Only full signal: 

% par.signals         = [100]; %
par.fracs           = [0.2 0.8];
par.signals         = [0 100];

trials.signal   = createDetectionTrialVector(par);
trials.signal(1) = par.signals(end); %first trial max signal

%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_maxonly.csv'))

%% Psychometric 5 levels including 0 signal: 

% par.signals     = [0      5   20  50  100]; %
par.signals     = [0        5   12  25  100]; %
nconds          = length(par.signals);
par.fracs       = repmat(1/nconds,nconds,1);

trials.signal   = createDetectionTrialVector(par);
trials.signal(1) = par.signals(end); %first trial max signal

%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,'MOL_trialseq_detection_5levels.csv'))

%% With noise distribution around threshold stimulus:
par.centersignal    = 10; %
par.stdsignal       = 10; %

par.signals     = [0   par.centersignal   100]; %
par.fracs       = [0.1 0.7 0.2];

trials.signal   = createDetectionTrialVector(par);

idx = trials.signal == par.centersignal;
trials.signal(idx) = trials.signal(idx) + (rand(sum(idx),1)-0.5)*par.stdsignal;

fprintf('\nJitter ranges from %2.0f to %2.0f %% signal\n',min(trials.signal(idx)),max(trials.signal(idx)))
trials.signal       = round(trials.signal);

trials.signal(1) = par.signals(end); %first trial max signal

%% trials.reward
trials.RewardTrial = trials.signal > 0;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,fullfile(protocoldir,sprintf('MOL_trialseq_detection_center%d_noise%d.csv',par.centersignal,par.stdsignal)))

