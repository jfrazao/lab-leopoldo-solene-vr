%% MOL_genGratings_Ori8_SF04cpd_TF1Hz_rep300
%% Define parameters:
par.nrep            = 300;
par.ori             = [0 : 45 : 315]; %orientations degrees
par.TF              = 1; %Hz
par.SF              = 0.04; %cpd
par.Contrast        = 0.8; %Hz

nOris               = length(par.ori);
par.ntrials = nOris  * par.nrep ;

% Output is .csv like this:
% Trial,Orientation,TF,SF,Contrast
% 1,90,2,0.04,0.80
% 2,30,2,0.04,0.30
% 3,0,2,0.04,0.80
% 4,180,2,0.04,0.40
% 5,330,2,0.04,0.80
% 6,210,2,0.04,0.80
% 7,180,2,0.04,0.40
% 8,0,4,0.08,0.80
% 9,210,2,0.04,0.80
% 10,180,2,0.04,0.40
% 11,330,2,0.04,0.80
% 12,210,2,0.04,0.80

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.ntrials);

%% Generate block-shuffled orientation:
trials.Orientation                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep
    trials.Orientation = [trials.Orientation; par.ori(randperm(nOris))']; %Add trials to trialType vector in randomized order (block-scrambled)
end

%% Rest:
trials.TF = repmat(par.TF,par.ntrials,1);
trials.SF = repmat(par.SF,par.ntrials,1);
trials.Contrast = repmat(par.Contrast,par.ntrials,1);


%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_OriGrating_Ori8_SF04cpd_TF1Hz_rep300.csv')


%%



% trials.tex_Stim_Left(ismember(trials.trialtype,'A') & leftrelevanttrials==1)    = {par.tex_A}; 
% trials.tex_Stim_Right(ismember(trials.trialtype,'A') & leftrelevanttrials==0)   = {par.tex_A}; 
% 
% trials.tex_Stim_Left(ismember(trials.trialtype,'B') & leftrelevanttrials==1)    = {par.tex_B}; 
% trials.tex_Stim_Right(ismember(trials.trialtype,'B') & leftrelevanttrials==0)   = {par.tex_B}; 

% trials.tex_Stim_Left(leftrelevanttrials==0)                                     = {par.tex_BG}; 
% trials.tex_Stim_Right(leftrelevanttrials==1)                                    = {par.tex_BG}; 
