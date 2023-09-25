%% MOL_genGratings_ with gaussian noise to have feedforward variability

%% Define parameters:
% par.ori             = 0 : 22.5 : 337.5; %orientations degrees
par.ori             = 0 : 90 : 270; %orientations degrees
par.TF              = 1.5; %Hz
par.SF              = 0.08; %cpd
par.Contrast        = 0.7; %0-1 contrast
par.Phase           = 0; %0-1 starting phase

par.stdOri          = 5; %deg
par.stdTF           = 0; %Hz
par.stdSF           = 0; %cpd
par.stdContr        = 0.1; %0-1 contrast
par.stdPhase        = 0; %

par.ntrials         = 3200;
nOris               = length(par.ori);
par.nrep            = par.nTrials / nOris;

% par.ntrials         = nOris  * par.nrep ;

% Output is .csv like this:
% Trial,Orientation,TF,SF,Contrast,Phase
% 1,90,2,0.04,0.80,0
% 2,30,2,0.04,0.30,0
% 3,0,2,0.04,0.80,0
% 4,180,2,0.04,0.40,0
% 5,330,2,0.04,0.80,0
% 6,210,2,0.04,0.80,0
% 7,180,2,0.04,0.40,0
% 8,0,4,0.08,0.80,0
% 9,210,2,0.04,0.80,0
% 10,180,2,0.04,0.40,0
% 11,330,2,0.04,0.80,0
% 12,210,2,0.04,0.80,0

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.ntrials);

%% Generate block-shuffled orientation:
trials.Orientation                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep
    trials.Orientation = [trials.Orientation; par.ori(randperm(nOris))']; %Add trials to trialType vector in randomized order (block-scrambled)
end

trials.Orientation = trials.Orientation + normrnd(0,par.stdOri,par.ntrials,1);
trials.Orientation = mod(trials.Orientation,360);

%% Rest:
trials.TF           = repmat(par.TF,par.ntrials,1)          + normrnd(0,par.stdTF,par.ntrials,1);
trials.SF           = repmat(par.SF,par.ntrials,1)          + normrnd(0,par.stdSF,par.ntrials,1);
trials.Contrast     = repmat(par.Contrast,par.ntrials,1)    + normrnd(0,par.stdContr,par.ntrials,1);
trials.Contrast(trials.Contrast>1) = 1;
trials.Phase        = repmat(par.Phase,par.ntrials,1)    + normrnd(0,par.stdPhase,par.ntrials,1);

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_OriGrating_gaussNoise_v1.csv')

%% 
figure();
[bins,edges] = histcounts(trials.Orientation,0:1:360);
plot(edges(1:end-1),bins)

figure();
[bins,edges] = histcounts(trials.Contrast,0:0.1:1);
plot(edges(1:end-1),bins)

figure();
[bins,edges] = histcounts(trials.TF,0:0.1:2.5);
plot(edges(1:end-1),bins)