%% MOL_genGratings_ with gaussian noise to have feedforward variability

%% Define parameters:
% par.ori             = 0 : 22.5 : 337.5; %orientations degrees
% par.ori             = 0 : 60 : 120; %orientations degrees
par.ori             = [30 90 150]; %orientations degrees
par.TF              = 1.5; %Hz
par.SF              = 0.08; %cpd

par.TF              = [1.5 3  6]; %Hz
% par.SF              = [0.02 0.06 0.12]; %cpd
par.SF              = [0.12 0.06 0.03]; %cpd

par.Contrast        = 0.7; %0-1 contrast
par.Phase           = 0; %0-1 starting phase

% par.Speed           = [5 20 100]; %cpd
% par.stdSpeed        = 5; %deg

par.stdOri          = 7.5; %deg
par.stdTF           = 0.1; %Hz
par.stdSF           = 0.01; %cpd
par.stdContr        = 0; %0-1 contrast
par.stdPhase        = 0; %

nOris               = length(par.ori);
nSpeeds             = length(par.TF);

% par.ntrials         = 3200;
% par.nrep            = par.ntrials / nOris;

par.nrep            = 300;
par.ntrials         = nOris * nSpeeds * par.nrep;

% par.nrep            = par.ntrials / nOris;

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

% PM: pref 1.5 Hz 0.08 cpd: 18.75 deg/s
% AL: pre 4 Hz 0.025 cpd: 160 deg/s


%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.ntrials);

%% Generate block-shuffled orientation:
trials.Orientation                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep*nSpeeds
    trials.Orientation = [trials.Orientation; par.ori(randperm(nOris))']; %Add trials to trialType vector in randomized order (block-scrambled)
end

% trials.Orientation = trials.Orientation + normrnd(0,par.stdOri,par.ntrials,1);
trials.Orientation = trials.Orientation + (rand(par.ntrials,1)-0.5)*par.stdOri;
trials.Orientation = mod(trials.Orientation,360);

%% Generate block-shuffled SF and TF:
trials.TF                   = []; %shuffle block (not stimulus side block)
trials.SF                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep*nOris
    order = randperm(nSpeeds); 
    trials.TF = [trials.TF; par.TF(order)']; %Add trials to trialType vector in randomized order (block-scrambled)
    trials.SF = [trials.SF; par.SF(order)']; %Add trials to trialType vector in randomized order (block-scrambled)
end

trials.TF = trials.TF + (rand(par.ntrials,1)-0.5) * 2 * par.stdTF;
trials.SF = trials.SF + (rand(par.ntrials,1)-0.5) * 2 * par.stdSF;

trials.Speed = trials.TF ./ trials.SF;

%% Rest:
% trials.TF           = repmat(par.TF,par.ntrials,1)          + normrnd(0,par.stdTF,par.ntrials,1);
% trials.SF           = repmat(par.SF,par.ntrials,1)          + normrnd(0,par.stdSF,par.ntrials,1);
% trials.Contrast     = repmat(par.Contrast,par.ntrials,1)    + normrnd(0,par.stdContr,par.ntrials,1);
trials.Contrast     = repmat(par.Contrast,par.ntrials,1)    + (rand(par.ntrials,1)-0.5) * 2 * par.stdContr;
trials.Contrast(trials.Contrast>1) = 1;
% trials.Phase        = repmat(par.Phase,par.ntrials,1)    + normrnd(0,par.stdPhase,par.ntrials,1);
trials.Phase        = repmat(par.Phase,par.ntrials,1)    + (rand(par.ntrials,1)-0.5) * 2 * par.stdPhase;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_OriGrating_gaussNoise_v2.csv')

%% Show results:
figure();
scatter(trials.Orientation,trials.Speed,10,'k.')
set(gca,'yscale','log')

